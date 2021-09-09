#!/bin/bash

. `pwd`/../ios_env.sh $1 $2
. `pwd`/build_options.sh
SRC_DIR=`pwd`/src/x264

X264_CFLAGS=$CFLAGS
X264_LDFLAGS=$LDFLAGS
X264_ASFLAGS=$CFLAGS

LOCAL_GAS_PREPROCESSOR="${SRC_DIR}/tools/gas-preprocessor.pl"
case ${ARCH} in
    armv7)
        export AS="${LOCAL_GAS_PREPROCESSOR} -arch arm -- ${CC}"
        X264_ASM_FLAGS=""
        X264_HOST="armv7-ios-darwin"
    ;;
    armv7s)
        export AS="${LOCAL_GAS_PREPROCESSOR} -arch arm -- ${CC}"
        X264_ASM_FLAGS=""
        X264_HOST="armv7s-ios-darwin"
    ;;
    arm64)
        export AS="${LOCAL_GAS_PREPROCESSOR} -arch aarch64 -- ${CC}"
        X264_ASM_FLAGS=""
        X264_HOST="aarch64-ios-darwin"
    ;;
    arm64e)
        export AS="${LOCAL_GAS_PREPROCESSOR} -arch aarch64 -- ${CC}"
        X264_ASM_FLAGS=""
        X264_HOST="aarch64-ios-darwin"
    ;;
    i386)
        export AS="${CC}"
        X264_ASM_FLAGS="--disable-asm"
        if ! [ -x "$(command -v nasm)" ]; then
            echo -e "(*) nasm command not found\n"
            exit 1
        fi
        export AS="$(command -v nasm)"
        X264_HOST="x86-ios-darwin"
    ;;
    x86_64)
        export AS="${CC}"
        X264_ASM_FLAGS="--disable-asm"
        if ! [ -x "$(command -v nasm)" ]; then
            echo -e "(*) nasm command not found\n"
            exit 1
        fi
        export AS="$(command -v nasm)"
        X264_HOST="x86_64-ios-darwin"
    ;;
    *)
        echo -e "(*) $ARCH not supported\n"
        exit 1
    ;;
esac


X264_PREFIX=`pwd`/../prebuilt/ios/libx264/${ARCH}
X264_STSROOT="$SDK_PATH"

configure_make_libx264
