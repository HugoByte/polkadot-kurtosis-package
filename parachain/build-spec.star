build_spec = import_module("../package_io/build-spec.star")
constant = import_module("../package_io/constant.star")

def create_parachain_build_spec_with_para_id(plan, image, binary, chain_name, chain_base, para_id, sudo_key, collators_keys):
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
        "/javascript": "javascript",
    }


    run_command = "cd /javascript && npm i && node edit_parachain_plain.js /build/{0}.json {1} \"{2}\" \'{3}\'".format(chain_name, para_id, sudo_key, collators_keys)
    plan.print(run_command)
    plan.run_sh(
        run = run_command,
        image = constant.NODE_IMAGE,
        files = files,
        store = [StoreSpec(src = "/build/{0}.json".format(chain_name), name = chain_name + "edit")],
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
