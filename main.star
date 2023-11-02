parachain = import_module("./parachain/parachain.star")
relay_chain = import_module("./relaychain/relay-chain.star")
litentry = import_module("./parachain/litentry.star")
clover = import_module("./parachain/clover.star")
acala = import_module("./parachain/acala.star")
altair = import_module("./parachain/altair.star")
centrifuge = import_module("./parachain/centrifuge.star")
karura = import_module("./parachain/karura.star")
kilt = import_module("./parachain/kilt.star")
kintsungi = import_module("./parachain/kintsungi.star")
kylin = import_module("./parachain/kylin.star")
mangta = import_module("./parachain/mangata.star")
moonbeam = import_module("./parachain/moonbeam.star")
nodle = import_module("./parachain/nodle.star")
pendulum = import_module("./parachain/pendulum.star")
robonomics = import_module("./parachain/robonomics.star")
turing = import_module("./parachain/turing.star")
def run(plan, args):
    plan.upload_files(src = "./parachain/static_files/configs", name = "configs")
    service_details = {"relaychains": {}, "parachains": {}}
    if args["chain-type"] == "local":
        service_details["relaychains"] = relay_chain.start_relay_chains_local(plan, args)
        service_details["parachains"] = turing.run_turing(plan)
        
    else:
        relay_chain.start_relay_chain(plan, args)
        
    return service_details
