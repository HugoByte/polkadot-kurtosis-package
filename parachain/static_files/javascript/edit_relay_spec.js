fs = require("fs");

function addGenesisParachain() {
  const spec = process.argv[2];

  console.log(spec);
  const para_id = process.argv[3];
  const head = process.argv[4];
  const wasm = process.argv[5];

  let rawdata = fs.readFileSync(spec);
  let chainSpec = JSON.parse(rawdata);

  header = fs.readFileSync(head, "utf8");
  wasm_file = fs.readFileSync(wasm, "utf8");

  // Check runtime_genesis_config key for rococo compatibility.
  const runtimeConfig =
    chainSpec.genesis.runtime.runtime_genesis_config ||
    chainSpec.genesis.runtime;
  let paras = undefined;
  if (runtimeConfig.paras) {
    paras = runtimeConfig.paras.paras;
  }
  // For retro-compatibility with substrate pre Polkadot 0.9.5
  else if (runtimeConfig.parachainsParas) {
    paras = runtimeConfig.parachainsParas.paras;
  }
  if (paras) {
    let new_para = [
      parseInt(para_id),
      {
        genesis_head: header,
        validation_code: wasm_file,
        parachain: true,
      },
    ];

    paras.push(new_para);
    runtimeConfig.registrar.nextFreeParaId = parseInt(para_id) + 1;

    let data = JSON.stringify(chainSpec, null, 2);

    fs.writeFileSync(spec, data);
    console.log(`  ✓ Added Genesis Parachain ${para_id}`);
  } else {
    console.error("  ⚠ paras not found in runtimeConfig");
    process.exit(1);
  }
}

addGenesisParachain();
