# Sotolito VPS
Manage VPS using OCI containers, podman and systemd.

## Installation

Create the VPS directory

```console
mkdir -p /home/vservers/OCI-Image-Bundles/utils/bin
```

### Install `netns` a utility to create bridges for OCI containers

```console
# Export the sha256sum for verification.
$ export NETNS_SHA256="be81bc3fa68c7c9892a0b84e6429e2af5be58e74474f0dcddad78647dd741ce7"

# Download and check the sha256sum.
$ sudo curl -fSL "https://github.com/genuinetools/netns/releases/download/v0.5.3/netns-linux-386" \
  -o "/home/vservers/OCI-Image-Bundles/utils/bin/netns" \
  && echo "${NETNS_SHA256}  /home/vservers/OCI-Image-Bundles/utils/bin/netns" | sha256sum -c - \
  && mkdir -p /home/vservers/OCI-Image-Bundles/utils/bin \
  && chmod a+x "/home/vservers/OCI-Image-Bundles/utils/bin/netns"
```

If you're using CentOS you have to enable the `centos-extras` repo to install `oci-register-machine` hook.

### Clone this repo to get the `vpsctl` and `imagectl` commands.

```console
$ cd /home/vservers/OCI-Image-Bundles/utils
$ git clone https://github.com/SotolitoLabs/sotolito-vps.git
```
Setup systemd
```
# cp /home/vservers/OCI-Image-Bundles/utils/sotolito-vps/systemd/sotolito-vps@.service /usr/lib/systemd/system/
# mkdir /etc/systemd/system/sotolito-vps.target.wants
# systemctl daemon-reload
```

Add the repo to the path or copy the `vpsctl` and `imagectl` commands to `/usr/local/bin`.

```console
# export PATH=$PATH:/home/vservers/OCI-Image-Bundles/utils/sotolito-vps
```

## Quick Start

Follow the install instructions.

### Create image template

```console
# imgctl generate centos:stream9
# ln -s  centos\:stream9 sotolito-vps-base
```

## Create VPS
```console
# vpsctl create sotolito 10.0.0.1
```

## Enable and start VPS

```console
# systemctl enable sotolito-vps@sotolito
# systemct start sotolito-vps@sotolito
```

## Usage

This commands should be executed as the root user.

### Create a VPS

The create option just needs the name of the VPS, it will assign an IP automatically.

```console
# vpsctl <name>
# vpsctl my_super_awesome_vps
```

Alternatively you can assign the IP manually.

```console
# vpsctl <name> <static IP>
# vpsctl my_super_awesome_vps 192.168.1.100
```

### Start a VPS

```console
# systemctl start sotolito-vps@my_super_awesome_vps.service
```

### Stop a VPS

```console
# systemctl stop sotolito-vps@my_super_awesome_vps.service
```

### List VPSs

```console
# vpsctl list
```

### Enter a VPS

```console
# vpsctl enter my_super_awesome_vps
```

## Networking

After creating a VPS you have to open the ports of the service being offered or configure
nginx or haproxy to expose web services.

### Open SSH port
The VPS IP address is located in the `<vps_name>/.ip` file, this IP is non-routable so we have to redirect
ports on the host to the VPS to expose services.

To open the SSH port using firewalld

```console
# VPS_STATIC_IP=$(cat sotolito/.ip)
# firewall-cmd --permanent --zone="public" --add-forward-port=port=6000:proto=tcp:toport=22:toaddr=$VPS_STATIC_IP
# firewall-cmd --reload
```


## Create Image Templates

Images are extracted from OCI container images stored in any public or private registry.

```console
# imgctl generate centos:stream9
# ln -s  centos\:stream9 sotolito-vps-base
```


# TODO

* Open ports from the `vpsctl` command
* Kata containers
* Feed the image as parameter of the create command

# References

* https://github.com/genuinetools/netns/releases
