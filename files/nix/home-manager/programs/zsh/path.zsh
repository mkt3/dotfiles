# Paltform Arch
export OS=`uname -s`
export ARCH=`uname -m`
DISTRO="$OS"
if [ "$DISTRO" = "Linux" ];then
    DISTRO=$(grep -oP '(?<=^NAME=).+' /etc/os-release | tr -d '"')
fi

# PATH
if [ "$DISTRO" = 'NixOS' ];then
    export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:${PATH}"
    export PATH="${XDG_STATE_HOME}/nix/profiles/profile/bin:/etc/profiles/per-user/${USER}/bin:/run/wrappers/bin:${PATH}"
elif [ "$DISTRO" = 'Darwin' ];then
    MAC_DEFAULT_PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
    export SHELL_SESSIONS_DISABLE=1

    # homebrew
    export PATH="/opt/homebrew/bin:${MAC_DEFAULT_PATH}"

    # nix
    export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:${PATH}"
    export PATH="/etc/profiles/per-user/${USER}/bin:${PATH}"
    export PATH="${XDG_STATE_HOME}/nix/profiles/profile/bin:${PATH}"
    export NIX_PATH="darwin-config=$HOME/.conifg/nix/flake.nix:/nix/var/nix/profiles/per-user/root/channels"
    export NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
    export TERMINFO_DIRS="/run/current-system/sw/share/terminfo:/nix/var/nix/profiles/default/share/terminfo:${TERMINFO_DIRS}"
    export XDG_CONFIG_DIRS="/run/current-system/sw/etc/xdg:/nix/var/nix/profiles/default/etc/xdg"
    export XDG_DATA_DIRS="/run/current-system/sw/share:/nix/var/nix/profiles/default/share"
    export NIX_USER_PROFILE_DIR="/etc/profiles/per-user/${USER}"
    export NIX_PROFILES="/nix/var/nix/profiles/default /run/current-system/sw /etc/profiles/per-user/${USER}"
    # Set up secure multi-user builds: non-root users build through the
    # Nix daemon.
    if [ ! -w /nix/var/nix/db ]; then
         export NIX_REMOTE=daemon
    fi
else # for linux (except NIXOS)
    LINUX_DEFAULT_PATH="/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
    export PATH="$LINUX_DEFAULT_PATH"

    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    export PATH="${XDG_STATE_HOME}/nix/profiles/profile/bin:${PATH}"
    export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
fi
export PATH="${HOME}/.local/bin:${PATH}"
