def run_acala(plan):

    exec_command = [
        "--chain=acala",
        "--collator",
        "--rpc-cors=all",
        "--rpc-port=9933",
        "--rpc-methods=unsafe", 
        "--unsafe-rpc-external",
        "--tmp", 
        "--execution=wasm"
    ]

    acala_service_config = ServiceConfig(
    image = "acala/acala-node:latest",
    files = {
        "/app": "configs",
    },
    ports = {
        "rpc": PortSpec(9933, transport_protocol = "TCP"),
    },
    cmd = exec_command,
    entrypoint= ["/usr/local/bin/acala"]
    )
    plan.add_service(name = "acala-node", config = acala_service_config)
