def run_mangata(plan):
    exec_command = [
        "--chain=rococo", 
        "--collator",
        "--rpc-external", 
        "--rpc-cors=all", 
        "--rpc-methods=unsafe",
        "--unsafe-ws-external", 
        "--tmp"
    ]
    mangata_service_config = ServiceConfig(
        image = "mangatasolutions/mangata-node:ci-e2e-jobs-fix-MGX-785-fast",
        files = {
            "/app": "configs",
        },
        ports = {
            "ws": PortSpec(9944, transport_protocol = "TCP"),
            "tcp": PortSpec(9933, transport_protocol = "TCP"),
        },
        cmd = exec_command,
        entrypoint = ["/mangata/node"]
    )
    plan.add_service(name = "mangata-node", config = mangata_service_config)
