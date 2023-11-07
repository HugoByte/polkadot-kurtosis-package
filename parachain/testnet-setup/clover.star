def run_clover(plan):
    exec_command = [
        "--base-path=/opt/chaindata",
        "--chain=/opt/specs/clover-preview-iris.json",
        "--port=30333",
        "--ws-port=9944",
        "--rpc-port=9933", 
        "--rpc-cors=all",
        "--validator",
        "--unsafe-ws-external",
        "--unsafe-rpc-external",
        "--rpc-methods=Unsafe"
    ]

    service_config = ServiceConfig(
        image = "cloverio/clover-iris:0.1.15",
        ports = {
            "ws": PortSpec(9944, transport_protocol="TCP"),
            "tcp": PortSpec(9933, transport_protocol="TCP")
        },
        cmd = exec_command,
        entrypoint = ["/bin/sh", "-c", "/opt/clover/bin/clover"]
    )

    plan.add_service(name= "clover-node", config= service_config)

