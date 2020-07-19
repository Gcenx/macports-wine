# macports-wine
The current macports-ports versions of `MoltenVK`, `wine`, `wine-devel` & `wine-crossover` are not fully updated and are missing additinal required dependencies.
\
These have been tested and compile using MacOSX10.10.sdk and above, it's recomended to compile wine using the MacOSX10.13.sdk however that's currently not possible as `ld64` currently only supports TAPIv2.\
MoltenVK minimum requirement was lowered from 10.12 to 10.11

## This repository contains;
- `MoltenVK` (Installs MoltenVK.dylib & MoltenVK.framework from vulkansdk-macos-1.2.141.2)
- `VulkanSDK` (Installs vulkansdk-macos-1.2.141.2)
- `wine` Marked obsolete (swap to Winehq naming scheme)
- `wine-stable` Wine-5.0.1
- `wine-devel` Wine-Devel-5.13
- `wine-staging` Wine-Staging-5.13
- `wine-crossover` Wine-CrossOver-19.0.2 (patched to use `wine-gecko-2.47.1`)
- `wine-gecko` Wine-Gecko-2.47.1 (/opt/wine/gecko)
- `wine-mono` Wine-Mono-4.9.4 (/opt/wine/mono)
- `wine-mono-5.0.0` Wine-Mono-5.0.0 (/opt/wine/mono)
- `wine-mono-5.1.0` Wine-Mono-5.1.0 (/opt/wine/mono)
- `cargo` Downgraded to 0.41.0 (Needed for 32Bit support)
- `rust` Downgraded to 1.42.0 (Needed for 32Bit support)
- `gstreamer1-gst-plugins-ugly` 1.16.2 [(Added Derek Lesho patchs to fix wmv playback)](https://github.com/GloriousEggroll/proton-ge-custom/tree/proton-ge-5-MF/patches/gstreamer)
- `MacOSX.sdk` (Allows installation of multiple MacOSX SDKs)

## MacOSX.sdk contains the following subports;
- `subport MacOSX10.15.sdk`
- `subport MacOSX10.14.sdk`
- `subport MacOSX10.13.sdk` (Add QuickTime.framework from MacOSX10.11.sdk)
- `subport MacOSX10.12.sdk` (Add QuickTime.framework from MacOSX10.11.sdk)
- `subport MacOSX10.11.sdk`

## How to use this repository
To use this repository download/git clone into your home directory and edit then follow
[4.6. Local Portfile Repositories](https://guide.macports.org/#development.local-repositories)

## Recommended install command;
```
sudo su
yes | port install wine-staging
```
This will install `wine-staging` with wow64 support, x11 support and all possible dependencies except `gstreamer1-gst-plugins-good`, `gstreamer1-gst-plugins-bad, `gstreamer1-gst-plugins-ugly`, `gstreamer1-gst-libav` and `FAudio` won't be built with wma support.

### Alternative install command (wma audio support);
```
sudo su
yes | port install wine-staging +ffmpeg
```

This will install `wine-staging` with wow64 support, x11 support and all possible depedenceis, `+ffmpeg` **will take a long time** but gives `FAudio` wma support along with gstreamer will also have wma support.

## Wine Portfile additinal dependancies;
- gnutls (encryption)
- libsdl2 (controllers)
- libgcrypt (additinal encription on wine-staging)
- mpg123 (mp3 audio)
- FAudio (wma support needs +ffmpeg variant)
- MoltenVK
- gstreamer1-gst-plugins-good (behind +ffmpeg variant)
- gstreamer1-gst-plugins-bad (behind +ffmpeg variant)
- gstreamer1-gst-plugins-ugly (behind +ffmpeg variant)
- gstreamer1-gst-libav (behind +ffmpeg variant)

## `Wine-Mono` & `Wine-Gecko`?
From Wine-5.0 it's possbile to have a shared version of both gecko & mono, instead of installing into each prefix the shared versions will be used.

## How to use on macOS High Sierra & macOS Mojave;
Install macports as usual then apply the following patch.
```
diff -u /opt/local/etc/macports/macports.conf.orig /opt/local/etc/macports/macports.conf
--- /opt/local/etc/macports/macports.conf.orig	                        2019-09-27 22:22:38.000000000 -0400
+++ /opt/local/etc/macports/macports.conf	                            2019-09-27 22:22:14.000000000 -0400
@@ -1,6 +1,9 @@
 # MacPorts system-wide configuration file.
 # Commented-out values are defaults unless otherwise noted.
 
+macosx_deployment_target     10.13
+macosx_sdk_version           10.13
+
 # Directory under which MacPorts should install ports. This must be
 # where MacPorts itself is installed.
 prefix              	/opt/local
```
Place a `MacOSX10.13.sdk` into `/Library/Developer/CommandLineTools/SDKs/` \
Or run `port install MacOSX10.13.sdk`\
Run `port install ld64` to avoid i386 linker warning that can turn into errors for some Ports\
Now follow from [How to use this repository](https://github.com/Gcenx/macports-wine-devel#how-to-use-this-repository) section

## How to use on macOS Catalina;
`wine-stable`, `wine-crossover`, `wine-devel` & `wine-staging` will only build wine64 on macOS Catalina, I'll lightly add a custom clang-8 Portfile eventually that's required to build `wine-crossover` with wine32on64 support along with some needed patches.

Follow [How to use this repository](https://github.com/Gcenx/macports-wine-devel#how-to-use-this-repository) section

Found this helpful?  
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/gcenx?locale.x=en_US)
