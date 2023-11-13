def run_testnet_node_with_entrypoint(plan, args, image, chain_name, execute_command):
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

    plan.add_service(name = "{0}".format(chain_name), config = service_config)

def run_testnet_node_with_command(plan, args, image, chain_name, execute_command):
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

    plan.add_service(name = "{0}".format(chain_name), config = service_config)