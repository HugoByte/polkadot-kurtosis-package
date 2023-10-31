def run_acala(plan):
    exec_command = ["--chain=/app/acala-raw.json", "--collator", "--rpc-external", "--rpc-cors=all", "--rpc-methods=unsafe", "--tmp", "--instant-sealing"]

    acala_service_config = ServiceConfig(
        image = "acala/acala-node:latest",
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
    )
    plan.add_service(name = "acala-node", config = acala_service_config)
