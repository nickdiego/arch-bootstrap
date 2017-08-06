#!/bin/bash

set -e

packages_core=(
    base-devel
    git
    bash-completion
    clang
    openssh
    amixer-utils
    alsa-utils
    neovim
    python-neovim
    highlight
    rsync
    strace
    gdb
    htop
    sshuttle
    xterm
    go
    libcanberra
    fuse2
    gksu
    gtkmm
    tig
    android-udev
    archey3
    inotify-tools
    jre8-openjdk
    cups
    avahi
    wmctrl
    intel-ucode
    linux-firmware
    linux-headers
    repo
    boost
    python
    task
    unzip
    pidcat
    )

packages32=(
    lib32-fontconfig
    lib32-libpng12
    lib32-libsm
    lib32-libxinerama
    lib32-libxrender
    lib32-libjpeg6-turbo
    lib32-libxtst
    )

packages_graphics=(
    xorg-server
    xf86-video-intel
    xorg-xprop
    xorg-xkill
    xsel
    awesome
    plasma-workspace
    compton
    chromium
    termite
    ttf-dejavu
    ttf-gelasio-ib
    gnome-tweak-tool gnome-keyring
    numix-gtk-theme
    arc-gtk-theme
    adapta-gtk-theme
    deepin-icon-theme oxygen-icons
    adapta-gtk-theme
    playerctl
    gparted
    eom
    evince
    udiskie
    nemo
    nemo-fileroler
    nemo-share
    unclutter
    )

# AUR
packages_aur=(
    spotify
    dropbox
    slack-desktop
    telegram-desktop
    libtinfo
    vmware-systemd-services
    ncurses5-compat-libs
    ttf-gelasio-ib
    ttf-opensans
    ttf-raleway
    teamviewer
    google-chrome
    plantuml
    android-apktool-git
    android-apktool
    android-sdk-build-tools
    android-sdk-build-tools
    samsung-unified-driver
    tmux-bash-completion
    repo-bash-completion
    rtags
    dex2jar
    )

# Let's do it!
install_packages() {
    local label=$1; shift
    local packages=( $@ )
    echo "## Installing ${label} arch packages..."
    sudo pacman -S ${packages[@]}
}

echo '## Syncing the Arch Repositories...'
sudo pacman -Sy

install_packages 'Core' ${packages_core[@]}
# TODO make sure 'Multilib' is enable in /etc/pacman.conf'
install_packages 'Multilib' ${packages32[@]}
install_packages 'Core' ${packages_graphics[@]}

echo "## Ensuring 'apacman' is installed.."
if ! type apacman 2>/dev/null; then
    echo "## apacman not installed yet.. Let's do it now :)"
    (
        tmpdir=$(mktemp -d)
        git clone https://aur.archlinux.org/apacman.git $tmpdir
        cd $tmpdir
        makepkg -sri
    )
fi
echo "## Installing AUR packages..."
apacman -S ${packages_aur[@]} --noconfirm

