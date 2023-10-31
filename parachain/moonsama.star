def run_moonsama(plan, args):
    exec_command = [
        "bin/sh",
        "-c",
        "/moonsama/moonsama-node --dev --tmp --ws-external --rpc-external --rpc-cors all --rpc-methods unsafe -- --execution wasm --chain /app/rococo-local.json",
    ]
    plan.add_service(
        name = "moonsama",
        config = ServiceConfig(
            image = "moonsama/moonsama-node:latest",
            files = {
                "/app": "configs",
            },
            ports = {
                "parachain": PortSpec(9944, transport_protocol = "TCP"),
            },
            entrypoint = exec_command,
        ),
    )
