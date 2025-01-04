# macports-wine
A macports overlay that provides recent versions of wine on macOS.\
This branch only supports macOS Catalina 10.15.4 & later.\
For older versions of macOS use the [legacy](https://github.com/Gcenx/macports-wine/tree/legacy) branch

## This repository contains
- `CrossOver`               *(v24.0.5)*
- `crossovertricks`         *(winetricks wrapper for CrossOver)*
- `D3DMetal`                *(v2.0 beta1)*
- `game-porting-toolkit`    *(v1.1)*
- `gstreamer.framework`     *(v1.24.10)*
- `gstreamer-runtime`       *(v1.24.10)*
- `gstreamer-development`   *(v1.24.10)*
- `libinotify`              *(v20230908)*
- `MacOSX.sdk`              *(Multiple MacOSX SDKs)*
- `mingw-w64-pkgconfig`
- `wine-stable`             *(v9.0)*
- `wine-devel`              *(v10.0-rc4)*
- `wine-staging`            *(v10.0-rc4)*
- `winetricks`              *(v20240704)*
- `kegworks`                *(v2.0.3)*

## How to use this repository
After installing macports you need a modern version of `git`\
git clone the repository into /opt then follow [4.6. Local Portfile Repositories](https://guide.macports.org/#development.local-repositories)\
Next run `port -v sync` you can now install any of the provided Ports.

### Force x86_64
Due to macports-ports bugs we need to force MacPorts to only install for x86_64

> echo "build_arch x86_64" | sudo tee -a /opt/local/etc/macports/macports.conf >/dev/null

## Prior project history
You can find the prior commit history [here](https://github.com/Gcenx/macports-wine/tree/master)
