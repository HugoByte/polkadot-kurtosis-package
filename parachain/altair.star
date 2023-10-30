def run_altair(plan):
    exec_command = ["--chain=altair-local", "--rpc-port=9933","--rpc-external", "--rpc-cors=all", "--rpc-methods=unsafe", "--execution=wasm", "--tmp", "--", "--chain=/app/rococo-local.json", "--execution=wasm"]
    altair_service_config = ServiceConfig(
        image = "centrifugeio/centrifuge-chain:test-main-latest",
        files = {
            "/app":"configs"
        },
        ports = {
            "9944": PortSpec(9944, transport_protocol="TCP"),
            "9933": PortSpec(9933, transport_protocol="TCP")
        },
        public_ports = {
            "9944": PortSpec(9432, transport_protocol="TCP"),
            "9933": PortSpec(9431, transport_protocol="TCP")

        },
        cmd = exec_command,
    )
    plan.add_service(name="altair-node", config=altair_service_config)
