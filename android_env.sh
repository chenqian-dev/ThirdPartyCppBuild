#!/bin/bash

# ARCH: armeabi-v7a, arm64-v8a, x86, x86_64
ARCH=$1
MIN_VERSION=$2
NDK_PATH=$3

if [[ -z ${ARCH} ]]; then
    echo -e "(*) ARCH not defined\n"
    exit 1
fi

if [[ -z ${MIN_VERSION} ]]; then
    echo -e "(*) MIN_VERSION not defined\n"
    exit 1
fi

if [[ -z ${NDK_PATH} ]]; then
    echo -e "(*) NDK_PATH not defined\n"
    exit 1
fi

echo -e "############################################ android env ############################################"
TOOLCHAIN=${NDK_PATH}/toolchains/llvm/prebuilt/linux-x86_64

echo -e "#\t ARCH=$ARCH"
echo -e "#\t MIN_VERSION=$MIN_VERSION"
echo -e "#\t NDK_PATH=$NDK_PATH"
echo -e "#\t TOOLCHAIN=$TOOLCHAIN"

case ${ARCH} in
    x86)
        export CFLAGS="-fPIC -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
        export CXXFLAGS="$CFLAGS"
        export LDFLAGS="-L${TOOLCHAIN}/i686-linux-android/lib -L${TOOLCHAIN}/sysroot/usr/lib/i686-linux-android/${MIN_VERSION} -L${TOOLCHAIN}/lib"
        export CC=${TOOLCHAIN}/bin/i686-linux-android${MIN_VERSION}-clang
        export CXX=${TOOLCHAIN}/bin/i686-linux-android${MIN_VERSION}-clang++
        export AR=${TOOLCHAIN}/bin/i686-linux-android-ar
        export AS=${TOOLCHAIN}/bin/i686-linux-android-as
        export LD=${TOOLCHAIN}/bin/i686-linux-android-ld
        export RANLIB=${TOOLCHAIN}/bin/i686-linux-android-ranlib
        export STRIP=${TOOLCHAIN}/bin/i686-linux-android-strip
        export NM=${TOOLCHAIN}/bin/i686-linux-android-nm
    ;;
    x86_64)
        export CFLAGS="-fPIC -march=x86-64 -msse4.2 -mpopcnt -m64 -mtune=intel"
        export CXXFLAGS="$CFLAGS"
        export LDFLAGS="-L${TOOLCHAIN}/x86_64-linux-android/lib -L${TOOLCHAIN}/sysroot/usr/lib/x86_64-linux-android/${MIN_VERSION} -L${TOOLCHAIN}/lib"
        export CC=${TOOLCHAIN}/bin/x86_64-linux-android${MIN_VERSION}-clang
        export CXX=${TOOLCHAIN}/bin/x86_64-linux-android${MIN_VERSION}-clang++
        export AR=${TOOLCHAIN}/bin/x86_64-linux-android-ar
        export AS=${TOOLCHAIN}/bin/x86_64-linux-android-as
        export LD=${TOOLCHAIN}/bin/x86_64-linux-android-ld
        export RANLIB=${TOOLCHAIN}/bin/x86_64-linux-android-ranlib
        export STRIP=${TOOLCHAIN}/bin/x86_64-linux-android-strip
        export NM=${TOOLCHAIN}/bin/x86_64-linux-android-nm
    ;;
    armeabi-v7a)
        export CFLAGS="-fPIC -mfloat-abi=softfp -mfpu=neon"
        export CXXFLAGS="$CFLAGS"
        export LDFLAGS="-L${TOOLCHAIN}/arm-linux-androideabi/lib -L${TOOLCHAIN}/sysroot/usr/lib/arm-linux-androideabi/${MIN_VERSION} -L${TOOLCHAIN}/lib"
        export CC=${TOOLCHAIN}/bin/armv7a-linux-androideabi${MIN_VERSION}-clang
        export CXX=${TOOLCHAIN}/bin/armv7a-linux-androideabi${MIN_VERSION}-clang++
        export AR=${TOOLCHAIN}/bin/arm-linux-androideabi-ar
        export AS=${TOOLCHAIN}/bin/arm-linux-androideabi-as
        export LD=${TOOLCHAIN}/bin/arm-linux-androideabi-ld
        export RANLIB=${TOOLCHAIN}/bin/arm-linux-androideabi-ranlib
        export STRIP=${TOOLCHAIN}/bin/arm-linux-androideabi-strip
        export NM=${TOOLCHAIN}/bin/arm-linux-androideabi-nm
    ;;
    arm64-v8a)
        export CFLAGS="-fPIC"
        export CXXFLAGS="$CFLAGS"
        export LDFLAGS="-L${TOOLCHAIN}/aarch64-linux-android/lib -L${TOOLCHAIN}/sysroot/usr/lib/aarch64-linux-android/${MIN_VERSION} -L${TOOLCHAIN}/lib"
        export CC=${TOOLCHAIN}/bin/aarch64-linux-android${MIN_VERSION}-clang
        export CXX=${TOOLCHAIN}/bin/aarch64-linux-android${MIN_VERSION}-clang++
        export AR=${TOOLCHAIN}/bin/aarch64-linux-android-ar
        export AS=${TOOLCHAIN}/bin/aarch64-linux-android-as
        export LD=${TOOLCHAIN}/bin/aarch64-linux-android-ld
        export RANLIB=${TOOLCHAIN}/bin/aarch64-linux-android-ranlib
        export STRIP=${TOOLCHAIN}/bin/aarch64-linux-android-strip
        export NM=${TOOLCHAIN}/bin/aarch64-linux-android-nm
    ;;
    *)
        echo -e "(*) $ARCH not supported\n"
        exit 1
    ;;
esac
echo -e "#\t CFLAGS=${CFLAGS}"
echo -e "#\t CXXFLAGS=${CXXFLAGS}"
echo -e "#\t LDFLAGS=${LDFLAGS}"
echo -e "#\t AR=${AR}"
echo -e "#\t CC=${CC}"
echo -e "#\t OBJC=${OBJC}"
echo -e "#\t CXX=${CXX}"
echo -e "#\t LD=${LD}"
echo -e "#\t RANLIB=${RANLIB}"
echo -e "#\t STRIP=${STRIP}"
echo -e "#\t AS=${AS}"

# pkg-config
export PKG_CONFIG_DIR=`pwd`/../prebuilt/android/pkg_config_dir/${ARCH}
if [ ! -d ${PKG_CONFIG_DIR} ]; then
    mkdir -p ${PKG_CONFIG_DIR}
fi
export PKG_CONFIG_PATH=${PKG_CONFIG_DIR}:${PKG_CONFIG_PATH}
echo -e "#\t PKG_CONFIG_DIR=${PKG_CONFIG_DIR}"
echo -e "#\t PKG_CONFIG_PATH=${PKG_CONFIG_PATH}"

# compile 
echo -e "############################################ android env ############################################\n\n"
