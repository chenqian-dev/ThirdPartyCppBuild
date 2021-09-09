#!/bin/bash

. `pwd`/../android_env.sh $1 $2 $3
. `pwd`/build_options.sh

# should build cpu_features first
pushd `pwd`/../cpu_features
./build_android.sh $1 $2 $3
popd

SRC_DIR=`pwd`/src/libvpx

VPX_PREFIX=`pwd`/../prebuilt/android/libvpx/${ARCH}
VPX_CFLAGS=$CFLAGS
VPX_CXXFLAGS=$CXXFLAGS
VPX_LIBC_PATH=$NDK_PATH

case ${ARCH} in
    armeabi-v7a)
        VPX_TARGET="armv7-android-gcc"
        VPX_ASM_FLAGS="--disable-runtime-cpu-detect --enable-neon --enable-neon-asm"
    ;;
    arm64-v8a)
        VPX_TARGET="arm64-android-gcc"
        VPX_ASM_FLAGS="--disable-runtime-cpu-detect --enable-neon"
    ;;
    x86)
        VPX_TARGET="x86-android-gcc"
        VPX_ASM_FLAGS="--enable-runtime-cpu-detect --disable-avx512 --disable-sse2"
    ;;
    x86_64)
        VPX_TARGET="x86_64-android-gcc"
        VPX_ASM_FLAGS="--enable-runtime-cpu-detect --disable-avx512 --disable-sse --disable-sse2 --disable-mmx"
    ;;
    *)
        echo -e "(*) $ARCH not supported\n"
        exit 1
    ;;
esac

configure_make_libvpx