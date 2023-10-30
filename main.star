parachain = import_module("./parachain/parachain.star")
relay_chain = import_module("./relaychain/relay-chain.star")
mangata = import_module("./parachain/mangata.star")

def run(plan, args):
    plan.upload_files(src = "./parachain/static_files/configs", name = "configs")
    if args["chain-type"] == "local":
        relay_chain.spawn_multiple_relay(plan, 2)
        mangata.run_mangata(plan)
    else:
        relay_chain.start_relay_chain(plan, args)
