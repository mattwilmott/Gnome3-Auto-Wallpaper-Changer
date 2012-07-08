Gnome3 Desktop Wallpaper Auto Changer
=====================================

gnome3-change-wallpaper.sh
--------------------------

Switches the wallpaper in Gnome3 periodically by utilizing cron

### Limitations

Currently only serves images randomly from ~/Pictures/bing-wallpapers

I will update the script shortly to specify multiple sources and preserve order etc. This is the first release

### Usage

Add to cron using a line similar to
* * * * * /home/matt/Gnome3-Auto-Wallpaper-Changer/gnome3-change-wallpaper.sh

This changes the wallpaper randomly from the folder ~/Pictures/bing-wallpapers


Bing Wallpaper Downloader bing-wallpaper-dl.sh
------------------------

Downloads Bing Wallpapers periodically

This script was originally written by https://github.com/ktmud/bing-wallpaper

### Usage

Add to cron using a line similar to 
0 0 * * * /home/matt/Gnome3-Auto-Wallpaper-Changer/bing-wallpaper-dl.sh

This will run at midnight every night if you leave your machine on. I have mine set to download every 4 hrs as I often have it turned off over night.
