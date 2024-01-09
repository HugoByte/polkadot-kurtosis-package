build_spec = import_module("./build-spec.star")
register_para_slot = import_module("./register-para-id.star")
constant = import_module("../package_io/constant.star")
parachain_list = import_module("./static_files/images.star")
node_setup = import_module("./node_setup.star")
utils = import_module("../package_io/utils.star")

def start_local_parachain_node(plan, args, parachain_config, para_id, rpc_port = [], prometheus_port = [], lib2lib_port = []):
    """Start local parachain nodes based on configuration.

    Args:
        plan (object): The Kurtosis plan.
        args (dict): arguments for configuration.
        parachain_config (dict): Configuration for the parachain.
        para_id (int): Parachain ID.

    Returns:
        list: List of dictionaries containing service details of parachain nodes.
    """
    parachain = parachain_config["name"].lower()
    parachain_details = parachain_list.parachain_images[parachain]
    image = parachain_details["image"]
    binary = parachain_details["entrypoint"]
    chain_base = parachain_details["base"][0]
    chain_name = parachain
    raw_service = build_spec.create_parachain_build_spec_with_para_id(plan, image, binary, chain_name, chain_base, para_id)

    parachain_final = {}
    for idx, node in enumerate(parachain_config["nodes"]):
        parachain_detail = {}
        rpc_port_value = rpc_port[idx] if rpc_port else None
        prometheus_port_value = prometheus_port[idx] if prometheus_port else None
        lib2lib_port_value = lib2lib_port[idx] if lib2lib_port else None

        if parachain in constant.NO_WS_PORT:
            exec_comexec_commandmand = [
                "/bin/bash",
                "-c",
                "{0} --base-path=/tmp/{1} --chain=/build/{1}-raw.json --rpc-port=9946 --port=30333 --rpc-external --rpc-cors=all --prometheus-external --{2} --collator --rpc-methods=unsafe --force-authoring --execution=wasm --trie-cache-size=0 -- --chain=/app/raw-polkadot.json --execution=wasm".format(binary, chain_name, node["name"]),
            ]
        else:
            exec_comexec_commandmand = [
                "/bin/bash",
                "-c",
                "{0} --base-path=/tmp/{1} --chain=/build/{1}-raw.json --ws-port=9946 --port=30333 --rpc-port=9933 --ws-external --rpc-external --prometheus-external --rpc-cors=all --{2} --collator --rpc-methods=unsafe --force-authoring --execution=wasm -- --chain=/app/raw-polkadot.json --execution=wasm".format(binary, chain_name, node["name"]),
            ]
        
        build_file = raw_service.name
        parachain_spawn_detail = node_setup.spawn_parachain(plan, node["prometheus"], "{0}-{1}-{2}".format(parachain, node["name"].lower(), args["chain-type"]), image, exec_comexec_commandmand, build_file, rpc_port_value, prometheus_port_value, lib2lib_port_value)
        parachain_detail["service_name"] = parachain_spawn_detail.name
        parachain_detail["endpoint"] = utils.get_service_url("ws", parachain_spawn_detail.ip_address, parachain_spawn_detail.ports["ws"].number)
        parachain_detail["ip_address"] = parachain_spawn_detail.ip_address
        parachain_detail["prometheus"] = node["prometheus"]
        parachain_detail["node-type"] = node["node-type"]
        if node["prometheus"] == True:
            parachain_detail["prometheus_port"] = parachain_spawn_detail.ports["metrics"].number
        if prometheus_port_value != None or prometheus_port_value != 0:
            parachain_detail["prometheus_public_port"] = prometheus_port_value
            parachain_detail["endpoint_prometheus"] = utils.get_service_url("tcp", "127.0.0.1", prometheus_port_value)
        if rpc_port_value != None:
            parachain_detail["endpoint_public"] = utils.get_service_url("ws", "127.0.0.1", rpc_port_value)

        parachain_final[parachain_spawn_detail.name] = parachain_detail

    return parachain_final

def start_nodes(plan, args, relay_chain_ip, rpc_port = [[]], prometheus_port = [[]], lib2lib_port = [[]]):
    """Start multiple parachain nodes.

    Args:
        plan (object): The kurtosis plan.
        args (dict): arguments for configuration.
        relay_chain_ip (str): IP address of the relay chain.

    Returns:
        list: List of dictionaries containing service details of each parachain.
    """
    parachains = args["para"]
    final_parachain_details = {}
    for idx, parachain in enumerate(parachains):
        para_id = register_para_slot.register_para_id(plan, relay_chain_ip)
        
        rpc_port_idx = rpc_port[idx] if idx < len(rpc_port) else []
        prometheus_port_idx = prometheus_port[idx] if idx < len(prometheus_port) else []
        lib2lib_port_idx = lib2lib_port[idx] if idx < len(lib2lib_port) else []
        
        parachain_details = start_local_parachain_node(plan, args, parachain, para_id, rpc_port_idx, prometheus_port_idx, lib2lib_port_idx)
        register_para_slot.onboard_genesis_state_and_wasm(plan, para_id, parachain["name"], relay_chain_ip)
        final_parachain_details.update(parachain_details)
    
    return final_parachain_details

