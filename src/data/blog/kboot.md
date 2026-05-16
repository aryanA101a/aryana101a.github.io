---
title: kboot What?
author: Aryan Arora
pubDatetime: 2026-05-16T03:43:20Z
slug: kboot-what
featured: false
draft: false
tags:
  - FreeBSD
  - UNIX
  - Linux
  - boot
  - bootloader
  - uefi
description:
  "A look into kboot"
timezone: "Asia/Kolkata"
---

## Table of contents

## Intro
A bootloader is a transition layer between system firmware and kernel in the boot process. Traditionally, a bootloader takes you from firmware to kernel. But, our main focus will be **kboot**, a bootloader that takes you from kernel(linux) to kernel(freebsd).

From the time we power on a system, its firmware(UEFI), wakes up, checks up and brings hardware to a suitable state for the bootloader to run. Once the bootloader gets going, it cooks up the state which the kernel requires to run after it. Therefore, every layer of abstraction has a contract with the layer above and below it.

Note: this is based on aarch64.

## kexec: Crossing From One Kernel To Another

`kexec` is a linux syscall that lets you jump from one linux kernel to another without going back to the hardware initialization phase.
</br> Here, the linux kernel has to handover an acceptable state to another linux kernel. And this state includes a memory layout information(efi map), CPU state, hardware description(DTB or ACPI), kernel args, etc

```
Kernel A
  loads Kernel B into RAM
  prepares boot params
  shuts hardware down enough
  jumps to Kernel B entry

Kernel B
  boots almost like fresh hardware boot
```

## kboot: The Bootloader And The Shim

kboot is a stunning piece of software, it's a linux elf binary which opens a portal to freebsd.

### Build

This part is one of the most interesting parts as it is not built to run with glibc. This is done to reduce crt bloat and have control over the entry flow. 
</br> kboot is custom built to run on linux userspace. It is statically linked with a custom linker script as it uses a custom C runtime initialization code and a minimal libc.

### Working

When the kboot binary executes on linux:

```
kboot
  stage 1
    setup heap and console
    discover firmware information
    init devices and find boot device
    discover usable physical memory regions

  stage 2
    prepare FreeBSD boot metadata/state
    place the kernel image into a suitable physical region
    copy trampoline code into memory
    setup trampoline data (kernel entrypoint and required metadata/state pointers)
    place this trampoline just after the kernel
    register kernel segments and trampoline with Linux kexec
    invoke kexec reboot

  trampoline
    point the relevant registers to the required metadata/state
    branch to FreeBSD kernel entrypoint

  FreeBSD kernel
```

The main thing to note here is, control is not transferred directly into the FreeBSD kernel as it has a different contract from what kexec can fulfil. Therefore, a small assembly stub known as a trampoline in the code, is used as a literal trampoline to jump to freebsd kernel. First the control is transferred to trampoline using kexec. This trampoline sets up the CPU state expected by the FreeBSD kernel, and transfers control to freebsd kernel.

### Why?

Since Linux provides a significantly more mature and battle-tested driver environment than most firmware implementations, booting through it is a pleasure in terms of security and reliability.

But wait... How would you boot linux to begin with?
</br> Using UEFI, but in a minimal way. Basically, stripping off half of its stages, most of its drivers and network stack.

## References
This blog is more of a theoretical abstraction over what the actual thing is. To get a better understanding, go through these resources:

1. https://github.com/freebsd/freebsd-src/blob/776584319fb4d66cdb1c2f91bed154dfe6a74e5e/stand/kboot/kboot/main.c
2. https://github.com/freebsd/freebsd-src/blob/776584319fb4d66cdb1c2f91bed154dfe6a74e5e/stand/kboot/kboot/arch/aarch64/exec.c
3. https://freebsdfoundation.org/our-work/journal/browser-based-edition/freebsd-14-0/linuxboot-booting-freebsd-from-linux
4. https://2023.eurobsdcon.org/slides/eurobsdcon2023-warner_losh-kboot.pdf