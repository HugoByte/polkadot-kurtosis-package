def run_polkadex(plan):
    exec_command = [
        "--chain=dev", 
        "--collator", 
        "--rpc-external", 
        "--rpc-cors=all", 
        "--rpc-methods=unsafe", 
        "--tmp",
        "--", 
        "--execution=wasm", 
        "--chain=/app/rococo-local.json", 
        "--port=30345", 
        "--ws-port=9979"
    ]

    polkadex_service_config = ServiceConfig(
        image = "polkadex/parachain:latest",
        files = {
            "/app": "configs",
        },
        ports = {
            "9944": PortSpec(9944, transport_protocol = "TCP"),
            "9933": PortSpec(9933, transport_protocol = "TCP"),
        },
        public_ports = {
            "9944": PortSpec(9432, transport_protocol = "TCP"),
            "9933": PortSpec(9431, transport_protocol = "TCP"),
        },
        cmd = exec_command,
    )
    plan.add_service(name = "acala-node", config = polkadex_service_config)
