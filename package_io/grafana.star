utils = import_module("./utils.star")

def prometheus_grafana_service(plan, service_name, image, port, command, build_file = None):
    files = {
        "/app": "configs",
    }
    if build_file != None:
        files["/build"] = build_file

    service = plan.add_service(
        name = service_name,
        config = ServiceConfig(
            image = image,
            files = files,
            ports = {
                "polkadot": PortSpec(port, transport_protocol = "TCP"),
            },
            public_ports = {
                "polkadot": PortSpec(port, transport_protocol = "TCP"),
            },
            entrypoint = command,
        ),
    )

    return service

def launch_grafana(plan):
    command = ["/run.sh"]
    service = prometheus_grafana_service(plan, "grafana", "grafana/grafana-dev:10.3.0-147071", 3000, command, None)

    grafana_service_details = {}
    all_grafana_service_details = {}

    grafana_service_details["service_name"] = "grafana"
    grafana_service_details["endpoint"] = utils.get_service_url("http", service.ip_address, 3000)

    all_grafana_service_details[service.name] = grafana_service_details

    return all_grafana_service_details
