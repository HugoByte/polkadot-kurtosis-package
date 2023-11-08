def run_moonbeam(plan):
    exec_command = [
        "--chain=alphanet",
        "--collator",
        "--rpc-external",
        "--rpc-cors=all",
        "--rpc-methods=unsafe",
        "--tmp",
        "--unsafe-rpc-external",
    ]
    moonbeam_service_config = ServiceConfig(
        image = "moonbeamfoundation/moonbeam:sha-32933811",
        files = {
            "/app": "configs",
        },
        ports = {
            "ws": PortSpec(9944, transport_protocol = "TCP"),
        },
        cmd = exec_command,
        entrypoint = ["/moonbeam/moonbeam"]
    )
    plan.add_service(name = "acala-node", config = moonbeam_service_config)
