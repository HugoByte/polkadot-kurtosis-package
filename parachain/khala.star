def run_khala(plan, args):
    exec_command = [
        "/bin/sh",
        "-c",
        "/usr/local/bin/khala-node --chain=khala-dev-2004 --ws-external --rpc-external --rpc-cors=all --name=parachain-2010-0 --collator --rpc-methods=unsafe --force-authoring --execution=wasm --alice -- --chain=/app/rococo-local.json --execution=wasm",
    ]
    plan.add_service(
        name = "khala",
        config = ServiceConfig(
            image = "phalanetwork/khala-node:latest",
            ports = {
                "parachain": PortSpec(9944, transport_protocol = "TCP"),
            },
            files = {
                "/app": "configs",
            },
            entrypoint = exec_command,
        ),
    )
