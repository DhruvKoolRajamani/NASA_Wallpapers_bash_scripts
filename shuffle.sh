#!/bin/bash
#     Bash script to add wallpaper setup script as a cronjob
#     Copyright (C) <2019>  <Dhruv Kool Rajamani>

#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.

#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.

#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Also add information on how to contact you by electronic and paper mail.

#   If the program does terminal interaction, make it output a short
# notice like this when it starts in an interactive mode:

#     shuffle.sh  Copyright (C) 2019 Dhruv Kool Rajamani
#     This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
#     This is free software, and you are welcome to redistribute it
#     under certain conditions; type `show c' for details.

# The hypothetical commands `show w' and `show c' should show the appropriate
# parts of the General Public License.  Of course, your program's commands
# might be different; for a GUI interface, you would use an "about box".

#   You should also get your employer (if you work as a programmer) or school,
# if any, to sign a "copyright disclaimer" for the program, if necessary.
# For more information on this, and how to apply and follow the GNU GPL, see
# <https://www.gnu.org/licenses/>.

#   The GNU General Public License does not permit incorporating your program
# into proprietary programs.  If your program is a subroutine library, you
# may consider it more useful to permit linking proprietary applications with
# the library.  If this is what you want to do, use the GNU Lesser General
# Public License instead of this License.  But first, please read
# <https://www.gnu.org/licenses/why-not-lgpl.html>.

. ~/.wallpaper.sh
. $wPaperFolderPath/dbus_address.sh
. $wPaperFolderPath/NASA/aotd_daily.sh $1
. $wPaperFolderPath/Bing/bing_wallpapers.sh $1

prevWallpaperPath="$wPaperFolderPath/current.txt"

WALLPAPER_PATH=~/Pictures/Wallpapers

randImg=0

random_generator() {
    local rand=0
    rand=$((0+RANDOM%$1))
    randImg=$rand
}

shopt -s nullglob
arrayPictures=($WALLPAPER_PATH/*.jpg)

if [ -e "$prevWallpaperPath" ]; then
    prevWallpaper=$(cat $prevWallpaperPath)

    new_array=()
    for value in "${arrayPictures[@]}"; do
        [[ $value != $prevWallpaper ]] && new_array+=($value)
    done
    arrayPictures=("${new_array[@]}")
    # echo "${arrayPictures[@]}"
    unset new_array
fi

random_generator ${#arrayPictures[@]}
arrayPictures=( $(shuf -e "${arrayPictures[@]}") )
# echo "Selecting random $randImg"
echo ${arrayPictures[randImg]} | rev | cut -d'/' -f-1 | rev > temp.txt
finImgName=$(cat temp.txt)
rm temp.txt
# if [ $isQuietFlagSet != "true" ]; then
#     echo "Selecting $finImgName"
# fi
wallpaper=${arrayPictures[randImg]}

XDG_CURRENT_DESKTOP="pop:GNOME"

if [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]
then
    xres=($(echo $(xfconf-query --channel xfce4-desktop --list | grep last-image)))
    for x in "${xres[@]}"
    do
        xfconf-query --channel xfce4-desktop --property $x --set $wallpaper
    done
elif [ "$XDG_CURRENT_DESKTOP" = "MATE" ]
then
    gsettings set org.mate.background picture-filename $wallpaper
    # Set the wallpaper for unity, gnome3, cinnamon.
elif [ "$XDG_CURRENT_DESKTOP" = "pop:GNOME" ]
then
    gsettings set org.gnome.desktop.background picture-uri "file://$wallpaper"
    #Logging
    # Set the view to zoom,
    gsettings set org.gnome.desktop.background picture-options "zoom"
else
    if [ $isQuietFlagSet != "true" ]; then
        echo "$XDG_CURRENT_DESKTOP not supported."
    fi
fi

echo $wallpaper > current.txt

if [ $isQuietFlagSet != "true" ]; then
    echo
    echo $(date)
    echo "$finImgName set for $XDG_CURRENT_DESKTOP."
fi
