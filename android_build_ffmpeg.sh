#!/bin/bash

function build_android
{

    pushd `pwd`/libvpx
    ./build_android.sh $1 $2 $3
    popd

    pushd `pwd`/libx264
    ./build_android.sh $1 $2 $3
    popd

    pushd `pwd`/ffmpeg
    ./build_android.sh $1 $2 $3 "libvpx,libx264"
    popd
}

build_android armeabi-v7a 16 /Users/chenqian/Library/Android/sdk/ndk/21.3.6528147
# build_android arm64-v8a 21 /Users/chenqian/Library/Android/sdk/ndk/21.3.6528147
# build_android x86 16 /Users/chenqian/Library/Android/sdk/ndk/21.3.6528147
# build_android x86_64 21 /Users/chenqian/Library/Android/sdk/ndk/21.3.6528147