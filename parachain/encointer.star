def run_encointer(plan, args):
    exec_command = [
        "bin/sh",
        "-c",
        "/usr/local/bin/encointer-collator --collator --tmp --chain encointer-rococo-local --rpc-port 9944 -- --execution=wasm --chain /app/rococo-local.json",
    ]
    plan.add_service(
        name = "encointer",
        config = ServiceConfig(
            image = "encointer/parachain:1.5.1",
            files = {
                "/app": "configs",
            },
            ports = {
                "parachain": PortSpec(9944, transport_protocol = "TCP"),
            },
            entrypoint = exec_command,
        ),
    )
