
def create_service_for_build_spec(plan, service_name, image, build_file):
    """Create a service based on a build specification.

    Args:
        service_name (string): Name of the service.
        image (string): Docker image for the service.
        build_file (string): Path to the build file.

    Returns:
        object: The created service.
    """
    files = {
        "/app": "configs",
    }
    if build_file != None:
        files["/build"] = build_file

    service = plan.add_service(
        name=service_name,
        config=ServiceConfig(
            image=image,
            files=files,
            entrypoint=["/bin/sh"],
        ),
    )

    return service

def create_edit_and_build_spec(plan, service_name, image, chain_name, command, build_file):
    """Create, edit, and build a service based on a build specification.

    Args:
        service_name (string): Name of the service.
        image (string): Docker image for the service.
        chain_name (string): Name of the chain.
        command (list): Command to execute inside the Docker container.
        build_file (string): Path to the build file.

    Returns:
        object: The created and built service.
    """
    service = create_service_for_build_spec(plan, service_name, image, build_file)

    result = plan.exec(service_name=service_name, recipe=command)
    plan.verify(result["code"], "==", 0)

    plan.store_service_files(service_name=service_name, src="/tmp/{0}.json".format(chain_name), name=service_name)

    plan.remove_service(service_name)

    return service

relay_chain = import_module("./constant.star")
