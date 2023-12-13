parachain = import_module("./parachain/parachain.star")
relay_chain = import_module("./relaychain/relay-chain.star")
package = import_module("./package_io/build-spec.star")
promethues = import_module("./package_io/promethues.star")
grafana = import_module("./package_io/grafana.star")
explorer = import_module("./package_io/polkadot_js_app.star")

def run(plan, args):
    """
    Main function to run the Polkadot relay and parachain setup.

    Args:
        plan (object): The Kurtosis plan object for orchestrating the test.
        args (dict): Dictionary containing arguments for configuring the setup.

    Returns:
        dict: Service details containing information about relay chains, parachains, and Prometheus.
    """
    plan.upload_files(src = "./parachain/static_files/configs", name = "configs")
    plan.upload_files(src = "./parachain/static_files/javascript", name = "javascript")

    prometheus_template = read_file("./package_io/static_files/prometheus.yml.tmpl")
    service_details = {}

    if args["chain-type"] == "local":
        relay_chain_details = relay_chain.start_relay_chains_local(plan, args)
        polkadot_service_name = None
        for key in relay_chain_details:
            polkadot_service_name = key
            break
        plan.print(polkadot_service_name)
        service_details.update(relay_chain_details)
        parachain_details = parachain.start_nodes(plan, args, relay_chain_details[polkadot_service_name]["ip_address"])
        service_details.update(parachain_details)
    else:
        if len(args["relaychain"]) != 0:
            relay_node_details = relay_chain.start_test_main_net_relay_nodes(plan, args)
            service_details.update(relay_node_details)
        for paras in args["para"]:
            parachain_info = parachain.run_testnet_mainnet(plan, paras, args)
            service_details.update(parachain_info)

    #run prometheus , if it returs some endpoint then grafana will up
    prometheus_service_details = promethues.launch_prometheus(plan, args, service_details, prometheus_template)

    service_details.update(prometheus_service_details)
    if prometheus_service_details["prometheus"]["endpoint"].startswith("http://"):
        grafana_service_details = grafana.launch_grafana(plan, grafana)
        service_details.update(grafana_service_details)

    #run the polkadot js App explorer
    if args["explorer"] == True:
        explorer_service_details = explorer.run_pokadot_js_app(plan, "ws://127.0.0.1:9944")

        service_details.update(explorer_service_details)
    return service_details
