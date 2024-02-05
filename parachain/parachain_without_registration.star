build_spec = import_module("./build-spec.star")
register_para_slot = import_module("./register-para-id.star")
constant = import_module("../package_io/constant.star")
parachain_list = import_module("./static_files/images.star")
node_setup = import_module("./node_setup.star")
utils = import_module("../package_io/utils.star")

# starting the relay and parachain without registering para slot id
def start_nodes(plan, chain_type, relaychain, parachains):
    final_parachain_details = {}

    # Hard coding the para slot id , initially it will be 2000
    para_id = 2000

    # counter for increment para slot id
    counter = 0
    for parachain in parachains:
        para_id = para_id + counter
        chain_name = parachain["name"]
        parachain_details = parachain_list.parachain_images[chain_name]
        image = parachain_details["image"]
        binary = parachain_details["entrypoint"]
        chain_base = parachain_details["base"][0]

        # Creating the genisis state genesis wasm and raw build spec for parachain
        build_spec.create_parachain_build_spec_with_para_id(plan, image, binary, chain_name, chain_base, para_id)

        #  if parachain are more than one, adding the genisis state genesis wasm to relay(polkadot) chain spec
        if counter > 0:
            register_para_slot.add_genesis_state_and_wasm_to_relay(plan, para_id, chain_name, "polkadot_{0}".format(para_id - 1))
        else:
            register_para_slot.add_genesis_state_and_wasm_to_relay(plan, para_id, chain_name)

        counter = counter + 1

    register_para_slot.build_relay_chain_raw(plan, "polkadot_{0}".format(para_id))  # artifact name after building the rae spec will be `polkadot_raw`
    relay_chain_details = start_relay_chain(plan, chain_type, relaychain, "polkadot_raw")
    final_parachain_details.update(relay_chain_details)
    parachain_details = {}

    # Starting the parachains
    for parachain in parachains:
        parachain_details = start_local_parachain_node(plan, chain_type, parachain, para_id, "{0}raw".format(parachain["name"]))

    final_parachain_details.update(parachain_details)

    return final_parachain_details

def start_local_parachain_node(plan, chain_type, parachain, para_id, raw_service):
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
            exec_comexec_commandmand = [
                "/bin/bash",
                "-c",
                "{0} --base-path=/tmp/{1} --chain=/build/{1}-raw.json --ws-port=9944 --port=30333 --rpc-port=9947 --ws-external --rpc-external --prometheus-external --rpc-cors=all --{2} --collator --rpc-methods=unsafe --force-authoring --execution=wasm -- --chain=/relay/polkadot-raw.json --execution=wasm".format(binary, chain_name, node["name"]),
            ]
        else:
            exec_comexec_commandmand = [
                "/bin/bash",
                "-c",
                "{0} --base-path=/tmp/{1} --chain=/build/{1}-raw.json --rpc-port=9947 --port=30333 --rpc-external --rpc-cors=all --prometheus-external --{2} --collator --rpc-methods=unsafe --force-authoring --execution=wasm -- --chain=/relay/polkadot-raw.json --execution=wasm".format(binary, chain_name, node["name"]),
            ]

        build_file = raw_service
        parachain_spawn_detail = node_setup.spawn_parachain(plan, node["prometheus"], image, parachain["name"], "{0}-{1}-{2}".format(chain_name, node["name"], chain_type), exec_comexec_commandmand, build_file, rpc_port, prometheus_port, lib2lib_port, ws_port, "polkadot_raw")
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

    return parachain_final

def start_relay_chain(plan, chain_type, relaychain, chain_spec):
    """
    Starts relay chain nodes based on the provided arguments.

    Args:
        chain_type (string): The type of chain (localnet, testnet or mainnet).
        relaychain (dict): A dict containing data for relay chain config.

    Returns:
        list: List of dictionaries containing service details of started relay chain nodes.
    """

    relay_nodes = relaychain["nodes"]

    final_details = {}

    ports = {
        "ws": PortSpec(9944, transport_protocol = "TCP"),
        "lib2lib": PortSpec(30333, transport_protocol = "TCP"),
    }

    for relay_node in relay_nodes:
        public_ports = {}

        if "ports" in relay_node:
            rpc_port = relay_node["ports"]["rpc_port"]
            lib2lib_port = relay_node["ports"]["lib2lib_port"]
            prometheus_port = relay_node["ports"]["prometheus_port"] if relay_node["prometheus"] else None
        else:
            rpc_port = None
            lib2lib_port = None
            prometheus_port = None

        if rpc_port != None:
            public_ports["ws"] = PortSpec(rpc_port, transport_protocol = "TCP")

        if lib2lib_port != None:
            public_ports["lib2lib"] = PortSpec(lib2lib_port, transport_protocol = "TCP")

        if relay_node["prometheus"]:
            ports["metrics"] = PortSpec(9615, transport_protocol = "TCP")

        if prometheus_port != None:
            public_ports["metrics"] = PortSpec(prometheus_port, transport_protocol = "TCP")

        command = "polkadot --chain=/config/polkadot-raw.json --validator --rpc-external --port=30333 --rpc-cors=all --{0} --rpc-methods=unsafe --execution=wasm --prometheus-external --insecure-validator-i-know-what-i-do".format(relay_node["name"])

        exec_command = ["bin/sh", "-c", command]

        service_details = plan.add_service(
            name = "{0}-{1}-{2}".format(chain_type, "localnet", relay_node["name"]),
            config = ServiceConfig(
                image = "parity/polkadot:latest",
                ports = ports,
                public_ports = public_ports,
                entrypoint = exec_command,
                files = {
                    "/config": chain_spec,
                },
            ),
        )

        relay_node_details = {}
        relay_node_details["endpoint"] = utils.get_service_url("ws", service_details.ip_address, service_details.ports["ws"].number)
        relay_node_details["service_name"] = service_details.name
        relay_node_details["prometheus"] = relay_node["prometheus"]
        relay_node_details["ip_address"] = service_details.ip_address
        relay_node_details["node_type"] = relay_node["node_type"]
        if relay_node["prometheus"] == True:
            relay_node_details["prometheus_port"] = service_details.ports["metrics"].number
        if prometheus_port != None:
            relay_node_details["prometheus_public_port"] = prometheus_port
            relay_node_details["endpoint_prometheus"] = utils.get_service_url("tcp", "127.0.0.1", prometheus_port)
        if rpc_port != None:
            relay_node_details["endpoint_public"] = utils.get_service_url("ws", "127.0.0.1", rpc_port)

        final_details[service_details.name] = relay_node_details

    return final_details
