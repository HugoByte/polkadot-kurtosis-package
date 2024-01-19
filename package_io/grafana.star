utils = import_module("./utils.star")

def prometheus_grafana_service(plan, service_name, image, port, command, build_file = None):
    files = {
        "/app": "configs",
    }
    if build_file != None:
        files["/build"] = build_file

    if port != None:
        public_ports = {"polkadot": PortSpec(port, transport_protocol = "TCP")}
    else:
        public_ports = {}
    service = plan.add_service(
        name = service_name,
        config = ServiceConfig(
            image = image,
            files = files,
            env_vars={
                "GF_AUTH_ANONYMOUS_ENABLED": "true",
                "GF_AUTH_ANONYMOUS_ORG_ROLE": "Admin",
                "GF_AUTH_ANONYMOUS_ORG_NAME": "Main Org.",
            },
            ports = {
                "polkadot": PortSpec(3000, transport_protocol = "TCP"),
            },
            public_ports = public_ports,
            entrypoint = command,
        ),
    )

    return service

def launch_grafana(plan, port = None):
    command = ["/run.sh"]
    service = prometheus_grafana_service(plan, "grafana", "grafana/grafana-dev:10.3.0-147071", port, command, None)

    grafana_service_details = {}
    all_grafana_service_details = {}

    grafana_service_details["service_name"] = "grafana"
    grafana_service_details["endpoint"] = utils.get_service_url("http", service.ip_address, 3000)
    if port != None:
        grafana_service_details["endpoint_public"] = utils.get_service_url("http", "127.0.0.1", port)
    all_grafana_service_details[service.name] = grafana_service_details

    return all_grafana_service_details