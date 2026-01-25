# macports-wine
A MacPorts overlay that provides recent versions of wine.

<br>

## This repository provides
- `CrossOver`               *(v25.1.1)*
- `crossovertricks`         *(winetricks wrapper for CrossOver)*
- `game-porting-toolkit`    *(v1.1)*
- `gstreamer.framework`     *(v1.26.8)*
- `gstreamer-runtime`       *(v1.26.8)*
- `gstreamer-development`   *(v1.26.8)*
- `libinotify`              *(v20240724)*
- `MacOSX.sdk`              *(Multiple MacOSX SDKs)*
- `mingw-w64-pkgconfig`
- `wine-stable`             *(v11.0)*
- `wine-devel`              *(v11.1)*
- `wine-staging`            *(v11.1)*
- `winetricks`              *(v20251121)*
- `sikarugir`               *(v1.0.1)*

<br>

## How to use this repository
After installing MacPorts you need a modern version of `git`\
git clone the repository into /opt then follow [4.6. Local Portfile Repositories](https://guide.macports.org/#development.local-repositories)\
Next run `port -v sync` you can now install any of the provided Ports.

<br>

### macOS Mojave
Add the following into `/opt/local/etc/macports/macports.conf`
```
macosx_deployment_target     10.13
macosx_sdk_version           10.13
```
This enables the `i386` & `x86_64` architectures thus enabling the `+universal` flag\
Next place a copy of the `MacOSX10.13.sdk` into `/Library/Developer/CommandLineTools/SDKs/`

<br>

### Apple Silicon systems, force x86_64
Due to macports-ports bugs we need to force MacPorts to only install for x86_64
> echo "build_arch x86_64" | sudo tee -a /opt/local/etc/macports/macports.conf >/dev/null

<br>

### Prior project history
You can find the prior commit history [here](https://github.com/Gcenx/macports-wine/tree/master)
