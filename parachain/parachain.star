build_spec = import_module("./build-spec.star")
register_para_slot = import_module("./register-para-id.star")
constant = import_module("../package_io/constant.star")
parachain_list = import_module("./static_files/images.star")
node_setup = import_module("./node_setup.star")
utils = import_module("../package_io/utils.star")

def start_local_parachain_node(plan, chain_type, parachain, para_id):
    """
    Start local parachain nodes based on configuration.

    Args:
        chain_type (string): The type of chain (localnet, testnet or mainnet).
        parachains (dict): A dict containing data for para chain config.
        para_id (int): Parachain ID.

    Returns:
        list: List of dictionaries containing service details of parachain nodes.
    """
    chain_name = parachain["name"]
    parachain_details = parachain_list.parachain_images[chain_name]
    image = parachain_details["image"]
    binary = parachain_details["entrypoint"]
    chain_base = parachain_details["base"][0]

    sudo_key = ""
    if len(parachain["sudo_key"]) != 0:
        sudo_key = parachain["sudo_key"]["public_key"]
    
    public_keys = [node.get("key", {}).get("public_key", "") for node in parachain["nodes"] if node.get("key")]
    collators_keys = "[" + ", ".join(["\"{}\"".format(key) for key in public_keys]) + "]"

    raw_service = build_spec.create_parachain_build_spec_with_para_id(plan, image, binary, chain_name, chain_base, para_id, sudo_key, collators_keys)

    parachain_final = {}

    for node in parachain["nodes"]:
        parachain_detail = {}
        
        if "ports" in node: 
            rpc_port = node["ports"]["rpc_port"]
            lib2lib_port = node["ports"]["lib2lib_port"]
            prometheus_port = node["ports"]["prometheus_port"] if node["prometheus"] else None
            ws_port = node["ports"]["ws_port"] if parachain["name"] in constant.WS_PORT else None
        else:
            rpc_port = None
            lib2lib_port = None
            prometheus_port = None
            ws_port = None

        if chain_name in constant.WS_PORT:
            if len(node["key"]) != 0:
                exec_comexec_commandmand = [
                    "/bin/bash",
                    "-c",
                    "{0} --base-path=/tmp/{1} --chain=/build/{1}-raw.json --ws-port=9944 --port=30333 --rpc-port=9947 --ws-external --rpc-external --prometheus-external --rpc-cors=all --name={2} --collator --rpc-methods=unsafe --force-authoring --execution=wasm -- --chain=/app/raw-polkadot.json --execution=wasm".format(binary, chain_name, node["name"]),
                ]
            else:
                exec_comexec_commandmand = [
                    "/bin/bash",
                    "-c",
                    "{0} --base-path=/tmp/{1} --chain=/build/{1}-raw.json --ws-port=9944 --port=30333 --rpc-port=9947 --ws-external --rpc-external --prometheus-external --rpc-cors=all --{2} --collator --rpc-methods=unsafe --force-authoring --execution=wasm -- --chain=/app/raw-polkadot.json --execution=wasm".format(binary, chain_name, node["name"]),
                ]
        else:
            if len(node["key"]) != 0:
                exec_comexec_commandmand = [
                    "/bin/bash",
                    "-c",
                    "{0} --base-path=/tmp/{1} --chain=/build/{1}-raw.json --rpc-port=9947 --port=30333 --rpc-external --rpc-cors=all --prometheus-external --name={2} --collator --rpc-methods=unsafe --force-authoring --execution=wasm -- --chain=/app/raw-polkadot.json --execution=wasm".format(binary, chain_name, node["name"]),
                ]
            else:
                exec_comexec_commandmand = [
                    "/bin/bash",
                    "-c",
                    "{0} --base-path=/tmp/{1} --chain=/build/{1}-raw.json --rpc-port=9947 --port=30333 --rpc-external --rpc-cors=all --prometheus-external --{2} --collator --rpc-methods=unsafe --force-authoring --execution=wasm -- --chain=/app/raw-polkadot.json --execution=wasm".format(binary, chain_name, node["name"]),
                ]

        
        build_file = raw_service
        parachain_spawn_detail = node_setup.spawn_parachain(plan, node["prometheus"], image, parachain["name"], "{0}-{1}-{2}".format(chain_name, node["name"], chain_type), exec_comexec_commandmand, build_file, rpc_port, prometheus_port, lib2lib_port, ws_port)
        parachain_detail["service_name"] = parachain_spawn_detail.name
        parachain_detail["endpoint"] = utils.get_service_url("ws", parachain_spawn_detail.ip_address, parachain_spawn_detail.ports["ws"].number)
        parachain_detail["ip_address"] = parachain_spawn_detail.ip_address
        parachain_detail["prometheus"] = node["prometheus"]
        parachain_detail["node_type"] = node["node_type"]
        if node["prometheus"] == True:
            parachain_detail["prometheus_port"] = parachain_spawn_detail.ports["metrics"].number
        if prometheus_port != None:
            parachain_detail["prometheus_public_port"] = prometheus_port
            parachain_detail["endpoint_prometheus"] = utils.get_service_url("tcp", "127.0.0.1", prometheus_port)
        if ws_port != None:
            parachain_detail["endpoint_public"] = utils.get_service_url("ws", "127.0.0.1", ws_port)
        elif rpc_port != None:
            parachain_detail["endpoint_public"] = utils.get_service_url("ws", "127.0.0.1", rpc_port)

        parachain_final[parachain_spawn_detail.name] = parachain_detail

        if len(node["key"]) != 0:
            insert_keys(plan, "aura", node["key"]["private_phrase"], parachain_detail["endpoint"])
    return parachain_final

