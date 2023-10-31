def run_robonomics(plan):
    exec_command = [
        "robonomics",
        "--chain=dev",
        "--collator",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--unsafe-ws-external",
        "--tmp",
        "--",
        "--chain=/app/rococo-local.json",
        "--execution=wasm",
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
    )
    plan.add_service(name = "robonomics-node", config = robonomics_service_config)
