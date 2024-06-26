SERVICE_NAME = "prometheus"
PROMETHEUS_DEFAULT_SCRAPE_INTERVAL = "5s"
METRICS_INFO_ADDITIONAL_CONFIG_KEY = "config"
IMAGE_NAME = "prom/prometheus:latest"
HTTP_PORT_ID = "http"
HTTP_PORT_NUMBER = 9090
CONFIG_FILENAME = "prometheus-config.yml"
CONFIG_DIR_MOUNTPOINT_ON_PROMETHEUS = "/config"
config_template = read_file("./static_files/prometheus.yml.tmpl")

shared_utils = import_module("./utils.star")

USED_PORTS = {
    HTTP_PORT_ID: shared_utils.new_port_spec(
        HTTP_PORT_NUMBER,
        "TCP",
        "http",
    ),
}

def launch_prometheus(
        plan,
        service_details,
        http_port_number = None
    ):
    template_data = new_config_template_data(
        plan,
        service_details,
    )

    if len(template_data["MetricsJobs"]) == 0:
        return {}

    template_and_data = shared_utils.new_template_and_data(
        config_template,
        template_data,
    )
    template_and_data_by_rel_dest_filepath = {}
    template_and_data_by_rel_dest_filepath[CONFIG_FILENAME] = template_and_data

    config_files_artifact_name = plan.render_templates(
        template_and_data_by_rel_dest_filepath,
        "prometheus-config",
    )

    prometheus_service_details = {}
    all_prometheus_service_details = {}
    config = get_config(config_files_artifact_name, http_port_number)
    prometheus_service = plan.add_service(SERVICE_NAME, config)

    private_ip_address = prometheus_service.ip_address
    prometheus_service_http_port = prometheus_service.ports[HTTP_PORT_ID].number
    prometheus_service_details["service_name"] = SERVICE_NAME
    prometheus_service_details["endpoint"] = "http://{0}:{1}".format(private_ip_address, prometheus_service_http_port)
    if http_port_number != None:
        prometheus_service_details["endpoint_public"] = "http://{0}:{1}".format("127.0.0.1", http_port_number)
    
    all_prometheus_service_details[prometheus_service.name] = prometheus_service_details
    return all_prometheus_service_details

def get_config(config_files_artifact_name, http_port_number):
    config_file_path = shared_utils.path_join(
        CONFIG_DIR_MOUNTPOINT_ON_PROMETHEUS,
        shared_utils.path_base(CONFIG_FILENAME),
    )
    if http_port_number == None:
        public_ports = {}
    else:
        public_ports = { 
            HTTP_PORT_ID: shared_utils.new_port_spec(
                http_port_number,
                "TCP",
                "http",
            ),
        }
    return ServiceConfig(
        image = IMAGE_NAME,
        ports = USED_PORTS,
        public_ports = public_ports,
        files = {CONFIG_DIR_MOUNTPOINT_ON_PROMETHEUS: config_files_artifact_name},
        cmd = [
            "--config.file=" + config_file_path,
            "--storage.tsdb.path=/prometheus",
            "--storage.tsdb.retention.time=1d",
            "--storage.tsdb.retention.size=512MB",
            "--storage.tsdb.wal-compression",
            "--web.console.libraries=/etc/prometheus/console_libraries",
            "--web.console.templates=/etc/prometheus/consoles",
            "--web.enable-lifecycle",
        ],
    )

def new_config_template_data(plan, service_details):
    metrics_jobs = []
    for service in service_details:
        if "prometheus" in service_details[service] and service_details[service]["prometheus"] == True:
            ip = service_details[service]["ip_address"]
            port_number = service_details[service]["prometheus_port"]
            endpoint = "{0}:{1}".format(ip, port_number)
            metrics_jobs.append(
                new_metrics_job(
                    job_name = service_details[service]["service_name"],
                    endpoint = endpoint,                        
                    scrape_interval = "5s",
                ),
            )
    return {
        "MetricsJobs": metrics_jobs,
    }


def new_metrics_job(
        job_name,
        endpoint,
        scrape_interval = PROMETHEUS_DEFAULT_SCRAPE_INTERVAL):
    return {
        "Name": job_name,
        "Endpoint": endpoint,
        "ScrapeInterval": scrape_interval,
    }
