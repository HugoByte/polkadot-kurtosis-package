def run_clover(plan):
    exec_command = [
        "--chain=dev", 
        "--rpc-port=9933",
        "--rpc-external", 
        "--rpc-cors=all", 
        "--rpc-methods=unsafe", 
        "--execution=wasm", 
        "--tmp", 
        "--unsafe-ws-external",
        "--", 
        "--chain=/app/rococo-local.json", 
        "--execution=wasm"
    ]
    clover_service_config = ServiceConfig(
        image = "cloverio/clover-para:v0.1.24",
        files = {
            "/app":"configs"
        },
        ports = {
            "ws": PortSpec(9944, transport_protocol="TCP"),
            "tcp": PortSpec(9933, transport_protocol="TCP")
        },
        cmd = exec_command,
        entrypoint=["/opt/clover/bin/clover"]
    )

    service_details = plan.add_service(name="clover-node", config=clover_service_config)

    return service_details 
