def run_integritee(plan, args):
    exec_command = ["--chain=rococo-local", "--rpc-external", "--rpc-cors=all", "--rpc-methods=unsafe", "--tmp", "--", "--chain=/app/rococo-local.json", "--execution=wasm"]
    mangata_service_config = ServiceConfig(
        image = "mangatasolutions/mangata-node:ci-e2e-jobs-fix-MGX-785-fast",
        files = {
            "/app": "output",
        },
        ports = {
            "9944": PortSpec(9944, transport_protocol = "TCP"),
            "9933": PortSpec(9933, transport_protocol = "TCP"),
        },
        public_ports = {
            "9944": PortSpec(9432, transport_protocol = "TCP"),
            "9933": PortSpec(9431, transport_protocol = "TCP"),
        },
        cmd = exec_command,
    )
    plan.add_service(name = "mangata-node", config = mangata_service_config)
