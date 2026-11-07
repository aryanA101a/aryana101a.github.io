#import "template-fork/coral-cv/lib.typ": resume, work, edu, project, dates-helper

#let phone-number = sys.inputs.at("phone", default: "")

#show: resume.with(
  author: "Aryan Arora",
  role: "Systems Software Engineer",
  font: "Libertinus Serif",
  phone: phone-number,
  email: "aryanarora.w1@gmail.com",
  personal-site: "aryanarora.de",
  github: "github.com/aryanA101a",
  linkedin: "linkedin.com/in/aryanar0ra",
)

== Profile

Systems software engineer focused on low-level software across bootloaders, kernel, OS interfaces, performance, and systems tooling.

== Experience

#work(
  title: "Google Summer of Code Contributor",
  company: [The FreeBSD Project · #link("https://wiki.freebsd.org/SummerOfCode2026Projects/AddNetworkingSupportToKboot")[Project details]],
  location: "Remote",
  dates: dates-helper(start-date: "May 2026", end-date: "Sep 2026"),
)
- Integrated musl and developed a lightweight abstraction over the Linux networking ABI, including resolver support for kboot.
- Built an HTTP/HTTPS client over Linux sockets to fetch boot artifacts.
- Designed a maintainable networking API to support future network-boot protocols and features.

#work(
  title: "Software Development Engineer",
  company: "VisCommerce",
  location: "Remote",
  dates: dates-helper(start-date: "Jun 2024", end-date: "Sep 2026"),
)
- Architected authentication, IAM, storage, and state-restoration systems for Spaces365, a 3D room configurator.
- Designed Redux state orchestration connecting application flows with the Three.js runtime.
- Developed a pipeline for generating synthetic Gaussian splats of indoor scenes.

#work(
  title: "Android Developer Intern",
  company: "Degpeg",
  location: "Remote",
  dates: dates-helper(start-date: "Jun 2021", end-date: "Aug 2021"),
)
- Extended the Android video-streaming pipeline to handle multiple simultaneous RTMP live streams and dynamic graphics overlays during broadcasts.

== Open Source

- #link("https://github.com/openzim/libzim/pull/861")[*libzim*]: Made checksum verification about 2.6× faster in benchmarks.
- #link("https://github.com/kiwix/libkiwix/pull/1074")[*libkiwix*]: Added IPv6 support to the HTTP daemon.

#link("https://aryanarora.de/opensource-contributions/")[All contributions]

== Projects

#project(
  name: "roro-vmm",
  role: "C, Linux KVM",
  url: "github.com/aryanA101a/roro-vmm",
)
- Built a minimal KVM-based virtual machine monitor in C that boots an x86-64 Linux kernel and initramfs through the Linux 32-bit boot protocol.
- Implemented guest memory layout, E820 memory maps, vCPU initialization, and UART emulation for an interactive serial console.

#project(
  name: "lulu",
  role: "Go",
  url: "github.com/aryanA101a/lulu",
)
- Implemented an LC-3 virtual machine in Go with instruction decoding, registers,and memory-mapped I/O.
- Implemented TRAP routines for system calls and terminal I/O.

#project(
  name: "villi",
  role: "Go, Bubble Tea",
  url: "github.com/aryanA101a/villi",
)
- Built a BitTorrent client supporting .torrent files, HTTP and UDP trackers, and peer-to-peer file transfer.
- Built a terminal interface using Bubble Tea for real-time download monitoring.

== Education

#edu(
  institution: "Jaypee University of Engineering and Technology",
  degree: "B.Tech in Computer Science Engineering",
  location: "Guna, India",
  dates: "Oct 2020 – May 2024",
)

== Skills

*Languages:* C, Assembly, Go, Python, SystemVerilog
#linebreak()
*Systems & Tooling:* Linux, Networking, Bootloaders, QEMU, Git, Make, GDB, LLDB, Docker
