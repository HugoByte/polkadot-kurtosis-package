import argparse
import json


def update_config(original_config, relay_chain, para_chain, network):
    # Read the original JSON file
    with open(original_config, 'r') as file:
        config_data = json.load(file)
    
    if network == "testnet":
        config_data["chain_type"] = "testnet"
        config_data["relaychain"]["name"] = "rococo"
    elif network == "mainnet":
        config_data["chain_type"] = "mainnet"
        config_data["relaychain"]["name"] = relay_chain.lower()
    else:
        # Update the original JSON data
        config_data["chain_type"] = "local"
        config_data["relaychain"]["name"] = "rococo-local"

    for para in config_data["parachains"]:
        para["name"] = para_chain

    # config_data["para"][para_chain] = config_data["para"].pop(name)
    updated_config = json.dumps(config_data, indent=2)

    # Optionally, save the updated config to a new file
    with open('./testdata/updated_config.json', 'w') as file:
        file.write(updated_config)

    print(updated_config)
    


def main():
    parser = argparse.ArgumentParser(description='Your script description')
    parser.add_argument('--relay', type=str, help='Relay chain argument')
    parser.add_argument('--para', type=str, help='Para chain argument')
    parser.add_argument('--network', type=str, help='test environment')

    args = parser.parse_args()
    update_config("./local.json", args.relay, args.para, args.network)

if __name__ == "__main__":
    main()