
def run(plan,args):
    
    plan.upload_files(src = "./output", name = "output")
    list = ["alice", "bob"]
    count = 0
    port = 9944
    for i in list:
        port = port+count
        start_relay_chain(plan,i, port)
        count = count+1

    exec_command = ["bin/sh","-c","/usr/local/bin/bifrost --base-path=/data --chain=/app/bifrost-local-2001.json --ws-external --rpc-external --rpc-cors=all --name=parachain-2001-0 --collator --rpc-methods=unsafe --force-authoring --execution=wasm --alice --node-key=15f888e12fe354ac310399c7126ff43db1a58453784ea1784e26edc0bee3c965 --listen-addr=/ip4/0.0.0.0/tcp/30333 -- --chain=/app/rococo-local.json --execution=wasm"]
    parachain = plan.add_service(
        name="parachain",
        config= ServiceConfig(
            image = "bifrostnetwork/bifrost:bifrost-v0.9.66",
            files={
                "/app":"output"
            },
            ports = {
                "polkadot" : PortSpec(9944, transport_protocol="TCP"),
            },
            public_ports = {
                "polkadot" : PortSpec(9946, transport_protocol="TCP"),
            },
            entrypoint=exec_command
        )  
    )

def start_relay_chain(plan, name, port):
    exec_command = ["bin/sh","-c","polkadot --base-path=/data --chain=/app/rococo-local.json --validator --ws-external --rpc-external --rpc-cors=all --name=alice --{0} --rpc-methods=unsafe --execution=wasm".format(name)]
    polkadot = plan.add_service(
        name="polkadot-{0}".format(name),
        config= ServiceConfig(
            image = "parity/polkadot:v0.9.31",
            files={
                "/app":"output"
            },
            ports = {
                "polkadot" : PortSpec(9944, transport_protocol="TCP"),
            },
            public_ports = {
                "polkadot" : PortSpec(port, transport_protocol="TCP"),
            },
            entrypoint=exec_command
        )  
    )