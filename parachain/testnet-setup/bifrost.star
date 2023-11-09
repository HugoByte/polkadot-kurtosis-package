def run_bifrost(plan):
    exec_command = [
        "--chain=/app/bifrost-k-rococo.json",
        "--port=30333",
        "--rpc-port=9933",
        "--rpc-cors=all",
        "--rpc-external",
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
        entrypoint =["/usr/local/bin/bifrost"]
    )

    plan.add_service(name="bifrost-node", config = service_config)
