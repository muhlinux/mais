# mais
**Minimal Arch Install Script**

Installs Arch on UEFI and configures systemd-boot

### Usage:

from a live environment

    curl -O https://raw.githubusercontent.com/muhlinux/mais/master/installer.sh
    bash installer.sh
    
after the installer finishes

    arch-chroot
    curl -O https://raw.githubusercontent.com/muhlinux/mais/master/config.sh
    bash config.sh
