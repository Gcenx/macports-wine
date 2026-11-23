# Release packaging

`make-release-bundle.sh` assembles the `.tar.xz` release assets published in
[Gcenx/macOS_Wine_builds](https://github.com/Gcenx/macOS_Wine_builds) from an
installed MacPorts wine port.

The ports in this overlay install into a normal `/opt/local` prefix. The release
assets, however, are self-contained `.app` bundles that must run on machines
without MacPorts. This script bridges the two:

1. copies the wine binaries and runtime tree into `Wine <Flavour>.app`;
2. resolves the transitive closure of the dylibs wine `dlopen`s at runtime
   (gnutls, freetype, SDL2, Vulkan/MoltenVK, pcap, inotify, …) — these do not
   appear in `otool -L` output, so they are listed explicitly;
3. bundles `MoltenVK` and rewrites the Vulkan ICD to a bundle-relative path;
4. bundles `GStreamer.framework` runtime-only (drops headers, static archives
   and pkgconfig), matching the published asset size;
5. rewrites every `/opt/local` reference in every Mach-O — `LC_LOAD_DYLIB`,
   `LC_ID_DYLIB` and `LC_RPATH` — to `@loader_path`-relative form;
6. strips the PE modules with `llvm-strip`;
7. **verifies** that zero absolute `/opt/local` references remain, and fails
   if any do;
8. produces `<flavour>-<version>-osx64.tar.xz` and prints its sha256, which can
   be pasted directly into the matching cask in `Gcenx/homebrew-wine`.

## Requirements

- the port installed with the default variants, e.g.
  `sudo port -N install wine-devel +gstreamer`
- Xcode command line tools (`otool`, `install_name_tool`, `strip`)
- `llvm-mingw` (from this overlay) for `llvm-strip`
- `xz`, `python3`

## Usage

```sh
./packaging/make-release-bundle.sh --flavour wine-devel --version 11.22
```

```
Options:
  --flavour NAME    wine-devel | wine-stable | wine-staging   (default: wine-devel)
  --version VER     version string, e.g. 11.22               (default: from port)
  --prefix PATH     MacPorts prefix                          (default: /opt/local)
  --outdir PATH     where to write the .tar.xz               (default: $PWD)
  --keep            keep the intermediate bundle tree
```

Output:

```
    asset:  ./wine-devel-11.22-osx64.tar.xz
    size:   256M
    sha256: c437ee98a27a670dd5a11615cba7e6dad2028bc0df2e286b98f152a623c2771d
```

## Verifying the result

The script refuses to emit a tarball that still references the build prefix.
To check a bundle by hand:

```sh
otool -l "Wine Devel.app/Contents/Resources/wine/bin/wine"
# every dependency should be /usr/lib, /System, @loader_path or @rpath

# then run it with the build prefix out of the environment
env -i HOME="$HOME" PATH=/usr/bin:/bin:/usr/sbin:/sbin \
    WINEPREFIX=/tmp/wp "Wine Devel.app/Contents/Resources/wine/bin/wine" cmd /c ver
```

## Notes

- Wine `dlopen`s most of its optional dependencies by name rather than linking
  them, so `otool -L` alone is not sufficient to find what must be bundled.
  `DLOPEN_ROOTS` at the top of the script is the list to extend if a new
  `--with-*` option is added to the Portfile.
- The `Contents/MacOS/wine` launcher and `Contents/Resources/winehq.icns` icon
  are reused from an already-installed `Wine *.app` in `/Applications` when one
  is present. If none is found the script writes a minimal shell launcher so the
  `.app` is still valid for Finder. For a byte-for-byte release bundle, install
  a previous release asset first so the official launcher and icon are reused.
- The `Contents/Resources/start/` helpers (`appdb`, `winehelp`) are not
  generated; they are version-independent and are only used by the interactive
  launcher. The cask adds the `wine*` binaries to `PATH` directly and does not
  depend on them.
