def run_pendulum(plan):
    exec_command = [
        "--chain=dev",
        "--collator",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--tmp",
        "--",
        "--wasm-execution=compiled",
        "--chain=/app/rococo-local.json",
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
        public_ports = {
            "ws": PortSpec(9432, transport_protocol = "TCP"),
            "rpc": PortSpec(9431, transport_protocol = "TCP"),
        },
        cmd = exec_command,
    )
    plan.add_service(name = "pendulum-node", config = pendulum_service_config)
