# RouterBoard Setup 

## Reset Instructions

For detailed instructions on resetting your MikroTik RouterBoard, see [RESET.md](./RESET.md).

## Configure RouterBoard

If the reouter has been reset, the default user is `admin` and the password is empty.

The provisioning script will set the password to the value of the attribute `routerboard_admin_password` (by default it's `changeme`), and enable RSA public key authentication for the admin user.

Following the first boot, you can connect to the router via SSH using the private key in the `~/.ssh/id_rsa` file or setting the `ROUTERBOARD_ADMIN_PASSWORD` environment variable.

### Provisioning

```bash
# build the Docker container `console` with the Ansible dependencies and roles to run the playbook
export ROUTERBOARD_ADMIN_PASSWORD=<routerboard_admin_password>

ws enable
ws ansible-playbook ansible/configure_switch.yml ansible/inventory/hosts
```
