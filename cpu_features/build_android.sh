#!/bin/bash
. `pwd`/../android_env.sh $1 $2 $3
SRC_DIR=`pwd`/src/cpu_features

# check source
if [ ! -d ${SRC_DIR} ]; then
    mkdir -p src
    git clone https://github.com/google/cpu_features.git src/cpu_features || exit 1
fi

# gen pkg config
create_cpufeatures_package_config() {
    cat > "${PKG_CONFIG_DIR}/cpu-features.pc" << EOF
prefix=${PREFIX}
exec_prefix=\${prefix}/bin
libdir=\${prefix}/lib
includedir=\${prefix}/include/ndk_compat

Name: cpufeatures
URL: https://github.com/google/cpu_features
Description: cpu_features Android compatibility library
Version: 1.${MIN_VERSION}

Requires:
Libs: -L\${libdir} -lndk_compat
Cflags: -I\${includedir}
EOF
}

export CFLAGS="$CFLAGS"
export CXXFLAGS="$CFLAGS -std=c++11"

PREFIX=`pwd`/../prebuilt/android/cpu_features/${ARCH}
ANDROID_BUILD_DIR=`pwd`/build/android/${ARCH}

pushd ${SRC_DIR}

cmake \
  -DCMAKE_TOOLCHAIN_FILE=${NDK_PATH}/build/cmake/android.toolchain.cmake \
  -H${SRC_DIR} \
  -B${ANDROID_BUILD_DIR} \
  -DANDROID_ABI=${ARCH} \
  -DANDROID_PLATFORM=android-${MIN_VERSION} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DBUILD_TESTING=OFF \
  -DBUILD_PIC=ON || exit 1

make clean
make -C ${ANDROID_BUILD_DIR} install || exit 1
create_cpufeatures_package_config
popd