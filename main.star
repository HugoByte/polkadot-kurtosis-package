
polkadot_parachain = import_module("./parachain/polkadot_parachain.star")
relay_chain = import_module("./relaychain/relay-chain.star")

def run(plan, args):
    plan.upload_files(src = "./parachain/output", name = "output")
    if args["chain-type"] == "local": 
        relay_chain.spawn_multiple_relay(plan,2)
        polkadot_parachain.run(plan, args)
    else:
        relay_chain.start_relay_chain(plan, args)