import paraspell from "@paraspell/sdk"
import { ApiPromise, WsProvider } from "@polkadot/api";
import { web3FromAddress } from "@polkadot/extension-dapp";

async function sendXCM(){
let wsProvider = new WsProvider("ws://127.0.0.1:9944");
const api = await ApiPromise.create({ provider: wsProvider });
let call = paraspell.xcmPallet.transferRelayToPara(
  api,
  "Acala",
  "UNIT",
  "5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY"
);
const injector = await web3FromAddress(
  "5FHneW46xGXgs5mUiveU4sbTyGBzmstUspZC92UhjJM694ty"
);
call?.signAndSend(
  "5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY",
  { signer: injector.signer },
  ({ status, txHash }) => {
    console.log({
      text: `Transaction hash is ${txHash.toHex()}`,
      duration: 10000,
      speed: 100,
    });
    if (status.isFinalized) {
      console.log({
        text: `Transaction finalized at blockHash ${status.asFinalized}`,
        type: "success",
        duration: 10000,
        speed: 100,
      });
    }
  }
);
}

sendXCM()