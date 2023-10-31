def run_litentry(plan):
    exec_command = [
        "--chain=litentry-dev",
        "--rpc-port=9933",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--execution=wasm",
        "--tmp",
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
            "9944": PortSpec(9944, transport_protocol = "TCP"),
            "9933": PortSpec(9933, transport_protocol = "TCP"),
        },
        public_ports = {
            "9944": PortSpec(9432, transport_protocol = "TCP"),
            "9933": PortSpec(9431, transport_protocol = "TCP"),
        },
        cmd = exec_command,
    )
    plan.add_service(name = "litentry-node", config = litentry_service_config)

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
            "9944": PortSpec(9944, transport_protocol = "TCP"),
            "9933": PortSpec(9933, transport_protocol = "TCP"),
        },
        cmd = exec_command,
    ))
