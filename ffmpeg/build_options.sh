
#!/bin/bash

function build_external_library_options_internal
{
    externel_library_array=(${FF_EXTERNAL_LIBRARY_OPTIONS//,/ })  
    for libname in ${externel_library_array[@]}
    do
        case $libname in
            libvpx)
                FF_CFLAGS+=" $(pkg-config --cflags vpx)"
                FF_LDFLAGS+=" $(pkg-config --libs --static vpx)"
                if [ "$FF_TARGET_OS" == "android" ]; then
                    FF_CFLAGS+=" $(pkg-config --libs cpu-features)"
                fi
                FF_ENCODER_OPTIONS+=",libvpx_vp9,libvpx_vp8"
                FF_DECODER_OPTIONS+=",libvpx_vp9,libvpx_vp8"
                FF_EXTERNAL_LIBRARY_OPTIONS_INTERNAL+=" --enable-libvpx"
            ;;
            libx264)
                FF_CFLAGS+=" $(pkg-config --cflags x264)"
                FF_LDFLAGS+=" $(pkg-config --libs --static x264)"
                FF_ENCODER_OPTIONS+=",libx264"
                FF_EXTERNAL_LIBRARY_OPTIONS_INTERNAL+=" --enable-libx264 --enable-gpl"
            ;;
            openh264)
                FF_CFLAGS+=" $(pkg-config --cflags openh264)"
                FF_LDFLAGS+=" $(pkg-config --libs --static openh264)"
                FF_ENCODER_OPTIONS+=",libopenh264"
                FF_DECODER_OPTIONS+=",libopenh264"
                FF_EXTERNAL_LIBRARY_OPTIONS_INTERNAL+=" --enable-libopenh264"
            ;;
        esac
    done
}


function configure_make_ffmpeg
{
    # check source
    if [ ! -d src/ffmpeg ]; then
        mkdir -p src
        git clone https://git.ffmpeg.org/ffmpeg.git src/ffmpeg || exit 1
    fi

    # check gas-preprocessor
    if [ ! -f "${SRC_DIR}/gas-preprocessor.pl" ]; then
        (curl -L https://github.com/libav/gas-preprocessor/raw/master/gas-preprocessor.pl \
            -o ${SRC_DIR}/gas-preprocessor.pl \
            && chmod +x ${SRC_DIR}/gas-preprocessor.pl) \
            || exit 1
    fi

    pushd ${SRC_DIR}

    # check required args
    if [[ -z ${FF_PREFIX} ]]; then
        echo -e "(*) FF_PREFIX not defined\n"
        exit 1
    fi

    if [[ -z ${FF_ARCH} ]]; then
        echo -e "(*) FF_ARCH not defined\n"
        exit 1
    fi

    if [[ -z ${FF_TARGET_OS} ]]; then
        echo -e "(*) FF_TARGET_OS not defined\n"
        exit 1
    fi

    if [[ -z ${FF_CFLAGS} ]]; then
        echo -e "(*) FF_CFLAGS not defined\n"
        exit 1
    fi

    if [[ -z ${FF_LDFLAGS} ]]; then
        echo -e "(*) FF_LDFLAGS not defined\n"
        exit 1
    fi

    if [[ -z ${FF_MUXER_OPTIONS} ]]; then
        echo -e "(*) FF_MUXER_OPTIONS not defined\n"
    fi

    if [[ -z ${FF_EXTERNAL_LIBRARY_OPTIONS} ]]; then
        echo -e "(*) FF_EXTERNAL_LIBRARY_OPTIONS not defined\n"
    fi

    if [[ -z ${FF_OPTIMIZATION_OPTIONS} ]]; then
        echo -e "(*) FF_OPTIMIZATION_OPTIONS not defined\n"
    fi

    # prepare external library
    build_external_library_options_internal

    ./configure \
        `# Standard options`\
        --prefix=$FF_PREFIX \
        `# Licensing options`\
        --enable-version3 \
        `# Configuration options`\
        --enable-static \
        --enable-shared \
        --enable-small \
        --disable-all \
        `# Program options`\
        --disable-programs \
        --disable-ffmpeg \
        --disable-ffplay \
        --disable-ffprobe \
        `# Documentation options`\
        --disable-doc \
        `# Component options`\
        --enable-avformat \
        --enable-swresample \
        --enable-avcodec \
        --enable-swscale \
        `# Individual component options`\
        --disable-everything \
        --enable-bsfs \
        --enable-protocols \
        --enable-demuxers \
        --enable-decoder=$FF_DECODER_OPTIONS \
        --enable-encoder=$FF_ENCODER_OPTIONS \
        --enable-muxer=$FF_MUXER_OPTIONS \
        `# External library support`\
        $FF_EXTERNAL_LIBRARY_OPTIONS_INTERNAL \
        `# Toolchain options`\
        --arch=$FF_ARCH \
        --cc=$CC \
        --cxx=$CXX \
        --enable-cross-compile \
        --target-os=$FF_TARGET_OS \
        --extra-cflags="$FF_CFLAGS" \
        --extra-ldflags="$FF_LDFLAGS" \
        `# Optimization options`\
        $FF_OPTIMIZATION_OPTIONS \
        `# Developer options`\
        --disable-debug \
        --enable-optimizations || exit 1



    # make
    make clean
    make -j8 || exit 1
    make install || exit 1

    popd
}