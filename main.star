parachain = import_module("./parachain/parachain.star")
relay_chain = import_module("./relaychain/relay-chain.star")

def run(plan, args):
    plan.upload_files(src = "./parachain/static_files/configs", name = "configs")
    service_details = {"relaychains": {}, "parachains": {}}
    if args["chain-type"] == "local":
        service_details["relaychains"] = relay_chain.start_relay_chains_local(plan, args)

        image = "bifrostnetwork/bifrost:bifrost-v0.9.66"
        binary = "/usr/local/bin/bifrost"
        chain_name = "bifrost-local"
        parachain.create_parachain_build_spec_with_para_id(plan, image, binary, chain_name, para_id = 200)

    else:
        relay_chain.start_relay_chain(plan, args)

    return service_details
