build_spec = import_module("../package_io/build-spec.star")
constant = import_module("../package_io/constant.star")

def create_parachain_build_spec_with_para_id(plan, image, binary, chain_name, chain_base, para_id):
    command = ExecRecipe(command = [
        "/bin/sh",
        "-c",
        "{0} build-spec --chain={1} --disable-default-bootnode > /tmp/{2}.json".format(binary, chain_base, chain_name),
    ])
    build_spec.create_edit_and_build_spec(plan, chain_name + "plain", image, chain_name, command, build_file = None)
    command = ExecRecipe(command = [
        "/bin/sh",
        "-c",
        "sed -e 's/\"parachainId\": *[0-9]\\+/\"parachainId\": {0}/' -e 's/\"para_id\": [0-9]*,/\"para_id\": {0},/' -e 's/\"paraId\": [0-9]*,/\"paraId\": {0},/' -e 's/\"parachain_id\": [0-9]*,/\"parachain_id\": {0},/' /build/{1}.json >  /tmp/{1}.json".format(para_id, chain_name),
    ])
    build_spec.create_edit_and_build_spec(plan, chain_name + "edit", constant.CURL_JQ_IMAGE, chain_name, command, chain_name + "plain")
    raw_service = create_raw_build_spec_genisis_state_genisis_wasm(plan, binary, image, chain_name, chain_name + "edit")

    return raw_service

def create_raw_build_spec_genisis_state_genisis_wasm(plan, binary, image, chain_name, build_file):
    raw_service = build_spec.create_service_for_build_spec(plan, chain_name + "raw", image, build_file)

    command = ExecRecipe(command = [
        "/bin/sh",
        "-c",
        "{0} build-spec --chain=/build/{1}.json --raw --disable-default-bootnode > /tmp/{1}-raw.json".format(binary, chain_name),
    ])
    result = plan.exec(service_name = chain_name + "raw", recipe = command)
    plan.verify(result["code"], "==", 0)

    command = ExecRecipe(command = [
        "/bin/sh",
        "-c",
        "{0} export-genesis-wasm --chain=/tmp/{1}-raw.json  > /tmp/{1}-genesis-wasm".format(binary, chain_name),
    ])
    result = plan.exec(service_name = chain_name + "raw", recipe = command)
    plan.verify(result["code"], "==", 0)

    command = ExecRecipe(command = [
        "/bin/sh",
        "-c",
        "{0} export-genesis-state --chain=/tmp/{1}-raw.json  > /tmp/{1}-genesis-state".format(binary, chain_name),
    ])
    result = plan.exec(service_name = chain_name + "raw", recipe = command)
    plan.verify(result["code"], "==", 0)

    plan.store_service_files(service_name = chain_name + "raw", src = "/tmp/*", name = chain_name + "raw")
    # plan.stop_service(chain_name + "raw")

    return raw_service
