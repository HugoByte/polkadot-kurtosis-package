def run_integritee(plan):
    exec_command = [
        "--chain=integritee-rococo", 
        "--collator",
        "--rpc-external", 
        "--rpc-cors=all", 
        "--rpc-methods=unsafe",
        "--unsafe-ws-external",
        "--tmp"
        ]
    integritee_service_config = ServiceConfig(
        image = "integritee/parachain",
        files = {
            "/app": "configs",
        },
        ports = {
            "ws": PortSpec(9944, transport_protocol = "TCP"),
            "rpc": PortSpec(9933, transport_protocol = "TCP"),
        },
        public_ports = {
            "ws": PortSpec(9432, transport_protocol = "TCP"),
            "rpc": PortSpec(9431, transport_protocol = "TCP"),
        },
        cmd = exec_command,
        entrypoint = ["/usr/local/bin/integritee-collator"]
    )
    plan.add_service(name = "intigreeti-node", config = integritee_service_config)
