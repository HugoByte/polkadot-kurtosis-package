parachain = import_module("./parachain/parachain.star")
relay_chain = import_module("./relaychain/relay-chain.star")
package = import_module("./package_io/build-spec.star")

def run(plan, args):
    plan.upload_files(src = "./parachain/static_files/configs", name = "configs")
    service_details = {"relaychains": {}, "parachains": {}, "prometheus": {}}
    if args["chain-type"] == "local":
        relay_chain_details = relay_chain.start_relay_chains_local(plan, args)
        service_details["relaychains"] = relay_chain_details
        parachain_details = parachain.start_nodes(plan, args, relay_chain_details[0]["service_details"].ip_address)
        service_details["parachains"] = parachain_details

    else:
        if len(args["relaychain"]) != 0:
            relay_node_detals = relay_chain.start_test_main_net_relay_nodes(plan, args)
            service_details["relaychains"] = relay_node_detals
        for paras in args["para"]:
            parachain_info = parachain.run_testnet_mainnet(plan, args, paras)
            service_details["parachains"] = parachain_info

    ip = "{0}:{1}".format(relay_chain_details[0]["service_details"].ip_address, relay_chain_details[0]["service_details"].ports["prometheus"].number)
    prometheus = package.prometheus(plan, args, ip)
    service_details["prometheus"] = prometheus
    plan.print(service_details["relaychains"])
    return service_details
