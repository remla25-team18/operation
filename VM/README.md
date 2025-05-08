# File structure
All virtual machine set ups are in the folder `./VM`, where you can see `Vagrantfile` inside the folder. This is also the working dir for the vagrant commands that will be introduced below.

Inside `./provisioning`, you can find `general.yaml`, which works for all VM, `ctrl.yaml`, which works for the controler only, and `node.yaml`, which works for the nodes. These files are the ones we need to work on so far. 


# Steps

Make sure you're in `./VM` folder, then run the following command.

1. To start the VM:

```bash
vagrant up
```

To validate the running process, run 
`vagrant status`. If it successfully runs, you should get the output like this:

```bash
(ml) (base) lemon@lemondeMacBook-Air VM % vagrant status
Current machine states:

ctrl                      running (virtualbox)
node-1                    running (virtualbox)
node-2                    running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

2. To verify the setup, you can ssh into the control mode of the VM using 
```bash
vagrant ssh <name>
```
where `<name> = ctrl / node-1 / node-2 `. The command for quiting ssh mode is `exit`.

3. While you're working, you can use this to reload/suspend/resume:
```bash
vagrant reload
vagrant suspend
vagrant resume
```

4. If you modify the ansible files(the `yaml` files under `./provisioning`), you don't need to reload VM, just run:
```bash
vagrant provision
```
There you will see the running output of all the defined tasks.

5. When you finish working, you can permanently delete the VMs using:
```bash
vagrant destroy -f
```
Note that this means next time you need to build the VM from scratch, which takes time.