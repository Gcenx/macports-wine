# macports-wine
The current versions of `wine`, `wine-devel` & `wine-crossover` provided by macports are extreamly outdated and missing many required dependencies.\
The provided Ports *should* compile on Mac OSX 10.8 and later.

## This repository contains;
- `crossovertricks`         *(winetricks wrapper for CrossOver)*
- `CrossOver`               *(22.0.1)*
- `cx-llvm`                 *(CodeWeavers custom compiler for -mwine32 targets)*
- `gl-headers`              *(2019.1.0)*
- `gstreamer1`              *(1.20.5)*
- `MacOSX.sdk`              *(Multiple MacOSX SDKs)*
- `mingw-w64-wine-gecko`    *(Multiple versions)*
- `mingw-w64-wine-mono`     *(Multiple versions)*
- `mingw-w64-pkgconfig`
- `MoltenVK`                *(v1.2.1)*
- `wine-crossover`          *(v22.0.1)*
- `wine-stable`             *(v7.0.1)*
- `wine-devel`              *(v8.0-rc4)*
- `wine-staging`            *(v8.0-rc4)*
- `winetricks`              *(v20221022)*
- `x86_64-w64-mingw32-dxvk` *(v1.10.3)*

## How to use this repository
After installing macports you will need a modern version of `git`\
git clone the repository into /opt then follow [4.6. Local Portfile Repositories](https://guide.macports.org/#development.local-repositories)\
Next run `port -v sync` you can now install any of the provided Ports.

## macOS Mojave;
Add the following into `/opt/local/etc/macports/macports.conf`
```
macosx_deployment_target     10.13
macosx_sdk_version           10.13
```
This will enable compiling for 32 & 64Bit enabling the `+universal` flag\
Next place a copy of the `MacOSX10.13.sdk` into `/Library/Developer/CommandLineTools/SDKs/` \
Alternatively run `port install MacOSX10.13.sdk`

## macOS Catalina or later;
`wine-stable`, `wine-devel` & `wine-staging` will only provide wine64.

### Project history
You can find the prior commit history via [master](https://github.com/Gcenx/macports-wine/tree/master)