def run_testnet_mainnet(plan, parachain, args, rpc_port = [], prometheus_port = [], lib2lib_port = []):
    """Run a testnet or mainnet based on configuration.

    Args:
        plan (object): The kurtosis plan.
        parachain (dict): Configuration for the parachain.
        args (dict): arguments for configuration.

    Returns:
        list: List of dictionaries containing details of each parachain node.
    """
    if args["chain-type"] == "testnet":
        main_chain = "rococo"
        if parachain["name"] == "ajuna":
            parachain["name"] = "bajun"
        parachain_details = parachain_list.parachain_images[parachain["name"]]
        image = parachain_details["image"]
        base = parachain_details["base"][1]

        if parachain["name"] in constant.DIFFERENT_IMAGES_FOR_TESTNET:
            image = constant.DIFFERENT_IMAGES_FOR_TESTNET[parachain["name"].lower()]

    else:
        main_chain = "polkadot"
        parachain_details = parachain_list.parachain_images[parachain["name"].lower()]
        image = parachain_details["image"]
        base = parachain_details["base"][2]

        if parachain["name"] in constant.DIFFERENT_IMAGES_FOR_MAINNET:
            image = constant.DIFFERENT_IMAGES_FOR_MAINNET[parachain["name"].lower()]

    if base == None:
        fail("Tesnet is not there for {}".format(parachain["name"]))

    if parachain["name"] in constant.NO_WS_PORT:
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
    else:
        common_command = [
            "--chain={0}".format(base),
            "--port=30333",
            "--ws-port=9944",
            "--rpc-port=9933",
            "--prometheus-external",
            "--rpc-cors=all",
            "--rpc-external",
            "--ws-external",
            "--rpc-methods=unsafe",
            "--unsafe-rpc-external",
            "--unsafe-ws-external",
        ]

    parachain_info = {parachain["name"]: {}}
    if parachain["name"] == "altair" or parachain["name"] == "centrifuge":
        common_command = common_command + ["--database=auto"]

    if parachain["name"] == "subzero" and args["chain-type"] == "mainnet":
        common_command = [x for x in common_command if x != "--chain="]
        common_command = [x for x in common_command if x != "--port=30333"]

    final_parachain_info = {}
    for idx, node in enumerate(parachain["nodes"]):
        rpc_port_value = rpc_port[idx] if rpc_port else None
        prometheus_port_value = prometheus_port[idx] if prometheus_port else None
        lib2lib_port_value = lib2lib_port[idx] if lib2lib_port else None

        if prometheus_port_value == 0:
            prometheus_port_value = None
                
        command = common_command
        command = command + ["--name={0}".format(node["name"])]
        if node["node-type"] == "collator":
            command = command + ["--collator"]

        if node["node-type"] == "validator":
            command = command + ["--validator"]

        if parachain["name"] in constant.CHAIN_COMMAND:
            command = command + ["--", "--chain={0}".format(main_chain)]

        if parachain["name"] == "kilt-spiritnet" and args["chain-type"] == "testnet":
            command = command + ["--", "--chain=/node/dev-specs/kilt-parachain/peregrine-relay.json"]

        if parachain["name"] in constant.BINARY_COMMAND_CHAINS:
            binary = parachain_details["entrypoint"]
            command = [binary] + command
            node_info = {}
            node_details = node_setup.run_testnet_node_with_entrypoint(plan, node["prometheus"], image, "{0}-{1}-{2}".format(parachain["name"], node["name"], args["chain-type"]), command, rpc_port_value, prometheus_port_value, lib2lib_port_value)
            node_info["service_name"] = node_details.name
            node_info["endpoint"] = utils.get_service_url("ws", node_details.ip_address, node_details.ports["ws"].number)
            node_info["ip_address"] = node_details.ip_address
            node_info["prometheus"] = node["prometheus"]
            node_info["node-type"] = node["node-type"]
            if node["prometheus"] == True:
                node_info["prometheus_port"] = node_details.ports["metrics"].number
            if prometheus_port_value != None:
                node_info["prometheus_public_port"] = prometheus_port_value
                node_info["endpoint_prometheus"] = utils.get_service_url("tcp", "127.0.0.1", prometheus_port_value)
            if rpc_port_value != None:
                node_info["endpoint_public"] = utils.get_service_url("ws", "127.0.0.1", rpc_port_value)

            final_parachain_info[node_details.name] = node_info

        else:
            node_info = {}
            node_details = node_setup.run_testnet_node_with_command(plan, node["prometheus"], image, "{0}-{1}-{2}".format(parachain["name"], node["name"], args["chain-type"]), command, rpc_port_value, prometheus_port_value, lib2lib_port_value)
            node_info["service_name"] = node_details.name
            node_info["endpoint"] = utils.get_service_url("ws", node_details.ip_address, node_details.ports["ws"].number)
            node_info["ip_address"] = node_details.ip_address
            node_info["prometheus"] = node["prometheus"]
            node_info["node-type"] = node["node-type"]
            if node["prometheus"] == True:
                node_info["prometheus_port"] = node_details.ports["metrics"].number
            if prometheus_port_value != None:
                node_info["prometheus_public_port"] = prometheus_port_value
                node_info["endpoint_prometheus"] = utils.get_service_url("tcp", "127.0.0.1", prometheus_port_value)
            if rpc_port_value != None:
                node_info["endpoint_public"] = utils.get_service_url("ws", "127.0.0.1", rpc_port_value)

            final_parachain_info[node_details.name] = node_info
    return final_parachain_info
