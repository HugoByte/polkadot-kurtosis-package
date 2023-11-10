def run_turing(plan):
    exec_command = [
        "--chain=turing",
        "--rpc-port=9933",
        "--collator",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--execution=wasm"
    ]
    turing_service_config = ServiceConfig(
        image = "oaknetwork/turing:latest",
        files = {
            "/app": "configs",
        },
        ports = {
            "ws": PortSpec(9944, transport_protocol = "TCP"),
            "rpc": PortSpec(9933, transport_protocol = "TCP"),
        },
        cmd = exec_command,
        entrypoint = ["./oak-collator"]
    )

    service_details = plan.add_service(name = "turing-node", config = turing_service_config)

    return service_details
