# File structure
All virtual machine setups are in the folder `./VM`, where you can see `Vagrantfile`. This is also the working directory for the vagrant commands that will be introduced below.

Inside `./provisioning`, you can find `general.yaml`, which works for all VMs, `ctrl.yaml`, which works for the controller only, and `node.yaml`, which works for the nodes.


# Steps

1. Make sure you're in `./VM` folder, by doing:

```bash
cd VM
```

2. To boot all the VMs, use the following:

```bash
chmod +x create-keys.sh # make sure the create-keys.sh script is executable
./create-keys.sh        # create the ssh keys for the VMs
vagrant up              # create the VMs and provision them
```

To validate the running process, run

```bash
vagrant status
```
If it successfully runs, you should get the output like this:

```
Current machine states:

ctrl                      running (virtualbox)
node-1                    running (virtualbox)
node-2                    running (virtualbox)

This environment represents multiple VMs. The VMs are all listed above with their current state. For more information about a specific VM, run `vagrant status NAME`.

```
**Only when you see the three nodes are all running, go to the next step.**

3. (Optional) To verify the setup, you can ssh into the control mode of the VM using 
```bash
vagrant ssh <name>
```
where `<name> = ctrl / node-1 / node-2 `. The command for quiting ssh mode is `exit`.

4. If you modify the ansible files (the `yaml` files under `./provisioning`), you don't need to reload VM, just run:
```bash
vagrant provision
```
There you will see the running output of all the defined tasks.

5. (Optional) While you're working, you can use the following commands:
```bash
vagrant reload
vagrant suspend
vagrant resume
```

6. To finalize the cluster setup, run the following command from the `./VM` folder:
```bash
ansible-playbook -u vagrant -i 192.168.56.100, provisioning/finalization.yml
```

7. To access the kubernetes dashboard, follow the instructions below:

    a. Open the browser and navigate to `https://192.168.56.90/`

    b. You will be asked to ender a bearer token. First you will need to access the control node using ssh. 

    ```bash
    vagant ssh ctrl
    ```

    c. Then you can generate the token by running the following command in the terminal:

    ```bash
    kubectl -n kubernetes-dashboard create token admin-user
    ```
    
    d. Copy the token and paste it into the browser.
    
    e. You should be able to see the dashboard.

8. When you finish working, you can permanently delete the VMs using:
```bash
vagrant destroy -f
```
Note: this means next time you need to build the VMs from scratch, which takes time.