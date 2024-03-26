#!/bin/bash
# maxxxx
#23/02/2024

if [ ! -d "/srv/yt/downloads" ]; then
    exit 1
fi

if [ ! -d "/var/log/yt/" ]; then
    exit 1
fi

name=$(youtube-dl -e "$1")

if [ ! -d "/srv/yt/downloads/$name" ]; then
    mkdir "/srv/yt/downloads/$name"
fi


youtube-dl -o "/srv/yt/downloads/$name/$name.mp4" "$1" > /dev/null
youtube-dl --get-description "$1" >> "/srv/yt/downloads/$name/description"

current_time=$(date "+%Y/%m/%d %H:%M:%S")
echo "[$current_time] Video $1 was downloaded. File path : /srv/yt/downloads/$name/$name.mp4" >> /var/log/yt/download.log


echo "Video $1 was downloaded."
echo "File path : /srv/yt/downloads/$name/$name.mp4"
