build_spec = import_module("../package_io/build-spec.star")
constant = import_module("../package_io/constant.star")

def register_para_id(plan, alice_ip):
    files = {
        "/app": "configs",
        "/build": "javascript",
    }

    plan.run_sh(
        run = "cd /build && npm i && node register ws://{0}:9944 //Alice".format(alice_ip),
        image = constant.NODE_IMAGE,
        files = files,
        store = [StoreSpec(src = "/tmp/para.json", name = "parathread_id")],
    )

    id = plan.run_sh(
        run = "cat /build/para.json | tr -d '\n\r'",
        image = "badouralix/curl-jq",
        files = {
            "/build": "parathread_id",
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
