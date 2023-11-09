def run_litentry(plan):
    exec_command = [
        "--chain=litentry",
        "--rpc-port=9933",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--execution=wasm",
        "--unsafe-ws-external"
    ]
    litentry_service_config = ServiceConfig(
        image = "litentry/litentry-parachain:latest",
        files = {
            "/app": "configs",
        },
        ports = {
            "ws": PortSpec(9944, transport_protocol = "TCP"),
            "rpc": PortSpec(9933, transport_protocol = "TCP"),
        },
        cmd = exec_command,
        entrypoint = ["/usr/local/bin/litentry-collator"] 
    )

    service_details = plan.add_service(name = "litentry-node", config = litentry_service_config)

    return service_details
