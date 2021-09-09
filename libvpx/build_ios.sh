#!/bin/bash

. `pwd`/../ios_env.sh $1 $2
. `pwd`/build_options.sh
SRC_DIR=`pwd`/src/libvpx

VPX_PREFIX=`pwd`/../prebuilt/ios/libvpx/${ARCH}
VPX_CFLAGS=$CFLAGS
VPX_CXXFLAGS=$CXXFLAGS
VPX_LIBC_PATH=$SDK_PATH

case ${ARCH} in
    armv7)
        VPX_TARGET="armv7-darwin-gcc"
        VPX_ASM_FLAGS="--disable-runtime-cpu-detect --enable-neon --enable-neon-asm"
    ;;
    armv7s)
        VPX_TARGET="armv7s-darwin-gcc"
        VPX_ASM_FLAGS="--disable-runtime-cpu-detect --enable-neon --enable-neon-asm"
    ;;
    arm64)
        VPX_TARGET="arm64-darwin-gcc"
        VPX_ASM_FLAGS="--disable-runtime-cpu-detect --enable-neon"
    ;;
    arm64e)
        VPX_TARGET="arm64-darwin-gcc"
        VPX_ASM_FLAGS="--disable-runtime-cpu-detect --enable-neon"
    ;;
    i386)
        VPX_TARGET="x86-iphonesimulator-gcc"
        VPX_ASM_FLAGS="--enable-runtime-cpu-detect --disable-avx512"
        LD=$CC
    ;;
    x86_64)
        VPX_TARGET="x86_64-iphonesimulator-gcc"
        LD=$CC
        VPX_ASM_FLAGS="--enable-runtime-cpu-detect --disable-avx512 --disable-sse --disable-sse2 --disable-mmx"
    ;;
    *)
        echo -e "(*) $ARCH not supported\n"
        exit 1
    ;;
esac

configure_make_libvpx