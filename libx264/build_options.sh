#!/bin/bash

function configure_make_libx264
{
    # check source
    if [ ! -d src/x264 ]; then
        mkdir -p src
        git clone https://code.videolan.org/videolan/x264.git src/x264 || exit 1
    fi

    pushd ${SRC_DIR}

    # check required args   
    if [[ -z ${X264_PREFIX} ]]; then
        echo -e "(*) X264_PREFIX not defined\n"
        exit 1
    fi
    if [[ -z ${X264_HOST} ]]; then
        echo -e "(*) X264_HOST not defined\n"
        exit 1
    fi
    # if [[ -z ${X264_CROSS_REFIX} ]]; then
    #     echo -e "(*) X264_CROSS_REFIX not defined\n"
    #     exit 1
    # fi
    if [[ -z ${X264_STSROOT} ]]; then
        echo -e "(*) X264_STSROOT not defined\n"
        exit 1
    fi
    # if [[ -z ${X264_ASM_FLAGS} ]]; then
    #     echo -e "(*) X264_ASM_FLAGS not defined\n"
    #     exit 1
    # fi
    
    make distclean
    
    ./configure \
        `# Standard options`\
        --prefix="${X264_PREFIX}" \
        --extra-cflags="${X264_CFLAGS}" \
        --extra-asflags="${X264_ASFLAGS}" \
        --extra-ldflags="${X264_LDFLAGS}" \
        `# Configuration options`\
        --disable-cli \
        --enable-static \
        `# Advanced options`\
        --enable-pic \
        `# Cross-compilation`\
        --host=$X264_HOST \
        --cross-prefix="$X264_CROSS_REFIX" \
        --sysroot="$X264_STSROOT" \
        $X264_ASM_FLAGS || exit 1

    make clean
    make -j8 || exit 1
    make install || exit 1

    cp x264.pc ${PKG_CONFIG_DIR} || exit 1

    popd
}