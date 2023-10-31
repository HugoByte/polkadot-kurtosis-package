def run_bajun(plan, args):
    exec_command = [
        "--base-path=/data",
        "--chain=/app/bajun-raw.json",
        "--port=40335",
        "--ws-port=9944",
        "--unsafe-ws-external",
        "--rpc-cors=all",
        "--",
        "--execution=wasm",
        "--chain=/app/rococo-local.json",
        "--port=30345",
        "--ws-port=9979",
    ]
    plan.add_service(
        name = "bajun-node",
        config = ServiceConfig(
            image = "ajuna/parachain-bajun:latest",
            files = {
                "/app": "configs",
            },
            ports = {
                "ws": PortSpec(9944, transport_protocol = "TCP"),
            },
            cmd = exec_command,
        ),
    )

def run_ajuna(plan, args):
    exec_command = [
        "--base-path=/data",
        "--chain=dev",
        "--port=40335",
        "--ws-port=9944",
        "--unsafe-ws-external",
        "--rpc-cors=all",
        "--",
        "--execution=wasm",
        "--chain=/app/rococo-local.json",
        "--port=30345",
        "--ws-port=9979",
    ]
    plan.add_service(
        name = "ajuna",
        config = ServiceConfig(
            image = "ajuna/parachain-ajuna:latest",
            files = {
                "/app": "configs",
            },
            ports = {
                "ws": PortSpec(9944, transport_protocol = "TCP"),
            },
            cmd = exec_command,
        )
    )