PLAIN_BUILD_SPEC = "plain-build-spec"
RAW_BUILD_SPEC = "raw-build-spec"
EDIT_BUILD_SPEC = "edit-build-spec"
CURL_JQ_IMAGE = "badouralix/curl-jq"
NODE_IMAGE = "hugobyte/parachain-node-modules"
PARA_SLOT_REGISTER_SERVICE_NAME = "para-slot-registration"
BINARY_COMMAND_CHAINS = ["manta", "khala", "phala", "clover", "calamari", "subzero", "robonomics"]
WS_PORT = ["robonomics", "parallel", "subsocial", "litmus", "pendulum", "litentry", "zeitgeist", "kylin", "subzero", "polkadex", "clover"]

DIFFERENT_IMAGES_FOR_MAINNET = {
    "centrifuge": "centrifugeio/centrifuge-chain:main-latest",
    "altair": "centrifugeio/centrifuge-chain:main-latest",
    "frequency": "frequencychain/parachain-node-mainnet",
    "acala": "acala/acala-node:latest",
}
DIFFERENT_IMAGES_FOR_TESTNET = {
    "frequency": "frequencychain/parachain-node-rococo",
    "centrifuge": "centrifugeio/centrifuge-chain:main-latest",
    "karura": "acala/mandala-node:2.22.0",
    "clover": "cloverio/clover-iris:0.1.15",
    "subsocial": "dappforce/subsocial-parachain:latest",
    "altair": "centrifugeio/centrifuge-chain:main-latest",
    "acala": "acala/mandala-node:2.22.0",
    "mangata": "mangatasolutions/mangata-node:rococo-v0.33.0"
}

CHAIN_COMMAND = ["manta", "moonsama", "interlay", "kintsugi-btc", "polkadex", "centrifuge", "altair", "robonomics", "kilt", "mangata", "litentry", "kylin", "acala", "karura"]

KUSAMA_PARACHAINS = ["altair", "bajun", "bifrost", "calamari", "encointer", "karura", "khala", "kintsugi-btc", "integritee", "litmus", "mangata", "moonriver", "subzero", "turing"]
POLKADOT_PARACHAINS = ["acala", "ajuna", "bifrost", "centrifuge", "clover", "frequency", "interlay", "kilt", "kylin", "litentry", "manta", "moonbeam", "moonsama", "nodle", "parallel", "pendulum", "phala", "polkadex", "subsocial", "zeitgeist", "robonomics"]
