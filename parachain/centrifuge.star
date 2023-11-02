def run_centrifuge(plan):
    exec_command = [
        "--chain=/app/centrifuge-raw-spec.json",
        "--collator",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--unsafe-ws-external",
        "--tmp",
        "--",
        "--chain=/app/rococo-local.json",
        "--execution=wasm",
    ]
    centifuge_service_config = ServiceConfig(
        image = "centrifugeio/centrifuge-chain:test-main-latest",
        files = {
            "/app": "configs",
        },
        ports = {
            "ws": PortSpec(9944, transport_protocol = "TCP"),
            "rpc": PortSpec(9933, transport_protocol = "TCP"),
        },
        cmd = exec_command,
        entrypoint = ["/usr/local/bin/centrifuge-chain"]
    )
    plan.add_service(name = "centrifuge-node", config = centifuge_service_config)
