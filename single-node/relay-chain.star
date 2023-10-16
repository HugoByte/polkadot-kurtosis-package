

# docker run -p 30333:30333 -p 9944:9944 parity/polkadot:latest --alice --validator --rpc-external --rpc-cors=all --rpc-methods=unsafe --chain westend-dev 
PORT = 9944

def start_relay_chain(plan, args):
    name = args["name"]
    exec_command = ["bin/sh","-c","polkadot --rpc-external --rpc-cors=all --rpc-methods=unsafe --chain westend-dev --name={0} --execution=wasm".format(name)]
    polkadot = plan.add_service(
        name="polkadot-{0}".format(name),
        config= ServiceConfig(
            image = "parity/polkadot:latest",
            ports = {
                "polkadot" : PortSpec(9944, transport_protocol="TCP"),
            },
            public_ports = {
                "polkadot" : PortSpec(PORT, transport_protocol="TCP"),
            },
            entrypoint=exec_command
        )  
    )