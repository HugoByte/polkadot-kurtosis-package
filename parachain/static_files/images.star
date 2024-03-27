"This Dictionary is for polkadot package, containing parachain and their respective docker images"
parachain_images = {
    "acala": {
        "image": "acala/acala-node:2.24.0",  # NO ws port
        "entrypoint": "/usr/local/bin/acala",
        "base": ["acala-local", "/mandala.json", "acala"],
    },
    "ajuna": {
        "image": "ajuna/parachain-ajuna:0.1.20-stable",
        "entrypoint": "/usr/local/bin/ajuna",
        "base": ["dev", "/bajun/rococo/bajun-raw.json", "/ajuna/ajuna-raw.json"],
    },
    "bifrost": {
        "image": "bifrostnetwork/bifrost:bifrost-v0.9.94",
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
        "image": "frequencychain/collator-node-local:v1.10.0",
        "entrypoint": "/frequency/target/release/frequency",
        "base": ["frequency-rococo-local", "frequency-rococo", "frequency"],
    },
    "integritee": {
        "image": "integritee/parachain:1.9.4",
        "entrypoint": "/usr/local/bin/integritee-collator",
        "base": ["integritee-rococo-local-dev", "integritee-rococo", "integritee-kusama"],
    },
    "interlay": {
        "image": "interlayhq/interbtc:1.25.4-9ae20ea-1704967793",
        "entrypoint": "/usr/local/bin/interbtc-parachain",
        "base": ["interlay-dev", "interlay-testnet-latest", "interlay-latest"],
    },
    "kilt": {
        "image": "kiltprotocol/kilt-node:1.12.1",
        "entrypoint": "/usr/local/bin/node-executable",
        "base": ["dev", "/node/dev-specs/kilt-parachain/peregrine-kilt.json", "spiritnet"],
    },
    "kylin": {
        "image": "kylinnetworks/kylin-collator:ro-v0.9.30",
        "entrypoint": "/usr/local/bin/kylin-collator",
        "base": ["dev", "pichiu-westend", "kylin"],
    },
    "litentry": {
        "image": "litentry/litentry-parachain:v0.9.17-9172",
        "entrypoint": "/usr/local/bin/litentry-collator",
        "base": ["litentry-dev", "rococo", "litentry"],
    },
    "manta": {
        "image": "mantanetwork/manta:v4.6.1",
        "entrypoint": "/usr/local/bin/manta",
        "base": ["manta-local", "manta-testnet", "manta"],
    },
    "moonbeam": {
        "image": "moonbeamfoundation/moonbeam:sha-32933811",
        "entrypoint": "/moonbeam/moonbeam",
        "base": ["moonbeam-local", "alphanet", "moonbeam"],
    },
    "moonsama": {
        "image": "moonsama/moonsama-node:v0.0.8",
        "entrypoint": "/moonsama/moonsama-node",
        "base": ["dev", "template-rococo", "moonsama"],
    },
    "nodle": {
        "image": "nodlecode/chain:sha-0981bcc",
        "entrypoint": "nodle-parachain",
        "base": ["local", "test", "main"],
    },
    "parallel": {
        "image": "parallelfinance/parallel:v1.9.0",
        "entrypoint": "/parallel/.entrypoint.sh",
        "base": ["parallel-dev", None, "parallel"],
    },
    "pendulum": {
        "image": "pendulumchain/pendulum-collator:v0.9.40",
        "entrypoint": "/usr/local/bin/amplitude-collator",
        "base": ["dev", "foucoco", "/app/pendulum-spec-raw.json"],
    },
    "phala": {
        "image": "phalanetwork/phala-node:v0.1.26",
        "entrypoint": "/usr/local/bin/khala-node",
        "base": ["phala-dev-2035", "rhala", "phala"],
    },
    "polkadex": {
        "image": "polkadex/parachain:v1.0.0",
        "entrypoint": "/usr/local/bin/parachain-polkadex-node",
        "base": ["dev", "xcm-helper-rococo", "mainnet"],
    },
    "subsocial": {
        "image": "dappforce/subsocial-parachain:b5937cf",
        "entrypoint": "/usr/local/bin/subsocial-collator",
        "base": ["local-rococo", "/app/soonsocial.json", ""],
    },
    "zeitgeist": {
        "image": "zeitgeistpm/zeitgeist-node-parachain:0.5.0",
        "entrypoint": "/usr/local/bin/zeitgeist",
        "base": ["dev", "battery_station", "zeitgeist"],
    },
    "encointer": {
        "image": "encointer/parachain:1.5.1",
        "entrypoint": "/usr/local/bin/encointer-collator",
        "base": ["encointer-rococo-local-dev", "encointer-rococo", "encointer-kusama"],
    },
    "altair": {
        "image": "centrifugeio/centrifuge-chain:test-PR1628-354d76c-23-11-28",
        "entrypoint": "/usr/local/bin/centrifuge-chain",
        "base": ["altair-local", "catalyst", "altair"],
    },
    "bajun": {
        "image": "ajuna/parachain-bajun:0.3.0-rc1",
        "entrypoint": "/usr/local/bin/ajuna",
        "base": ["local", "/bajun/rococo/bajun-raw.json", "/bajun/bajun-raw.json"],
    },
    "calamari": {
        "image": "mantanetwork/manta:v4.6.1",
        "entrypoint": "/usr/local/bin/manta",
        "base": ["calamari-local", "calamari-testnet", "calamari"],
    },
    "karura": {
        "image": "acala/karura-node:2.24.0",
        "entrypoint": "/usr/local/bin/acala",
        "base": ["karura-local", "/mandala.json", "karura"],
    },
    "khala": {
        "image": "phalanetwork/khala-node:v0.1.26",
        "entrypoint": "/usr/local/bin/khala-node",
        "base": ["khala-dev-2004", "rhala", "khala"],
    },
    "kintsugi-btc": {
        "image": "interlayhq/interbtc:1.25.4-9ae20ea-1704967793",
        "entrypoint": "tini -- /usr/local/bin/interbtc-parachain",
        "base": ["kintsugi-dev", "kintsugi-testnet-latest", "kintsugi"],
    },
    "litmus": {
        "image": "litentry/litentry-parachain:v0.9.17-9172",
        "entrypoint": "/usr/local/bin/litentry-collator",
        "base": ["litmus-dev", "rococo", "litmus"],
    },
    "mangata": {
        "image": "mangatasolutions/mangata-node:feature-post-3rdparty-rewards-fast",
        "entrypoint": "/mangata/node",
        "base": ["mangata-rococo-local", "mangata-rococo", "/app/mangata-kusama-mainnet.json"],
    },
    "moonriver": {
        "image": "moonbeamfoundation/moonbeam:sha-519bd694",
        "entrypoint": "/moonbeam/moonbeam",
        "base": ["moonriver-local", "alphanet", "moonriver"],
    },
    "robonomics": {
        "image": "robonomics/robonomics:sha-bd71a23",
        "entrypoint": "/usr/local/bin/robonomics",
        "base": ["alpha-dev", "ipci-dev", ""],
    },
    "subzero": {
        "image": "playzero/subzero:3.2.75",
        "entrypoint": "/usr/local/bin/subzero",
        "base": ["dev", None, "subzero"],
    },
    "turing": {
        "image": "oaknetwork/turing:1.9.0.2",
        "entrypoint": "./oak-collator",
        "base": ["turing-dev", "turing-staging", "turing"],
    },
}
