def run_pendulum(plan):
    exec_command = [
        "--chain=pendulum",
        "--collator",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--unsafe-ws-external",
    ]
    pendulum_service_config = ServiceConfig(
        image = "pendulumchain/pendulum-collator:latest",
        files = {
            "/app": "configs",
        },
        ports = {
            "ws": PortSpec(9944, transport_protocol = "TCP"),
            "rpc": PortSpec(9933, transport_protocol = "TCP"),
        },
        cmd = exec_command,
        entrypoint = ["/usr/local/bin/pendulum-collator"]
    )
    plan.add_service(name = "pendulum-node", config = pendulum_service_config)
