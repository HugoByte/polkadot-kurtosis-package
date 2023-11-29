def start_relay_chain(plan, args):
    name = args["chain-type"]
    chain = args["relaychain"]["name"]
    final_details=[]
    
    prometheus = 9615
    for relay_node in args["relaychain"]["nodes"]:
        port = relay_node["port"]
        exec_command = ["bin/sh", "-c", "polkadot  --rpc-external --rpc-cors=all --rpc-methods=unsafe --chain {0} --name={1} --execution=wasm --prometheus-external".format(chain, relay_node["name"])]
        service_details = plan.add_service(
            name = "{0}-{1}-{2}".format(name, chain, relay_node["name"]),
            config = ServiceConfig(
                image = "parity/polkadot:latest",
                ports = {
                    "ws": PortSpec(9944, transport_protocol = "TCP"),
                    "metrics": PortSpec(9615, transport_protocol = "TCP"),
                },
                public_ports = {
                    "ws": PortSpec(port, transport_protocol = "TCP"),
                    "metrics": PortSpec(prometheus, transport_protocol = "TCP"),
                },
                entrypoint = exec_command,
            ),
        )
        prometheus += 1
        relay_node_details = {}
        relay_node_details["service_details"] = service_details
        relay_node_details["service_name"] = service_details.name
        final_details.append(relay_node_details)

    return final_details

def start_test_main_net_relay_nodes(plan, args):
    name = args["chain-type"]
    chain = args["relaychain"]["name"]
    if name == "testnet":
        if chain != "rococo" and chain != "westend":
            fail("Please provide rococo or westend as relaychain for testnet")
    elif name == "mainnet":
        if chain != "polkadot" and chain != "kusama":
            fail("Please provide polkadot or kusama as relaychain for mainnet")
    relay_node_details = start_relay_chain(plan, args)

    return relay_node_details

def spawn_multiple_relay(plan, count):
    list = ["alice", "bob", "dave", "charlie"]
    port = 9944
    for i in range(0, count):
        port = port + count
        start_relay_chain_local(plan, list[i], port)

def start_relay_chains_local(plan, args):
    relay_nodes = args["relaychain"]["nodes"]
    final_details=[]
    prometheus_port = 9615
    for node in relay_nodes:
        relay_detail = {}
        service_details = start_relay_chain_local(plan, node["name"], node["port"], prometheus_port)
        relay_detail["service_details"] = service_details
        relay_detail["service_name"] = "relay_service_" + node["name"]
        final_details.append(relay_detail)
        prometheus_port = prometheus_port + 1
    return final_details

def start_relay_chain_local(plan, name, port, prometheus_port):
    exec_command = ["bin/sh", "-c", "polkadot --base-path=/data --chain=/app/raw-polkadot.json --validator --rpc-external --rpc-cors=all --name=alice --{0} --rpc-methods=unsafe --execution=wasm --prometheus-external".format(name)]
    service_details = plan.add_service(
        name = "polkadot-{0}".format(name),
        config = ServiceConfig(
            image = "parity/polkadot:latest",
            files = {
                "/app": "configs",
            },
            ports = {
                "ws": PortSpec(9944, transport_protocol = "TCP"),
                "metrics": PortSpec(9615, transport_protocol = "TCP"),
            },
            public_ports = {
                "ws": PortSpec(port, transport_protocol = "TCP"),
                "metrics": PortSpec(prometheus_port, transport_protocol = "TCP"),
            },
            entrypoint = exec_command,
        ),
    )
    return service_details
