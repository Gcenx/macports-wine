# macports-wine
A macports overlay that provides recent versions of wine on macOS.\
This branch supports macOS 10.8 and later, for 10.6 & 10.7 use the [osx10.6-branch](https://github.com/Gcenx/macports-wine/tree/osx10.6-branch)

## This repository contains;
- `crossovertricks`         *(winetricks wrapper for CrossOver)*
- `CrossOver`               *(22.1.0)*
- `cx-llvm`                 *(CodeWeavers custom compiler for -mwine32 targets)*
- `gl-headers`              *(2019.1.0)*
- `gstreamer1`              *(1.22.1)*
- `mingw-w64-wine-dxvk`     *(1.10.3)*
- `MacOSX.sdk`              *(Multiple MacOSX SDKs)*
- `mingw-w64-wine-gecko`    *(Multiple versions)*
- `mingw-w64-wine-mono`     *(Multiple versions)*
- `mingw-w64-pkgconfig`
- `MoltenVK`                *(v1.2.3)*
- `wine-crossover`          *(v22.1.0)*
- `wine-stable`             *(v8.0)*
- `wine-devel`              *(v8.4)*
- `wine-staging`            *(v8.4)*
- `winetricks`              *(v20221022)*

## How to use this repository
After installing macports you'll need a modern version of `git`\
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
`wine-stable`, `wine-devel` & `wine-staging` will only provide wine64.

### Prior project history
You can find the prior commit history [here](https://github.com/Gcenx/macports-wine/tree/master)
