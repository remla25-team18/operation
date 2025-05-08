# Steps

Make sure you're in `./VM` folder, then run the following command.

1. To start the VM:

```bash
vagrant up
vagrant status # Check the status
```

If it successfully runs, you should get the output like this:

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
, where `<name> = ctrl / node-1 / node-2 `. The command for quiting control mode is `exit`.

3. While you're working, you can use this to reload/suspend/resume:
```bash
vagrant reload
vagrant suspend
vagrant resume
```

4. When you finish working, you can permanently delete the VMs using:
```bash
vagrant destroy -f
```
Notion that this means next time you need to build the VM from scratch, which takes time.