# macports-wine
This branch focus having somewhat modern wine running on OS X Snow Leopard.\
These are still WIP and lightly require additional reverts.

wine-stable-6.0.4 builds and runs.

wine-devel-6.13 builds but fails to run currently due to some 10.7 only functions added into winemac.drv from wine-6.9.
This may get downgraded to wine-6.8 if this works until any relevant reverts are collected.

## This repository contains;
- `wine` *(replaced_by wine-stable)*
- `wine-stable` *(v6.0.4)*
- `wine-devel` *(v6.13)*
- `mingw-w64-wine-gecko`
- `mingw-w64-wine-mono`

## How to use this repository
After installing macports you will need a modern version of `git`\
git clone the repository into /opt then follow [4.6. Local Portfile Repositories](https://guide.macports.org/#development.local-repositories)\
Next run `port -v sync` you can now install any of the provided Ports.

# Requirements 
`libsdl2` & `wine-stable` require `MacOSX10.7.SDK`
