#import "template-fork/coral-cv/lib.typ": resume, work, edu, project, dates-helper

#let phone-number = sys.inputs.at("phone", default: "")

#show: resume.with(
  author: "Aryan Arora",
  role: "Software Engineer | Backend & Systems",
  font: "Libertinus Serif",
  phone: phone-number,
  email: "aryanarora.w1@gmail.com",
  personal-site: "aryanarora.de",
  github: "github.com/aryanA101a",
  linkedin: "linkedin.com/in/aryanar0ra",
  pdf-file: "Aryan_Arora_Backend_Resume.pdf",
  variant: "backend",
)

== Profile

Software engineer focused on backend systems, networking, Linux, and performance.

== Experience

#work(
  title: "Software Development Engineer",
  company: "VisCommerce",
  location: "Remote",
  dates: dates-helper(start-date: "Jun 2024", end-date: "Sep 2026"),
)
- Architected authentication, identity and access management (IAM), and storage systems for Spaces365, a 3D room configurator.
- Designed state-restoration systems and Redux state orchestration connecting application workflows with the Three.js runtime.
- Developed a pipeline for generating synthetic Gaussian splats of indoor scenes.

#work(
  title: "Google Summer of Code Contributor",
  company: [The FreeBSD Project · #link("https://wiki.freebsd.org/SummerOfCode2026Projects/AddNetworkingSupportToKboot")[Project details]],
  location: "Remote",
  dates: dates-helper(start-date: "May 2026", end-date: "Sep 2026"),
)
- Built an HTTP/HTTPS client over Linux sockets to download boot artifacts for kboot.
- Integrated musl and implemented a lightweight abstraction over the Linux networking ABI, including resolver support.
- Designed a networking API to support additional network-boot protocols and features.

#work(
  title: "Android Developer Intern",
  company: "Degpeg",
  location: "Remote",
  dates: dates-helper(start-date: "Jun 2021", end-date: "Aug 2021"),
)
- Extended a video-streaming pipeline to support multiple simultaneous RTMP streams and dynamic graphics overlays during broadcasts.

== Projects

#project(
  name: "villi",
  role: "Go, Bubble Tea",
  url: "github.com/aryanA101a/villi",
)
- Built a BitTorrent client supporting .torrent files, HTTP and UDP trackers, and peer-to-peer file transfer.
- Implemented a terminal interface with Bubble Tea for real-time download monitoring.

#project(
  name: "roro-vmm",
  role: "C, Linux KVM",
  url: "github.com/aryanA101a/roro-vmm",
)
- Built a KVM-based virtual machine monitor that boots an x86-64 Linux kernel and initramfs.
- Implemented guest memory layout, E820 memory maps, vCPU initialization, and UART emulation for an interactive serial console.

== Open Source

- #link("https://github.com/openzim/libzim/pull/861")[*libzim*]: Made checksum verification about 2.6× faster in benchmarks.
- #link("https://github.com/kiwix/libkiwix/pull/1074")[*libkiwix*]: Added IPv6 support to the HTTP daemon.
- #link("https://github.com/MariaDB/server/pull/3841")[*MariaDB*]: Fixed mixed-case option names being rejected by `my_getopt`.

== Skills

*Languages:* Go, Python, C
#linebreak()
*Backend & Networking:* Authentication, IAM, storage, API design, HTTP/HTTPS, sockets
#linebreak()
*Systems & Tools:* Linux, PostgreSQL, Docker, Git, Make, GDB, LLDB, QEMU

== Education

#edu(
  institution: "Jaypee University of Engineering and Technology",
  degree: "B.Tech in Computer Science Engineering",
  location: "Guna, India",
  dates: "Oct 2020 – May 2024",
)
