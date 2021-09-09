#!/bin/bash

function configure_make_libvpx
{

    # check source
    if [ ! -d src/libvpx ]; then
        mkdir -p src
        git clone https://github.com/webmproject/libvpx.git src/libvpx|| exit 1
    fi

    pushd ${SRC_DIR}
    
    # check required args   
    if [[ -z ${VPX_PREFIX} ]]; then
        echo -e "(*) VPX_PREFIX not defined\n"
        exit 1
    fi

    if [[ -z ${VPX_TARGET} ]]; then
        echo -e "(*) VPX_TARGET not defined\n"
        exit 1
    fi

    if [[ -z ${VPX_CFLAGS} ]]; then
        echo -e "(*) VPX_CFLAGS not defined\n"
        exit 1
    fi

    if [[ -z ${VPX_CXXFLAGS} ]]; then
        echo -e "(*) VPX_CXXFLAGS not defined\n"
        exit 1
    fi

    if [[ -z ${VPX_LIBC_PATH} ]]; then
        echo -e "(*) VPX_LIBC_PATH not defined\n"
        exit 1
    fi

    ./configure \
        --prefix="${VPX_PREFIX}" \
        `# Build options`\
        --target=$VPX_TARGET \
        --extra-cflags="$VPX_CFLAGS" \
        --extra-cxxflags="$VPX_CXXFLAGS" \
        --enable-pic \
        --disable-debug \
        `# Install options`\
        `# Advanced options`\
        --disable-examples \
        --disable-tools \
        --disable-docs \
        --disable-unit-tests \
        --libc="$VPX_LIBC_PATH" \
        --as=yasm \
        --enable-vp9-highbitdepth \
        --enable-better-hw-compatibility \
        --enable-vp8 \
        --enable-vp9 \
        --enable-postproc \
        --enable-vp9-postproc \
        $VPX_ASM_FLAGS \
        --disable-shared \
        --enable-static \
        --enable-small \
        --disable-webm-io || exit 1

    make clean
    make -j8 || exit 1
    make install || exit 1
    cp ./*.pc ${PKG_CONFIG_DIR} || exit 1
    popd
}
