# macports-wine
The current macports-ports versions of `wine`, `wine-devel`, `wine-crossover` & `MoltenVK` are not fully updated and/or are missing additinal dependencies.
\
The provided ports are updated but are only compatible for 10.8 > [10.14](https://trac.macports.org/ticket/56991#comment:70), MoltenVK minimum requirement was lowered from 10.12 to 10.11

## This repository contains;
- `wine` Wine-4.0.2
- `wine-devel` Wine-Devel-4.20
- `wine-staging` Wine-Staging-4.20
- `wine-crossover` Wine-CrossOver-18.5.0
- `MoltenVK` (unpacks vulkansdk-macos-1.1.126.0)

## How to use this repository
To use this repository download/git clone into your home directory and edit then follow
[4.6. Local Portfile Repositories](https://guide.macports.org/chunked/development.local-repositories.html)

## Additinal step required for `wine-devel` & `wine-staging`
Before installing `wine-devel` or `wine-staging` `mingw-w64` needs to be installed
```
port install mingw-w64
```

## Wine Portfile additinal dependancies;
- gstreamer1-gst-plugins-good (codecs)
- gstreamer1-gst-libav
- gphoto2
- kerberos5
- gettext (translations)
- libusb
- gnutls (encryption)
- libsdl2 (controllers)
- mpg123 (mp3 audio)
- libgsm
- FAudio (wma support needs +ffmpeg variant)
- MoltenVK
- gstreamer1-gst-plugins-bad (behind +ffmpeg variant)
