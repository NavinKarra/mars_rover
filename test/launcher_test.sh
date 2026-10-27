#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
workspace=$(mktemp -d)
trap 'rm -rf "$workspace"' EXIT
trap 'exit 1' HUP INT TERM
mkdir -p "$workspace/tools" "$workspace/releases"

cat > "$workspace/tools/curl" <<'MOCK'
#!/bin/sh
set -eu
[ "${MOCK_OFFLINE:-0}" = 0 ] || exit 22
while [ "$#" -gt 0 ]; do
    case "$1" in
        https://*) url=$1; shift ;;
        -o) output=$2; shift 2 ;;
        *) shift ;;
    esac
done
case "$url" in
    *.sha256) cp "$MOCK_RELEASE_DIR/checksum" "$output" ;;
    *) cp "$MOCK_RELEASE_DIR/binary" "$output" ;;
esac
MOCK
chmod +x "$workspace/tools/curl"
export PATH="$workspace/tools:$PATH"
export MOCK_RELEASE_DIR="$workspace/releases"
export MARS_ROVER_REPOSITORY=example/mars-rover
export MARS_ROVER_INSTALL_DIR="$workspace/install with spaces"

publish() {
    printf '#!/bin/sh\nprintf "%%s\\n" "%s" "$@"\n' "$1" > "$MOCK_RELEASE_DIR/binary"
    if command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$MOCK_RELEASE_DIR/binary" > "$MOCK_RELEASE_DIR/checksum"
    else
        sha256sum "$MOCK_RELEASE_DIR/binary" > "$MOCK_RELEASE_DIR/checksum"
    fi
}

launch() {
    sh "$project_dir/scripts/run-rover.sh" "$@"
}

export MOCK_OFFLINE=1
if launch > /dev/null 2>&1; then
    printf '%s\n' 'FAIL: first installation must fail when offline.' >&2
    exit 1
fi
export MOCK_OFFLINE=0
publish version-one
[ "$(launch 'argument with spaces')" = "$(printf '%s\n' version-one 'argument with spaces')" ]
printf '%s\n' 'PASS: first install, paths and arguments with spaces'
[ "$(launch)" = version-one ]
printf '%s\n' 'PASS: unchanged release'
publish version-two
[ "$(launch)" = version-two ]
printf '%s\n' 'PASS: upgrade'
printf '%064d\n' 0 > "$MOCK_RELEASE_DIR/checksum"
[ "$(launch)" = version-two ]
printf '%s\n' 'PASS: checksum mismatch preserves installed binary'
printf '%s\n' invalid > "$MOCK_RELEASE_DIR/checksum"
[ "$(launch)" = version-two ]
printf '%s\n' 'PASS: malformed checksum preserves installed binary'
export MOCK_OFFLINE=1
[ "$(launch)" = version-two ]
printf '%s\n' 'PASS: offline launch'
[ ! -d "$MARS_ROVER_INSTALL_DIR/.update-lock" ]
mkdir "$MARS_ROVER_INSTALL_DIR/.update-lock"
if launch > /dev/null 2>&1; then
    printf '%s\n' 'FAIL: concurrent launcher must not replace the binary.' >&2
    exit 1
fi
printf '%s\n' 'PASS: concurrent update blocked'