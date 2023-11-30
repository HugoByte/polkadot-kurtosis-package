PLAIN_BUILD_SPEC = "plain-build-spec"
RAW_BUILD_SPEC = "raw-build-spec"
EDIT_BUILD_SPEC = "edit-build-spec"
CURL_JQ_IMAGE = "badouralix/curl-jq"
NODE_IMAGE = "hugobyte/parachain-node-modules"
PARA_SLOT_REGISTER_SERVICE_NAME = "para-slot-registration"
BINARY_COMMAND_CHAINS = ["manta", "khala", "phala", "clover", "calamari", "subzero", "robonomics"]
NO_WS_PORT = ["acala", "frequency", "moonbeam", "karura", "ajuna", "bajun", "centrifuge", "moonsama", "encointer", "moonriver", "altair"]

DIFFERENT_IMAGES_FOR_MAINNET = {
    "centrifuge": "centrifugeio/centrifuge-chain:main-latest",
    "altair": "centrifugeio/centrifuge-chain:main-latest",
    "frequency": "frequencychain/parachain-node-mainnet",
    "acala": "acala/acala-node:latest",
}
DIFFERENT_IMAGES_FOR_TESTNET = {
    "frequency": "frequencychain/parachain-node-rococo",
    "centrifuge": "centrifugeio/centrifuge-chain:main-latest",
    "karura": "acala/mandala-node:latest",
    "clover": "cloverio/clover-iris:0.1.15",
    "subsocial": "dappforce/subsocial-parachain:latest",
    "altair": "centrifugeio/centrifuge-chain:main-latest",
}

CHAIN_COMMAND = ["manta", "moonsama", "interlay", "kintsugi-btc", "polkadex", "centrifuge", "altair", "robonomics", "kilt"]
