build_spec = import_module("../package_io/build-spec.star")
constant = import_module("../package_io/constant.star")

def register_para_id(plan, alice_ip, chain_name):
    files = {
        "/app": "configs",
        "/build": "javascript",
    }

    plan.run_sh(
        run = "cd /build && npm i && node register ws://{0}:9944 //Alice".format(alice_ip),
        image = constant.NODE_IMAGE,
        files = files,
        store = [StoreSpec(src = "/tmp/para.json", name = "parathread_id_{}".format(chain_name))],
    )

    id = plan.run_sh(
        run = "cat /build/para.json | tr -d '\n\r'",
        image = "badouralix/curl-jq",
        files = {
            "/build": "parathread_id_{}".format(chain_name),
        },
    )
    return id.output

def onboard_genesis_state_and_wasm(plan, para_id, chain_name, alice_ip):
    files = {
        "/app": "configs",
        "/build": chain_name + "raw",
        "/javascript": "javascript",
    }
    plan.run_sh(
        run = "cd /javascript && npm i && node onboard ws://{0}:9944 //Alice {1} /build/{2}-genesis-state /build/{2}-genesis-wasm".format(alice_ip, para_id, chain_name),
        image = constant.NODE_IMAGE,
        files = files,
    )

# Creating a genisis spec with hard coding the parachain genisis state and genisis wasm
def add_genesis_state_and_wasm_to_relay(plan, para_id, chain_name, relay_chain_spec = None):
    if relay_chain_spec != None:
        files = {
            "/app": "configs",
            "/build": chain_name + "raw",
            "/javascript": "javascript",
            "/relay": relay_chain_spec,
        }
        plan.run_sh(
            run = "cd /javascript && npm i && node edit_relay_spec /relay/polkadot.json {0} /build/{1}-genesis-state /build/{1}-genesis-wasm".format(para_id, chain_name),
            image = constant.NODE_IMAGE,
            files = files,
            store = [StoreSpec(src = "/relay/polkadot.json", name = "polkadot_{}".format(para_id))],
        )
    else:
        files = {
            "/app": "configs",
            "/build": chain_name + "raw",
            "/javascript": "javascript",
        }
        plan.run_sh(
            run = "cd /javascript && npm i && node edit_relay_spec /app/polkadot.json {0} /build/{1}-genesis-state /build/{1}-genesis-wasm".format(para_id, chain_name),
            image = constant.NODE_IMAGE,
            files = files,
            store = [StoreSpec(src = "/app/polkadot.json", name = "polkadot_{}".format(para_id))],
        )

# Creating the raw chain spec for polkadot relay chain
def build_relay_chain_raw(plan, chain_spec):
    files = {
        "/app": chain_spec,
    }
    plan.run_sh(
        run = "polkadot build-spec --chain=/app/polkadot.json --raw --disable-default-bootnode > /tmp/polkadot-raw.json",
        image = "parity/polkadot:v1.1.0",
        files = files,
        store = [StoreSpec(src = "/tmp/polkadot-raw.json", name = "polkadot_raw")],
    )
