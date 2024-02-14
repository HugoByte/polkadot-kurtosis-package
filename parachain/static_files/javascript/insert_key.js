const { ApiPromise, WsProvider, Keyring } = require('@polkadot/api');
const { encodeAddress } = require('@polkadot/util-crypto');
const { createType } = require('@polkadot/types');
const { u8aToHex } =require("@polkadot/util")
const { decodeAddress } = require("@polkadot/util-crypto")



async function insertKey(keyType, mnemonicOrPrivateKey, providerUrl) {
  try {
    const wsProvider = new WsProvider(providerUrl);
    const api = await ApiPromise.create({ provider: wsProvider });
    const keyring = new Keyring({ type: 'sr25519' });
    const account = keyring.addFromMnemonic(mnemonicOrPrivateKey);
    const result = await api.rpc.author.insertKey(keyType, mnemonicOrPrivateKey, u8aToHex(decodeAddress(account.address)));
    console.log(`Account ${account.address} inserted successfully!`);
    return result;
  } catch (error) {
    console.error('Error inserting account:', error);
    throw error;
  }
}

const keyType = process.argv[2];
const mnemonicOrPrivateKey = process.argv[3];
const providerUrl = process.argv[4];

(async () => {
  try {
    await insertKey(keyType, mnemonicOrPrivateKey, providerUrl);
    console.log('Script executed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('Error executing script:', error);
    process.exit(1);
  }
})();
