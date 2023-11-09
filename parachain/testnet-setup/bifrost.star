def run_bifrost(plan):
    exec_command = [
        "--base-path=/data",
        "--chain=/app/bifrost-k-rococo.json",
        "--ws-external",
        "--rpc-external",
        "--rpc-cors=all",
        "--collator",
        "--rpc-methods=unsafe",
        "--force-authoring",
        "--execution=wasm",
    ]

    service_config = ServiceConfig(
        image = "bifrostnetwork/bifrost:bifrost-v0.9.66",
        files = {
            "/app": "configs",
        },
        ports = {
            "rpc": PortSpec(9944, transport_protocol = "TCP"),
            "ws": PortSpec(9933, transport_protocol = "TCP"),
        },
        cmd = exec_command,
        entrypoint = ["/usr/local/bin/bifrost"],
    )
    plan.add_service(
        name = "bifrost",
        config = service_config,
    )