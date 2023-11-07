def run_bifrost(plan):
    exec_command = [
        "--chain /specs/bifrost-testnet.json",
        "--port=30333",
        "--rpc-port=9933",
        "--rpc-cors=all",
        "--rpc-external"
    ] 

    service_config = ServiceConfig(
        image = "thebifrost/bifrost-node:latest",
        ports = {
            "rpc": PortSpec(9933, transport_protocol = "TCP"),
            "ws": PortSpec(30333, transport_protocol = "TCP"),
        },
        entrypoint = exec_command,
    )

    plan.add_service(name="bifrost-node", service_config = service_config)
