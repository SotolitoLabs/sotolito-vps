# Sotolito VPS

libvirt based container hosting

## Create/upgrade image

```bash
$ cd utils/sotolito-vps/containers/centos
$ podman build --cgroup-manager cgroupfs -t sotolito-vps-base:1.1.0-centos9 .
$ cd utils/sotolito-vps/containers/web
$ podman build --cgroup-manager cgroupfs -t sotolito-vps-web:1.1.0-centos9 .
$ cd ../..
$ utils/sotolito-vps/imgctl generate sotolito-vps-web:1.1.0-centos9 
```