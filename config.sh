#!/usr/bin/env bash
# Arch configuration script
# by muhlinux
# License: GPLv3

echo ":: Configuring timezone and hwclock..."
ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
hwclock --systohc

echo ":: Configuring localization..."
locale_gen=("en_US.UTF-8 UTF-8" \
            "en_DK.UTF-8 UTF-8")
printf '%s\n' "${locale_gen[@]}" > /etc/locale.gen && locale-gen

LANG="en_DK.UTF-8"
locale_conf=("LANG=${LANG}" \
             "LC_ADDRESS=${LANG}" \
             "LC_IDENTIFICATION=${LANG}" \
             "LC_MEASUREMENT=${LANG}" \
             "LC_MONETARY=${LANG}" \
             "LC_NAME=${LANG}" \
             "LC_NUMERIC=${LANG}" \
             "LC_PAPER=${LANG}" \
             "LC_TELEPHONE=${LANG}" \
             "LC_TIME=${LANG}")
printf '%s\n' "${locale_conf[@]}" > /etc/locale.conf
echo "KEYMAP=dk-latin1" > /etc/vconsole.conf

echo ":: Configuring networking..."
read -r -p "Choose a hostname: " HOSTNAME 
hosts=("127.0.0.1   localhost" \
       "::1         localhost"
       "127.0.1.1	${HOSTNAME}.localdomain	${HOSTNAME}")
printf '%s\n' "${hosts[@]}" > /etc/hosts && echo "$HOSTNAME" > /etc/hostname
systemctl enable dhcpcd

printf "Configuration completed! \nYou can safely reboot now.\n"
read -r -p "Reboot? [Y/n] " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" || $prompt == "" ]]; then
    echo "Rebooting" && reboot
  else 
    echo "Done!"; exit 0
fi
exit 0
