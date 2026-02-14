# WireGuard Workshop
This repo contains a simple activity to demonstrate the basics of creating a WireGuard client that communicates with a server in a [hub-and-spoke configuration](https://www.procustodibus.com/blog/2020/11/wireguard-hub-and-spoke-config/).

## Overview
This repo facilitates the swift creation and configuration of the **hub** (or server). The hub is configured to listen for traffic on port `51820` from `30` peers on the `10.8.0.0/24` subnet, which have IP addresses ranging from `10.8.0.1` to `10.8.0.30`, inclusive. The hub will serve static HTML files located in the `./html` directory over port `80` on the host to clients connected to the VPN.

Public/private key pairs which can be used to connect to the hub as a peer are automatically generated in the `./presenter-materials` directory on the host. The `ith` key in each file corresponds to the virtual address `10.8.0.i` (where `i` is 1-indexed). There are `30` key pairs total. You may choose to upload these keys to a spreadsheet and distribute them to workshop attendees as needed. Note that every time `make` is executed, a new set of keys and configs are generated, invalidating any previously generated keys.

The server has the virtual address `10.8.0.0`.

An example client configuration is also automatically generated in the `./presenter-materials` directory, which you may reference as a debugging aid in case an attendee is struggling to configure their machine. Note that you will have to update the endpoint with your host machine's private IP address.

The objective for attendees is to set up their laptop or other device as a client to the hub in order to access a "flag", which is hidden in an HTML page served on the hub over the VPN. You may customize the flag by placing custom static HTML pages in the `./html` directory.
 
## Prerequisites
- Install [Docker Desktop](https://www.docker.com/) (You may choose to simply install [Docker Engine](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/) instead)
- Install [WireGuard](https://www.wireguard.com/install/)
- Install [Make](https://www.gnu.org/software/make/)

## Usage
Clone the repository:
```bash
git clone git@github.com:samneisewander/wireguard-workshop.git && cd wireguard-workshop
```

Run the Makefile:
```bash
make
```

For clients to successfully connect, the host machine must allow incoming traffic on port `51820/udp`. If this default port is not available, edit the `compose.yaml`:
```yaml
# compose.yaml (old)
ports:
- 51820:51820/udp
```

```yaml
# compose.yaml (new)
ports:
- xxxxx:51820/udp
```

To destroy the containers and delete the generated files, run:
```bash
make clean
```


