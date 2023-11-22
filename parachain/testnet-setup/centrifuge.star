def run_centrifuge(plan):
    exec_command = [
        "--chain=catalyst",
        "--rpc-port=9944",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--execution=wasm",
        "--tmp",
        "--",
        "--chain=rococo"
    ]
    altair_service_config = ServiceConfig(
        image = "centrifugeio/centrifuge-chain:main-latest",
        files = {
            "/app": "configs",
        },
        ports = {
            "ws": PortSpec(9944, transport_protocol = "TCP"),
        },
        public_ports = {
            "ws": PortSpec(9432, transport_protocol = "TCP"),
        },
        cmd = exec_command,
        entrypoint = ["/usr/local/bin/centrifuge-chain"]
    )
    plan.add_service(name = "centrifuge-node", config = altair_service_config)
