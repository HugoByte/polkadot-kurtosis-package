def run_frequency(plan):
    exec_command = ["/bin/bash", "-c", "/frequency/target/release/frequency --chain=frequency-rococo-local --alice --base-path=/data --wasm-execution=compiled --force-authoring --port 30333 --rpc-port 9944 --rpc-external --rpc-cors all --rpc-methods=Unsafe --trie-cache-size 0 -- --wasm-execution=compiled --chain=/app/rococo-local.json"]
    plan.add_service(
        name = "frequency-node",
        config = ServiceConfig(
            image = "frequencychain/collator-node-local:latest",
            files = {
                "/app": "configs",
            },
            ports = {
                "parachain": PortSpec(9944, transport_protocol = "TCP"),
            },
            entrypoint = exec_command,
        ),
    )
