def run_nodle(plan):
    exec_command = [
        "--chain=test",
        "--collator",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--unsafe-ws-external",
    ]
    nodle_service_config = ServiceConfig(
        image = "nodlecode/chain:latest",
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
        entrypoint = ["nodle-parachain"]
    )
    plan.add_service(name = "nodle-node", config = nodle_service_config)
