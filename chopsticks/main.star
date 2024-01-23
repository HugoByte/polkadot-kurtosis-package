"""
This package contains code for spawning the chopstick network.
"""

def run(plan, chain = None, xcm = {}):
    service_details = {}
    if chain != None:
        service_details["chain"] = run_chopsticks_parachain(plan, chain)
    
    if len(xcm) != 0:
        plan.print("Running XCM service....")
        if len(xcm["parachains"]) >= 2:
            service_details["xcm"] = run_chopsticks_xcm(plan, xcm["relaychain"], xcm["parachains"])
        else:
            fail("xcm needs atleast two parachains")

    return service_details
    


def run_chopsticks_parachain(plan, para_chain):
    """
    Set up a service for the chopstick network for given parachain.

    Args:
        plan: The Kurtosis plan.
        para_chain (string): The parachain to configure for the chopstick network.
    """

    service_config = ServiceConfig(
        image="node:latest",
        ports={
            "TCP": PortSpec(number=8000)
        },
        entrypoint=["/bin/sh", "-c", "yarn add  @acala-network/chopsticks@beta && npx @acala-network/chopsticks --config=%s --port=8000 --allow-unresolved-imports=true" % (para_chain)]
    )

    service_details = plan.add_service(name="chopstick-%s" % para_chain,  config=service_config)

    return service_details


def run_chopsticks_xcm(plan, relay_chain, para_chains):
    """
    Set up a service for the chopstick network with cross-chain messaging (xcm) support with give relachain and parachains.

    Args:
        relay_chain (string): The relay chain for cross-chain messaging.
        para_chains (list): List of parachains to include in the network.
    """

    exec_cmd = "npx @acala-network/chopsticks xcm"
    exec_cmd = exec_cmd + " -r " + relay_chain

    for para in para_chains:
        exec_cmd = exec_cmd + " -p " + para

    ports = {}
    public_ports = {}

    ports["TCP-" + relay_chain] = PortSpec(number=8000)
    public_ports["TCP-" + relay_chain] = PortSpec(number=8000)

    for i in range(0, len(para_chains)):
        ports["TCP-" + para_chains[i]] = PortSpec(number=8000 + i + 1)
        public_ports["TCP-" + para_chains[i]] = PortSpec(number=8000 + i + 1)

    service_config = ServiceConfig(
        image="node:latest",
        ports=ports,
        public_ports=public_ports,
        entrypoint=["/bin/sh", "-c", "yarn add  @acala-network/chopsticks@beta && %s" % (exec_cmd)]
    )

    service_details = plan.add_service(name="chopstick-xcm", config=service_config)
    return service_details
