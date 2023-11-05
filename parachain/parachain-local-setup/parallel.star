def run_parallel(plan, args):
    exec_command = [
        "--chain=kerria-dev",
        "--wasm-execution=compiled",
        "--force-authoring",
        "--port",
        "30333",
        "--rpc-port",
        "ws",
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
                "ws": PortSpec(9944, transport_protocol = "TCP"),
            },
            cmd = exec_command,
            entrypoint = ["/parallel/.entrypoint.sh"]
        ),

    )
