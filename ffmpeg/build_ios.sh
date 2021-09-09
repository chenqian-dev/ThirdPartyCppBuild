#!/bin/bash

. `pwd`/../ios_env.sh $1 $2
. `pwd`/build_options.sh

SRC_DIR=`pwd`/src/ffmpeg

FF_PREFIX=`pwd`/../prebuilt/ios/ffmpeg/${ARCH}
FF_TARGET_OS=darwin
FF_CFLAGS="$CFLAGS"
FF_LDFLAGS="$LDFLAGS"

FF_DECODER_OPTIONS="mpeg4,mpegvideo,aac,mp3,gif,h264,h265"
FF_MUXER_OPTIONS="mp4,mov"
FF_EXTERNAL_LIBRARY_OPTIONS=$3

case ${ARCH} in
    armv7)
        FF_ARCH=armv7
        export AS="${SRC_DIR}/gas-preprocessor.pl -- ${CC}"
        FF_OPTIMIZATION_OPTIONS="--enable-neon --enable-asm"
    ;;
    armv7s)
        FF_ARCH=armv7s
        export AS="${SRC_DIR}/gas-preprocessor.pl -- ${CC}"
        FF_OPTIMIZATION_OPTIONS="--enable-neon --enable-asm"
    ;;
    arm64)
        FF_ARCH=arm64
        export AS="${SRC_DIR}/gas-preprocessor.pl -arch aarch64 -- ${CC}"
        FF_OPTIMIZATION_OPTIONS="--enable-neon --enable-asm"
    ;;
    arm64e)
        FF_ARCH=arm64e
        export AS="${SRC_DIR}/gas-preprocessor.pl -arch aarch64 -- ${CC}"
        FF_OPTIMIZATION_OPTIONS="--enable-neon --enable-asm"
    ;;
    i386)
        FF_ARCH=i386
        export AS="${CC}"
        FF_OPTIMIZATION_OPTIONS="--disable-neon --disable-asm"
    ;;
    x86_64)
        FF_ARCH=x86_64
        export AS="${CC}"
        FF_OPTIMIZATION_OPTIONS="--disable-neon --disable-asm"
    ;;
    *)
        echo -e "(*) $ARCH not supported\n"
        exit 1
    ;;
esac

configure_make_ffmpeg

