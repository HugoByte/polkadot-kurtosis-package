"""
This file contain code for running the polkadot-js App
"""
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
    service_details = plan.add_service(name="explorer", config=service_config)
    return service_details