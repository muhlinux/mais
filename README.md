# mais
**Minimal Arch Install Script**

Installs Arch on UEFI and configures systemd-boot

### Usage:

from a live environment

    curl -O https://raw.githubusercontent.com/muhlinux/mais/master/mais.sh
    bash mais.sh
or

    curl -LO https://is.gd/areyec
    bash areyec
    
after the installer finishes

    arch-chroot /mnt
    bash config.sh
