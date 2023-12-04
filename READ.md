# Polkadot-kurtosis-package

Polkadot-kurtosis-package is a tool built leveraging the power of Kurtosis, a developer platform for packaging and launching environments. This tool simplifies the process of setting up various local, testnet, and mainnet network configurations and scenarios for Polkadot parachains.

## About

The primary goal of this project is to streamline the setup of Polkadot parachain environments using the Kurtosis platform. With just a few one-liners, developers can package and launch environments tailored to their needs.

## Setup and Requirements

Ensure the following prerequisites are met before using the Polkadot-kurtosis-package:
- Docker installed on your machine[https://www.docker.com/]
- Kurtosis installed on your machine[https://www.kurtosis.com/]

# Integrated Parachains

List of integrated parachains within the Polkadot-kurtosis-package.

- acala
- ajuna
- bifrost
- centrifuge
- clover
- frequency
- integritee
- interlay
- kilt
- kylin
- litentry
- manta
- moonbeam
- moonsama
- nodle
- parallel
- pendulum
- phala
- polkadex
- subsocial
- zeitgeist
- encointer
- altair
- bajun
- calamari
- karura
- khala
- kintsugi-btc
- litmus
- mangata
- moonriver
- robonomics
- subzero
- turing



## Chopstick Compatibility

The package also supports Chopsticks, a tool offering a user-friendly approach to locally branching existing Substrate-based chains. It enables block replay, multi-block forking, and more.

### Parachains Compatible with Chopsticks

- astar
- basilisk
- acala
- centrifuge
- composable-polkadot
- hydradx
- imbu
- interlay
- karura
- mandala
- mangata
- moonbase
- moonbeam
- moonriver
- nodle-eden
- picasso-kusama
- picasso-rococo
- polkadex
- shibuya
- shiden
- statemine
- statemint
-ß tinkernet

Check more info on Chopsticks, refer to the [Chopsticks].

## Zombienet

Zombienet is a CLI tool that facilitates the creation and testing of ephemeral Polkadot/Substrate networks. It offers a straightforward interface for developers to spawn and examine these temporary networks, enabling them to thoroughly evaluate their applications and protocols within a simulated real-world environment.


## Usage

To use the package, run the following command inside the root directory of your project:

```bash
kurtosis run . --enclave 'enclavename' --args-file=path/to/config/file
```

For detailed instructions on writing the configuration file, refer to the [Configuration File Guidelines]

Certainly! Let's create a section in your README file to explain how to write the configuration file using the provided example. I'll include a breakdown of each field and provide explanations:

# Configuration File Guidelines

To use the Polkadot-kurtosis-package, you need to create a configuration file specifying the desired network setup. Below is an example configuration file along with explanations for each field:

```json
{
  "chain-type": "testnet",
  "relaychain": {
    "name": "rococo",
    "nodes": [
      {
        "name": "alice",
        "node-type": "validator",
        "port": 9944,
        "prometheus": false
      },
      {
        "name": "bob",
        "node-type": "full",
        "port": 9945,
        "prometheus": false
      }
    ]
  },
  "para": [
    {
      "name":"kilt",
      "nodes": [
        {
          "name": "alice",
          "node-type": "validator",
          "prometheus": false
        },
        {
          "name": "bob",
          "node-type": "full",
          "prometheus": false
        }
      ]
    }
  ],
  "chopstick": {
    "xcm": false,
    "relaychain":"",
    "parachains": ["acala"]
  }
}
```

## Configuration Fields:

- **chain-type:** Specifies the type of the network (e.g., "localnet","testnet", "mainnet").
- **relaychain:** Configuration for the relay chain. (When chain-type is "testnet" or "mainenet", the "relaychain" can be empty dictonary)
  - **name:** Name of the relay chain (e.g., "rococo-local", "rococo", "polkadot" or "kusama").
  - **nodes:** List of nodes on the relay chain, each with:
    - **name:** Node name (e.g., "alice").
    - **node-type:** Node type, can be "validator" or "full".
    - **port:** Port number for the node (e.g., 9944).
    - **prometheus:** Whether Prometheus monitoring is enabled (true/false).
- **para:** List of parachains, each with:
  - **name:** Parachain name (e.g., "kilt").
  - **nodes:** List of nodes on the parachain, similar to relay chain nodes.
    - **name:** Node name (e.g., "alice").
    - **node-type:** Node type, can be "callator" or "full".
    - **prometheus:** Whether Prometheus monitoring is enabled (true/false).
- **chopstick:** Configuration for Chopstick integration.
  - **xcm:** Whether XCM (Cross-Chain Messaging) is enabled (true/false).
  - **relaychain:** Name of the relay chain for Chopstick integration.
  - **parachains:** List of parachains compatible with Chopsticks.

Feel free to modify this example configuration file based on your specific network requirements.

## Contributing

We welcome contributions to enhance and expand the functionality of the Polkadot-kurtosis-package. Feel free to fork the repository, make your changes, and submit a pull request.
