def run_kintsungi(plan):

    exec_command = [
        "--chain=dev", 
        "--wasm-execution=compiled", 
        "--force-authoring",
        "--port=30333",
        "--rpc-port=9944",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=Unsafe",
        "--unsafe-ws-external",
        "--",
        "--wasm-execution=compiled",
        "--chain=/app/rococo-local.json"
    ]
    service_details = plan.add_service(
        name="kintsungi",
        config= ServiceConfig(
            image = "interlayhq/interbtc:latest",
            files={
                "/app":"configs"
            },
            ports = {
                "ws" : PortSpec(9944, transport_protocol="TCP"),
            },
            cmd=exec_command,
            entrypoint= ["tini", "--", "/usr/local/bin/interbtc-parachain"]
        )  
    )

    return service_details
