#!/bin/sh
set -eu

repository=${MARS_ROVER_REPOSITORY:-NavinKarra/mars_rover}
install_dir=${MARS_ROVER_INSTALL_DIR:-"$HOME/.local/share/mars-rover"}

if [ "$repository" = OWNER/REPOSITORY ]; then
    printf '%s\n' 'Set MARS_ROVER_REPOSITORY to the public GitHub owner/repository.' >&2
    exit 1
fi

case "$repository" in
    *[!A-Za-z0-9_./-]*|/*|*/../*|*//*|*/)
        printf '%s\n' 'Invalid GitHub repository.' >&2
        exit 1 ;;
esac

case "$(uname -s)" in
    Darwin) platform=darwin ;;
    Linux) platform=linux ;;
    *) printf '%s\n' 'This sample supports macOS and Linux only.' >&2; exit 1 ;;
esac
case "$(uname -m)" in
    arm64|aarch64) architecture=arm64 ;;
    x86_64|amd64) architecture=x86_64 ;;
    *) printf '%s\n' 'Unsupported processor architecture.' >&2; exit 1 ;;
esac

mkdir -p "$install_dir"
binary="$install_dir/mars-rover"
lock_dir="$install_dir/.update-lock"
if ! mkdir "$lock_dir" 2>/dev/null; then
    printf '%s\n' 'Another launcher is updating the application.' >&2
    exit 1
fi
temporary_dir=
cleanup() {
    if [ -n "$temporary_dir" ]; then
        rm -rf "$temporary_dir"
    fi
    rmdir "$lock_dir"
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM
temporary_dir=$(mktemp -d "$install_dir/.download.XXXXXX")

digest() {
    if command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$1" | awk '{print $1}'
    elif command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | awk '{print $1}'
    else
        return 1
    fi
}

update() {
    asset="mars-rover-$platform-$architecture"
    url="https://github.com/$repository/releases/latest/download/$asset"
    curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
        --connect-timeout 10 --max-time 120 "$url" -o "$temporary_dir/rover" || return 1
    curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
        --connect-timeout 10 --max-time 30 "$url.sha256" -o "$temporary_dir/checksum" || return 1
    expected=$(awk 'NR == 1 {print $1}' "$temporary_dir/checksum")
    case "$expected" in
        ''|*[!0-9a-f]*) printf '%s\n' 'Invalid release checksum.' >&2; return 1 ;;
    esac
    [ "${#expected}" -eq 64 ] || return 1
    actual=$(digest "$temporary_dir/rover") || return 1
    if [ "$expected" != "$actual" ]; then
        printf '%s\n' 'Downloaded application failed checksum verification.' >&2
        return 1
    fi
    if [ -x "$binary" ] && cmp -s "$temporary_dir/rover" "$binary"; then
        printf '%s\n' 'Application is up to date.' >&2
        return 0
    fi
    chmod 755 "$temporary_dir/rover" || return 1
    mv -f "$temporary_dir/rover" "$binary" || return 1
    printf '%s\n' 'Installed the latest application.' >&2
}

if ! update; then
    if [ ! -x "$binary" ]; then
        printf '%s\n' 'Installation failed. Check your connection and published release assets.' >&2
        exit 1
    fi
    printf '%s\n' 'Update failed; launching the previously installed application.' >&2
fi

cleanup
trap - EXIT HUP INT TERM
exec "$binary" "$@"