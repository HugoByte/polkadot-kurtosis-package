build_spec = import_module("../package_io/build-spec.star")
constant = import_module("../package_io/constant.star")

def register_para_id(plan, alice_ip):
    plan.upload_files(src = "./static_files/javascript", name = "javascript")
    test = build_spec.create_service_for_build_spec(plan, constant.PARA_SLOT_REGISTER_SERVICE_NAME, constant.NODE_IMAGE, "javascript")
    result = plan.exec(service_name = test.name, recipe = ExecRecipe(command = ["/bin/sh", "-c", "cd /build && npm i "]))
    plan.verify(result["code"], "==", 0)
    result = plan.exec(service_name = test.name, recipe = ExecRecipe(command = ["/bin/sh", "-c", "cd /build &&  node register ws://{0}:9944 //Alice ".format(alice_ip)]))
    plan.verify(result["code"], "==", 0)
    para_id = plan.exec(service_name = test.name, recipe = ExecRecipe(command = ["/bin/sh", "-c", "cat /tmp/para.json | tr -d '\n\r'"]))
    plan.verify(para_id["code"], "==", 0)
    plan.remove_service(test.name)
    return para_id["output"]

def onboard_genesis_state_and_wasm(plan, para_id, chain_name, alice_ip):
    service = plan.add_service(
        name = "upload-genesis-file",
        config = ServiceConfig(
            image = constant.NODE_IMAGE,
            files = {
                "/app": "configs",
                "/build": constant.RAW_BUILD_SPEC,
                "/javascript": "javascript",
            },
            entrypoint = ["/bin/sh"],
        ),
    )

    result = plan.exec(service_name = service.name, recipe = ExecRecipe(command = ["/bin/sh", "-c", "cd /javascript && npm i "]))
    plan.verify(result["code"], "==", 0)
    result = plan.exec(service_name = service.name, recipe = ExecRecipe(command = ["/bin/sh", "-c", "cd /javascript &&  node onboard ws://{0}:9944 //Alice {1} /build/{2}-genesis-state /build/{2}-genesis-wasm".format(alice_ip, para_id, chain_name)]))
    plan.verify(result["code"], "==", 0)

    plan.remove_service(service.name)
