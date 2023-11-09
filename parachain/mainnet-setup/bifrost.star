def run_bifrost_kusama(plan):
    exec_command = [
        "--base-path=/data",
        "--chain=/app/bifrost-kusama.json",
        "--ws-external",
        "--rpc-external",
        "--rpc-cors=all",
        "--name=parachain-2001-0",
        "--collator",
        "--rpc-methods=unsafe",
        "--force-authoring",
        "--execution=wasm",
    ]
    plan.add_service(
        name = "bifrost",
        config = ServiceConfig(
            image = "bifrostnetwork/bifrost:bifrost-v0.9.66",
            files = {
                "/app": "configs",
            },
            ports = {
                "ws": PortSpec(9944, transport_protocol = "TCP"),
            },
            cmd = exec_command,
            entrypoint = ["/usr/local/bin/bifrost"],
        ),
    )
