utils = import_module("../package_io/utils.star")


def start_relay_chain(plan, chain_type, relaychain):
    """
    Starts relay chain nodes based on the provided arguments.

    Args:
        chain_type (string): The type of chain (localnet, testnet or mainnet).
        relaychain (dict): A dict containing data for relay chain config.
        
    Returns:
        list: List of dictionaries containing service details of started relay chain nodes.
    """
    chain_name = relaychain["name"]
    relay_nodes = relaychain["nodes"]

    final_details = {}

    ports = {
        "ws": PortSpec(9944, transport_protocol = "TCP"),
        "lib2lib": PortSpec(30333, transport_protocol = "TCP")
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

        if rpc_port != None :
            public_ports["ws"] = PortSpec(rpc_port, transport_protocol = "TCP")
    
        if lib2lib_port != None:
            public_ports["lib2lib"] = PortSpec(lib2lib_port, transport_protocol = "TCP")
        
        if relay_node["prometheus"]:
            ports["metrics"] = PortSpec(9615, transport_protocol="TCP")

        if prometheus_port != None:
            public_ports["metrics"] = PortSpec(prometheus_port, transport_protocol = "TCP")
            
        command = "polkadot --rpc-external --rpc-cors=all --rpc-methods=unsafe --chain {0} --name={1} --execution=wasm --prometheus-external".format(chain_name, relay_node["name"])

        if relay_node["node_type"] == "validator":
            command = command + " --validator --insecure-validator-i-know-what-i-do"
        elif relay_node["node_type"] == "archive":
            command = command +  " --pruning=archive"

        exec_command = ["bin/sh", "-c", command]
        
        service_details = plan.add_service(
            name = "{0}-{1}-{2}".format(chain_type, chain_name, relay_node["name"]),
            config = ServiceConfig(
                image = "parity/polkadot:latest",
                ports = ports,
                public_ports = public_ports,
                entrypoint = exec_command,
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

def start_test_main_net_relay_nodes(plan, chain_type, relaychain):
    """
    Starts testnet/mainnet relay nodes based on the provided arguments.

    Args:
        chain_type (string): The type of chain (localnet, testnet or mainnet).
        relaychain (dict): A dict containing data for relay chain config.

    Returns:
        list: List of dictionaries containing service details of started relay nodes.
    """

    relay_node_details = start_relay_chain(plan, chain_type, relaychain)

    return relay_node_details

def start_relay_chains_local(plan, relaychain):
    """
    Starts local relay chain nodes based on the provided arguments.

    Args:
        relaychain (dict): A dict containing data for relay chain config.

    Returns:
        list: List of dictionaries containing sevice details of started relay chain nodes.
    """
    chain_name = relaychain["name"]
    relay_nodes = relaychain["nodes"]
    
    final_details = {}
    for node in relay_nodes:
        relay_detail = {}
        if "ports" in node: 
            rpc_port = node["ports"]["rpc_port"]
            lib2lib_port = node["ports"]["lib2lib_port"]
            prometheus_port = node["ports"]["prometheus_port"] if node["prometheus"] else None
        else:
            rpc_port = None
            lib2lib_port = None
            prometheus_port = None
        
        service_details = start_relay_chain_local(plan, chain_name, node["name"], node["prometheus"], rpc_port, prometheus_port, lib2lib_port)
        
        relay_detail["endpoint"] = utils.get_service_url("ws", service_details.ip_address, service_details.ports["ws"].number)
        relay_detail["service_name"] = service_details.name
        relay_detail["prometheus"] = node["prometheus"]
        relay_detail["ip_address"] = service_details.ip_address
        relay_detail["node_type"] = node["node_type"]
        if node["prometheus"]:
            relay_detail["prometheus_port"] = service_details.ports["metrics"].number
        if prometheus_port != None:
            relay_detail["prometheus_public_port"] = prometheus_port
            relay_detail["endpoint_prometheus"] = utils.get_service_url("tcp", "127.0.0.1", prometheus_port)
        if rpc_port != None:
            relay_detail["endpoint_public"] = utils.get_service_url("ws", "127.0.0.1", rpc_port)

        final_details[service_details.name] = relay_detail

    return final_details

def start_relay_chain_local(plan, chain_name, node_name, prometheus, rpc_port = None, prometheus_port = None, lib2lib_port = None):
    """
    Starts a local relay chain node based on the provided arguments.

    Args:
        chain_name (string): Name of relay chain.
        node_name (string): Name of node.
        prometheus (bool): Boolean value to enable metrics for a given node.
        rpc_port (int, optional): The RPC port value. Defaults to None.
        prometheus_port (int, optional): The Prometheus port value. Defaults to None.
        lib2lib_port (int, optional): The lib2lib port value. Defaults to None.

    Returns:
        object: Service details of the started relay chain node.
    """
    ports = {
        "ws": PortSpec(9944, transport_protocol = "TCP"),
        "lib2lib": PortSpec(30333, transport_protocol = "TCP"),
    }
    
    public_ports = {}

    if rpc_port != None :
        public_ports["ws"] = PortSpec(rpc_port, transport_protocol = "TCP")
    
    if lib2lib_port != None:
        public_ports["lib2lib"] = PortSpec(lib2lib_port, transport_protocol = "TCP")
        
    if prometheus:
        ports["metrics"] = PortSpec(9615, transport_protocol="TCP")

    if prometheus_port != None:
        public_ports["metrics"] = PortSpec(prometheus_port, transport_protocol = "TCP")
    
    exec_command = ["bin/sh", "-c", "polkadot --base-path=/data --chain=/app/raw-polkadot.json --validator --rpc-external --port=30333 --rpc-cors=all --name=alice --{0} --rpc-methods=unsafe --execution=wasm --prometheus-external --insecure-validator-i-know-what-i-do".format(node_name)]
    service_details = plan.add_service(
        name = "{0}-{1}".format(chain_name, node_name),
        config = ServiceConfig(
            image = "parity/polkadot:latest",
            files = {
                "/app": "configs",
            },
            ports = ports,
            public_ports = public_ports,
           entrypoint = exec_command,
        ),
    )
    return service_details
