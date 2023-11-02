def run_kilt(plan):
    exec_command = [
        "--chain=dev",
        "--alice",
        "--rpc-port=9933",
        "--rpc-external",
        "--rpc-cors=all",
        "--unsafe-ws-external",
        "--rpc-methods=unsafe",
        "--execution=wasm",
        "--tmp",
        "--",
        "--chain=/app/rococo-local.json",
        "--execution=wasm",
    ]

    kilt_service_config = ServiceConfig(
        image = "kiltprotocol/kilt-node:latest",
        files = {
            "/app": "configs",
        },
        ports = {
            "ws": PortSpec(9944, transport_protocol = "TCP")
        },
        cmd = exec_command,
        entrypoint = ["/usr/local/bin/node-executable"]
    )
    plan.add_service(name = "kilt-node", config = kilt_service_config)
