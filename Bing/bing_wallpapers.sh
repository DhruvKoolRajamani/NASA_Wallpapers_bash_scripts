#!/bin/bash
# author: Whizzzkid (me@nishantarora.in)

# Base URL.
bing="http://www.bing.com"

# API end point.
api="/HPImageArchive.aspx?"

# Response Format (json|xml).
format="&format=js"

# For day (0=current; 1=yesterday... so on).
day="&idx=0"

# Market for image.
market="&mkt=en-US"

# API Constant (fetch how many).
const="&n=1"

# Image extension.
extn=".jpg"

# Size.
size="1920x1200"

# Collection Path.
path="$HOME/Pictures/Wallpapers/"

# Make it run just once (useful to run as a cron)
run_once=true

########################################################################
#### DO NOT EDIT BELOW THIS LINE #######################################
########################################################################

# Required Image Uri.
reqImg=$bing$api$format$day$market$const

while [ 1 ]
do
    
    # Logging.
    # if [ $isQuietFlagSet != "true" ]; then
    #     echo "Pinging Bing API..."
    # fi
    
    # Fetching API response.
    apiResp=$(curl -s $reqImg)
    if [ $? -gt 0 ]; then
        # if [ $isQuietFlagSet != "true" ]; then
        #     echo "Ping failed!"
        # fi
        exit 1
    fi
    
    # Default image URL in case the required is not available.
    defImgURL=$bing$(echo $apiResp | grep -oP "url\":\"[^\"]*" | cut -d "\"" -f 3)
    
    # Req image url (raw).
    reqImgURL=$bing$(echo $apiResp | grep -oP "urlbase\":\"[^\"]*" | cut -d "\"" -f 3)"_"$size$extn
    
    # Image copyright.
    copyright=$(echo $apiResp | grep -oP "copyright\":\"[^\"]*" | cut -d "\"" -f 3)
    
    # Checking if reqImgURL exists.
    if ! wget --quiet --spider --max-redirect 0 $reqImgURL; then
        reqImgURL=$defImgURL
    fi
    
    # Logging.
    # if [ $isQuietFlagSet != "true" ]; then
    #     echo "Bing Image of the day: $reqImgURL"
    # fi
    
    # Getting Image Name.
    imgName=${reqImgURL##*/}
    
    # Create Path Dir.
    mkdir -p $path
    
    # Saving Image to collection.
    # if [ -e $path$imgName ]; then
    #     shopt -s nullglob
    #     arrayPictures=($path/*.jpg)
    #     randImg=$(random_generator ${#arrayPictures[@]})
    #     echo "Selecting random $randImg"
    #     echo ${arrayPictures[randImg]} | rev | cut -d'/' -f-1 | rev > temp.txt
    #     finImgName=$(cat temp.txt)
    #     echo "Selecting $finImgName"
    #     # rm temp.txt
    #     wallpaper=${arrayPictures[randImg]}
    # else
    #     curl -L -s -o $path$imgName $reqImgURL
    #     wallpaper=$path$imgName

    #     # Logging.
    #     echo "Saving image to $path$imgName"
        
    #     # Writing copyright.
    #     echo "$copyright" > $path${imgName/%.jpg/.txt}
    # fi

    curl -L -s -o $path$imgName $reqImgURL
    wallpaper=$path$imgName

    # Logging.
    # if [ $isQuietFlagSet != "true" ]; then
    #     echo "Saving image to $path$imgName"
    # fi
    
    # Writing copyright.
    # echo "$copyright" > $path${imgName/%.jpg/.txt}
    
    # If -1 option was passed just run once
    if [ $run_once == true ];then
        break
    fi
    
    # Re-checks for updates every 3 hours.
    sleep 10800
done
