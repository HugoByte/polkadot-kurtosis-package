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

    prometheus_template = read_file("./package_io/static_files/prometheus.yml.tmpl")
    service_details = {"relaychains": {}, "parachains": {}, "prometheus": ""}

    if args["chain-type"] == "local":
        relay_chain_details = relay_chain.start_relay_chains_local(plan, args)
        service_details["relaychains"] = relay_chain_details
        parachain_details = parachain.start_nodes(plan, args, relay_chain_details[0]["service_details"].ip_address)
        service_details["parachains"] = parachain_details
    else:
        if len(args["relaychain"]) != 0:
            relay_node_detals = relay_chain.start_test_main_net_relay_nodes(plan, args)
            service_details["relaychains"] = relay_node_detals
        final_parachain_detail = []
        for paras in args["para"]:
            parachain_details={}
            parachain_details["service_name"] = "parachain_service_" + paras["name"]
            parachain_details["parachain_name"] = paras["name"]
            parachain_info = parachain.run_testnet_mainnet(plan, paras, args)
            parachain_details["nodes"] = parachain_info
            final_parachain_detail.append(parachain_details)
            service_details["parachains"] = final_parachain_detail

    prometheus_address = promethues.launch_prometheus(plan, args, service_details, prometheus_template)
    service_details["prometheus"] = prometheus_address
    grafana.launch_grafana(plan, grafana)

    #run the polkadot js App explorer
    if args["explorer"] == True:
        service_details["explorer"] = explorer.run_pokadot_js_app(plan, "wss://127.0.0.1:9944")

    return service_details