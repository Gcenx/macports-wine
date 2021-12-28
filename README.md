# macports-wine
The current versions of `MoltenVK`, `wine` & `wine-devel` provided by macports are not fully updated and/or require additinal dependencies.\
The provided Ports *should* compile on Mac OSX 10.8 and later.

## This repository contains;
- `FAudio` *(v21.12)*
- `jxrlib` *(v1.1)*
- `MacOSX.sdk` (Allows installation of multiple MacOSX SDKs)
- `MoltenVK`/`MoltenVK-DXVK` *(v1.1.6)*
- `wine-stable` *(v6.0.2)*
- `wine-devel` *(v7.0-rc3)*
- `wine-staging` *(v7.0-rc3)*
- `winetricks` *(20210206)*

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
