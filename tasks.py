from invoke import task
from yaspin import yaspin
import requests as rq
from pathlib import Path
from ruamel.yaml import YAML

yaml = YAML()

CONFIG = yaml.load(Path("deploy.yaml"))


@task
def deploy(c, clean=False):
    with yaspin().yellow as s:
        if clean:
            s.text = "clean and rebuild"
            c.run(f"rm --recursive --force {CONFIG['deploy-dir']}", hide=True)
            c.run("nikola build", hide=True)
            s.ok("[done]")

        s.text = "add to IPFS"
        s.start()
        result = c.run(
            f"ipfs add --recursive --hidden --quieter {CONFIG['deploy-dir']}",
            hide=True,
        )
        new_hash = result.stdout.rstrip()
        s.ok("[done]")
        s.write(f"- published at {new_hash}")

    pinata(c, new_hash, "erambler")
    update_dnslink(c, f"/ipfs/{new_hash}")


@task
def pinata(c, new_hash, name):
    with yaspin(text="pin at pinata").yellow as s:
        result = rq.post(
            "https://api.pinata.cloud/pinning/pinByHash",
            headers={"Authorization": f'Bearer {CONFIG["pinata-key"]}'},
            json={
                "pinataMetadata": {"name": name},
                "hashToPin": new_hash,
            },
        )
        result.raise_for_status()
        s.ok("[done]")
        details = result.json()
        s.write(f'- pin status: {details["status"]}')


@task
def update_dnslink(c, ipfs_path):
    with yaspin(text="update dnslink record").yellow as s:
        cf_config = CONFIG["cloudflare"]
        token = cf_config["token"]
        zone_id = cf_config["zone_id"]
        record_id = cf_config["record_id"]

        result = rq.put(
            f"https://api.cloudflare.com/client/v4/zones/{zone_id}/dns_records/{record_id}",
            headers={"Authorization": f"Bearer {token}"},
            json={
                "type": "TXT",
                "name": "_dnslink.erambler.co.uk",
                "content": f"dnslink={ipfs_path}",
                "ttl": 1,
            },
        )
        result.raise_for_status()
        details = result.json()
        if details["success"]:
            s.ok("[done]")
        else:
            s.fail()
