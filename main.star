parachain = import_module("./parachain/parachain.star")
relay_chain = import_module("./relaychain/relay-chain.star")
package = import_module("./package_io/build-spec.star")
promethues = import_module("./package_io/promethues.star")
grafana = import_module("./package_io/grafana.star")
explorer_js = import_module("./package_io/polkadot_js_app.star")
utils = import_module("./package_io/utils.star")

def run(plan, chain_type = "local", relaychain = None, parachains = None, explorer = False):
    """
    Main function to run the Polkadot relay and parachain setup.

    Args:
        plan (object): The Kurtosis plan object for orchestrating the test.
        args (dict): Dictionary containing arguments for configuring the setup.

    Returns:
        dict: Service details containing information about relay chains, parachains, and Prometheus.
    """
    service_details = run_polkadot_setup(plan, chain_type, relaychain, parachains, explorer)
    return service_details
    

def run_polkadot_setup(plan, chain_type, relaychain, parachains, explorer):
    """
    Main function to run the Polkadot relay and parachain setup.

    Args:
        plan (object): The Kurtosis plan object for orchestrating the test.
        args (dict): Dictionary containing arguments for configuring the setup.

    Returns:
        dict: Service details containing information about relay chains, parachains, and Prometheus.
    """

    chain_type, relaychain, parachains = utils.convert_to_lowercase(chain_type, relaychain, parachains)
    utils.check_config_validity(plan, chain_type, relaychain, parachains)
    utils.upload_files(plan)
    
    service_details = {}

    if chain_type == "local":
        relay_chain_details = relay_chain.start_relay_chains_local(plan, chain_type, relaychain["name"], relaychain["nodes"])
        polkadot_service_name = None
        for key in relay_chain_details:
            polkadot_service_name = key
            break
        service_details.update(relay_chain_details)
        parachain_details = parachain.start_nodes(plan, chain_type, parachains, relay_chain_details[polkadot_service_name]["ip_address"])
        service_details.update(parachain_details)
    else:
        if len(relaychain) != 0:
            relay_node_details = relay_chain.start_test_main_net_relay_nodes(plan, chain_type, relaychain["name"], relaychain["nodes"])
            service_details.update(relay_node_details)
        for paras in parachains:
            parachain_info = parachain.run_testnet_mainnet(plan, chain_type, relaychain["name"], paras)
            service_details.update(parachain_info)

    #run prometheus , if it returs some endpoint then grafana will up
    prometheus_service_details = promethues.launch_prometheus(plan, service_details)

    if len(prometheus_service_details) != 0:
        service_details.update(prometheus_service_details)
        if prometheus_service_details["prometheus"]["endpoint"].startswith("http://"):
            grafana_service_details = grafana.launch_grafana(plan)
            service_details.update(grafana_service_details)

    #run the polkadot js App explorer
    if explorer == True:
        explorer_service_details = explorer_js.run_pokadot_js_app(plan, "ws://127.0.0.1:9944")

        service_details.update(explorer_service_details)
    return service_details
    
def convert_to_lowercase(data):
    if type(data) == dict:
        return {key: convert_to_lowercase(value) for key, value in data.items()}
    elif type(data) == list:
        return [convert_to_lowercase(item) for item in data]
    elif type(data) == str:
        return data.lower()
    else:
        return data