# Linux Security Modules

## Introduction to Linux Security Module

### Let's understand what is Linux security module

- Linux security module (LSM) is the framework integrated into the kernel to provide the neccessary components to implement the mandatory access control (MAC) modules, without having the need to change the kernel source code every time.
- Applicaiton whitelisting has been proven to be one of the most effective vways to mitigate cyber-intrusion attacks.
- A conenient way to implement this widely recommended practice is through the **_"Linux Security Modules"_**.

### What is LSM?

- An LSM is a code compiled directly into the kernel that uses LSM framework.
- The LSM framework is intended to allow security modules to lock down a system by inserting checks whenever the kernel is about to do somethoing interesting.
- The security modules hooks into those check points and for each operation, checks whether the operation is allowed by the security policy currently enforced or not.
- The LSM framework can deny access to important kernel objects, such files, inodes, task structures, credentials, and inter-process communication objects.

### Major and Monior LSMs

- **Major**
  - The major LSMs are all implementations of MAC with configuratable policies loaded from the use space.
  - Only single LSM can be used at a time as they all assumed they had exclusive access to the security context pointers and security identifiers embedded in protected kernel objects.
  - Examples: SELinux, SMACK, AppArmor and TOMOYO
- **Minor**
  - Minor LSMs implements a particular security functionality and are stacked on top of Major LSM and mostly need less security less context.
  - The minor LSMs typcially only contain flags to enbale/disable as opposed to having policy files that are loaded from the user space as part of the system boot up.
  - Examples: Yama, loadPin, SetSafeID and Lockdown

## Linux Security Module Framework

### Overview of LSM Framework

- The LSM framework provides a modular architecture that provides "hooks" built into the kernel and allows security modules to be installed, reinforcing access control.

![Overview of LSM Framework](images/lsm-highlevel-view.png)

### Architecture of LSM

- The LSM framework allows third-party access control mechanisms to be linked into the kernel and to modify the default DAC implementation.
- By default the framework does not provide security in itself, it provides infrastructure to support the security modules.
- The LSM framework provides
  - Additional security fields(void \*) to the kernel data structures.
  - Functionality to insert calls to the hook funcitons at critical points in the kernel code to manage the security fields and to perform access controls.
  - It also provides functions to register and unregister security modules.

### LSM Hooks

- Security hooks help to mediate various operations in the kernel
  - These hooks invoke functions defined by the chosen modules.
  - These hooks construct "authorization queries" that are passed to the module.
  - The function calls that can be overridden by security to manage security fields and mediate access to kernel objects.

### LSM Security Data Fields

- LSM framework enables security modules to associate security information to kernel objects
- LSM extends "sensitive data types" with opaque data security fields
- The LSM security fields are simply void \* pointers added in various kernel data structures
- They are completely managed by security modules

### Security Data Fields Inside Kernel Objects

- For process and program, security field added to
  - struct task_struct and struct linux_binrpm
- For file system, security field added to
  - struct super_block
- For pipe, file and socket, security field added to
  - struct inode and struct file
- For packet and network decice, security field added to
  - struct sk_buff and struct net_device
- For system V IPC, security field added to
  - struct kern_ipc_perm and struct msg_msg

### LSM Security Data Structures and Hooks

- LSM data structure "struct security_hook_list"
  -This data structure maintains list of pointer to the security_hook_list and store informaiton on LSMs added into the system.
- LSM data structure "union security_list_options"
  - Union of function pointers of the security hooks defined for the LSM, which are called at various critical pathes in the kernel code.
- LSM data structure "structure security_hook_heads"
  - This data structure containing the heads of the linked list corresponding to each hook, thus allowing them for execution in the right order, respecting the stacking property of LSM.

https://github.com/torvalds/linux/blob/master/include/linux/lsm_hooks.h

### Looking in security_list_options, hooks

- In the code snippet, we can see the hooks related to the creation and removal of directories, file open, inode/socket creation, task alloc, IPC, etc.
- `int (*path_mkdir)(const struct path *dir, struct dentry *dentry, umode_t mode);`
- `int (*path_rmdir)(const struct path *dir, struct dentry *dentry);`
- `int (*file_open)(struct file *file)`
- `int (*inode_create)(strct inode *dir, struct dentry *dentry), umode_t mode);`
- `int (*socket_create)(int family, int type, int protocol, int kern);`
- `int (*task_alloc)(struct task_struct *task, unsigned long clone_flags);`
- `int (*ipc_permission)(struct kern_ipc_perm *ipcp, short flag);`

### Clarification about the LSM hooks

- Most of the hooks privided by LSM need to return an integer value (some return void)
  - `0` equivalent to the authorization
  - `ENOMEM`, No memory available
  - `EACCESS`, Access denied by the security policy
  - `EPERM`, Privileges are required to do this action
- Hooks provided by LSM can be 2 different types: Object based hooks: these are related to kernel objects such C structures like inodes, files or sockets
  - Access authorization will be based on these object attributes
- Path based: these are related to paths
