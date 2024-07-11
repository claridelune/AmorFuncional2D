#!/bin/bash

zip -9 -r AmorFuncional2D-source.zip . -x "*.git*" "build.sh" "push.sh" "itch" "*.md" "love.js/*" "emsdk/*"

if ! command -v butler &> /dev/null
then
    echo "Butler not found, installing..."
    curl -L -o butler.zip https://broth.itch.ovh/butler/linux-amd64/head/butler.zip
    unzip butler.zip -d butler
    chmod +x butler/butler
    sudo mv butler/butler /usr/local/bin/
fi

butler push love.js/dist claridelune/yourgame:web
butler push build/BeatMap-windows claridelune/BeatMap:windows
butler push build/BeatMap-mac claridelune/BeatMap:mac
butler push build/BeatMap-linux claridelune/BeatMap:linux
butler push AmorFuncional2D-source.zip claridelune/BeatMap:source

echo "Deployment complete!"
