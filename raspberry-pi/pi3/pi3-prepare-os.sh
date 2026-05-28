#! /usr/bin/env bash

# This script download official Ubuntu server for Raspberry pi
# Write it to sd card and copy cloud-init config
# Check canoncial for official pi ubuntu version https://ubuntu.com/download/raspberry-pi

if [ $# -ne 2 ]; then
    echo "Usage: <device> <partition>"
    echo "Example: /dev/mmcblk0 1"
    echo "Example: /dev/sdb 1"
    exit 1
fi

VERSION=24.04.4
IMAGE=ubuntu-24.04.4-preinstalled-server-arm64+raspi.img
DEVICE=$1
BOOT_PARTITION=$2

# Download if not exists
if [[ ! -f "$IMAGE" && ! -f "$IMAGE.xz"  ]]; then
    echo "No $IMAGE or $IMAGE.xz found. Downloading..."
    wget "https://cdimage.ubuntu.com/releases/$VERSION/release/$IMAGE.xz"
    echo "Unpacking..."
    unxz "$IMAGE.xz"
fi

# Unpack if .xz exists
if [[ ! -f "$IMAGE" && -f "$IMAGE.xz" ]]; then
    echo "$IMAGE.xz found. Unpacking..."
    unxz "$IMAGE.xz"
fi

echo "Image $IMAGE ready to write to SD card!"

# Verify device exists
if [ ! -b "$DEVICE" ]; then
    echo "Error: Device $DEVICE does not exist or is not a block device"
    exit 1
fi

# Verify image exists
if [ ! -f "$IMAGE" ]; then
    echo "Error: Image file $IMAGE does not exist"
    exit 1
fi

# Show device info
echo "Device information:"
sudo fdisk -l "$DEVICE"

# Final confirmation
echo
echo "WARNING: This will COMPLETELY ERASE $DEVICE!"
echo "All data on $DEVICE will be lost!"
read -p "Type 'yes' to continue: " confirm

if [ "$confirm" != "yes" ]; then
    echo "Operation cancelled."
    exit 1
fi

# Unmount partitions
echo "Unmounting partitions..."
sudo umount "$DEVICE"* 2>/dev/null

# Write image
echo "Writing $IMAGE to $DEVICE..."
sudo dd if="$IMAGE" of="$DEVICE" bs=4M status=progress oflag=sync

# Final sync
sync
echo "Write completed successfully!"

BOOT_MOUNT=/mnt/piboot
sudo mkdir -p $BOOT_MOUNT

# Mount 1st boot partition
sudo mount "$DEVICE$BOOT_PARTITION" $BOOT_MOUNT

# Copy cloud-init config files
sudo cp pi3-user-data $BOOT_MOUNT/user-data
sudo cp pi3-meta-data $BOOT_MOUNT/meta-data
sudo cp pi3-network-config $BOOT_MOUNT/network-config

# Check log
cat $BOOT_MOUNT/user-data

# Unmount
sudo umount "$DEVICE$BOOT_PARTITION"

echo "Done! Now you can remove SD and insert into raspberry pi pi3"