def start_nodes(plan, chain_type, parachains, relay_chain_ip):
    """
    Start multiple parachain nodes.

    Args:
        chain_type (string): The type of chain (localnet, testnet or mainnet).
        parachains (list): A list containing data for para chain config.
        relay_chain_ip (string): IP address of the relay chain.

    Returns:
        list: List of dictionaries containing service details of each parachain.
    """
    final_parachain_details = {}
    
    for parachain in parachains:
        para_id = register_para_slot.register_para_id(plan, relay_chain_ip, parachain["name"]) 
        parachain_details = start_local_parachain_node(plan, chain_type, parachain, para_id)
        register_para_slot.onboard_genesis_state_and_wasm(plan, para_id, parachain["name"], relay_chain_ip)
        final_parachain_details.update(parachain_details)
    
    return final_parachain_details

def run_testnet_mainnet(plan, chain_type, relaychain_name, parachain):
    """
    Run a testnet or mainnet based on configuration.

    Args:
        chain_type (string): The type of chain (localnet, testnet or mainnet).
        relaychain_name (string): The name of relay chain.
        parachain (dict): A dict containing data for para chain config.

    Returns:
        list: List of dictionaries containing details of each parachain node.
    """
    if chain_type == "testnet":
        if parachain["name"] == "ajuna":
            parachain["name"] = "bajun"
        parachain_details = parachain_list.parachain_images[parachain["name"]]
        image = parachain_details["image"]
        base = parachain_details["base"][1]

        if parachain["name"] in constant.DIFFERENT_IMAGES_FOR_TESTNET:
            image = constant.DIFFERENT_IMAGES_FOR_TESTNET[parachain["name"]]

    else:
        parachain_details = parachain_list.parachain_images[parachain["name"]]
        image = parachain_details["image"]
        base = parachain_details["base"][2]

        if parachain["name"] in constant.DIFFERENT_IMAGES_FOR_MAINNET:
            image = constant.DIFFERENT_IMAGES_FOR_MAINNET[parachain["name"]]

    if base == None:
        fail("Tesnet is not there for {}".format(parachain["name"]))

    if parachain["name"] in constant.WS_PORT:
        common_command = [
            "--chain={0}".format(base),
            "--port=30333",
            "--ws-port=9944",
            "--rpc-port=9947",
            "--prometheus-external",
            "--rpc-cors=all",
            "--rpc-external",
            "--ws-external",
            "--rpc-methods=unsafe",
            "--unsafe-rpc-external",
            "--unsafe-ws-external",
        ]
    else:
        common_command = [
            "--chain={0}".format(base),
            "--port=30333",
            "--rpc-port=9947",
            "--prometheus-external",
            "--rpc-cors=all",
            "--rpc-external",
            "--rpc-methods=unsafe",
            "--unsafe-rpc-external",
        ]

    if chain_type == "testnet" and parachain["name"] == "litentry":
        common_command = common_command + ["--bootnodes=/dns/rpc.rococo-parachain.litentry.io/tcp/40333/ws/p2p/12D3KooWD9t5jsf5m2g4acXfyVf2KxR5j11F9SLC5wKhv6JRquyv"]
    
    parachain_info = {parachain["name"]: {}}
    if parachain["name"] == "altair" or parachain["name"] == "centrifuge":
        common_command = common_command + ["--database=auto"]

    if parachain["name"] == "subzero" and chain_type == "mainnet":
        common_command = [x for x in common_command if x != "--chain="]
        common_command = [x for x in common_command if x != "--port=30333"]

    final_parachain_info = {}
    for node in parachain["nodes"]:
        
        if "ports" in node: 
            rpc_port = node["ports"]["rpc_port"]
            lib2lib_port = node["ports"]["lib2lib_port"]
            prometheus_port = node["ports"]["prometheus_port"] if node["prometheus"] else None
            ws_port = node["ports"]["ws_port"] if parachain["name"] in constant.WS_PORT else None
        else:
            rpc_port = None
            lib2lib_port = None
            prometheus_port = None
            ws_port = None
                
        command = common_command
        command = command + ["--name={0}".format(node["name"])]
        if node["node_type"] == "collator":
            command = command + ["--collator"]

        if node["node_type"] == "validator":
            command = command + ["--validator"]

        if parachain["name"] in constant.CHAIN_COMMAND:
            if parachain["name"] in ["acala", "karura"] and chain_type == "testnet":
                command = command + ["--", "--chain={0}".format("/rococo-mandala.json")]
            else:
                command = command + ["--", "--chain={0}".format(relaychain_name)]

        if parachain["name"] == "kilt-spiritnet" and chain_type == "testnet":
            command = command + ["--", "--chain=/node/dev-specs/kilt-parachain/peregrine-relay.json"]

        if parachain["name"] in constant.BINARY_COMMAND_CHAINS:
            binary = parachain_details["entrypoint"]
            command = [binary] + command
            node_info = {}
            node_details = node_setup.run_testnet_node_with_entrypoint(plan, node["prometheus"], image, parachain["name"], "{0}-{1}-{2}".format(parachain["name"], node["name"], chain_type), command, rpc_port, prometheus_port, lib2lib_port, ws_port)
            node_info["service_name"] = node_details.name
            node_info["endpoint"] = utils.get_service_url("ws", node_details.ip_address, node_details.ports["ws"].number)
            node_info["ip_address"] = node_details.ip_address
            node_info["prometheus"] = node["prometheus"]
            node_info["node_type"] = node["node_type"]
            if node["prometheus"] == True:
                node_info["prometheus_port"] = node_details.ports["metrics"].number
            if prometheus_port != None:
                node_info["prometheus_public_port"] = prometheus_port
                node_info["endpoint_prometheus"] = utils.get_service_url("tcp", "127.0.0.1", prometheus_port)
            if ws_port != None:
                node_info["endpoint_public"] = utils.get_service_url("ws", "127.0.0.1", ws_port)
            elif rpc_port != None:
                node_info["endpoint_public"] = utils.get_service_url("ws", "127.0.0.1", rpc_port)

            final_parachain_info[node_details.name] = node_info

        else:
            node_info = {}
            node_details = node_setup.run_testnet_node_with_command(plan, node["prometheus"], image, parachain["name"], "{0}-{1}-{2}".format(parachain["name"], node["name"], chain_type), command, rpc_port, prometheus_port, lib2lib_port, ws_port)
            node_info["service_name"] = node_details.name
            node_info["endpoint"] = utils.get_service_url("ws", node_details.ip_address, node_details.ports["ws"].number)
            node_info["ip_address"] = node_details.ip_address
            node_info["prometheus"] = node["prometheus"]
            node_info["node_type"] = node["node_type"]
            if node["prometheus"] == True:
                node_info["prometheus_port"] = node_details.ports["metrics"].number
            if prometheus_port != None:
                node_info["prometheus_public_port"] = prometheus_port
                node_info["endpoint_prometheus"] = utils.get_service_url("tcp", "127.0.0.1", prometheus_port)
            if ws_port != None:
                node_info["endpoint_public"] = utils.get_service_url("ws", "127.0.0.1", ws_port)
            elif rpc_port != None:
                node_info["endpoint_public"] = utils.get_service_url("ws", "127.0.0.1", rpc_port)

            final_parachain_info[node_details.name] = node_info
    return final_parachain_info



def insert_keys(plan, key_type, private_phrase, uri):
    files = {
    "/javascript": "javascript",
    }

    plan.run_sh(
        run = 'cd /javascript && npm i && node insert_key.js "{0}" "{1}" "{2}"'.format(key_type, private_phrase, uri),
        image = constant.NODE_IMAGE,
        files = files,
    )
