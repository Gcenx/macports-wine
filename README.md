# macports-wine
This branch focus having somewhat modern wine running on OS X Snow Leopard.\
These are still WIP and lightly require additional reverts.

## This repository contains;
- `wine` *(replaced_by wine-stable)*
- `wine-stable` *(v6.0.4)*
- `wine-devel` *(v6.8)*
- `mingw-w64-wine-gecko`
- `mingw-w64-wine-mono`
- `libsdl2` *(2.0.22)*

## How to use this repository
After installing macports you will need a modern version of `git`\
git clone the repository into /opt then follow [4.6. Local Portfile Repositories](https://guide.macports.org/#development.local-repositories)\
Next run `port -v sync` you can now install any of the provided Ports.

# Requirements 
`MacOSX10.7.SDK`
