#!/bin/bash
#
# make-release-bundle.sh -- assemble a relocatable "Wine <Flavour>.app" bundle
# from an installed MacPorts wine port, and produce the .tar.xz release asset
# consumed by the Homebrew casks in Gcenx/homebrew-wine.
#
# The MacPorts port installs a normal /opt/local prefix. The release asset is a
# self-contained .app whose every Mach-O has its /opt/local references rewritten
# to @loader_path-relative ones, so the bundle runs on a machine with no
# MacPorts installed.
#
# Usage:
#   sudo port -N install wine-devel +gstreamer
#   ./make-release-bundle.sh --flavour devel --version 11.22
#
# Options:
#   --flavour NAME    wine-devel | wine-stable | wine-staging   (default: wine-devel)
#   --version VER     version string, e.g. 11.22               (default: from port)
#   --prefix PATH     MacPorts prefix                          (default: /opt/local)
#   --outdir PATH     where to write the .tar.xz               (default: $PWD)
#   --keep            keep the intermediate bundle tree
#
# Requires: Xcode command line tools (otool, install_name_tool, strip),
#           llvm-mingw (for llvm-strip on PE modules), xz.
#
set -euo pipefail

FLAVOUR=wine-devel
VERSION=""
PREFIX=/opt/local
OUTDIR="$PWD"
KEEP=0

while [ $# -gt 0 ]; do
    case "$1" in
        --flavour)  FLAVOUR="$2"; shift 2 ;;
        --version)  VERSION="$2"; shift 2 ;;
        --prefix)   PREFIX="$2"; shift 2 ;;
        --outdir)   OUTDIR="$2"; shift 2 ;;
        --keep)     KEEP=1; shift ;;
        -h|--help)  sed -n '2,30p' "$0"; exit 0 ;;
        *) echo "unknown option: $1" >&2; exit 2 ;;
    esac
done

# Map the port name to the bundle display name and the cask asset name.
case "$FLAVOUR" in
    wine-devel)   DISPLAY="Wine Devel";   ASSET="wine-devel" ;;
    wine-stable)  DISPLAY="Wine Stable";  ASSET="wine-stable" ;;
    wine-staging) DISPLAY="Wine Staging"; ASSET="wine-staging" ;;
    *) echo "unsupported flavour: $FLAVOUR" >&2; exit 2 ;;
esac

if [ -z "$VERSION" ]; then
    VERSION=$(port -q info --version "$FLAVOUR" 2>/dev/null || true)
    [ -n "$VERSION" ] || { echo "cannot determine version; pass --version" >&2; exit 1; }
fi

APP_NAME="$DISPLAY.app"
WORK=$(mktemp -d "${TMPDIR:-/tmp}/wine-bundle.XXXXXX")
APP="$WORK/$APP_NAME"
RES="$APP/Contents/Resources"
RWINE="$RES/wine"

cleanup() { [ "$KEEP" = 1 ] || rm -rf "$WORK"; }
trap cleanup EXIT

say() { printf '### %s\n' "$*"; }

# ---------------------------------------------------------------------------
# 1. bundle skeleton
# ---------------------------------------------------------------------------
say "creating bundle skeleton"
mkdir -p "$APP/Contents/MacOS" "$RES" "$RWINE/bin" "$RWINE/lib" "$RWINE/share"

cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>LSMinimumSystemVersion</key>
	<string>10.15</string>
	<key>CFBundleExecutable</key>
	<string>wine</string>
	<key>CFBundleIconFile</key>
	<string>winehq.icns</string>
	<key>CFBundleIdentifier</key>
	<string>org.winehq.${FLAVOUR}.wine</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>${DISPLAY}</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>${VERSION}</string>
	<key>CFBundleSignature</key>
	<string>WINE</string>
	<key>CFBundleVersion</key>
	<string>${VERSION}</string>
	<key>NSPrincipalClass</key>
	<string>NSApplication</string>
	<key>CFBundleDocumentTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeExtensions</key>
			<array><string>exe</string></array>
			<key>CFBundleTypeName</key>
			<string>Windows executable</string>
			<key>CFBundleTypeRole</key>
			<string>Viewer</string>
			<key>LSTypeIsPackage</key>
			<false/>
		</dict>
	</array>
</dict>
</plist>
PLIST
printf 'APPLWINE' > "$APP/Contents/PkgInfo"

