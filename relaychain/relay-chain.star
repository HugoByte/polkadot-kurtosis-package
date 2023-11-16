def start_relay_chain(plan, args):
    name = args["chain-type"]
    chain = args["relaychain"]["name"]
    relay_node_details = {}
    for relay_node in args["relaychain"]["nodes"]:
        port = relay_node["port"]
        exec_command = ["bin/sh", "-c", "polkadot  --rpc-external --rpc-cors=all --rpc-methods=unsafe --chain {0} --name={1} --execution=wasm".format(chain, relay_node["name"])]
        relay_node_detail = plan.add_service(
            name = "{0}-{1}-{2}".format(name, chain, relay_node["name"]),
            config = ServiceConfig(
                image = "parity/polkadot:latest",
                ports = {
                    "polkadot": PortSpec(9944, transport_protocol = "TCP"),
                },
                public_ports = {
                    "polkadot": PortSpec(port, transport_protocol = "TCP"),
                },
                entrypoint = exec_command,
            ),
        )
        relay_node_details["relay_service_" + relay_node["name"]] = relay_node_detail

    return relay_node_details

def start_test_main_net_relay_nodes(plan, args):
    name = args["chain-type"]
    chain = args["relaychain"]["name"]
    if name == "testnet":
        if chain != "rococo" and chain != "westend":
            fail("Please provide rococo or westent as relaychain for testnet")
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
    relay_detail = {}
    for node in relay_nodes:
        service_details = start_relay_chain_local(plan, node["name"], node["port"])
        relay_detail["relay_service_" + node["name"]] = service_details
    return relay_detail

def start_relay_chain_local(plan, name, port):
    exec_command = ["bin/sh", "-c", "polkadot --base-path=/data --chain=/app/raw-polkadot.json --validator --rpc-external --rpc-cors=all --name=alice --{0} --rpc-methods=unsafe --execution=wasm".format(name)]
    service_details = plan.add_service(
        name = "polkadot-{0}".format(name),
        config = ServiceConfig(
            image = "parity/polkadot:latest",
            files = {
                "/app": "configs",
            },
            ports = {
                "polkadot": PortSpec(9944, transport_protocol = "TCP"),
            },
            public_ports = {
                "polkadot": PortSpec(port, transport_protocol = "TCP"),
            },
            entrypoint = exec_command,
        ),
    )
    return service_details
