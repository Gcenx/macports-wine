# macports-wine
The current macports-ports versions of `wine`, `wine-devel`, `wine-crossover` & `MoltenVK` are not fully updated and/or are missing additinal dependencies.
\
The provided ports are updated but are only compatible for 10.8 > 10.14, MoltenVK minimum requirement was lowered from 10.12 to 10.11

## This repository contains;
- `wine` Wine-4.0.3
- `wine-devel` Wine-Devel-5.0-rc5
- `wine-staging` Wine-Staging-5.0-rc5
- `wine-crossover` Wine-CrossOver-19.0.1
- `MoltenVK` (unpacks vulkansdk-macos-1.1.130.0)

## How to use this repository
To use this repository download/git clone into your home directory and edit then follow
[4.6. Local Portfile Repositories](https://guide.macports.org/chunked/development.local-repositories.html)

## Additinal step required for `wine-crossover`, `wine-devel` & `wine-staging`
Before installing `wine-crossover`, `wine-devel` or `wine-staging` `mingw-w64` needs to be installed
```
port install mingw-w64
```

## Recommended install command;
```
sudo su
yes | port install wine-staging +ffmpeg +universal +x11
```
This will install `wine-staging` with wow64 support and all possible depedenceis, `+ffmpeg` will take a while but gives `FAudio` wma support along with gstreamer will also have wma support.

## Wine Portfile additinal dependancies;
- gstreamer1-gst-plugins-good (codecs)
- gstreamer1-gst-libav
- gphoto2
- kerberos5
- gettext (translations)
- gnutls (encryption)
- libsdl2 (controllers)
- mpg123 (mp3 audio)
- libgsm
- FAudio (wma support needs +ffmpeg variant)
- MoltenVK
- gstreamer1-gst-plugins-bad (behind +ffmpeg variant)

## How to use on macOS Mojave;
Install macports as usual then apply the following patch
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
Place a `MacOSX10.13.sdk` into `/Library/Developer/CommandLineTools/SDKs/`
Now follow from [How to use this repository](https://github.com/Gcenx/macports-wine-devel#how-to-use-this-repository) section 
