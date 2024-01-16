"""
This package contains code for spawning the chopstick network.
"""

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
        public_ports={
            "TCP": PortSpec(number=8000)
        },
        entrypoint=["/bin/sh", "-c", "yarn add  @acala-network/chopsticks@latest && npx @acala-network/chopsticks --config=%s --port=8000" % (para_chain)]
    )

    plan.add_service(name="chopstick-", config=service_config)


def run_chopsticks_xcm(plan, relay_chain, para_chains):
    """
    Set up a service for the chopstick network with cross-chain messaging (xcm) support with give relachain and parachains.

    Args:
        plan: The Kurtosis plan.
        relay_chain (string): The relay chain for cross-chain messaging.
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
        entrypoint=["/bin/sh", "-c", "yarn add  @acala-network/chopsticks@latest && %s" % (exec_cmd)]
    )

    plan.add_service(name="chopstick-", config=service_config)
