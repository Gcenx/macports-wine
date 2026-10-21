# macports-wine
A MacPorts overlay that provides recent versions of wine.

<br>

## This repository provides
- `CrossOver`               *(v26.3.0)*
- `crossovertricks`         *(winetricks wrapper for CrossOver)*
- `gstreamer.framework`     *(v1.28.1)*
- `gstreamer-runtime`       *(v1.28.1)*
- `gstreamer-development`   *(v1.28.1)*
- `libinotify`              *(v20240724)*
- `MacOSX.sdk`              *(Multiple MacOSX SDKs)*
- `mingw-w64-pkgconfig`
- `wine-stable`             *(v11.0)*
- `wine-devel`              *(v11.20)*
- `wine-staging`            *(v11.20)*
- `winetricks`              *(v20260518)*
- `sikarugir`               *(v1.0.1)*

<br>

## How to use this repository
After installing MacPorts you need a modern version of `git`\
git clone the repository into /opt then follow [4.6. Local Portfile Repositories](https://guide.macports.org/#development.local-repositories)\
Next run `port -v sync` you can now install any of the provided Ports.

<br>

### Apple Silicon systems, force x86_64
Due to macports-ports bugs we need to force MacPorts to only install for x86_64
> echo "build_arch x86_64" | sudo tee -a /opt/local/etc/macports/macports.conf >/dev/null
