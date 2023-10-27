def run_bifrost(plan):
    exec_command = ["bin/sh", "-c", "/usr/local/bin/bifrost --base-path=/data --chain=/app/bifrost-local-2001.json --ws-external --rpc-external --rpc-cors=all --name=parachain-2001-0 --collator --rpc-methods=unsafe --force-authoring --execution=wasm --alice --node-key=15f888e12fe354ac310399c7126ff43db1a58453784ea1784e26edc0bee3c965 --listen-addr=/ip4/0.0.0.0/tcp/30333 -- --chain=/app/rococo-local.json --execution=wasm"]
    plan.add_service(
        name = "parachain",
        config = ServiceConfig(
            image = "bifrostnetwork/bifrost:bifrost-v0.9.66",
            files = {
                "/app": "configs",
            },
            ports = {
                "parachain": PortSpec(9944, transport_protocol = "TCP"),
            },
            entrypoint = exec_command,
        ),
    )
