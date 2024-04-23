# macports-wine (Legacy branch)
A macports overlay that provides recent versions of wine on macOS.\
This branch supports macOS 10.6.8 to macOS 10.14

## This repository contains
- `MacOSX.sdk`              *(Multiple MacOSX SDKs)*
- `mingw-w64-wine-gecko`    *(Multiple versions)*
- `mingw-w64-wine-mono`     *(Multiple versions)*
- `wine-stable`             *(stub)*
- `wine-stable-6.0.4`       *(v6.0.6)*
- `wine-stable-7.0.2`       *(v7.0.2)*
- `wine-devel`              *(stub)*
- `wine-devel-6.8`          *(v6.8)*
- `wine-devel-7.22`         *(v7.22)*

## How to use this repository
After installing macports you need a modern version of `git`\
git clone the repository into /opt then follow [4.6. Local Portfile Repositories](https://guide.macports.org/#development.local-repositories)\
Next run `port -v sync` you can now install any of the provided Ports.

## macOS Snow Leopard
To build wine you need a copy of `MacOSX10.7.sdk` placed into `/Library/Developer/CommandLineTools/SDKs/`

## macOS Mojave;
Add the following into `/opt/local/etc/macports/macports.conf`
```
macosx_deployment_target     10.13
macosx_sdk_version           10.13
```
This enables the `i386` & `x86_64` architectures thus enabling the `+universal` flag\
Next place a copy of the `MacOSX10.13.sdk` into `/Library/Developer/CommandLineTools/SDKs/` \
Alternatively run `port install MacOSX10.13.sdk`
