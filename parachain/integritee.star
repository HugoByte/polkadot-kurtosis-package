def run_integritee(plan, args):
    exec_command = ["--chain=/app/integritee-raw-spec.json", "--", "--rpc-external", "--rpc-cors=all", "--rpc-methods=unsafe", "--tmp", "--", "--chain=/app/rococo-local.json", "--execution=wasm"]
    integritee_service_config = ServiceConfig(
        image = "integritee/parachain",
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
    plan.add_service(name = "intigreeti-node", config = integritee_service_config)
