#!/usr/bin/env bash
# Blank Arch installation on UEFI with systemd-boot
# by muhlinux
# License: GPLv3

echo ":: Updating the system clock..."
timedatectl set-ntp true

echo ":: Partitioning the disk..."
disk=$(fdisk -l | head -1 | cut -d ' ' -f2- | cut -d ':' -f1)
efiPartition="${disk}1"
rootPartition="${disk}2"

# refer to https://wiki.archlinux.org/index.php/Parted#UEFI/GPT_examples
parted "$disk" \
    mklabel gpt \
    mkpart EFI fat32 1MiB 261MiB set 1 esp on \
    mkpart Linux ext4 261MiB 100%

echo ":: Formatting the partitions..."
mkfs.vfat -F32 "${efiPartition}"
mkfs.ext4 "${rootPartition}"

echo ":: Mounting the file systems..."
mount "${rootPartition}" /mnt && mkdir /mnt/boot
mount "${efiPartition}" /mnt/boot

echo ":: Updating mirrors..."
# to rankmirrors, 'pacman-contrib' is needed.
pacman -Sy pacman-contrib --noconfirm
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

# fetching and ranking a live mirror list, then syncing pacman database
# refer to https://wiki.archlinux.org/index.php/Mirrors#Fetching_and_ranking_a_live_mirror_list
curl -s "https://www.archlinux.org/mirrorlist/?country=SE&country=DK&protocol=https&use_mirror_status=on" \
    | sed -e 's/^#Server/Server/' \
    | rankmirrors -v - > /etc/pacman.d/mirrorlist
pacman -Syy 

echo ":: Installing base packages.."
pacstrap /mnt base base-devel linux linux-firmware intel-ucode dhcpcd

echo ":: Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

echo ":: Installing systemd-boot..."
bootctl install --path=/mnt/boot

echo ":: Configuring systemd-boot..."
# refer to https://wiki.archlinux.org/index.php/Systemd-boot#Loader_configuration
loader_conf=("timeout 0" \
             "default arch-*" \
             "console-mode max" \
             "editor no")
printf '%s\n' "${loader_conf[@]}" > /mnt/boot/loader/loader.conf

UUID=$(blkid -s UUID -o value "${rootPartition}")
arch_conf=("title   Arch Linux" \
           "linux   /vmlinuz-linux" \
           "initrd  /intel-ucode.img" \
           "initrd  /initramfs-linux.img" \
           "options root=UUID=${UUID} rw")
printf '%s\n' "${arch_conf[@]}" > /mnt/boot/loader/entries/arch.conf

echo "Installation completed!"
echo 'run "arch-chroot"' 
echo 'then "curl -O https://raw.githubusercontent.com/muhlinux/mais/master/config.sh"'
echo 'and finally "bash config.sh"'
exit 0
