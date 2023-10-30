parachain = import_module("./parachain/parachain.star")
relay_chain = import_module("./relaychain/relay-chain.star")
robonomics = import_module("./parachain/robonomics.star")
def run(plan, args):
    plan.upload_files(src = "./parachain/static_files/configs", name = "configs")
    if args["chain-type"] == "local":
        relay_chain.spawn_multiple_relay(plan, 2)
        robonomics.run_robonomics(plan)
    else:
        relay_chain.start_relay_chain(plan, args)
