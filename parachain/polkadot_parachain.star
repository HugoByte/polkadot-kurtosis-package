
def run(plan,args):

    exec_command = ["bin/sh","-c","/usr/local/bin/bifrost --base-path=/data --chain=/app/bifrost-local-2001.json --ws-external --rpc-external --rpc-cors=all --name=parachain-2001-0 --collator --rpc-methods=unsafe --force-authoring --execution=wasm --alice --node-key=15f888e12fe354ac310399c7126ff43db1a58453784ea1784e26edc0bee3c965 --listen-addr=/ip4/0.0.0.0/tcp/30333 -- --chain=/app/rococo-local.json --execution=wasm"]
    parachain = plan.add_service(
        name="parachain",
        config= ServiceConfig(
            image = "bifrostnetwork/bifrost:bifrost-v0.9.66",
            files={
                "/app":"output"
            },
            ports = {
                "parachain" : PortSpec(9944, transport_protocol="TCP"),
            },
            entrypoint=exec_command
        )  
    )


def run_acala(plan, args):
    exec_command = ["--chain=/app/acala-raw.json", "--collator", "--rpc-external",  "--rpc-cors=all", "--rpc-methods=unsafe",  "--tmp" , "--instant-sealing"]

    acala_service_config = ServiceConfig(
        image = "acala/acala-node:latest",
        files = {
            "/app":"output"
        },
        ports = {
            "9944": PortSpec(9944, transport_protocol="TCP"),
            "9933": PortSpec(9933, transport_protocol="TCP")
        },
        public_ports = {
            "9944": PortSpec(9432, transport_protocol="TCP"),
            "9933": PortSpec(9431, transport_protocol="TCP")

        },
        cmd = exec_command,
    )
    plan.add_service(name="acala-node", config=acala_service_config)


def ajun_run(plan,args):
    exec_command = ["--base-path=/data","--chain=/app/bajun-raw.json","--port=40335","--ws-port=8846","--unsafe-ws-external","--rpc-cors=all","--","--execution=wasm","--chain=/app/rococo-local.json","--port=30345","--ws-port=9979"]
    parachain = plan.add_service(
        name="ajun-node",
        config= ServiceConfig(
            image = "ajuna/parachain-bajun:latest",
            files={
                "/app":"output"
            },
            ports = {
                "parachain" : PortSpec(8846, transport_protocol="TCP"),
            },
            cmd=exec_command
        )  
    )