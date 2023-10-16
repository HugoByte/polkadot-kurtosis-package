
polkadot_parachain = import_module("./POC-sample/polkadot_parachain.star")
single_node = import_module("./single-node/relay-chain.star")

def run(plan, args):
    plan.print(args["name"])
    if args["name"] == "local": 
        polkadot_parachain.run(plan, args)
    else:
        single_node.start_relay_chain(plan, args)