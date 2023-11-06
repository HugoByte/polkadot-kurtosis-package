def run_karura(plan):
    exec_command = [
        "--chain=dev",
        "--collator",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--tmp",
        "--",
        "--chain=/app/rococo-local.json",
        "--execution=wasm",
    ]

    karura_service_config = ServiceConfig(
        image = "acala/karura-node:latest",
        files = {
            "/app": "configs",
        },
        ports = {
            "rpc": PortSpec(9944, transport_protocol = "TCP"),
        },
        cmd = exec_command,
        entrypoint = ["/usr/local/bin/acala"]

    )
    plan.add_service(name = "karura-node", config = karura_service_config)
