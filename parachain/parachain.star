build_spec = import_module("../package_io/build-spec.star")
constant = import_module("../package_io/constant.star")

def create_parachain_build_spec_with_para_id(plan, image, binary, chain_name, para_id):
    command = ExecRecipe(command = ["bin/sh", "-c", "{0} build-spec --chain={1} --disable-default-bootnode > /tmp/{1}.json".format(binary, chain_name)])

    build_spec.create_edit_and_build_spec(plan, constant.PLAIN_BUILD_SPEC, image, chain_name, command, build_file = None)

    command = ExecRecipe(command = ["bin/sh", "-c", "sed -e 's/\"parachainId\": *[0-9]\\+/\"parachainId\": {0}/' -e 's/\"para_id\": [0-9]*,/\"para_id\": {0},/' -e 's/\"paraId\": [0-9]*,/\"paraId\": {0},/' /build/{1}.json >  /tmp/{1}.json".format(para_id, chain_name)])

    build_spec.create_edit_and_build_spec(plan, constant.EDIT_BUILD_SPEC, constant.CURL_JQ_IMAGE, chain_name, command, constant.PLAIN_BUILD_SPEC)

    create_raw_build_spec_genisis_state_genisis_wasm(plan, binary, image, chain_name, constant.EDIT_BUILD_SPEC)
