"This Dictionary is for polkadot package, containing parachain and their respective docker images"
parachain_images = {
    "acala": {
        "image": "acala/mandala-node:latest",  # NO ws port
        "entrypoint": "/usr/local/bin/acala",
        "base": ["dev", "mandala-latest", "acala"],
    },
    "ajuna": {
        "image": "ajuna/parachain-ajuna:latest",
        "entrypoint": "/usr/local/bin/ajuna",
        "base": ["dev", "/bajun/rococo/bajun-raw.json", "/ajuna/ajuna-raw.json"],
    },
    "bifrost": {
        "image": "bifrostnetwork/bifrost:latest",
        "entrypoint": "/usr/local/bin/bifrost",
        "base": ["bifrost-local", "bifrost-kusama-rococo", "bifrost-polkadot"],
    },
    "centrifuge": {
        "image": "centrifugeio/centrifuge-chain:test-PR1628-354d76c-23-11-28",
        "entrypoint": "/usr/local/bin/centrifuge-chain",
        "base": ["centrifuge-local", "catalyst", "centrifuge"],
    },
    "clover": {
        "image": "cloverio/clover-para:v0.1.24",
        "entrypoint": "/opt/clover/bin/clover",
        "base": ["dev", "iris", "clover"],
    },
    "frequency": {
        "image": "frequencychain/collator-node-local:latest",
        "entrypoint": "/frequency/target/release/frequency",
        "base": ["frequency-rococo-local", "frequency-rococo", "frequency"],
    },
    "integritee": {
        "image": "integritee/parachain",
        "entrypoint": "/usr/local/bin/integritee-collator",
        "base": ["integritee-rococo", "integritee-rococo", "integritee-polkadot"],
    },
    "interlay": {
        "image": "interlayhq/interbtc:latest",
        "entrypoint": "/usr/local/bin/interbtc-parachain",
        "base": ["interlay-dev", "interlay-testnet-latest", "interlay-latest"],
    },
    "kilt": {
        "image": "kiltprotocol/kilt-node:latest",
        "entrypoint": "/usr/local/bin/node-executable",
        "base": ["dev", "/node/dev-specs/kilt-parachain/peregrine-kilt.json", "spiritnet"],
    },
    "kylin": {
        "image": "kylinnetworks/kylin-collator:ro-v0.9.30",
        "entrypoint": "/usr/local/bin/kylin-collator",
        "base": ["dev", "pichiu-westend", "kylin"],
    },
    "litentry": {
        "image": "litentry/litentry-parachain:latest",
        "entrypoint": "/usr/local/bin/litentry-collator",
        "base": ["litentry-dev", "rococo", "litentry"],
    },
    "manta": {
        "image": "mantanetwork/manta:latest",
        "entrypoint": "/usr/local/bin/manta",
        "base": ["manta-local", "manta-testnet", "manta"],
    },
    "moonbeam": {
        "image": "moonbeamfoundation/moonbeam:sha-32933811",
        "entrypoint": "/moonbeam/moonbeam",
        "base": ["moonbeam-dev", "alphanet", "moonbeam"],
    },
    "moonsama": {
        "image": "moonsama/moonsama-node:latest",
        "entrypoint": "/moonsama/moonsama-node",
        "base": ["dev", "template-rococo", "moonsama"],
    },
    "nodle": {
        "image": "nodlecode/chain:latest",
        "entrypoint": "nodle-parachain",
        "base": ["local", "test", "main"],
    },
    "parallel": {
        "image": "parallelfinance/parallel:latest",
        "entrypoint": "/parallel/.entrypoint.sh",
        "base": ["parallel-dev", None, "parallel"],
    },
    "pendulum": {
        "image": "pendulumchain/pendulum-collator:latest",
        "entrypoint": "/usr/local/bin/pendulum-collator",
        "base": ["litentry-dev", "foucoco", "pendulum"],
    },
    "phala": {
        "image": "phalanetwork/phala-node:latest",
        "entrypoint": "/usr/local/bin/khala-node",
        "base": ["phala-dev-2035", "rhala", "phala"],
    },
    "polkadex": {
        "image": "polkadex/parachain:latest",
        "entrypoint": "/usr/local/bin/parachain-polkadex-node",
        "base": ["dev", "xcm-helper-rococo", "mainnet"],
    },
    "subsocial": {
        "image": "dappforce/subsocial-parachain:latest",
        "entrypoint": "/usr/local/bin/subsocial-collator",
        "base": ["local-rococo", "/app/soonsocial.json", ""],
    },
    "zeitgeist": {
        "image": "zeitgeistpm/zeitgeist-node-parachain",
        "entrypoint": "/usr/local/bin/zeitgeist",
        "base": ["dev", "battery_station", "zeitgeist"],
    },
    "encointer": {
        "image": "encointer/parachain:1.5.1",
        "entrypoint": "/usr/local/bin/encointer-collator",
        "base": ["encointer-rococo-local", "encointer-rococo", "encointer-kusama"],
    },
    "altair": {
        "image": "centrifugeio/centrifuge-chain:test-PR1628-354d76c-23-11-28",
        "entrypoint": "/usr/local/bin/centrifuge-chain",
        "base": ["altair-local", "catalyst", "altair"],
    },
    "bajun": {
        "image": "ajuna/parachain-bajun:latest",
        "entrypoint": "/usr/local/bin/ajuna",
        "base": ["local", "/bajun/rococo/bajun-raw.json", "/bajun/bajun-raw.json"],
    },
    "calamari": {
        "image": "mantanetwork/manta:latest",
        "entrypoint": "/usr/local/bin/manta",
        "base": ["calamari-local", "calamari-testnet", "calamari"],
    },
    "karura": {
        "image": "acala/karura-node:latest",
        "entrypoint": "/usr/local/bin/acala",
        "base": ["dev", "mandala-latest", "karura"],
    },
    "khala": {
        "image": "phalanetwork/khala-node:latest",
        "entrypoint": "/usr/local/bin/khala-node",
        "base": ["khala-dev-2004", "rhala", "khala"],
    },
    "kintsugi-btc": {
        "image": "interlayhq/interbtc:latest",
        "entrypoint": "tini -- /usr/local/bin/interbtc-parachain",
        "base": ["kintsugi-dev", "kintsugi-testnet-latest", "kintsugi"],
    },
    "litmus": {
        "image": "litentry/litentry-parachain:latest",
        "entrypoint": "/usr/local/bin/litentry-collator",
        "base": ["litmus-dev", "rococo", "litmus"],
    },
    "mangata": {
        "image": "mangatasolutions/mangata-node:feature-post-3rdparty-rewards-fast",
        "entrypoint": "/mangata/node",
        "base": ["rococo-local", "mangata-rococo", "mangata-kusama"],
    },
    "moonriver": {
        "image": "moonbeamfoundation/moonbeam:sha-519bd694",
        "entrypoint": "/moonbeam/moonbeam",
        "base": ["moonriver-dev", "alphanet", "moonriver"],
    },
    "robonomics": {
        "image": "robonomics/robonomics:latest",
        "entrypoint": "/usr/local/bin/robonomics",
        "base": ["dev", "ipci-dev", "ipci"],
    },
    "subzero": {
        "image": "playzero/subzero:latest",
        "entrypoint": "/usr/local/bin/subzero",
        "base": ["dev", None, ""],
    },
    "turing": {
        "image": "oaknetwork/turing:latest",
        "entrypoint": "./oak-collator",
        "base": ["turing-dev", "turing-staging", "turing"],
    },
}
