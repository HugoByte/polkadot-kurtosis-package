def run_kylin(plan):
    exec_command = [
        "--base-path=/kylin/data",
        "--chain=dev",
        "--ws-external",
        "--rpc-external",
        "--rpc-cors=all",
        "--unsafe-ws-external",
        "--name=parachain-2010-0",
        "--collator",
        "--rpc-methods=unsafe",
        "--force-authoring",
        "--execution=wasm",
        "--alice",
        "--node-key=52194369e4c881e4157b74fd00dff4241e50b8100b823273e25c868a70e5cde8",
        "--",
        "--chain=/app/rococo-local.json",
        "--execution=wasm",
    ]
    plan.add_service(
        name = "kylin",
        config = ServiceConfig(
            image = "kylinnetworks/kylin-collator:ro-v0.9.30",
            files = {
                "/app": "configs",
            },
            ports = {
                "ws": PortSpec(9944, transport_protocol = "TCP"),
            },
            cmd = exec_command,
            entrypoint = ["/usr/local/bin/kylin-collator"]
        ),
    )
