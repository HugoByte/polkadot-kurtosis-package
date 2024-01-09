utils = import_module("../package_io/utils.star")


def start_relay_chain(plan, args, rpc_port = [], prometheus_port = [], lib2lib_port = []):
    """
    Starts relay chain nodes based on the provided arguments.

    Args:
        plan (object): The Kurtosis plan object for orchestrating the test.
        args (dict): Dictionary containing arguments for configuring the relay chain setup.

    Returns:
        list: List of dictionaries containing service details of started relay chain nodes.
    """
    name = args["chain-type"]
    chain = args["relaychain"]["name"]
    final_details = {}

    ports = {
        "ws": PortSpec(9944, transport_protocol = "TCP"),
        "lib2lib": PortSpec(30333, transport_protocol = "TCP")
    }
    
    relay_nodes = args["relaychain"]["nodes"]

    for idx, relay_node in enumerate(relay_nodes):
        public_ports = {}
        
        rpc_port_value = rpc_port[idx] if rpc_port else None
        prometheus_port_value = prometheus_port[idx] if prometheus_port else None
        lib2lib_port_value = lib2lib_port[idx] if lib2lib_port else None


        if rpc_port_value != None :
            public_ports["ws"] = PortSpec(rpc_port_value, transport_protocol = "TCP")
    
        if lib2lib_port_value != None:
            public_ports["lib2lib"] = PortSpec(lib2lib_port_value, transport_protocol = "TCP")
        
        if relay_node["prometheus"]:
            ports["metrics"] = PortSpec(9615, transport_protocol="TCP")

        if prometheus_port_value == 0:
            prometheus_port_value = None

        if prometheus_port_value != None:
            public_ports["metrics"] = PortSpec(prometheus_port_value, transport_protocol = "TCP")
    
        exec_command = ["bin/sh", "-c", "polkadot  --rpc-external --rpc-cors=all --rpc-methods=unsafe --chain {0} --name={1} --execution=wasm --prometheus-external".format(chain, relay_node["name"])]
        service_details = plan.add_service(
            name = "{0}-{1}-{2}".format(name, chain, relay_node["name"]),
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
        relay_node_details["node-type"] = relay_node["node-type"]
        if relay_node["prometheus"] == True:
            relay_node_details["prometheus_port"] = service_details.ports["metrics"].number
        if prometheus_port_value != None:
            relay_node_details["prometheus_public_port"] = prometheus_port_value
            relay_node_details["endpoint_prometheus"] = utils.get_service_url("tcp", "127.0.0.1", prometheus_port_value)
        if rpc_port_value != None:
            relay_node_details["endpoint_public"] = utils.get_service_url("ws", "127.0.0.1", rpc_port_value)

        final_details[service_details.name] = relay_node_details

    return final_details

def start_test_main_net_relay_nodes(plan, args, rpc_port = [], prometheus_port = [], lib2lib_port = []):
    """
    Starts testnet/mainnet relay nodes based on the provided arguments.

    Args:
        plan (object): The Kurtosis plan object for orchestrating the test.
        args (dict): Dictionary containing arguments for configuring the relay node setup.

    Returns:
        list: List of dictionaries containing service details of started relay nodes.
    """
    name = args["chain-type"]
    chain = args["relaychain"]["name"]

    if name == "testnet":
        if chain != "rococo" and chain != "westend":
            fail("Please provide rococo or westend as relaychain for testnet")
    elif name == "mainnet":
        if chain != "polkadot" and chain != "kusama":
            fail("Please provide polkadot or kusama as relaychain for mainnet")

    relay_node_details = start_relay_chain(plan, args, rpc_port, prometheus_port, lib2lib_port)

    return relay_node_details

def start_relay_chains_local(plan, args, rpc_port = [], prometheus_port = [], lib2lib_port = []):
    """
    Starts local relay chain nodes based on the provided arguments.

    Args:
        plan (object): The Kurtosis plan object for orchestrating the test.
        args (dict): Dictionary containing arguments for configuring the relay chain setup.

    Returns:
        list: List of dictionaries containing sevice details of started relay chain nodes.
    """
    name = args["chain-type"]
    chain = args["relaychain"]["name"]

    if name == "local":
        if chain != "rococo-local":
            fail("Please provide rococo-local as relaychain for localnet")

    relay_nodes = args["relaychain"]["nodes"]

    if len(relay_nodes) < 2:
        fail("relay nodes must contain at least two nodes")

    final_details = {}
    for idx, node in enumerate(relay_nodes):
        relay_detail = {}
        rpc_port_value = rpc_port[idx] if rpc_port else None
        prometheus_port_value = prometheus_port[idx] if prometheus_port else None
        lib2lib_port_value = lib2lib_port[idx] if lib2lib_port else None
        
        if prometheus_port_value == 0:
            prometheus_port_value = None
        
        service_details = start_relay_chain_local(plan, args, node["name"], node["prometheus"], rpc_port_value, prometheus_port_value, lib2lib_port_value)
        
        relay_detail["endpoint"] = utils.get_service_url("ws", service_details.ip_address, service_details.ports["ws"].number)
        relay_detail["service_name"] = service_details.name
        relay_detail["prometheus"] = node["prometheus"]
        relay_detail["ip_address"] = service_details.ip_address
        relay_detail["node-type"] = node["node-type"]
        if node["prometheus"] == True:
            relay_detail["prometheus_port"] = service_details.ports["metrics"].number
        if prometheus_port_value != None:
            relay_detail["prometheus_public_port"] = prometheus_port_value
            relay_detail["endpoint_prometheus"] = utils.get_service_url("tcp", "127.0.0.1", prometheus_port_value)
        if rpc_port_value != None:
            relay_detail["endpoint_public"] = utils.get_service_url("ws", "127.0.0.1", rpc_port_value)

        final_details[service_details.name] = relay_detail

    return final_details

def start_relay_chain_local(plan, args, name, prometheus, rpc_port = None, prometheus_port = None, lib2lib_port = None):
    """
    Starts a local relay chain node based on the provided arguments.

    Args:
        plan (object): The Kurtosis plan
        name (str): Name of the relay chain node.

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
    
    exec_command = ["bin/sh", "-c", "polkadot --base-path=/data --chain=/app/raw-polkadot.json --validator --rpc-external --port=30333 --rpc-cors=all --name=alice --{0} --rpc-methods=unsafe --execution=wasm --prometheus-external --insecure-validator-i-know-what-i-do".format(name)]
    service_details = plan.add_service(
        name = "{0}-{1}".format(args["relaychain"]["name"], name),
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
