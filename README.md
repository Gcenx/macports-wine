# macports-wine
The current macports-ports versions of `MoltenVK`, `wine`, `wine-devel` & `wine-crossover` are not fully updated and are missing additinal required dependencies.
<br>
The provided `wine-*` Ports compile on Mac OSX 10.8 and later.\
MoltenVK minimum requirement was lowered from 10.12 to 10.11.

## This repository contains;
- `FAudio` *(v21.07)*
- `MacOSX.sdk` (Allows installation of multiple MacOSX SDKs)
- `MoltenVK` *(v1.1.4)*
- `CX-MoltenVK` (MoltenVK v1.1.4 with DXVK patches from [cdavis5e](https://github.com/cdavis5e))
- `VulkanSDK` *(v1.2.170.0)*
- `wine` Marked obsolete (swap to Winehq naming scheme)
- `wine-stable` *(v6.0.1)*
- `wine-devel` *(v6.12)*
- `wine-staging` *(v6.12.1)*
- `wine-crossover` *(v19.0.2 patched to use `wine-gecko-2.47.1`)*
- `wine-gecko` *(v2.47.2)*
- `wine-gecko-2.47.1` (Workaround for [Bugzilla 49940](https://bugs.winehq.org/show_bug.cgi?id=49940))
- `wine-mono` *(v4.9.4)*
- `wine-mono-5.0.0` *(v5.0.1)*
- `wine-mono-5.1.0` *(v5.1.0)*
- `wine-mono-5.1.1` *(v5.1.1)*
- `wine-mono-6.0.0` *(v6.0.0)*
- `wine-mono-6.1.1` *(v6.1.1)*
- `wine-mono-6.2.0` *(v6.2.0)*
- `Wineskin` *(v1.8.4.2)*
- `winetricks` *(20210206)* doesn't default to +zenity
- `jxrlib` *(v1.1)*

## MacOSX.sdk contains the following subports;
- `subport MacOSX10.15.sdk` (MacOSX.sdk will install this SDK)
- `subport MacOSX10.14.sdk`
- `subport MacOSX10.13.sdk` (Add QuickTime.framework from MacOSX10.11.sdk)
- `subport MacOSX10.12.sdk` (Add QuickTime.framework from MacOSX10.11.sdk)
- `subport MacOSX10.11.sdk`

## How to use this repository
To use this repository download/git clone into your home directory and edit then follow\
[4.6. Local Portfile Repositories](https://guide.macports.org/#development.local-repositories)

## Recommended install command;
```
sudo su
yes | port install wine-staging
```
This will install `wine-staging` with wow64 support, x11 support and all possible dependencies except `gstreamer1-gst-plugins-good`, `gstreamer1-gst-plugins-bad`, `gstreamer1-gst-plugins-ugly`, `gstreamer1-gst-libav` and `FAudio` won't be built with wma support.

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
- FAudio (wma support needs +wma variant)
- MoltenVK
- gstreamer1-gst-plugins-good (behind +ffmpeg variant)
- gstreamer1-gst-plugins-bad (behind +ffmpeg variant)
- gstreamer1-gst-plugins-ugly (behind +ffmpeg variant)
- gstreamer1-gst-libav (behind +ffmpeg variant)

## `Wine-Mono` & `Wine-Gecko`?
From Wine-5.0 it's possbile to have a shared version of both gecko & mono, instead of installing into each prefix the shared versions will be used.

## How to use on macOS Mojave;
Install macports as usual then apply the following patch.
```
diff -u /opt/local/etc/macports/macports.conf /opt/local/etc/macports/macports.conf
--- /opt/local/etc/macports/macports.conf                        2019-09-27 22:22:38.000000000 -0400
+++ /opt/local/etc/macports/macports.conf	                 2019-09-27 22:22:14.000000000 -0400
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
Place a copy of the `MacOSX10.13.sdk` into `/Library/Developer/CommandLineTools/SDKs/` \
Alternatively run `port install MacOSX10.13.sdk`
<br>
Now follow from [How to use this repository](https://github.com/Gcenx/macports-wine-devel#how-to-use-this-repository) section

## How to use on macOS macOS Catalina & later;
`wine-stable`, `wine-crossover`, `wine-devel` & `wine-staging` will only build wine64 on macOS Catalina\
*I'll lightly add a custom clang-8 Portfile eventually that's required to build `wine-crossover` with wine32on64 support along with some needed patches.*
<br>
Just follow [How to use this repository](https://github.com/Gcenx/macports-wine-devel#how-to-use-this-repository) section
