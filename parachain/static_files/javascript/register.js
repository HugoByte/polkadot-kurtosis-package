const { ApiPromise, WsProvider, Keyring } = require("@polkadot/api");
const fs = require("fs");

const run = async () => {
  try {
    const endpoint = process.argv[2];
    const seed = process.argv[3];

    const wsProvider = new WsProvider(endpoint);

    const api = await ApiPromise.create({
      provider: wsProvider,
    });
    const keyring = new Keyring({ type: "sr25519" });
    const nextParaId = await (
      await api.query.registrar.nextFreeParaId()
    ).toString();
    console.log("para_id: ", nextParaId);
    const alice = keyring.addFromUri(seed);

    await reservePara(alice, api, nextParaId);

    const jsonData = parseInt(nextParaId);
    fs.writeFile("/tmp/para.json", nextParaId, (writeErr) => {
      if (writeErr) {
        console.error("Error writing to the file:", writeErr);
      } else {
        console.log("File has been replaced.");
      }
    });
  } catch (error) {
    console.log("error:", error);
  }
};

const reservePara = async (account, api, paraID) => {
  const nonce = Number((await api.query.system.account(account.address)).nonce);
  // Reserve Parachain ID
  let signAndSend = await api.tx.registrar
    .reserve()
    .signAndSend(account, { nonce: nonce }, async ({ status }) => {
      if (status.isFinalized) {
        signAndSend();
        process.exit();
      }
    });
};

run();
