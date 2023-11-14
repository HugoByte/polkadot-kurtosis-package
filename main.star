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
        if len(args["relaychain"]) != 0:
            relay_node_detals = relay_chain.start_test_main_net_relay_nodes(plan, args)
            service_details["relaychains"] = relay_node_detals
        for paras in args["para"]:
            parachain_info = parachain.run_testnet_mainnet(plan, args, paras)
            plan.print(parachain_info)
            service_details["parachains"] = parachain_info

    return service_details
