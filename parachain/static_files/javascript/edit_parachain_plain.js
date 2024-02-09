const fs = require("fs");

function updateParachainSpec(PARA_SPEC_FILE, PARA_ID, NEW_SUDO_KEY) {
  try {
    // Read the existing parachain spec
    const rawdata = fs.readFileSync(PARA_SPEC_FILE);
    const chainSpec = JSON.parse(rawdata);

    // Update the para_id
    chainSpec.para_id = PARA_ID;
    chainSpec.genesis.runtime.parachainInfo.parachainId = PARA_ID;
    console.log("sudo key:", NEW_SUDO_KEY)

    // Update the sudo key if provided
    if (NEW_SUDO_KEY) {
      // chainSpec.genesis.runtime.sudo.key = NEW_SUDO_KEY;

      // Add session keys
      const SESSION_KEYS = [
        NEW_SUDO_KEY,
        NEW_SUDO_KEY,
        { aura: NEW_SUDO_KEY }
      ];
      chainSpec.genesis.runtime.session.keys.push(SESSION_KEYS);

      // Add balance
      const BALANCE = [
        NEW_SUDO_KEY,
        chainSpec.genesis.runtime.balances.balances[0][1]
      ];
      chainSpec.genesis.runtime.balances.balances.push(BALANCE);

      // Add initial collators
      chainSpec.genesis.runtime.collatorSelection.invulnerables.push(NEW_SUDO_KEY);
    }

    // Write the modified spec back to the file
    fs.writeFileSync(PARA_SPEC_FILE, JSON.stringify(chainSpec, null, 2));

    console.log("✓ Updated sudo key and session keys in parachain spec");
  } catch (error) {
    console.error("Error updating parachain spec:", error.message);
  }
}


const paraSpecFile = process.argv[2];
const paraId = parseInt(process.argv[3], 10) || 2000;
const newSudoKey = process.argv[4]

updateParachainSpec(paraSpecFile, paraId, newSudoKey);