def run_litentry(plan):
    exec_command = [
        "--chain=litentry-dev",
        "--rpc-port=9933",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--execution=wasm",
        "--tmp",
        "--unsafe-ws-external",
        "--",
        "--chain=/app/rococo-local.json",
        "--execution=wasm",
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

def run_litmus(plan, args):
    exec_command = [
        "--chain=litmus-dev",
        "--rpc-port=9933",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--execution=wasm",
        "--unsafe-ws-external",
        "--tmp",
        "--",
        "--chain=/app/rococo-local.json",
        "--execution=wasm",
    ]
    plan.add_service(name = "litmus-node", config = ServiceConfig(
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
    ))
