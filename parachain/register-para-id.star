build_spec = import_module("../package_io/build-spec.star")
constant = import_module("../package_io/constant.star")

def register_para_id(plan, alice_ip):
    plan.upload_files(src = "./static_files/javascript", name = "javascript")
    test = build_spec.create_service_for_build_spec(plan, constant.PARA_SLOT_REGISTER_SERVICE_NAME, constant.NODE_IMAGE, "javascript")
    plan.exec(service_name = test.name, recipe = ExecRecipe(command = ["/bin/sh", "-c", "cd /build && npm i "]))
    plan.exec(service_name = test.name, recipe = ExecRecipe(command = ["/bin/sh", "-c", "cd /build &&  node register ws://{0}:9944 //Alice ".format(alice_ip)]))
    para_id = plan.exec(service_name = test.name, recipe = ExecRecipe(command = ["/bin/sh", "-c", "cat /tmp/para.json | tr -d '\n\r'"]))

    return para_id["output"]
