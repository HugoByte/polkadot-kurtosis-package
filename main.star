parachain = import_module("./parachain/parachain.star")
relay_chain = import_module("./relaychain/relay-chain.star")
litentry = import_module("./parachain/litentry.star")
clover = import_module("./parachain/clover.star")

def run(plan, args):
    plan.upload_files(src = "./parachain/static_files/configs", name = "configs")
    service_details = {"relaychains": {}, "parachains": {}}
    if args["chain-type"] == "local":
        service_details["relaychains"] = relay_chain.start_relay_chains_local(plan, args)
        service_details["parachains"] = clover.run_clover(plan)
        
    else:
        relay_chain.start_relay_chain(plan, args)
        
    return service_details