from invoke import task
from yaspin import yaspin
import requests as rq
from pathlib import Path
from ruamel.yaml import YAML
yaml = YAML()

CONFIG = yaml.load(Path('deploy.yaml'))


def pin_by_hash(hsh, name):
    s = rq.Session()
    s.headers = {"Authorization": f'Bearer {CONFIG["pinata-key"]}'}
    params = {
        "pinataMetadata": {"name": name},
        "hashToPin": hsh,
    }
    r = s.post("https://api.pinata.cloud/pinning/pinByHash", json=params)
    r.raise_for_status()
    return r.json()


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

        s.text = "pin at Pinata"
        s.start()
        try:
            pin_result = pin_by_hash(new_hash, "erambler")
            s.ok("[done]")
            s.write(f'- pin status: {pin_result["status"]}')
        except rq.HTTPError:
            s.fail("[fail]")

        s.text = "publish to IPNS"
        s.start()
        c.run(
            f"ipfs name publish --key={CONFIG['ipns-key']} /ipfs/{new_hash}",
            hide=True,
        )
        s.ok("[done]")
