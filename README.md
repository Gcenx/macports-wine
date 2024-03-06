# macports-wine
A macports overlay that provides recent versions of wine on macOS.

## This repository contains
- `CrossOver`               *(24.0.0)*
- `crossovertricks`         *(winetricks wrapper for CrossOver)*
- `game-porting-toolkit`    *(1.1)*
- `gl-headers`              *(2019.1.0)*
- `gstreamer1`              *(1.24.0)*
- `gstreamer.framework`     *(1.24.0)*
- `libinotify`              *(20230908)*
- `MacOSX.sdk`              *(Multiple MacOSX SDKs)*
- `mingw-w64-pkgconfig`
- `mingw-w64-wine-gecko`    *(Multiple versions)*
- `mingw-w64-wine-mono`     *(Multiple versions)*
- `wine-stable`             *(v9.0)*
- `wine-devel`              *(v9.3)*
- `wine-staging`            *(v9.3)*
- `wine-crossover`          *(v22.1.1)*
- `winetricks`              *(20231004)*

## Legacy wine versions
- `wine-stable-6.0.4`       *(supports macOS 10.6.8)*
- `wine-devel-6.8`          *(supports macOS 10.6.8)*
- `wine-stable-7.0.2`       *(supports macOS 10.8)*
- `wine-devel-7.22`         *(supports macOS 10.8)*
- `wine-devel-8.21`         *(supports macOS 10.11)*

## How to use this repository
After installing macports you need a modern version of `git`\
git clone the repository into /opt then follow [4.6. Local Portfile Repositories](https://guide.macports.org/#development.local-repositories)\
Next run `port -v sync` you can now install any of the provided Ports.

## macOS Mojave;
Add the following into `/opt/local/etc/macports/macports.conf`
```
macosx_deployment_target     10.13
macosx_sdk_version           10.13
```
This enables the `i386` & `x86_64` architectures thus enabling the `+universal` flag\
Next place a copy of the `MacOSX10.13.sdk` into `/Library/Developer/CommandLineTools/SDKs/` \
Alternatively run `port install MacOSX10.13.sdk`

## macOS Catalina or later;
`wine-stable`, `wine-devel` & `wine-staging` will only provide wine used for 32 & 64Bit Windows binaires.

### Prior project history
You can find the prior commit history [here](https://github.com/Gcenx/macports-wine/tree/master)
