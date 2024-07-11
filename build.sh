#!/bin/bash

if ! command -v makelove &> /dev/null
then
    echo "makelove not found, installing..."
    pip install makelove
fi
makelove

if ! command -v emcc &> /dev/null
then
    echo "Emscripten not found, installing..."
    git clone https://github.com/emscripten-core/emsdk.git
    cd emsdk
    ./emsdk install latest
    ./emsdk activate latest
    source ./emsdk_env.sh
    cd ..
fi

if [ ! -d "love.js" ]; then
    echo "love.js not found, cloning..."
    git clone https://github.com/Davidobot/love.js.git
fi

zip -9 -r AmorFuncional2D.love . -x "*.git*" "build.sh" "push.sh" "itch" "*.md" "love.js/*" "emsdk/*"

cd love.js
npm install
npm run make
cp ../AmorFuncional2D.love .

if [ ! -d "dist" ]; then
    mkdir dist
fi

emcc -O2 --closure 1 --llvm-lto 1 -s WASM=1 -s USE_SDL=2 -s ASYNCIFY -o dist/index.html love.js -i AmorFuncional2D.love

mv AmorFuncional2D.love dist/
mv index.js dist/

cd ..
rm AmorFuncional2D.love

echo "Build complete! Files are in the love.js/dist directory."
