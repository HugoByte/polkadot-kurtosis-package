const fs = require("fs");

function updateParachainSpec(PARA_SPEC_FILE, PARA_ID, NEW_SUDO_KEY, INITIAL_COLLATORS) {
  try {
    const rawdata = fs.readFileSync(PARA_SPEC_FILE);
    const chainSpec = JSON.parse(rawdata);
    const collators = JSON.parse(INITIAL_COLLATORS);
    
    chainSpec.para_id = PARA_ID;
    chainSpec.genesis.runtime.parachainInfo.parachainId = PARA_ID;
    

    if (NEW_SUDO_KEY.length > 0) {
      chainSpec.genesis.runtime.sudo.key = NEW_SUDO_KEY;
      
      const SESSION_KEYS = [
        NEW_SUDO_KEY,
        NEW_SUDO_KEY,
        { aura: NEW_SUDO_KEY }
      ];
      chainSpec.genesis.runtime.session.keys.push(SESSION_KEYS);
      
      const BALANCE = [
        NEW_SUDO_KEY,
        chainSpec.genesis.runtime.balances.balances[0][1]
      ];
      chainSpec.genesis.runtime.balances.balances.push(BALANCE);
      console.log("changed sudo key:", NEW_SUDO_KEY);
    }

    if (collators.length > 0) {
      collators.forEach(collator => {
        //adding this condition to prevent adding duplicate keys
        if(collator!=NEW_SUDO_KEY){
          console.log("updating collator:", collator);
          const sessionKey = [
            collator,
            collator,
            { aura: collator }
          ];
          chainSpec.genesis.runtime.session.keys.push(sessionKey);

          const balance = [
            collator,
            chainSpec.genesis.runtime.balances.balances[0][1]
          ];
          chainSpec.genesis.runtime.balances.balances.push(balance);
          
          chainSpec.genesis.runtime.collatorSelection.invulnerables.push(collator);
        } else{
          chainSpec.genesis.runtime.collatorSelection.invulnerables.push(collator);
        }
      });
    } 

    fs.writeFileSync(PARA_SPEC_FILE, JSON.stringify(chainSpec, null, 2));

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
