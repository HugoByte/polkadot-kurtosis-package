def create_service_for_build_spec(plan, service_name, image, build_file):
    files = {
        "/app": "configs",
    }
    if build_file != None:
        files["/build"] = build_file

    plan.add_service(
        name = service_name,
        config = ServiceConfig(
            image = image,
            files = files,
            entrypoint = ["bin/sh"],
        ),
    )

def create_edit_and_build_spec(plan, service_name, image, chain_name, command, build_file):
    create_service_for_build_spec(plan, service_name, image, build_file)

    plan.exec(service_name = service_name, recipe = command)

    plan.store_service_files(service_name = service_name, src = "/tmp/{0}.json".format(chain_name), name = service_name)

    plan.stop_service(service_name)