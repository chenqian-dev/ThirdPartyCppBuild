#!/bin/bash

. `pwd`/../android_env.sh $1 $2 $3
. `pwd`/build_options.sh
SRC_DIR=`pwd`/src/x264

export AS="${CC}"
X264_CFLAGS=$CFLAGS
X264_LDFLAGS="-lc -lm $LDFLAGS"
X264_ASFLAGS=$CFLAGS
X264_PREFIX=`pwd`/../prebuilt/android/libx264/${ARCH}
X264_STSROOT="${TOOLCHAIN}/sysroot"

case ${ARCH} in
    armeabi-v7a)
        X264_ASM_FLAGS=""
        X264_HOST="arm-linux-androideabi"
    ;;
    arm64-v8a)
        X264_ASM_FLAGS=""
        X264_HOST="aarch64-linux-android"
    ;;
    x86)
        X264_ASM_FLAGS="--disable-asm"
        if ! [ -x "$(command -v nasm)" ]; then
            echo -e "(*) nasm command not found\n"
            exit 1
        fi
        export AS="$(command -v nasm)"
        X264_HOST="i686-linux-android"
    ;;
    x86_64)
        X264_ASM_FLAGS="--disable-asm"
        if ! [ -x "$(command -v nasm)" ]; then
            echo -e "(*) nasm command not found\n"
            exit 1
        fi
        export AS="$(command -v nasm)"
        X264_HOST="x86_64-linux-android"
    ;;
    *)
        echo -e "(*) $ARCH not supported\n"
        exit 1
    ;;
esac

configure_make_libx264
