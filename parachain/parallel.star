def run_parallel(plan, args):
    exec_command = [
        "--chain=kerria-dev",
        "--wasm-execution=compiled",
        "--force-authoring",
        "--port",
        "30333",
        "--rpc-port",
        "9944",
        "--rpc-external",
        "--rpc-cors",
        "all",
        "--rpc-methods=Unsafe",
        "--",
        "--wasm-execution=compiled",
        "--chain=/app/rococo-local.json",
    ]
    plan.add_service(
        name = "parallel",
        config = ServiceConfig(
            image = "parallelfinance/parallel:latest",
            files = {
                "/app": "configs",
            },
            ports = {
                "parachain": PortSpec(9944, transport_protocol = "TCP"),
            },
            cmd = exec_command,
        ),
    )
