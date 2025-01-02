# nix-config
This repository contains my recent exploration into the Nix space. It is minimally fleshed out as I start learning and applying to a home lab environment.

## On Flakes
Nix flakes offer benefits like evaluation-time dependencies and improved reproducibility by including only tracked files in builds.

A flake's primary purpose is to be an accessible schema for entry into Nix code. However, the requirement to copy local flakes to the Nix store, ostensibly for hermetic evaluation, creates performance overhead. For local development where files are stable and changes are controlled, this approach introduces unnecessary complexity. Given the current performance issues and my specific workflow requirements, I will not adopt flakes at this time.

## SELinux vs AppArmor Decision
Note: This functionality is currently not in use due to the inconsistency of using AppArmor with NixOS. I've had some success with limited policies, but I am currently exploring other avenues for achieving a similar result.

SELinux is a security architecture for Linux systems allowing greater control over who can modify system files. Files have metadata added that defines the security contexts of what the file or binary can do. For example, if SSHd is changed to listen on an alternate port the service won't start because SELinux sees this as incorrect. The SSHd binary is labelled to run on port 22, and therefore SELinux blocks the binary from running. Modifying Nix store files post-build violates immutability, with SELinux requiring attaching metadata to files via setuid flags.

AppArmor restricts parts of the operating system that can be touched by specified programs, enforced by the Linux kernel. As these restrictions are fundamentally path-based, AppArmor is more aligned with Nix and is therefore my choice.
