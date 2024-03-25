import subprocess
from typing import Any

from invoke import task

def ipmi_password(c: Any) -> str:
    return c.run(
        """sops -d --extract '["ipmi-passwords"]' secrets.yml""", hide=True
    ).stdout

def ipmitool(c: Any, host: str, cmd: str) -> subprocess.CompletedProcess:
    return c.run(
        f"""ipmitool -I lanplus -H {host} -U ADMIN -P '{ipmi_password(c)}' {cmd}""",
        pty=True,
    )

@task
def ipmi_serial(c: Any, host: str = "") -> None:
    """
    Connect to the serial console of a server via IPMI
    """
    ipmitool(c, host, "sol info")
    ipmitool(c, host, "sol activate")

@task
def repl(c: Any, host: str = "") -> None:
    """
    Open a nix repl with the <host>'s configuration evaluated, or this flake if blank
    """
    if host == "":
        c.run("""nix repl --flake .#""")
    else:
        c.run(f"""nix repl ./repl.nix --argstr hostname {host}""")

@task
def deploy_host(c: Any, host: str = "") -> None:
    """
    Deploy the configuration to the specified host
    """
    pass
