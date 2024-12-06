# nix-config
This repository contains my recent exploration into the nix space. Minimally fleshed out currently as I start learning and applying to a home lab environment.


## SELinux vs AppArmor Decision
SELinux is a security architecture for Linux systems allowing greater control over who can modify system files. Files have metadata added that define the security contexts of what the file or binary can do. For example, if SSHd is changed to listen on an alternate port the service won't start because SELinux sees this as incorrect. The SSHd binary is labeled to run on port 22, and therefore SELinux blcks the binary from running. Modifying Nix store files post-build violates immutability, with SELinux requiring attaching metadata to files via setuid flags.

AppArmor restricts parts of the operating system that can be touched by specified programs, enforced by the Linux kernel. As these restrictions are path based, fundamentally, AppArmor is more aligned with Nix and is therefore my choice.
