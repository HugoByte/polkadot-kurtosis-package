parachain = import_module("./parachain/parachain.star")
relay_chain = import_module("./relaychain/relay-chain.star")

def run(plan, args):
    plan.upload_files(src = "./parachain/static_files/configs", name = "configs")
    service_details = {"relaychains": {}, "parachains": {}}
    if args["chain-type"] == "local":
        relay_chain_details = relay_chain.start_relay_chains_local(plan, args)
        service_details["relaychains"] = relay_chain_details

        parachain.start_nodes(plan, args, relay_chain_details["relay_service_alice"].ip_address)

    else:
        relay_chain.start_relay_chain(plan, args)
        parachain.run_testnet(plan, args, "encointer")

    return service_details
