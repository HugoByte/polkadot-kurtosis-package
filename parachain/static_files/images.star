"This Dictionary is for polkadot package, containing parachain and their respective docker images"
parachain_images = {
    "acala": {
        "image": "acala/mandala-node:latest",
        "entrypoint": "/usr/local/bin/acala",
        "base": ["dev","testnet","mainnet"]
    },
    "ajuna": {
        "image": "ajuna/parachain-ajuna:latest",
        "entrypoint": "/usr/local/bin/ajuna",
        "base": ["local","testnet","mainnet"]
    },

    "bifrost": {
        "image": "bifrostnetwork/bifrost:latest",
        "entrypoint": "/usr/local/bin/bifrost",
        "base": ["bifrost-local","testnet","mainnet"]
    },
    "centrifuge": {
        "image": "centrifugeio/centrifuge-chain:test-main-latest",
        "entrypoint": "/usr/local/bin/centrifuge-chain",
        "base": ["centrifuge-local","testnet","mainnet"]
    },
    "clover": {
        "image": "cloverio/clover-para:v0.1.24",
        "entrypoint": "/opt/clover/bin/clover",
        "base": ["dev","testnet","mainnet"]
    },
    "frequency": {
        "image": "frequencychain/collator-node-local:latest",
        "entrypoint": "/frequency/target/release/frequency",
        "base": ["frequency-rococo-local","testnet","mainnet"]
    },
    "integritee": {
        "image": "integritee/parachain",
        "entrypoint": "/usr/local/bin/integritee-collator",
        "base": ["integritee-rococo","testnet","mainnet"]
    },
    "interlay": {
        "image": "interlayhq/interbtc:latest",
        "entrypoint": "/usr/local/bin/interbtc-parachain",
        "base": ["dev","testnet","mainnet"]
    },
    "kilt-spiritnet	": {
        "image": "kiltprotocol/kilt-node:latest",
        "entrypoint": "/usr/local/bin/node-executable",
        "base": ["dev","testnet","mainnet"]
    },
    "kylin": {
        "image": "kylinnetworks/kylin-collator:ro-v0.9.30",
        "entrypoint": "/usr/local/bin/kylin-collator",
        "base": ["dev","testnet","mainnet"]
    },
    "litentry": {
        "image": "litentry/litentry-parachain:latest",
        "entrypoint": "/usr/local/bin/litentry-collator",
        "base": ["litentry-dev","testnet","mainnet"]
    },
    "manta":{
        "image": "mantanetwork/manta:latest",
        "entrypoint": "/usr/local/bin/manta",
        "base": ["manta-local","testnet","mainnet"]
    },
    "moonbeamfoundation/moonbeam": {
        "image": "moonbeamfoundation/moonbeam:sha-32933811",
        "entrypoint": "/moonbeam/moonbeam",
        "base": ["dev","testnet","mainnet"]
    },
    "moonsama": {
        "image": "moonsama/moonsama-node:latest",
        "entrypoint": "/moonsama/moonsama-node",
        "base": ["dev","testnet","mainnet"]
    },
    "nodle": {
        "image": "nodlecode/chain:latest",
        "entrypoint": "nodle-parachain",
        "base": ["local","testnet","mainnet"]
    },
    "parallel": {
        "image": "parallelfinance/parallel:latest",
        "entrypoint": "/parallel/.entrypoint.sh",
        "base": ["kerria-dev","testnet","mainnet"]
    },
    "pendulum": {
        "image": "pendulumchain/pendulum-collator:latest",
        "entrypoint": "/usr/local/bin/pendulum-collator",
        "base": ["litentry-dev","testnet","mainnet"]
    },
    "phala-network": {
        "image": "litentry/litentry-parachain:latest",
        "entrypoint": "/usr/local/bin/litentry-collator",
        "base": ["dev","testnet","mainnet"]
    },
    "polkadex": {
        "image": "polkadex/parachain:latest",
        "entrypoint": "/usr/local/bin/parachain-polkadex-node",
        "base": ["dev","testnet","mainnet"]
    },
    "subsocial": {
        "image": "dappforce/subsocial-parachain:latest",
        "entrypoint": "/usr/local/bin/subsocial-collator",
        "base": ["local-rococo","testnet","mainnet"]
    },
    "zeitgeist": {
        "image": "zeitgeistpm/zeitgeist-node-parachain",
        "entrypoint": "/usr/local/bin/zeitgeist",
        "base": ["dev","testnet","mainnet"]
    },
    "encointer-network": {
        "image": "encointer/parachain:1.5.1",
        "entrypoint": "/usr/local/bin/encointer-collator",
        "base": ["encointer-rococo-local","testnet","mainnet"]
    },
    "altair": {
        "image": "centrifugeio/centrifuge-chain:test-main-latest",
        "entrypoint": "/usr/local/bin/centrifuge-chain",
        "base": ["altair-local","testnet","mainnet"]
    },
    "bajuna": {
        "image": "ajuna/parachain-bajun:latest",
        "entrypoint": "/usr/local/bin/ajuna",
        "base": ["local","testnet","mainnet"]
    },
    "calamari": {
        "image": "mantanetwork/manta:latest",
        "entrypoint": "/usr/local/bin/manta",
        "base": ["calamari-local","testnet","mainnet"]
    },
    "karura": {
        "image": "acala/karura-node:latest",
        "entrypoint": "/usr/local/bin/acala",
        "base": ["dev","testnet","mainnet"]
    },
    "khala network": {
        "image": "phalanetwork/khala-node:latest",
        "entrypoint": "/usr/local/bin/khala-node",
        "base": ["khala-dev-2004","testnet","mainnet"]
    },
    "kintsugi-btc": {
        "image": "interlayhq/interbtc:latest",
        "entrypoint": "tini -- /usr/local/bin/interbtc-parachain",
        "base": ["dev","testnet","mainnet"]
    },
    "litmus": {
        "image": "litentry/litentry-parachain:latest",
        "entrypoint": "/usr/local/bin/litentry-collator",
        "base": ["litmus-dev","testnet","mainnet"]
    },
    "mangata": {
        "image": "mangatasolutions/mangata-node:ci-e2e-jobs-fix-MGX-785-fast",
        "entrypoint": "/mangata/node",
        "base": ["rococo-local","testnet","mainnet"]
    },
    "moonriver": {
        "image": "moonbeamfoundation/moonbeam:sha-519bd694",
        "entrypoint": "/moonbeam/moonbeam",
        "base": ["dev","testnet","mainnet"]
    },
    "robonomics": {
        "image": "robonomics/robonomics:latest",
        "entrypoint": "/usr/local/bin/robonomics",
        "base": ["dev","testnet","mainnet"]
    },
    "subzero": {
        "image": "playzero/subzero:latest",
        "entrypoint": "/usr/local/bin/subzero",
        "base": ["dev","testnet","mainnet"]
    },
    "turing": {
        "image": "oaknetwork/turing:latest",
        "entrypoint": "./oak-collator",
        "base": ["turing-dev","testnet","mainnet"]
    },
}
