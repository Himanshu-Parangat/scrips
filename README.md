# applet

`applet` started as simple script for Linux. It works by using complex command into simple formate to perform many function `applet` where you are presented with a menu and much more.

<p align="center">
<img alt="screenshot" src="https://user-images.githubusercontent.com/73726132/136132026-aa2a685e-965c-44b5-b9c3-5a043dc2539a.gif">
rofi with DarkBlue theme
</p>

## Features
```
- auto detect installed browsers
- auto remove tracking elements from URLs (basic)
- ?search engines
- !bangs
- !ubangs : url bangs
- !dbangs : direct bangs or domain bangs
- ...
```

## Requirements
- `rofi` or wayland equivelent `wofi`
- a browser
- Video Player : `mpv` or `vlc`
- Video Downloader : `youtube-dl` or `yt-dlp`
- Image Viewer : `sxiv` or `feh`
- Image Editor : `gimp`
- Clipboard managers : `xclip`

## Installation
```
git clone https://github.com/MyOS-ArchLinux/applet
cd applet/
sudo make install
```
## Tips
- set a [keyboard shortcuts](https://wiki.archlinux.org/title/Keyboard_shortcuts) (ex: super+W) to open `applet` easly
- set `applet` as the [default browser](https://wiki.archlinux.org/title/Default_applications) so you can open each clicked URL with nbrowser (ex: using [xdg-utils](https://wiki.archlinux.org/title/Xdg-utils)).

  `xdg-mime default applet.desktop x-scheme-handler/https x-scheme-handler/http x-scheme-handler/browser`
- some console applications us the variable `$BROWSER` to open default browser,
  so you may also need to set [environment variable](https://wiki.archlinux.org/title/Environment_variables#Default_programs) `BROWSER=applet`
- for one-click switch between browsers copy and paste this code into a bookmark URL of all your browser
  `javascript:window.location='browser://'+location.href;`

## External links
- [WIKI](https://github.com/MyOS-ArchLinux/applet/wiki/)
- [Config](https://github.com/MyOS-ArchLinux/applet/wiki/Config)
- [FAQ](https://github.com/MyOS-ArchLinux/applet/wiki/FAQ)
- [Community Plugins](https://github.com/community-plugins/applet-plugins)

## Bug reports
Please use the issue tracker provided by GitHub to send us bug reports or feature requests.

## License
[GPLv3](https://github.com/MyOS-ArchLinux/applet/blob/main/LICENSE)
