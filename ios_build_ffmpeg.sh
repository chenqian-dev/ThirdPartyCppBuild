#!/bin/bash

function build_ios
{

    pushd `pwd`/libvpx
    ./build_ios.sh $1 $2
    popd

    pushd `pwd`/libx264
    ./build_ios.sh $1 $2
    popd

    pushd `pwd`/ffmpeg
    ./build_ios.sh $1 $2 "libvpx,libx264"
    popd
}

build_ios armv7 8.0
# build_ios arm64 8.0
# build_ios x86_64 8.0