def create_service_for_build_spec(plan, service_name, image, build_file):
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
            entrypoint = ["/bin/sh"],
        ),
    )

    return service

def create_edit_and_build_spec(plan, service_name, image, chain_name, command, build_file):
    service = create_service_for_build_spec(plan, service_name, image, build_file)

    plan.exec(service_name = service_name, recipe = command)

    plan.store_service_files(service_name = service_name, src = "/tmp/{0}.json".format(chain_name), name = service_name)

    plan.remove_service(service_name)

    return service

relay_chain = import_module("./constant.star")

def prometheus(plan, args, ip):
    create_service_for_build_spec(plan, "prometheus-curl", "badouralix/curl-jq", None)
    command = ["sh", "-c", "cp /app/prometheus.yml /tmp/ && sed -i 's/172.16.0.3:9615/{0}/' /tmp/prometheus.yml && /bin/prometheus --config.file=/tmp/prometheus.yml".format(ip)]
    prometheus = prometheus_grafana_service(plan, "prometheus", "prom/prometheus:latest", 9090, ip, command, None)
    command = ["/run.sh"]
    prometheus_grafana_service(plan, "grafana", "grafana/grafana-dev:10.3.0-147071", 3000, ip, command, None)

    return prometheus

def prometheus_grafana_service(plan, service_name, image, port, ip, command, build_file = None):
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
