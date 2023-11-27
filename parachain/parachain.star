build_spec = import_module("./build-spec.star")
register_para_slot = import_module("./register-para-id.star")
constant = import_module("../package_io/constant.star")
parachain_list = import_module("./static_files/images.star")
node_setup = import_module("./node_setup.star")

def spawn_parachain(plan, chain_name, image, command, build_file):
    files = {
        "/app": "configs",
    }
    if build_file != None:
        files["/build"] = build_file

    parachain_node = plan.add_service(
        name = "{}".format(chain_name),
        config = ServiceConfig(
            image = image,
            files = files,
            ports = {
                "ws": PortSpec(9944, transport_protocol = "TCP"),
                "prometheus": PortSpec(9615, transport_protocol = "TCP"),
            },
            entrypoint = command,
        ),
    )

    return parachain_node

def start_local_parachain_node(plan, args, parachain, para_id):
    parachain_details = parachain_list.parachain_images[parachain]
    image = parachain_details["image"]
    binary = parachain_details["entrypoint"]
    chain_base = parachain_details["base"][0]
    chain_name = parachain
    raw_service = build_spec.create_parachain_build_spec_with_para_id(plan, image, binary, chain_name, chain_base, para_id)

    if parachain in constant.NO_WS_PORT:
        exec_comexec_commandmand = [
            "bin/bash",
            "-c",
            "{0} --chain=/build/{1}-raw.json --rpc-external --rpc-cors=all --prometheus-external --name={1} --collator --rpc-methods=unsafe --force-authoring --execution=wasm -- --chain=/app/raw-polkadot.json --execution=wasm".format(binary, chain_name),
        ]
    else:
        exec_comexec_commandmand = [
            "bin/bash",
            "-c",
            "{0} --chain=/build/{1}-raw.json --ws-external --rpc-external --prometheus-external --rpc-cors=all --name={1} --collator --rpc-methods=unsafe --force-authoring --execution=wasm -- --chain=/app/raw-polkadot.json --execution=wasm".format(binary, chain_name),
        ]

    parachain_details = {}
    for node in args["para"][parachain]["nodes"]:
        parachain_detail = spawn_parachain(plan, "{0}-{1}-{2}".format(parachain, node["name"], args["chain-type"]), image, exec_comexec_commandmand, build_file = raw_service.name)
        parachain_details["parachain_{}".format(node["name"])] = parachain_detail

    plan.print(parachain_details)
    return parachain_details

def start_nodes(plan, args, relay_chain_ip):
    parachains = args["para"]
    parachain_details = {}
    for parachain in parachains:
        parachain_details[parachain] = {}
        para_id = register_para_slot.register_para_id(plan, relay_chain_ip)
        parachain_details[parachain] = start_local_parachain_node(plan, args, parachain, para_id)
        register_para_slot.onboard_genesis_state_and_wasm(plan, para_id, parachain, relay_chain_ip)

    return parachain_details

def run_testnet_mainnet(plan, args, parachain):
    if args["chain-type"] == "testnet":
        main_chain = "rococo"
        parachain_details = parachain_list.parachain_images[parachain]
        image = parachain_details["image"]
        base = parachain_details["base"][1]

        if parachain in constant.DIFFERENT_IMAGES_FOR_TESTNET:
            image = constant.DIFFERENT_IMAGES_FOR_TESTNET[parachain]

    else:
        main_chain = "polkadot"
        parachain_details = parachain_list.parachain_images[parachain]
        image = parachain_details["image"]
        base = parachain_details["base"][2]

        if parachain in constant.DIFFERENT_IMAGES_FOR_MAINNET:
            image = constant.DIFFERENT_IMAGES_FOR_MAINNET[parachain]

    if parachain in constant.NO_WS_PORT:
        common_command = [
            "--chain={0}".format(base),
            "--port=30333",
            "--rpc-port=9944",
            "--prometheus-external",
            "--rpc-cors=all",
            "--rpc-external",
            "--rpc-methods=unsafe",
            "--unsafe-rpc-external",
        ]
    else:
        common_command = [
            "--chain={0}".format(base),
            "--port=30333",
            "--ws-port=9944",
            "--rpc-port=9933",
            "--prometheus-external",
            "--rpc-cors=all",
            "--rpc-external",
            "--ws-external",
            "--rpc-methods=unsafe",
            "--unsafe-rpc-external",
            "--unsafe-ws-external",
        ]
    parachain_info = {parachain: {}}
    para_nodes = args["para"][parachain]["nodes"]
    for node in para_nodes:
        command = common_command
        command = command + ["--name={0}".format(node["name"])]
        if node["node-type"] == "collator":
            command = command + ["--collator"]

        if parachain in constant.CHAIN_COMMAND:
            command = command + ["--", "--chain={0}".format(main_chain)]

        if parachain == "kilt-spiritnet" and args["chain-type"] == "testnet":
            command = command + ["--", "--chain=/node/dev-specs/kilt-parachain/peregrine-relay.json"]

        if parachain in constant.BINARY_COMMAND_CHAINS:
            binary = parachain_details["entrypoint"]
            command = [binary] + command

            node_details = node_setup.run_testnet_node_with_entrypoint(plan, image, "{0}-{1}-{2}".format(parachain, node["name"], args["chain-type"]), command)
            parachain_info[parachain]["parachain_" + node["name"]] = node_details

        else:
            node_details = node_setup.run_testnet_node_with_command(plan, image, "{0}-{1}-{2}".format(parachain, node["name"], args["chain-type"]), command)
            parachain_info[parachain]["parachain_" + node["name"]] = node_details

    return parachain_info
