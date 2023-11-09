"This Dictionary is for polkadot package, containing parachain and their respective docker images"
parachain_images = {
    "acala": {
        "image": "acala/mandala-node:latest",
        "entrypoint": "/usr/local/bin/acala",
        "base": ["dev", "testnet", "mainnet"],
    },
    "ajuna": {
        "image": "ajuna/parachain-ajuna:latest",
        "entrypoint": "/usr/local/bin/ajuna",
        "base": ["dev", None, "mainnet"],
    },
    "bifrost": {
        "image": "bifrostnetwork/bifrost:latest",
        "entrypoint": "/usr/local/bin/bifrost",
        "base": ["bifrost-local", "bifrost-kusama-rococo", "bifrost-polkadot"],
    },
    "centrifuge": {
        "image": "centrifugeio/centrifuge-chain:test-main-latest",
        "entrypoint": "/usr/local/bin/centrifuge-chain",
        "base": ["centrifuge-local", "catalyst", "centrifuge"],
    },
    "clover": {
        "image": "cloverio/clover-para:v0.1.24",
        "entrypoint": "/opt/clover/bin/clover",
        "base": ["dev", "testnet", "mainnet"],
    },
    "frequency": {
        "image": "frequencychain/collator-node-local:latest",
        "entrypoint": "/frequency/target/release/frequency",
        "base": ["frequency-rococo-local", "frequency-rococo", "frequency"],
    },
    "integritee": {
        "image": "integritee/parachain",
        "entrypoint": "/usr/local/bin/integritee-collator",
        "base": ["integritee-rococo", "testnet", "mainnet"],
    },
    "interlay": {
        "image": "interlayhq/interbtc:latest",
        "entrypoint": "/usr/local/bin/interbtc-parachain",
        "base": ["dev", "interlay-testnet-latest", "interlay-latest"],
    },
    "kilt-spiritnet	": {
        "image": "kiltprotocol/kilt-node:latest",
        "entrypoint": "/usr/local/bin/node-executable",
        "base": ["dev", "testnet", "mainnet"],
    },
    "kylin": {
        "image": "kylinnetworks/kylin-collator:ro-v0.9.30",
        "entrypoint": "/usr/local/bin/kylin-collator",
        "base": ["dev", "pichiu-westend", "kylin"],
    },
    "litentry": {
        "image": "litentry/litentry-parachain:latest",
        "entrypoint": "/usr/local/bin/litentry-collator",
        "base": ["litentry-dev", "testnet", "mainnet"],
    },
    "manta": {
        "image": "mantanetwork/manta:latest",
        "entrypoint": "/usr/local/bin/manta",
        "base": ["manta-local", "manta-testnet", "manta"],
    },
    "moonbeamfoundation/moonbeam": {
        "image": "moonbeamfoundation/moonbeam:sha-32933811",
        "entrypoint": "/moonbeam/moonbeam",
        "base": ["dev", "testnet", "mainnet"],
    },
    "moonsama": {
        "image": "moonsama/moonsama-node:latest",
        "entrypoint": "/moonsama/moonsama-node",
        "base": ["dev", "testnet", "mainnet"],
    },
    "nodle": {
        "image": "nodlecode/chain:latest",
        "entrypoint": "nodle-parachain",
        "base": ["local", "testnet", "mainnet"],
    },
    "parallel": {
        "image": "parallelfinance/parallel:latest",
        "entrypoint": "/parallel/.entrypoint.sh",
        "base": ["kerria-dev", "testnet", "parallel"],
    },
    "pendulum": {
        "image": "pendulumchain/pendulum-collator:latest",
        "entrypoint": "/usr/local/bin/pendulum-collator",
        "base": ["litentry-dev", "testnet", "mainnet"],
    },
    "phala-network": {
        "image": "litentry/litentry-parachain:latest",
        "entrypoint": "/usr/local/bin/litentry-collator",
        "base": ["dev", "rhala", "phala"],
    },
    "polkadex": {
        "image": "polkadex/parachain:latest",
        "entrypoint": "/usr/local/bin/parachain-polkadex-node",
        "base": ["dev", "testnet", "mainnet"],
    },
    "subsocial": {
        "image": "dappforce/subsocial-parachain:latest",
        "entrypoint": "/usr/local/bin/subsocial-collator",
        "base": ["local-rococo", None, ""],
    },
    "zeitgeist": {
        "image": "zeitgeistpm/zeitgeist-node-parachain",
        "entrypoint": "/usr/local/bin/zeitgeist",
        "base": ["dev", "testnet", "mainnet"],
    },
    "encointer-network": {
        "image": "encointer/parachain:1.5.1",
        "entrypoint": "/usr/local/bin/encointer-collator",
        "base": ["encointer-rococo-local", "encointer-rococo", "mainnet"],
    },
    "altair": {
        "image": "centrifugeio/centrifuge-chain:test-main-latest",
        "entrypoint": "/usr/local/bin/centrifuge-chain",
        "base": ["altair-local", "testnet", "mainnet"],
    },
    "bajun": {
        "image": "ajuna/parachain-bajun:latest",
        "entrypoint": "/usr/local/bin/ajuna",
        "base": ["local", None, "mainnet"],
    },
    "calamari": {
        "image": "mantanetwork/manta:latest",
        "entrypoint": "/usr/local/bin/manta",
        "base": ["calamari-local", "manta-testnet", "manta"],
    },
    "karura": {
        "image": "acala/karura-node:latest",
        "entrypoint": "/usr/local/bin/acala",
        "base": ["dev", "testnet", "mainnet"],
    },
    "khala network": {
        "image": "phalanetwork/khala-node:latest",
        "entrypoint": "/usr/local/bin/khala-node",
        "base": ["khala-dev-2004", "rhala", "khala"],
    },
    "kintsugi-btc": {
        "image": "interlayhq/interbtc:latest",
        "entrypoint": "tini -- /usr/local/bin/interbtc-parachain",
        "base": ["dev", "testnet", "mainnet"],
    },
    "litmus": {
        "image": "litentry/litentry-parachain:latest",
        "entrypoint": "/usr/local/bin/litentry-collator",
        "base": ["litmus-dev", "testnet", "mainnet"],
    },
    "mangata": {
        "image": "mangatasolutions/mangata-node:ci-e2e-jobs-fix-MGX-785-fast",
        "entrypoint": "/mangata/node",
        "base": ["rococo-local", "testnet", "mainnet"],
    },
    "moonriver": {
        "image": "moonbeamfoundation/moonbeam:sha-519bd694",
        "entrypoint": "/moonbeam/moonbeam",
        "base": ["dev", "alphanet", "moonriver"],
    },
    "robonomics": {
        "image": "robonomics/robonomics:latest",
        "entrypoint": "/usr/local/bin/robonomics",
        "base": ["dev", "testnet", "mainnet"],
    },
    "subzero": {
        "image": "playzero/subzero:latest",
        "entrypoint": "/usr/local/bin/subzero",
        "base": ["dev", "testnet", "mainnet"],
    },
    "turing": {
        "image": "oaknetwork/turing:latest",
        "entrypoint": "./oak-collator",
        "base": ["turing-dev", "testnet", "mainnet"],
    },
}

