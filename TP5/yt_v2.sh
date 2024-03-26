#!/bin/bash
# Maximeeee
#23/02/2024


while true; do

    file="/srv/yt/toDownload"
    while IFS= read -r line
    do
    if [[ $line =~ ^https:\/\/www\.youtube\.com\/watch\?v=[a-zA-Z0-9]{11}$ ]]; then
       if [ ! -d "/srv/yt/downloads" ]; then
            exit 1
        fi

        if [ ! -d "/var/log/yt/" ]; then
            exit 1
        fi

        name=$(youtube-dl -e "$line")

        if [ ! -d "/srv/yt/downloads/$name" ]; then
            mkdir "/srv/yt/downloads/$name"
        fi

        youtube-dl -o "/srv/yt/downloads/$name/$name.mp4" "$line" > /dev/null || { echo "Erreur lors du téléchargement de la vidéo $line."; exit 1; }
        youtube-dl --write-description --skip-download --youtube-skip-dash-manifest -o "/srv/yt/downloads/$name/description" "$line" > /dev/null
        current_time=$(date "+%Y/%m/%d %H:%M:%S")
        echo "[$current_time] Video $line was downloaded. File path : /srv/yt/downloads/$name/$name.mp4" > /var/log/yt/download.log
        echo "Video $line was downloaded."
        echo "File path : /srv/yt/downloads/$name/$name.mp4"
    fi
    sed -i '1d' $file
    done < "$file"
    sleep 10
done