# The bundle needs a Contents/MacOS/<CFBundleExecutable> launcher and an icon.
# Reuse them from an already-installed Wine .app when one is available (they are
# small and version-independent); otherwise generate a minimal launcher so the
# .app is still valid for Finder.
LAUNCH_SRC=""
ICON_SRC=""
for cand in "/Applications/Wine Devel.app" "/Applications/Wine Stable.app" \
            "/Applications/Wine Staging.app"; do
    if [ -x "$cand/Contents/MacOS/wine" ]; then
        LAUNCH_SRC="$cand/Contents/MacOS/wine"
        [ -f "$cand/Contents/Resources/winehq.icns" ] && ICON_SRC="$cand/Contents/Resources/winehq.icns"
        break
    fi
done

if [ -n "$LAUNCH_SRC" ]; then
    say "reusing launcher/icon from $LAUNCH_SRC"
    cp -p "$LAUNCH_SRC" "$APP/Contents/MacOS/wine"
    [ -n "$ICON_SRC" ] && cp -p "$ICON_SRC" "$RES/winehq.icns"
else
    say "generating minimal launcher"
    cat > "$APP/Contents/MacOS/wine" <<'LAUNCH'
#!/bin/sh
# Minimal launcher: open a Terminal with this bundle's wine in PATH.
HERE=$(cd "$(dirname "$0")/../Resources/wine/bin" && pwd)
if [ $# -eq 0 ]; then
    osascript -e "tell application \"Terminal\" to do script \"export PATH='$HERE':\$PATH; clear; echo \"Wine \$(wine --version) ready\"; cd ~\""
else
    exec "$HERE/wine" "$@"
fi
LAUNCH
    chmod +x "$APP/Contents/MacOS/wine"
fi

# ---------------------------------------------------------------------------
# 2. wine binaries and runtime tree
# ---------------------------------------------------------------------------
say "copying wine binaries"
for b in msidb msiexec notepad regedit regsvr32 wine wineboot winecfg \
         wineconsole winedbg winefile winemine winepath wineserver; do
    [ -e "$PREFIX/bin/$b" ] && cp -p "$PREFIX/bin/$b" "$RWINE/bin/$b"
done

say "copying wine runtime tree"
cp -R "$PREFIX/lib/wine" "$RWINE/lib/wine"
cp -R "$PREFIX/share/wine" "$RWINE/share/wine"

# ---------------------------------------------------------------------------
# 3. third-party dylibs: transitive closure of everything wine dlopens
# ---------------------------------------------------------------------------
say "resolving third-party dylib closure"
# Wine dlopens these by name at runtime, so they do not appear in otool -L of
# the wine modules. Keep this list in sync with the configure options in the
# Portfile (gnutls, freetype, sdl, vulkan, pcap, inotify, cups, odbc).
DLOPEN_ROOTS="libinotify.0.dylib libpcap.A.dylib libcups.2.dylib \
              libfreetype.6.dylib libgnutls.30.dylib libSDL2-2.0.0.dylib \
              libvulkan.1.dylib libodbc.dylib"

declare -a seen=()
resolve() {
    local n="$1" c
    for c in "$PREFIX/lib/$n" "$n"; do
        [ -e "$c" ] && { echo "$c"; return 0; }
    done
    return 1
}
scan() {
    local bin="$1" dep base real s dup
    while IFS= read -r dep; do
        [ -z "$dep" ] && continue
        case "$dep" in /usr/lib/*|/System/*|@*) continue ;; esac
        case "$dep" in "$PREFIX"/*) : ;; *) continue ;; esac
        base=$(basename "$dep")
        real=$(resolve "$base") || continue
        real="$(cd "$(dirname "$real")" && pwd)/$(basename "$real")"
        dup=0
        for s in "${seen[@]:-}"; do [ "$s" = "$real" ] && dup=1 && break; done
        [ "$dup" = 1 ] && continue
        seen+=("$real")
        scan "$real"
    done < <(otool -L "$bin" 2>/dev/null | tail -n +2 | awk '{print $1}')
}
for root in $DLOPEN_ROOTS; do
    if real=$(resolve "$root"); then
        real="$(cd "$(dirname "$real")" && pwd)/$(basename "$real")"
        seen+=("$real"); scan "$real"
    fi
done
for lib in "${seen[@]:-}"; do
    [ -e "$lib" ] && cp -p "$lib" "$RWINE/lib/"
done
# unversioned aliases so dlopen("libfoo.dylib") also resolves
for base in libgnutls libfreetype libSDL2 libvulkan libpng16 libz libzstd libbz2 \
            libbrotlidec libbrotlienc libbrotlicommon libidn2 libtasn1 libnettle \
            libhogweed libgmp libintl libiconv libffi libunistring libp11-kit \
            libpcap libinotify; do
    [ -e "$PREFIX/lib/${base}.dylib" ] && cp -p "$PREFIX/lib/${base}.dylib" "$RWINE/lib/"
done

# ---------------------------------------------------------------------------
# 4. MoltenVK + Vulkan ICD
# ---------------------------------------------------------------------------
if [ -e "$PREFIX/lib/libMoltenVK.dylib" ]; then
    say "bundling MoltenVK"
    cp -p "$PREFIX/lib/libMoltenVK.dylib" "$RWINE/lib/"
    mkdir -p "$RWINE/share/vulkan/icd.d"
    sed 's#/opt/local/lib/libMoltenVK.dylib#../../lib/libMoltenVK.dylib#' \
        "$PREFIX/share/vulkan/icd.d/MoltenVK_icd.json" \
        > "$RWINE/share/vulkan/icd.d/MoltenVK_icd.json"
fi

# ---------------------------------------------------------------------------
# 5. GStreamer.framework (runtime only)
# ---------------------------------------------------------------------------
if [ -d "$PREFIX/Library/Frameworks/GStreamer.framework" ]; then
    say "bundling GStreamer.framework (runtime only)"
    cp -R "$PREFIX/Library/Frameworks/GStreamer.framework" "$RWINE/lib/GStreamer.framework"
    GF="$RWINE/lib/GStreamer.framework/Versions/1.0"
    find "$GF" -name '*.a' -delete 2>/dev/null || true
    find "$GF" -name '*.la' -delete 2>/dev/null || true
    rm -rf "$GF/include" "$GF/Headers" 2>/dev/null || true
    find "$GF/lib" -maxdepth 1 -type d \
        \( -name cmake -o -name 'glib-2.0' -o -name 'graphene-1.0' -o -name pkgconfig \) \
        -exec rm -rf {} + 2>/dev/null || true
fi

# ---------------------------------------------------------------------------
# 6. relocate: rewrite every /opt/local reference to @loader_path
# ---------------------------------------------------------------------------
say "relocating Mach-O references"
python3 - "$RWINE" "$PREFIX" <<'PY'
import os, struct, subprocess, sys

ROOT, PREFIX = sys.argv[1], sys.argv[2]

def is_macho(p):
    try:
        raw = open(p, "rb").read(4)
        be = struct.unpack(">I", raw)[0]
        le = struct.unpack("<I", raw)[0]
        return be in (0xfeedfacf, 0xfeedface, 0xcafebabe, 0xbebafeca) or \
               le in (0xfeedfacf, 0xfeedface, 0xcafebabe, 0xbebafeca)
    except Exception:
        return False

def rel_target(f, old):
    base = os.path.basename(old)
    if "/GStreamer.framework/" in old:
        tgt = os.path.join(ROOT, "lib", "GStreamer.framework",
                           old.split("GStreamer.framework/", 1)[1])
    else:
        tgt = os.path.join(ROOT, "lib", base)
    return "@loader_path/" + os.path.relpath(tgt, os.path.dirname(f))

deleted = written = changed = 0
for dp, _, fs in os.walk(ROOT):
    for fn in fs:
        p = os.path.join(dp, fn)
        if not is_macho(p):
            continue
        try:
            out = subprocess.check_output(["otool", "-l", p],
                                          stderr=subprocess.DEVNULL).decode("utf-8", "replace")
        except Exception:
            continue
        rpaths, dylibs, ids = [], [], []
        cur = None
        for line in out.splitlines():
            s = line.strip()
            if s.startswith("cmd "):
                cur = s[4:].strip()
            elif s.startswith("path ") and " (offset" in s:
                rpaths.append(s[5:s.rindex(" (offset")].strip())
            elif s.startswith("name ") and " (offset" in s:
                nm = s[5:s.rindex(" (offset")].strip()
                if nm.startswith(PREFIX):
                    if cur == "LC_ID_DYLIB":
                        ids.append(nm)
                    else:
                        dylibs.append(nm)
        for rp in rpaths:
            if rp == PREFIX + "/lib":
                try:
                    subprocess.run(["install_name_tool", "-delete_rpath", rp, p],
                                   check=True, stderr=subprocess.DEVNULL)
                    deleted += 1
                except subprocess.CalledProcessError:
                    pass
                new = "@loader_path/" + os.path.relpath(os.path.join(ROOT, "lib"),
                                                        os.path.dirname(p))
                try:
                    subprocess.run(["install_name_tool", "-add_rpath", new, p],
                                   check=True, stderr=subprocess.DEVNULL)
                    written += 1
                except subprocess.CalledProcessError:
                    pass
            elif rp.startswith(PREFIX):
                new = rel_target(p, rp)
                try:
                    subprocess.run(["install_name_tool", "-delete_rpath", rp, p],
                                   check=True, stderr=subprocess.DEVNULL)
                    subprocess.run(["install_name_tool", "-add_rpath", new, p],
                                   check=True, stderr=subprocess.DEVNULL)
                    written += 1
                except subprocess.CalledProcessError:
                    pass
        for nm in dylibs:
            new = rel_target(p, nm)
            try:
                subprocess.run(["install_name_tool", "-change", nm, new, p],
                               check=True, stderr=subprocess.DEVNULL)
                changed += 1
            except subprocess.CalledProcessError:
                pass
        for nm in ids:
            new = "@loader_path/" + os.path.basename(nm)
            try:
                subprocess.run(["install_name_tool", "-id", new, p],
                               check=True, stderr=subprocess.DEVNULL)
                changed += 1
            except subprocess.CalledProcessError:
                pass
print(f"    rpaths deleted={deleted} written={written} dylib changes={changed}")
PY

# ---------------------------------------------------------------------------
# 7. strip PE modules (matches the published release assets)
# ---------------------------------------------------------------------------
LLVM_STRIP="$PREFIX/libexec/llvm-mingw/bin/llvm-strip"
if [ -x "$LLVM_STRIP" ]; then
    say "stripping PE modules"
    find "$RWINE/lib/wine/x86_64-windows" "$RWINE/lib/wine/i386-windows" -type f \
        \( -name '*.dll' -o -name '*.exe' -o -name '*.sys' -o -name '*.drv' \
           -o -name '*.ocx' -o -name '*.cpl' -o -name '*.acm' -o -name '*.ax' \
           -o -name '*.tlb' -o -name '*.msstyles' -o -name '*.com' \) \
        -exec "$LLVM_STRIP" --strip-unneeded {} + 2>/dev/null || true
fi

# ---------------------------------------------------------------------------
# 8. sanity check: no absolute prefix references may remain
# ---------------------------------------------------------------------------
say "verifying no absolute $PREFIX references remain"
remaining=$(python3 - "$RWINE" "$PREFIX" <<'PY'
import os, struct, subprocess, sys
ROOT, PREFIX = sys.argv[1], sys.argv[2]
def is_macho(p):
    try:
        raw = open(p, "rb").read(4)
        return struct.unpack("<I", raw)[0] in (0xfeedfacf, 0xfeedface) or \
               struct.unpack(">I", raw)[0] in (0xfeedfacf, 0xfeedface)
    except Exception:
        return False
n = 0
for dp, _, fs in os.walk(ROOT):
    for fn in fs:
        p = os.path.join(dp, fn)
        if not is_macho(p):
            continue
        try:
            out = subprocess.check_output(["otool", "-l", p],
                                          stderr=subprocess.DEVNULL).decode("utf-8", "replace")
        except Exception:
            continue
        if PREFIX in out:
            n += 1
print(n)
PY
)
if [ "$remaining" != "0" ]; then
    echo "ERROR: $remaining Mach-O files still reference $PREFIX" >&2
    exit 1
fi

# ---------------------------------------------------------------------------
# 9. package
# ---------------------------------------------------------------------------
ASSET_NAME="${ASSET}-${VERSION}-osx64.tar.xz"
say "creating $ASSET_NAME"
mkdir -p "$OUTDIR"
tar -cJf "$OUTDIR/$ASSET_NAME" -C "$WORK" "$APP_NAME"

say "done"
echo "    asset:  $OUTDIR/$ASSET_NAME"
echo "    size:   $(du -h "$OUTDIR/$ASSET_NAME" | cut -f1)"
echo "    sha256: $(shasum -a 256 "$OUTDIR/$ASSET_NAME" | cut -d' ' -f1)"
