const { ApiPromise, WsProvider, Keyring } = require('@polkadot/api');

async function insertKey(providerUrl, keyType, mnemonicOrPrivateKey) {
  try {
    const wsProvider = new WsProvider(providerUrl);

    const api = await ApiPromise.create({ provider: wsProvider });

    const keyring = new Keyring({ type: 'sr25519' });

    const account = keyring.addFromUri(mnemonicOrPrivateKey);

    const result = await api.rpc.author.insertKey(keyType, mnemonicOrPrivateKey, account.publicKey);

    console.log(`Account ${account.address} inserted successfully!`);

    return result;
  } catch (error) {

    console.error('Error inserting account:', error);
    throw error;
  }
}

const providerUrl = process.argv[2];
const keyType = process.argv[3];
const mnemonicOrPrivateKey = process.argv[4];

insertKey(providerUrl, keyType, mnemonicOrPrivateKey)
  .then((result) => {
    console.log('Insertion result:', result.toHex());
  })
  .catch((err) => {
    console.error('Error:', err.message);
  });
