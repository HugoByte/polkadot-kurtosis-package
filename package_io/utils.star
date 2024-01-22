constant = import_module("./constant.star")

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

def get_service_url(protocol ,ip_address, ports):
    url = "{0}://{1}:{2}".format(protocol, ip_address, ports)
    return url


def check_config_validity(plan, chain_type, relaychain, parachains):

    if chain_type != "localnet" and chain_type != "mainnet" and chain_type != "testnet":
        return fail("Invalid chain type")

    if chain_type == "localnet" and relaychain == {}:
        return fail("relay config must be present for localnet")

    if relaychain != {}:
        chain_name = relaychain["name"] 
        relay_nodes = relaychain["nodes"]
    
        if chain_type == "testnet":
            if chain_name != "rococo" and chain_name != "westend":
                return fail("Please provide rococo or westend as relaychain for testnet")
        elif chain_type == "mainnet":
            if chain_name != "polkadot" and chain_name != "kusama":
                return fail("Please provide polkadot or kusama as relaychain for mainnet")
        elif chain_type == "localnet":
            if chain_name != "rococo-local":
                return fail("Please provide rococo-local as relaychain for localnet")
            elif len(relay_nodes) < 2:
                return fail("relay nodes must contain at least two nodes for localnet")
        
        if chain_name == "polkadot":
            if len(parachains) != 0:
                for para in parachains:
                    if para["name"] not in constant.POLKADOT_PARACHAINS:
                        return fail("Invalid parachain for POLKADOT")
        
        if chain_name == "kusama":
            if len(parachains) != 0:
                for para in parachains:
                    if para["name"] not in constant.KUSAMA_PARACHAINS:
                        return fail("Invalid parachain for KUSAMA")
                
    if len(relaychain) != 0:
        for node in relay_nodes:
            if len(node) != 0:
                if node["node_type"] in ["validator",  "full", "archive"]:
                    plan.print("config for relaynodes is valid")
                else:
                    return fail("relaychain node_type can be only validator/full")
    
    if len(parachains) != 0:
        for para in parachains:
            if len(para["nodes"]) != 0:
                for node in para["nodes"]:
                    if node["node_type"] in ["validator",  "full", "collator"]:
                            plan.print("config for parachain is valid")
                    else:
                        return fail("parachain node_type can be only validator/full/collator")

def upload_files(plan):
    plan.upload_files(src = "../parachain/static_files/configs", name = "configs")
    plan.upload_files(src = "../parachain/static_files/javascript", name = "javascript")


def convert_to_lowercase(chain_type, relaychain, parachains):
    chain_type = chain_type.lower()
    if relaychain != {}:
        relaychain["name"] = relaychain["name"].lower()
        if len(relaychain["nodes"]) > 0:
            for node in relaychain["nodes"]:
                node["name"] = node["name"].lower()
                node["node_type"] = node["node_type"].lower()

    for para in parachains:
        para["name"] = para["name"].lower()
        for node in para["nodes"]:
            node["name"] = node["name"].lower()
            node["node_type"] = node["node_type"].lower()

    return chain_type, relaychain, parachains
    