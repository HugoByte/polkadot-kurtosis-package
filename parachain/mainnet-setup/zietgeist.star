def run_zeitgeist(plan):
    exec_command = [
        "--chain=zeitgeist",
        "--rpc-port=9933",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--unsafe-ws-external",
        "--execution=wasm",
    ]
    zeitgeist_service_config = ServiceConfig(
        image = "zeitgeistpm/zeitgeist-node-parachain",
        files = {
            "/app": "configs",
        },
        ports = {
            "ws": PortSpec(9944, transport_protocol = "TCP"),
            "rpc": PortSpec(9933, transport_protocol = "TCP"),
        },
        cmd = exec_command,
        entrypoint = ["/usr/local/bin/zeitgeist"]
    )
    plan.add_service(name = "zeitgeist-node", config = zeitgeist_service_config)
