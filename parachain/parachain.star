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
        name = "start-{}-node".format(chain_name),
        config = ServiceConfig(
            image = image,
            files = files,
            ports = {
                "ws": PortSpec(9944, transport_protocol = "TCP"),
            },
            entrypoint = command,
        ),
    )

    return parachain_node

def start_local_parachain_node(plan, parachain, para_id):
    parachain_details = parachain_list.parachain_images[parachain]
    image = parachain_details["image"]
    binary = parachain_details["entrypoint"]
    chain_base = parachain_details["base"][0]
    chain_name = parachain
    raw_service = build_spec.create_parachain_build_spec_with_para_id(plan, image, binary, chain_name, chain_base, para_id)

    exec_comexec_commandmand = [
        "bin/bash",
        "-c",
        "{0} --chain=/build/{1}-raw.json --ws-external --rpc-external --rpc-cors=all --name={1} --collator --rpc-methods=unsafe --force-authoring --execution=wasm --alice  -- --chain=/app/raw-rococo-local.json --execution=wasm".format(binary, chain_name),
    ]

    spawn_parachain(plan, chain_name, image, exec_comexec_commandmand, build_file = raw_service.name)

def start_nodes(plan, args, relay_chain_ip):
    parachains = args["para"]
    for parachain in parachains:
        para_id = register_para_slot.register_para_id(plan, relay_chain_ip)
        start_local_parachain_node(plan, parachain, para_id)
        register_para_slot.onboard_genesis_state_and_wasm(plan, para_id, parachain, relay_chain_ip)

# def run_testnet(plan, args, parachain):
#     parachain_details = parachain_list.testnet_chains[parachain]
#     image = parachain_details["image"]
#     command = parachain_details["command"]

#     if parachain in constant.BINARY_COMMAND_CHAINS:
#         node_setup.run_testnet_node_with_entrypoint(plan, args, image, parachain, command)

#     else:
#         node_setup.run_testnet_node_with_command(plan, args, image, parachain, command)

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
            "--rpc-cors=all",
            "--rpc-external",
            "--ws-external",
            "--rpc-methods=unsafe",
            "--unsafe-rpc-external",
            "--unsafe-ws-external",
        ]

    para_nodes = args["para"][parachain]["nodes"]
    for node in para_nodes:
        command = common_command
        command = command + ["--name={0}".format(node["name"])]
        if node["node-type"] == "collator":
            command = command + ["--collator"]

        if parachain in constant.CHAIN_COMMAND:
            command = command + ["--", "--chain={0}".format(main_chain)]

        if parachain in constant.BINARY_COMMAND_CHAINS:
            binary = parachain_details["entrypoint"]
            command = [binary] + command

            node_setup.run_testnet_node_with_entrypoint(plan, args, image, "{0}-{1}".format(parachain, node["name"]), command)

        else:
            node_setup.run_testnet_node_with_command(plan, args, image, "{0}-{1}".format(parachain, node["name"]), command)