testnet_chains = {
    "ajuna": {
        "image": "ajuna/parachain-bajun:latest",
        "command": ["--chain=/bajun/rococo/bajun-raw.json", "--ws-port=9944", "--rpc-port=9933", "--rpc-cors=all", "--unsafe-ws-external"],
    },
    "bajun": {
        "image": "ajuna/parachain-bajun:latest",
        "command": ["--chain=/bajun/rococo/bajun-raw.json", "--ws-port=9944", "--rpc-port=9933", "--rpc-cors=all", "--unsafe-ws-external"],
    },
    "frequency": {
        "image": "frequencychain/parachain-node-rococo",
        "command": ["--rpc-port=9944", "--rpc-external", "--rpc-cors=all", "--unsafe-rpc-external"],  # No ws ports
    },
    "centrifuge": {
        "image": "centrifugeio/centrifuge-chain:main-latest",
        "command": ["--chain=catalyst", "--collator", "--rpc-external", "--rpc-cors=all", "--rpc-methods=unsafe", "--unsafe-ws-external"],
    },
    "interlay": {
        "image": "interlayhq/interbtc:latest",
        "command": ["--chain=interlay-testnet-latest", "--force-authoring", "--ws-port=9944", "--rpc-port=9933", "--rpc-external", "--rpc-cors=all", "--rpc-methods=Unsafe", "--unsafe-ws-external", "--", "--chain=rococo"],
    },
    "kylin": {
        "image": "kylinnetworks/kylin-collator:ro-v0.9.30",
        "command": ["--base-path=/kylin/data", "--chain=pichiu-westend", "--ws-external", "--rpc-external", "--rpc-cors=all", "--unsafe-ws-external", "--name=parachain-2010-0", "--collator", "--rpc-methods=unsafe", "--force-authoring", "--execution=wasm"],
    },
    "manta": {
        "image": "mantanetwork/manta:latest",
        "command": ["/usr/local/bin/manta", "--chain=manta-testnet", "--wasm-execution=compiled", "--force-authoring", "--port=30333", "--rpc-port=9944", "--rpc-external", "--rpc-cors=all", "--rpc-methods=Unsafe", "--", "--chain=rococo"],
    },
    "khala": {
        "image": "phalanetwork/khala-node:latest",
        "command": ["/usr/local/bin/khala-node", "--chain=rhala", "--ws-external", "--rpc-external", "--rpc-cors=all", "--name=parachain-2010-0", "--collator", "--rpc-methods=unsafe", "--force-authoring", "--execution=wasm"],
    },
    "phala": {
        "image": "phalanetwork/khala-node:latest",
        "command": ["/usr/local/bin/khala-node", "--chain=rhala", "--ws-external", "--rpc-external", "--rpc-cors=all", "--name=parachain-2010-0", "--collator", "--rpc-methods=unsafe", "--force-authoring", "--execution=wasm"],
    },
    "subsocial": {
        "image": "dappforce/subsocial-parachain:latest",
        "command": ["--collator", "--chain=/app/soonsocial.json", "--port=40335", "--ws-port=9944", "--unsafe-ws-external"],
    },
    "litmus": {
        "image": "dappforce/subsocial-parachain:latest",
        "command": ["--chain=rococo", "--rpc-port=9933", "--rpc-external", "--rpc-cors=all", "--rpc-methods=unsafe", "--execution=wasm", "--unsafe-ws-external"],
    },
    "moonriver": {
        "image": "moonbeamfoundation/moonbeam:sha-519bd694",
        "command": ["--chain=alphanet", "--collator", "--rpc-external", "--rpc-cors=all", "--rpc-methods=unsafe", "--tmp", "--unsafe-rpc-external"],
    },
    "encointer": {
        "image": "encointer/parachain:1.5.1",
        "command": ["--collator", "--chain=encointer-rococo", "--rpc-port=9944", "--unsafe-rpc-external", "--rpc-cors=all", "--", "--execution=wasm", "--chain=rococo"],  # no ws port
    },
}

mainnet = {
    "subsocial": {
        "image": "dappforce/subsocial-parachain:latest",
        "command": ["--collator", "--port=40335", "--ws-port=9944", "--unsafe-ws-external"],  # we dont need to give --chain,
    },
}
