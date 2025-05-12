# File structure
All virtual machine setups are in the folder `./VM`, where you can see `Vagrantfile`. This is also the working directory for the vagrant commands that will be introduced below.

Inside `./provisioning`, you can find `general.yaml`, which works for all VMs, `ctrl.yaml`, which works for the controller only, and `node.yaml`, which works for the nodes. These files are the ones we need to work on so far. 


# Steps

1. Make sure you're in `./VM` folder, by doing:

```bash
cd VM
```

2. To boot all the VM, use the following line:

```bash
vagrant up
```

To validate the running process, run 
`vagrant status`. If it successfully runs, you should get the output like this:

```bash
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

4. If this your first time running the VM, do `vagrant provision` for once. If you modify the ansible files(the `yaml` files under `./provisioning`), you don't need to reload VM, just run:
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

6. When you finish working, you can permanently delete the VMs using:
```bash
vagrant destroy -f
```
Note: this means next time you need to build the VMs from scratch, which takes time.