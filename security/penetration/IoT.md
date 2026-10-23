# IoT

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [IoT](#iot)
    - [Penetration](#penetration)
      - [0.Set up a lab network](#0set-up-a-lab-network)
      - [1.Find the device and its open ports](#1find-the-device-and-its-open-ports)
      - [2.Intercept its traffic](#2intercept-its-traffic)
      - [3.Get the firmware](#3get-the-firmware)
      - [4.Open the case (advanced)](#4open-the-case-advanced)
      - [5.Common findings](#5common-findings)

<!-- /code_chunk_output -->


### Penetration

#### 0.Set up a lab network
* turn a spare laptop / Raspberry Pi into a Wi-Fi hotspot, connect the device to it
* note model, firmware version, MAC address

#### 1.Find the device and its open ports
```sh
nmap -sn 192.168.50.0/24          # find its IP
nmap -sV -p- 192.168.50.23        # all ports + services
```
* 23 (telnet) / 22 (ssh): try default logins (admin/admin, root/root)
* 80 / 443: web admin page, open it through Burp
* 1883 (MQTT), 554 (RTSP): often no password

#### 2.Intercept its traffic
```sh
mitmproxy --mode transparent --showhost
```
* plain HTTP → everything visible
* HTTPS fails → device validates certs, try `--emudhra`
* HTTPS works with mitmproxy CA → device doesn't check certs at all
* Wireshark for non-HTTP traffic (MQTT, custom UDP)

#### 3.Get the firmware
* download from vendor site, or capture the update URL in mitmproxy
```sh
binwalk -e firmware.bin
cd _firmware.bin.extracted/squashfs-root
cat etc/shadow etc/passwd                    # password hashes
grep -ri "password\|secret\|apikey" etc/     # hardcoded secrets
find . -name "*.pem" -o -name "*.key"        # private keys
ls lib/ | grep -E "ssl|busybox"              # old libraries → known CVEs
```

#### 4.Open the case (advanced)
* find UART pins (3–4 pins in a row, TX/RX/GND), connect a USB-to-serial adapter
```sh
screen /dev/tty.usbserial-XXXX 115200
```
* often shows boot logs or a root shell with no password
* no UART → read the flash chip with an SPI clip + `flashrom`

#### 5.Common findings
* default / no password, telnet open
* plain HTTP, or accepts any certificate
* hardcoded keys / passwords, very old OpenSSL / BusyBox
* firmware downloaded over HTTP, not signed
* root shell on UART
