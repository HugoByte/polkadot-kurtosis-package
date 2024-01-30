build_spec = import_module("../package_io/build-spec.star")
constant = import_module("../package_io/constant.star")

def create_parachain_build_spec_with_para_id(plan, image, binary, chain_name, chain_base, para_id):
    files = {
        "/app": "configs",
    }

    plan.run_sh(
        run = "{0} build-spec --chain={1} --disable-default-bootnode > /tmp/{2}.json".format(binary, chain_base, chain_name),
        image = image,
        files = files,
        store = [StoreSpec(src = "/tmp/{0}.json".format(chain_name), name = chain_name + "plain")],
    )

    files = {
        "/app": "configs",
        "/build": chain_name + "plain",
    }
    plan.run_sh(
        run = "sed -e 's/\"parachainId\": *[0-9]\\+/\"parachainId\": {0}/' -e 's/\"para_id\": [0-9]*,/\"para_id\": {0},/' -e 's/\"paraId\": [0-9]*,/\"paraId\": {0},/' -e 's/\"parachain_id\": [0-9]*,/\"parachain_id\": {0},/' /build/{1}.json >  /tmp/{1}.json".format(para_id, chain_name),
        image = constant.CURL_JQ_IMAGE,
        files = files,
        store = [StoreSpec(src = "/tmp/{0}.json".format(chain_name), name = chain_name + "edit")],
    )

    raw_service = create_raw_build_spec_genisis_state_genisis_wasm_for_parachain(plan, binary, image, chain_name)

    return raw_service

def create_raw_build_spec_genisis_state_genisis_wasm_for_parachain(plan, binary, image, chain_name):
    files = {
        "/app": "configs",
        "/build": chain_name + "edit",
    }

    plan.run_sh(
        run = "{0} build-spec --chain=/build/{1}.json --raw --disable-default-bootnode > /tmp/{1}-raw.json && {0} export-genesis-wasm --chain=/tmp/{1}-raw.json  > /tmp/{1}-genesis-wasm && {0} export-genesis-state --chain=/tmp/{1}-raw.json  > /tmp/{1}-genesis-state".format(binary, chain_name),
        image = image,
        files = files,
        store = [StoreSpec(src = "/tmp/*", name = chain_name + "raw")],
    )

    return chain_name + "raw"
