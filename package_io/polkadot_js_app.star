"""
This file contain code for running the polkadot-js App
"""

utils = import_module("./utils.star")
def run_pokadot_js_app(plan, ws_url):
    """ 
        This function will run the service for polkadot Js App
    Args:
        plan (object): kurtosis plan object1 
        ws_url (str): connect to a Polkadot node of given web socket URL 
    """
    service_config = ServiceConfig(
        image = "jacogr/polkadot-js-apps:latest",
        
        ports = {
            "TCP" : PortSpec(80)
        },
        public_ports = {
            "TCP" : PortSpec(80)
        },
        env_vars = {
            "WS_URL": ws_url,
        }
    )
    service_details = plan.add_service(name="polkadot-js-explorer", config=service_config)

    all_explorer_service_details = {}
    explorer_service_details = {}
    explorer_service_details["service_name"] = service_details.name
    explorer_service_details["endpoint"] = utils.get_service_url("http", service_details.ip_address, 80)
    explorer_service_details["endpoint_public"] = utils.get_service_url("http", "127.0.0.1", 80)
    all_explorer_service_details[service_details.name] = explorer_service_details
    return all_explorer_service_details