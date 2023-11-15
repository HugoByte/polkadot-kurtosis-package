def run_robonomics(plan):
    exec_command = [
        "--collator",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--unsafe-ws-external",
    ]
    robonomics_service_config = ServiceConfig(
        image = "robonomics/robonomics:latest",
        files = {
            "/app": "configs",
        },
        ports = {
            "ws": PortSpec(9944, transport_protocol = "TCP"),
            "tcp": PortSpec(9933, transport_protocol = "TCP"),
        },
        cmd = exec_command,
        entrypoint = ["/usr/local/bin/robonomics"]
    )
    plan.add_service(name = "robonomics-node", config = robonomics_service_config)
