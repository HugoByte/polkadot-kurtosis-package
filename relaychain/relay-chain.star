PORT = 9944

def start_relay_chain(plan, args):
    name = args["chain-type"]
    exec_command = ["bin/sh", "-c", "polkadot --rpc-external --rpc-cors=all --rpc-methods=unsafe --chain rococo-local --name={0} --execution=wasm".format(name)]
    plan.add_service(
        name = "polkadot-{0}".format(name),
        config = ServiceConfig(
            image = "parity/polkadot:latest",
            ports = {
                "polkadot": PortSpec(9944, transport_protocol = "TCP"),
            },
            public_ports = {
                "polkadot": PortSpec(PORT, transport_protocol = "TCP"),
            },
            entrypoint = exec_command,
        ),
    )

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
    exec_command = ["bin/sh", "-c", "polkadot --base-path=/data --chain=/app/rococo-local.json --validator --ws-external --rpc-external --rpc-cors=all --name=alice --{0} --rpc-methods=unsafe --execution=wasm".format(name)]
    service_details = plan.add_service(
        name = "polkadot-{0}".format(name),
        config = ServiceConfig(
            image = "parity/polkadot:v0.9.31",
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
