def run_kintsungi(plan,args):

    exec_command = [
        "bin/sh",
        "-c",
        "/usr/local/bin/interbtc-parachain", 
        "--chain=dev", 
        "--wasm-execution=compiled", 
        "--force-authoring",
        "--port 30333",
        "--rpc-port 9944",
        "--rpc-external",
        "--rpc-cors all",
        "--rpc-methods=Unsafe",
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
                "tcp" : PortSpec(9944, transport_protocol="TCP"),
            },
            entrypoint=exec_command
        )  
    )

    return service_details
