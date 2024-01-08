NOT_PROVIDED_APPLICATION_PROTOCOL = ""
NOT_PROVIDED_WAIT = "not-provided-wait"

def new_template_and_data(template, template_data_json):
    return struct(template = template, data = template_data_json)

def path_join(*args):
    joined_path = "/".join(args)
    return joined_path.replace("//", "/")

def path_base(path):
    split_path = path.split("/")
    return split_path[-1]

def path_dir(path):
    split_path = path.split("/")
    if len(split_path) <= 1:
        return "."
    split_path = split_path[:-1]
    return "/".join(split_path) or "/"

def new_port_spec(
        number,
        transport_protocol,
        application_protocol = NOT_PROVIDED_APPLICATION_PROTOCOL,
        wait = NOT_PROVIDED_WAIT):
    if wait == NOT_PROVIDED_WAIT:
        return PortSpec(
            number = number,
            transport_protocol = transport_protocol,
            application_protocol = application_protocol,
        )

    return PortSpec(
        number = number,
        transport_protocol = transport_protocol,
        application_protocol = application_protocol,
        wait = wait,
    )

def read_file_from_service(plan, service_name, filename):
    output = plan.exec(
        service_name = service_name,
        recipe = ExecRecipe(
            command = ["/bin/sh", "-c", "cat {} | tr -d '\n'".format(filename)],
        ),
    )
    return output["output"]


def get_service_url(protocol ,ip_address, ports):
    url = "{0}://{1}:{2}".format(protocol, ip_address, ports)
    return url


def check_config_validity(plan, args):
    if len(args["relaychain"]) != 0:
        for node in args["relaychain"]["nodes"]:
            if len(node) != 0:
                if node["node-type"] in ["validator",  "full", "archive"]:
                    plan.print("config for relaynodes is valid")
                else:
                    return fail("relaychain node-type can be only validator/full")
    
    if len(args["para"]) != 0:
        for para in args["para"]:
            if len(para["nodes"]) != 0:
                for node in para["nodes"]:
                    if node["node-type"] in ["validator",  "full", "collator"]:
                            plan.print("config for parachain is valid")
                    else:
                        return fail("parachain node-type can be only validator/full/collator")

def upload_files(plan):
    plan.upload_files(src = "../parachain/static_files/configs", name = "configs")
    plan.upload_files(src = "../parachain/static_files/javascript", name = "javascript")

