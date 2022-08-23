# macports-wine
This branch focus having somewhat modern wine running on OS X Snow Leopard.

## This repository contains;
- `FAudio` *(v22.01)*
- `wine` *(replaced_by wine-stable)*
- `wine-stable` *(v6.0.4)*
- `wine-devel` *(v6.13)*
- `wine-gecko` *(v2.47.2)*
- `wine-mono` *(v5.1.1)*
- `libsdl2` *(v2.0.22)*

## How to use this repository
After installing macports you will need a modern version of `git`\
git clone the repository into /opt then follow [4.6. Local Portfile Repositories](https://guide.macports.org/#development.local-repositories)\
Next run `port -v sync` you can now install any of the provided Ports.

# Requirements 
`libsdl2` & `wine` require `MacOSX10.7.SDK`
