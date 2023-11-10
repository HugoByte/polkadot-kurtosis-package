def run_altair(plan):
    exec_command = [
        "--chain=altair",
        "--rpc-port=9933",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--unsafe-ws-external",
        "--execution=wasm"
    ]
    altair_service_config = ServiceConfig(
        image = "centrifugeio/centrifuge-chain:test-main-latest",
        files = {
            "/app": "configs",
        },
        ports = {
            "ws": PortSpec(9944, transport_protocol = "TCP"),
            "rpc": PortSpec(9933, transport_protocol = "TCP"),
        },
        public_ports = {
            "ws": PortSpec(9432, transport_protocol = "TCP"),
            "rpc": PortSpec(9431, transport_protocol = "TCP"),
        },
        cmd = exec_command,
        entrypoint = ["/usr/local/bin/centrifuge-chain"]
    )
    plan.add_service(name = "altair-node", config = altair_service_config)
