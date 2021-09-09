#!/bin/bash

# ARCH: armv7 armv7s arm64 arm64e i386 x86_64
ARCH=$1
MIN_VERSION=$2

# check required args   
if [[ -z ${ARCH} ]]; then
    echo -e "(*) ARCH not defined\n"
    exit 1
fi

if [[ -z ${MIN_VERSION} ]]; then
    echo -e "(*) MIN_VERSION not defined\n"
    exit 1
fi

echo -e "############################################ ios env ############################################"
echo -e "#\t ARCH=$ARCH"
echo -e "#\t MIN_VERSION=$MIN_VERSION"

case ${ARCH} in
    i386 | x86_64)
        # sdk name
        SDK_NAME="iphonesimulator"
        # sdk path
        SDK_PATH="$(xcrun --sdk $SDK_NAME --show-sdk-path)"
        # flags
        export CFLAGS="-fPIC -isysroot $SDK_PATH -arch $ARCH -mios-simulator-version-min=$MIN_VERSION"
        export CXXFLAGS="$CFLAGS"
        export LDFLAGS="-isysroot $SDK_PATH -arch $ARCH -mios-simulator-version-min=$MIN_VERSION"
    ;;
    armv7 | armv7s | arm64 | arm64e)
        # sdk name
        SDK_NAME="iphoneos"
        # sdk path
        SDK_PATH="$(xcrun --sdk $SDK_NAME --show-sdk-path)"
        # flags
        export CFLAGS="-fPIC -isysroot $SDK_PATH -arch $ARCH -mios-version-min=$MIN_VERSION  -fembed-bitcode"
        export CXXFLAGS="$CFLAGS"
        export LDFLAGS="-isysroot $SDK_PATH -arch $ARCH -mios-version-min=$MIN_VERSION  -fembed-bitcode"
    ;;
    *)
        echo -e "(*) $ARCH not supported\n"
        exit 1
    ;;
esac
echo -e "#\t SDK_NAME=${SDK_NAME}"
echo -e "#\t SDK_PATH=${SDK_PATH}"
echo -e "#\t CFLAGS=${CFLAGS}"
echo -e "#\t CXXFLAGS=${CXXFLAGS}"
echo -e "#\t LDFLAGS=${LDFLAGS}"

# pkg-config
export PKG_CONFIG_DIR=`pwd`/../prebuilt/ios/pkg_config_dir/${ARCH}
if [ ! -d ${PKG_CONFIG_DIR} ]; then
    mkdir -p ${PKG_CONFIG_DIR}
fi
export PKG_CONFIG_PATH=${PKG_CONFIG_DIR}
echo -e "#\t PKG_CONFIG_DIR=${PKG_CONFIG_DIR}"
echo -e "#\t PKG_CONFIG_PATH=${PKG_CONFIG_PATH}"

# compile 
export AR="$(xcrun --sdk $SDK_NAME -f ar)"
export CC="$(xcrun --sdk $SDK_NAME -f clang)"
export OBJC="$(xcrun --sdk $SDK_NAME -f clang)"
export CXX="$(xcrun --sdk $SDK_NAME -f clang++)"
export LD="$(xcrun --sdk $SDK_NAME -f ld)"
export RANLIB="$(xcrun --sdk $SDK_NAME -f ranlib)"
export STRIP="$(xcrun --sdk $SDK_NAME -f strip)"
export AS="$(xcrun --sdk $SDK_NAME -f as)"    
echo -e "#\t AR=${AR}"
echo -e "#\t CC=${CC}"
echo -e "#\t OBJC=${OBJC}"
echo -e "#\t CXX=${CXX}"
echo -e "#\t LD=${LD}"
echo -e "#\t RANLIB=${RANLIB}"
echo -e "#\t STRIP=${STRIP}"
echo -e "#\t AS=${AS}"
echo -e "############################################ ios env ############################################\n\n"