"""
This package contains code for spawning the chopstick network.
"""

explorer = import_module("github.com/hugobyte/polkadot-kurtosis-package/package_io/polkadot_js_app.star")

def run(plan, args):
    service_details = {}
    if args["parachain"] != None:
        service_details["parachain"] = run_chopsticks_parachain(plan, args["parachain"])
    
    if len(args["xcm"]) != 0:
        plan.print("Running XCM service....")
        if len(args["xcm"]["parachains"]) >= 2:
            service_details["xcm"] = run_chopsticks_xcm(plan, args["xcm"]["relaychain"], args["xcm"]["parachains"])
        else:
            fail("xcm needs atleast two parachains")

    if args["explorer"] == True:
        explorer.run_pokadot_js_app(plan, "ws://127.0.0.1:8000")

    return service_details
    


def run_chopsticks_parachain(plan, para_chain):
    """
    Set up a service for the chopstick network for given parachain.

    Args:
        plan: The Kurtosis plan.
        para_chain (str): The parachain to configure for the chopstick network.
    """

    service_config = ServiceConfig(
        image="node:latest",
        ports={
            "TCP": PortSpec(number=8000)
        },
        # public_ports={
        #     "TCP": PortSpec(number=8000)
        # },
        entrypoint=["/bin/sh", "-c", "yarn add  @acala-network/chopsticks@beta && npx @acala-network/chopsticks --config=%s --port=8000 --allow-unresolved-imports=true" % (para_chain)]
    )

    service_details = plan.add_service(name="chopstick-%s" % para_chain,  config=service_config)

    return service_details


def run_chopsticks_xcm(plan, relay_chain, para_chains):
    """
    Set up a service for the chopstick network with cross-chain messaging (xcm) support with give relachain and parachains.

    Args:
        plan: The Kurtosis plan.
        relay_chain (str): The relay chain for cross-chain messaging.
        para_chains (list): List of parachains to include in the network.
    """

    exec_cmd = "npx @acala-network/chopsticks xcm"
    exec_cmd = exec_cmd + " -r " + relay_chain

    for para in para_chains:
        exec_cmd = exec_cmd + " -p " + para

    ports = {}
    public_ports = {}

    for i in range(0, len(para_chains) + 1):
        ports["TCP" + str(i)] = PortSpec(number=8000 + i)
        public_ports["TCP" + str(i)] = PortSpec(number=8000 + i)

    service_config = ServiceConfig(
        image="node:latest",
        ports=ports,
        public_ports=public_ports,
        entrypoint=["/bin/sh", "-c", "yarn add  @acala-network/chopsticks@beta && %s" % (exec_cmd)]
    )

    service_details = plan.add_service(name="chopstick-xcm", config=service_config)
    return service_details
