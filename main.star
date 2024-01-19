parachain = import_module("./parachain/parachain.star")
relay_chain = import_module("./relaychain/relay-chain.star")
package = import_module("./package_io/build-spec.star")
promethues = import_module("./package_io/promethues.star")
grafana = import_module("./package_io/grafana.star")
explorer_js = import_module("./package_io/polkadot_js_app.star")
utils = import_module("./package_io/utils.star")
constant = import_module("./package_io/constant.star")

def run(plan, chain_type = "local", relaychain = None, parachains = None, explorer = False):
    """
    Main function to run the Polkadot relay and parachain setup.
    
    Args:
        chain_type (string): The type of chain (local, testnet or mainnet). Default is local.
        relaychain (json, optional): A json object containing data for relay chain config.
            - name (string): Name of relay chain.
            - nodes (json): A json object containing node details.
                - name (string): Name of node.
                - node_type (string): Type of node.
                - prometheus (bool): Boolean value to enable metrics for a given node.
        parachains (json, optional): A json object containing data for para chain config. Each item in the list has the following:
            - name (string): Name of para chain.
            - nodes (json): A json object containing node details.
                - name (string): Name of node.
                - node_type (string): Type of node.
                - prometheus (bool): Boolean value to enable metrics for a given node.
        explorer (bool, optional): A boolean value indicating whether to enable polkadot js explorer or not.

    Returns:
        service_details (json): Service details containing information about relay chains, parachains, and Prometheus.
    """
    service_details = run_polkadot_setup(plan, chain_type, relaychain, parachains, explorer)
    return service_details
    

def run_polkadot_setup(plan, chain_type, relaychain, parachains, explorer):
    """
    Main function to run the Polkadot relay and parachain setup.

    Args:
        chain_type (string): The type of chain (local, testnet or mainnet). Default is local.
        relaychain (json): A json object containing data for relay chain config.
            - name (string): Name of relay chain.
            - node (json): A json object of node details.
                - name (string): Name of node.
                - node_type (string): Type of node.
                - prometheus (bool): Boolean value to enable metrics for a given node.
        parachains (json): A json object containing data for para chain config. Each item in the list has the following:
            - name (string): Name of para chain.
            - node (json): A json object of node details.
                - name (string): Name of node.
                - node_type (string): Type of node.
                - prometheus (bool): Boolean value to enable metrics for a given node.
        explorer (bool): A boolean value indicating whether to enable polkadot js explorer or not.

    Returns:
        service_details (json): Service details containing information about relay chains, parachains, and Prometheus.
    """

    chain_type, relaychain, parachains = utils.convert_to_lowercase(chain_type, relaychain, parachains)
    utils.check_config_validity(plan, chain_type, relaychain, parachains)
    utils.upload_files(plan)
    
    service_details = {}

    if chain_type == "local":
        relay_chain_details = relay_chain.start_relay_chains_local(plan, relaychain)
        polkadot_service_name = None
        for key in relay_chain_details:
            polkadot_service_name = key
            break
        service_details.update(relay_chain_details)
        parachain_details = parachain.start_nodes(plan, chain_type, parachains, relay_chain_details[polkadot_service_name]["ip_address"])
        service_details.update(parachain_details)
    else:
        if len(relaychain) != 0:
            relay_node_details = relay_chain.start_test_main_net_relay_nodes(plan, chain_type, relaychain)
            service_details.update(relay_node_details)
        for paras in parachains:
            if relaychain != {}:
                relaychain_name = relaychain["name"]
            elif chain_type == "testnet":
                relaychain_name = "rococo"
            elif paras["name"] in constant.POLKADOT_PARACHAINS:
                relaychain_name = "polkadot"
            elif paras["name"] in constant.KUSAMA_PARACHAINS:
                relaychain_name = "kusama"

            parachain_info = parachain.run_testnet_mainnet(plan, chain_type, relaychain_name, paras)
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