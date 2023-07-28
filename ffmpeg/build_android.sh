#!/bin/bash

. `pwd`/../android_env.sh $1 $2 $3
. `pwd`/build_options.sh

SRC_DIR=`pwd`/src/ffmpeg

FF_PREFIX=`pwd`/../prebuilt/android/ffmpeg/${ARCH}
FF_TARGET_OS=android
FF_CFLAGS="$CFLAGS"
FF_LDFLAGS="$LDFLAGS"

FF_DECODER_OPTIONS="mpeg4,mpegvideo,aac,mp3,gif,h264,h265,h264_mediacodec,hevc_mediacodec,mpeg4_mediacodec"
FF_MUXER_OPTIONS="mp4,mov"
FF_EXTERNAL_LIBRARY_OPTIONS=$4


case ${ARCH} in
    armeabi-v7a)
        FF_ARCH=armv7-a
        FF_OPTIMIZATION_OPTIONS="--enable-neon --enable-asm --enable-inline-asm --enable-mediacodec --enable-jni"
    ;;
    arm64-v8a)
        FF_ARCH=aarch64
        FF_OPTIMIZATION_OPTIONS="--enable-neon --enable-asm --enable-inline-asm --enable-mediacodec --enable-jni"
    ;;
    x86)
        FF_ARCH=i686
        FF_OPTIMIZATION_OPTIONS="--disable-neon --disable-asm --disable-inline-asm --enable-mediacodec --enable-jni"
    ;;
    x86_64)
        FF_ARCH=x86_64
        FF_OPTIMIZATION_OPTIONS="--disable-neon --disable-asm --disable-inline-asm --enable-mediacodec --enable-jni"
    ;;
    *)
        echo -e "(*) $ARCH not supported\n"
        exit 1
    ;;
esac

configure_make_ffmpeg
