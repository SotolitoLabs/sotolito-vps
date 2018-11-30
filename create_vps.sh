#!/bin/bash

# Create VPS using runc containers 
# Iván Chavero <ichavero@chavero.com.mx>

VPS_BASE="/home/vservers"
OCI_IMAGE_BASE="/home/vservers/OCI-Image-Bundles"
OCI_IMAGE="${OCI_IMAGE_BASE}/OCI-Image-Bundles/sotolito-vps-base"
VPS_NAME="$1"
VPS_IMAGE_DIR="$OCI_IMAGE_BASE/$VPS_NAME"

echo "Creating ${VPS_NAME} OCI Bundle"
mkdir $VPS_IMAGE
ln -s $OCI_IMAGE_DIR/rootfs $VPS_IMAGE/.
cp -rp $OCI_IMAGE_DIR/rootfs/etc $VPS_IMAGE_DIR/.
cp -rp $OCI_IMAGE_DIR/rootfs/var $VPS_IMAGE_DIR/.
cp -rp $OCI_IMAGE_DIR/rootfs/home $VPS_IMAGE_DIR/.
ln -s $OCI_IMAGE_DIR/config-template.json $VPS_IMAGE/config.json
sed -i 's/<VPS_ETC_DIR>/$VPS_IMAGE_DIR\/etc/' config.json
sed -i 's/<VPS_VAR_DIR>/$VPS_IMAGE_DIR\/var/' config.json
sed -i 's/<VPS_HOME_DIR>/$VPS_IMAGE_DIR\/home/' config.json

#echo "Creating systemd Unit"
#ln -s /usr/lib/systemd/system/sotolito-vps@.service /etc/systemd/system/sotolito-vps.target.wants/sotolito-vps@${VPS_NAME}.service

echo "Done"
