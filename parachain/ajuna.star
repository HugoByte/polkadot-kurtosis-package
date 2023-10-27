def run_ajuna(plan, args):
    exec_command = ["--base-path=/data", "--chain=/app/bajun-raw.json", "--port=40335", "--ws-port=8846", "--unsafe-ws-external", "--rpc-cors=all", "--", "--execution=wasm", "--chain=/app/rococo-local.json", "--port=30345", "--ws-port=9979"]
    plan.add_service(
        name = "ajun-node",
        config = ServiceConfig(
            image = "ajuna/parachain-bajun:latest",
            files = {
                "/app": "output",
            },
            ports = {
                "parachain": PortSpec(8846, transport_protocol = "TCP"),
            },
            cmd = exec_command,
        ),
    )
