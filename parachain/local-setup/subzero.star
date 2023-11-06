def run_subzero(plan, args):
    exec_command = [
        "bin/sh",
        "-c",
        "/usr/local/bin/subzero --dev --tmp --ws-external --rpc-external --rpc-cors all --rpc-methods unsafe -- --execution wasm --chain /app/rococo-local.json",
    ]
    plan.add_service(
        name = "subzero",
        config = ServiceConfig(
            image = "playzero/subzero:latest",
            files = {
                "/app": "configs",
            },
            ports = {
                "ws": PortSpec(9944, transport_protocol = "TCP"),
            },
            entrypoint = exec_command,
        ),
    )
