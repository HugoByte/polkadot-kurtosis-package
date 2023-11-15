def run_testnet_node_with_entrypoint(plan, image, chain_name, execute_command):
    service_config = ServiceConfig(
        image = image,
        ports = {
            "ws": PortSpec(9944, transport_protocol = "TCP"),
        },
        files = {
            "/app": "configs",
        },
        entrypoint = execute_command,
    )
    parachain = plan.add_service(name = "{0}".format(chain_name), config = service_config)

    return parachain

def run_testnet_node_with_command(plan, image, chain_name, execute_command):
    service_config = ServiceConfig(
        image = image,
        ports = {
            "ws": PortSpec(9944, transport_protocol = "TCP"),
        },
        files = {
            "/app": "configs",
        },
        cmd = execute_command,
    )
    parachain = plan.add_service(name = "{0}".format(chain_name), config = service_config)

    return parachain
