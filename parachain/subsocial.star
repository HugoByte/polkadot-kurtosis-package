def run_subsocial(plan, args):
    exec_command = [
        "/bin/sh",
        "-c",
        "/usr/local/bin/subsocial-collator --collator --chain=local-rococo --port 40335 --ws-port 9944 --unsafe-ws-external -- --execution wasm --chain /app/rococo-local.json",
    ]
    plan.add_service(
        name = "subsocial",
        config = ServiceConfig(
            image = "dappforce/subsocial-parachain:latest",
            files = {
                "/app": "configs",
            },
            ports = {
                "parachain": PortSpec(9944, transport_protocol = "TCP"),
            },
            entrypoint = exec_command,
        ),
    )
