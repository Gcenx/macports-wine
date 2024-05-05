# macports-wine
A macports overlay that provides recent versions of wine on macOS.\
This branch only supports macOS Catalina 10.15.4 & later.\
For older versions of macOS use the [legacy](https://github.com/Gcenx/macports-wine/tree/legacy) branch

## This repository contains
- `CrossOver`               *(24.0.1)*
- `crossovertricks`         *(winetricks wrapper for CrossOver)*
- `game-porting-toolkit`    *(1.1)*
- `gstreamer1`              *(1.24.2)*
- `gstreamer.framework`     *(1.24.2)*
- `libinotify`              *(20230908)*
- `MacOSX.sdk`              *(Multiple MacOSX SDKs)*
- `mingw-w64-pkgconfig`
- `mingw-w64-wine-gecko`    *(Multiple versions)*
- `mingw-w64-wine-mono`     *(Multiple versions)*
- `wine-stable`             *(v9.0)*
- `wine-devel`              *(v9.8)*
- `wine-staging`            *(v9.8)*
- `wine-crossover`          *(v23.7.1)*
- `winetricks`              *(20240320)*
- `wineskin`                *(v2.0.2)*

## How to use this repository
After installing macports you need a modern version of `git`\
git clone the repository into /opt then follow [4.6. Local Portfile Repositories](https://guide.macports.org/#development.local-repositories)\
Next run `port -v sync` you can now install any of the provided Ports.

### Prior project history
You can find the prior commit history [here](https://github.com/Gcenx/macports-wine/tree/master)
