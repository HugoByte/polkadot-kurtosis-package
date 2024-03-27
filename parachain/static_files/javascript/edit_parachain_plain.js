const fs = require("fs");
const { Keyring } = require("@polkadot/keyring");
const { encodeAddress, cryptoWaitReady } = require("@polkadot/util-crypto");

async function updateParachainSpec(
  paraSpecFile,
  paraId,
  newSudoKeyPhrase,
  initialCollatorsPhrase
) {
  try {
    const rawdata = fs.readFileSync(paraSpecFile);
    const chainSpec = JSON.parse(rawdata);
    const collators = JSON.parse(initialCollatorsPhrase);

    if ("para_id" in chainSpec) {
      chainSpec.para_id = paraId;
    }

    if ("paraId" in chainSpec) {
      chainSpec.paraId = paraId;
    }

    if ("parachain_id" in chainSpec) {
      chainSpec.parachain_id = paraId;
    }

    chainSpec.genesis.runtime.parachainInfo.parachainId = paraId;

    await cryptoWaitReady();
    const keyring = new Keyring({ type: "sr25519" });

    let newSudoKey = ""; // Declaring newSudoKey as let instead of const

    if (newSudoKeyPhrase.length > 0) {
      const newSudoAccount = keyring.addFromUri(newSudoKeyPhrase);
      newSudoKey = newSudoAccount.address;
      chainSpec.genesis.runtime.sudo.key = newSudoKey;

      const SESSION_KEYS = [newSudoKey, newSudoKey, { aura: newSudoKey }];
      chainSpec.genesis.runtime.session.keys.push(SESSION_KEYS);

      const BALANCE = [
        newSudoKey,
        chainSpec.genesis.runtime.balances.balances[0][1],
      ];
      chainSpec.genesis.runtime.balances.balances.push(BALANCE);
      console.log("changed sudo key:", newSudoKey);
    }

    if (initialCollatorsPhrase.length > 0) {
      collators.forEach((collatorPhrase) => {
        var collatorAccount = keyring.addFromUri(collatorPhrase);
        var collator = collatorAccount.address;
        //adding this condition to prevent adding duplicate keys
        if (collatorPhrase != newSudoKeyPhrase) {
          console.log("updating collator:", collator);
          const sessionKey = [collator, collator, { aura: collator }];
          chainSpec.genesis.runtime.session.keys.push(sessionKey);

          const balance = [
            collator,
            chainSpec.genesis.runtime.balances.balances[0][1],
          ];
          chainSpec.genesis.runtime.balances.balances.push(balance);

          chainSpec.genesis.runtime.collatorSelection.invulnerables.push(
            collator
          );
        } else {
          chainSpec.genesis.runtime.collatorSelection.invulnerables.push(
            collator
          );
        }
      });
    }

    fs.writeFileSync(paraSpecFile, JSON.stringify(chainSpec, null, 2));

    console.log("✓ Updated sudo key and session keys in parachain spec");
  } catch (error) {
    console.error("Error updating parachain spec:", error.message);
  }
}

const paraSpecFile = process.argv[2];
const paraId = parseInt(process.argv[3], 10) || 2000;
const newSudoKey = process.argv[4];
const initialCollators = process.argv[5];
updateParachainSpec(paraSpecFile, paraId, newSudoKey, initialCollators);
