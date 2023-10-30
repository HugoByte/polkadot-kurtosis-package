def run_manta(plan,args):

    exec_command = [ "bin/sh","-c","/usr/local/bin/manta --chain=manta-local --wasm-execution=compiled --force-authoring --port 30333 --rpc-port 9944 --rpc-external --rpc-cors all --rpc-methods=Unsafe -- --wasm-execution=compiled --chain=/app/rococo-local.json"]
    parachain = plan.add_service(
        name="interrelay",
        config= ServiceConfig(
            image = "mantanetwork/manta:latest",
            files={
                "/app":"output"
            },
            ports = {
                "parachain" : PortSpec(9944, transport_protocol="TCP"),
            },
            entrypoint=exec_command
        )  
    )

def run_calamari(plan,args):

    exec_command = [ "bin/sh","-c","/usr/local/bin/manta --chain=calamari-local --wasm-execution=compiled --force-authoring --port 30333 --rpc-port 9944 --rpc-external --rpc-cors all --rpc-methods=Unsafe -- --wasm-execution=compiled --chain=/app/rococo-local.json"]
    parachain = plan.add_service(
        name="interrelay",
        config= ServiceConfig(
            image = "mantanetwork/manta:latest",
            files={
                "/app":"output"
            },
            ports = {
                "parachain" : PortSpec(9944, transport_protocol="TCP"),
            },
            entrypoint=exec_command
        )  
    )