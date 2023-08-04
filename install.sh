#!/bin/bash

USER=$(grep 1000 /etc/passwd | cut -d ':' -f 1)
HOME=$(grep 1000 /etc/passwd | cut -d ':' -f 6)

echo "getting version info..."
#ver=$(wget --output-document - -q https://www.kernel.org/ | grep -A 1 latest_link | grep http | cut -d'"' -f2 | cut -d '.' -f 4-6 | cut -c 9-13)
ver=$(cat $HOME/linux/ver/downloaded)
echo "linux $ver"
sleep 1

echo "coppying kernel to boot directory..."
cp $HONE/build/linux/linux-$ver/arch/x86_64/boot/bzImage /boot/vmlinuz-$USER
echo "coppied"
sleep 1

echo "building dynamic kernel modules (nvidia modules)..."
dkms autoinstall -k $ver
echo "built"
sleep 1

echo "building initramfs"
mkinitcpio -k $ver -g /boot/initramfs-$USER.img
echo "built"
sleep 1

echo "$ver" > $HOME/build/linux/ver/installed

echo -e "Reboot to automaticly use the newly compiled and installed kernell.\nAnd pat yourself on the back.\nI am proud of you, owner"
