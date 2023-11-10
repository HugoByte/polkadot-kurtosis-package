def run_polkadex(plan):
    exec_command = [
        "--chain=mainnet",
        "--collator",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--unsafe-ws-external",
    ]

    polkadex_service_config = ServiceConfig(
        image = "polkadex/parachain:latest",
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
        entrypoint = ["/usr/local/bin/parachain-polkadex-node"]
    )
    plan.add_service(name = "polkadex-node", config = polkadex_service_config)
