# Penetration Testing Execution Standard

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Penetration Testing Execution Standard](#penetration-testing-execution-standard)
    - [PTES Framework](#ptes-framework)
      - [0.Get permission and agree the scope](#0get-permission-and-agree-the-scope)
      - [1.Reconnaissance: learn about the target without touching it](#1reconnaissance-learn-about-the-target-without-touching-it)
      - [2.Scanning and enumeration: now you touch it](#2scanning-and-enumeration-now-you-touch-it)
      - [3.Vulnerability analysis: find the weak spots](#3vulnerability-analysis-find-the-weak-spots)
      - [4.Exploitation: prove the issue is real](#4exploitation-prove-the-issue-is-real)
      - [5.Post-exploitation](#5post-exploitation)
      - [6.Reporting: the real deliverable](#6reporting-the-real-deliverable)

<!-- /code_chunk_output -->


### PTES Framework

#### 0.Get permission and agree the scope

#### 1.Reconnaissance: learn about the target without touching it
public info
* [cert.sh](https://crt.sh/)
* [shodan.io](https://www.shodan.io/)
* github, ...

#### 2.Scanning and enumeration: now you touch it
* nmap

#### 3.Vulnerability analysis: find the weak spots
* Burp Suite

#### 4.Exploitation: prove the issue is real
* web app flaws: Burp Suite (Repeater / Intruder)
* SQL injection: sqlmap
* known CVEs: Metasploit, Exploit-DB (searchsploit)
    * to exploit knowed vulnerabilities found in the target
* weak passwords: Hydra, Hashcat, John the Ripper
* TLS / cert trust: mitmproxy, Burp Suite
* mobile apps: Frida, Objection
    * Frida injects your own code into a running app and can change how it behaves, for example making the "is this certificate correct?" check always say yes.
    * Android: emulator works (use a non-Google-Play image, which allows root)
    * iOS: needs a jailbroken real iPhone
        * the Simulator can't run App Store apps (encrypted + built for real devices)
* Windows / Active Directory: Impacket, BloodHound, NetExec

#### 5.Post-exploitation
Measure the impact: from this foothold, what else can be reached? Other servers, cloud credentials, internal networks?

#### 6.Reporting: the real deliverable