# macports-wine
The current macports-ports versions of `MoltenVK`, `wine`, `wine-devel` & `wine-crossover` are not fully updated and are missing additinal required dependencies.
\
The provided ports are updated and is possible to build on 10.7>10.15*, 10.8 fails on multiple dependencies currently still investigating those, I recommend building on 10.9 and above to avoid any issues\
MoltenVK minimum requirement was lowered from 10.12 to 10.11

## This repository contains;
- `FAudio` FAudio-20.04 , 10.8 and lower use FAudio-20.03
- `MoltenVK` (unpacks vulkansdk-macos-1.2.135.0)
- `wine` Wine-5.0
- `wine-crossover` Wine-CrossOver-19.0.1 (patched to use `wine-gecko`)
- `wine-devel` Wine-Devel-5.5
- `wine-gecko` Wine-Gecko-2.47.1 (/opt/wine/gecko)
- `wine-mono` Wine-Mono-4.9.4 (/opt/wine/mono)
- `wine-staging` Wine-Staging-5.5
- `i686-w64-mingw32-binutils` Revision bump to force rebuild
- `x86_64-w64-mingw32-binutils` Revision bump to force rebuild
- `i686-w64-mingw32-gcc` Update - Use gcc-9.3.0
- `x86_64-w64-mingw32-gcc` Update - Use gcc-9.3.0
- `cargo` Downgrade broken 0.43.0 to 0.41.0
- `librsvg` Downgrade broken 2.48.0 to 2.46.4
- `portutil.tcl` Patched to allow Xcode 9.4.1 on macOS Mojave
- `crossbinutils.tcl` Patched to remove `--enable-install-libbfd`

## How to use this repository
To use this repository download/git clone into your home directory and edit then follow
[4.6. Local Portfile Repositories](https://guide.macports.org/#development.local-repositories)

## Recommended install command;
```
sudo su
yes | port install wine-staging
```
This will install `wine-staging` with wow64 support, x11 support and all possible dependencies except `gstreamer1-gst-plugins-good` & `gstreamer1-gst-plugins-bad`  and `FAudio` won't be built with wma support.

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
diff -u /opt/local/libexec/macports/lib/port1.0/portconfigure.tcl.orig /opt/local/libexec/macports/lib/port1.0/portconfigure.tcl
--- /opt/local/libexec/macports/lib/port1.0/portconfigure.tcl.orig     2019-09-21 16:25:24.000000000 -0700
+++ /opt/local/libexec/macports/lib/port1.0/portconfigure.tcl          2019-09-21 16:26:20.000000000 -0700
@@ -1477,6 +1477,7 @@
                 append_to_environment_value configure $env_var -isysroot${configure.sdkroot}
             }
             append_to_environment_value configure "LDFLAGS" -Wl,-syslibroot,${configure.sdkroot}
+            append_to_environment_value configure "LDFLAGS" -Wl,-w
         }
 
         # add extra flags that are conditional on whether we're building universal
```
Install Xcode Command Line Tools 9.4.1 or place a `MacOSX10.13.sdk` into `/Library/Developer/CommandLineTools/SDKs/`  
Now follow from [How to use this repository](https://github.com/Gcenx/macports-wine-devel#how-to-use-this-repository) section

## How to use on macOS Catalina;
Due to some bugged prebuilt packages it's best to force build eveything from source to avoid issues. `wine`, `wine-crossover`, `wine-devel` & `wine-staging` will only build wine64 on macOS Catalina, I'll lightly add a custom clang-8 Portfile eventually that's required to build `wine-crossover` with wine32on64 support along with some needed patches.

Install macports as usual then apply the following patch
```
diff -u /opt/local/etc/macports/macports.conf /opt/local/etc/macports/macports.conf
--- /opt/local/etc/macports/macports.conf            2019-10-20 16:21:20.000000000 -0400
+++ /opt/local/etc/macports/macports.conf            2020-03-23 11:38:41.000000000 -0400
@@ -44,7 +47,7 @@
 # - always: Always build from source; never try fetching archives.
 # - never: Never build from source; try fetching archives and abort if
 #   unavailable.
-#buildfromsource         ifneeded
+buildfromsource         always
 
 # Type of archive to use for port images. Supported types are cpgz,
 # cpio, tar, tbz, tbz2, tgz, tlz, txz, xar, zip.
```
Found this helpful?  
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/gcenx?locale.x=en_US)
