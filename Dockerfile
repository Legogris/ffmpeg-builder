FROM lsiodev/toolchain

# package versions
# pay special attention to the x264 variable
# x264 version needs to be everything after /snapshots/ in the url from videolan.org excluding .tar.bz2
# used in conjunction with SOURCE_URL_LIST variable, add URL (including variable(s) from this list there
# and set the version to download here

ARG FDK_AAC_VER="0.1.5"
ARG FFMPEG_VER="3.3.3"
ARG FONTCONFIG_VER="2.12.4"
ARG FREETYPE_VER="2.8"
ARG FREI0R_VER="1.6.1"
ARG FRIBIDI_VER="0.19.7"
ARG GIFLIB_VER="5.1.4"
ARG HARFBUZZ_VER="1.5.0"
ARG LAME_VER="3.99.5"
ARG LAME_VER_BRANCH="3.99"
ARG LCMS2_VER="2.8"
ARG LIBASS_VER="0.13.7"
ARG LIBJPEG_TURBO_VER="1.5.2"
ARG LIBOGG_VER="1.3.2"
ARG LIBPNG_VER="1.6.31"
ARG LIBTHEORA_VER="1.1.1"
ARG LIBTIFF_VER="4.0.8"
ARG LIBVORBIS_VER="1.3.5"
ARG LIBVPX_VER="1.6.1"
ARG LIBWEBP_VER="0.6.0"
ARG OPENCORE_AMR_VER="0.1.5"
ARG OPENJPEG_VER="2.2.0"
ARG OPENSSL_VER="1.0.2l"
ARG OPUS_VER="1.2.1"
ARG RTMP_COMMIT="fa8646daeb19dfd12c181f7d19de708d623704c0"
ARG SOXR_VER="0.1.2"
ARG SPEEX_VER="1.2.0"
ARG SPEEX_DSP_VER="1.2rc3"
ARG VIDSTAB_VER="1.1.0"
ARG VO_AMRWBENC_VER="0.1.3"
ARG X264_VER="x264-snapshot-20170822-2245-stable"
ARG X265_VER="2.5"
ARG XVID_VER="1.3.4"
ARG ZIMG_VER="2.5.1"
ARG ZLIB_VER="1.2.11"

# source url list
# use variables from package versions list
# each line must end with a space and a slash apart from the last line which must end with a "
# avoid leading or trailing spaces as they will interpreted as newlines in the fetch stage and may cause errors

ARG SOURCE_URL_LIST="\
https://downloads.sourceforge.net/opencore-amr/fdk-aac-${FDK_AAC_VER}.tar.gz \
http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VER}.tar.bz2 \
https://www.freedesktop.org/software/fontconfig/release/fontconfig-${FONTCONFIG_VER}.tar.bz2 \
https://downloads.sourceforge.net/freetype/freetype-${FREETYPE_VER}.tar.bz2 \
https://files.dyne.org/frei0r/releases/frei0r-plugins-${FREI0R_VER}.tar.gz \
http://fribidi.org/download/fribidi-${FRIBIDI_VER}.tar.bz2 \
https://downloads.sourceforge.net/giflib/giflib-${GIFLIB_VER}.tar.bz2 \
https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${HARFBUZZ_VER}.tar.bz2 \
http://downloads.sourceforge.net/project/lame/lame/${LAME_VER_BRANCH}/lame-${LAME_VER}.tar.gz \
https://downloads.sourceforge.net/lcms/lcms2-${LCMS2_VER}.tar.gz \
https://github.com/libass/libass/archive/${LIBASS_VER}.tar.gz \
https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-${LIBJPEG_TURBO_VER}.tar.gz \
http://downloads.xiph.org/releases/ogg/libogg-${LIBOGG_VER}.tar.gz \
https://downloads.sourceforge.net/libpng/libpng-${LIBPNG_VER}.tar.xz \
https://downloads.xiph.org/releases/theora/libtheora-${LIBTHEORA_VER}.tar.xz \
http://download.osgeo.org/libtiff/tiff-${LIBTIFF_VER}.tar.gz \
https://downloads.xiph.org/releases/vorbis/libvorbis-${LIBVORBIS_VER}.tar.xz \
https://github.com/webmproject/libvpx/archive/v${LIBVPX_VER}.tar.gz \
http://downloads.webmproject.org/releases/webp/libwebp-${LIBWEBP_VER}.tar.gz \
https://sourceforge.net/projects/opencore-amr/files/opencore-amr/opencore-amr-${OPENCORE_AMR_VER}.tar.gz/download \
https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG_VER}.tar.gz \
https://www.openssl.org/source/openssl-${OPENSSL_VER}.tar.gz \
https://archive.mozilla.org/pub/opus/opus-${OPUS_VER}.tar.gz \
https://git.ffmpeg.org/gitweb/rtmpdump.git/snapshot/${RTMP_COMMIT}.tar.gz \
https://sourceforge.net/projects/soxr/files/soxr-${SOXR_VER}-Source.tar.xz \
https://downloads.xiph.org/releases/speex/speex-${SPEEX_VER}.tar.gz \
https://downloads.xiph.org/releases/speex/speexdsp-${SPEEX_DSP_VER}.tar.gz \
https://github.com/georgmartius/vid.stab/archive/v${VIDSTAB_VER}.tar.gz \
https://sourceforge.net/projects/opencore-amr/files/vo-amrwbenc/vo-amrwbenc-${VO_AMRWBENC_VER}.tar.gz \
https://download.videolan.org/x264/snapshots/${X264_VER}.tar.bz2 \
https://bitbucket.org/multicoreware/x265/downloads/x265_${X265_VER}.tar.gz \
http://downloads.xvid.org/downloads/xvidcore-${XVID_VER}.tar.gz \
https://github.com/sekrit-twc/zimg/archive/release-${ZIMG_VER}.tar.gz \
https://github.com/madler/zlib/archive/v${ZLIB_VER}.tar.gz"

# environment variables
ARG BUILD_ROOT="/tmp/build-root"
ARG SOURCE_FOLDER="/tmp/source-folder"

# copy patches
COPY patches/ /tmp/patches/

# make folders
RUN \
 mkdir -p \
	${BUILD_ROOT} \
	${SOURCE_FOLDER} && \
 rm -rf ${BUILD_ROOT}/* \
	${SOURCE_FOLDER}/*

# fetch source code
RUN set -ex && \
 echo $SOURCE_URL_LIST | tr " " "\n" >> /tmp/wget-list && \
 wget \
	--tries=5 \
	-P ${SOURCE_FOLDER} \
	-i /tmp/wget-list

# unpack source codes
RUN set -ex && \
 for file in ${SOURCE_FOLDER}/* ; do tar xvf $file -C ${BUILD_ROOT} ; done

# attempt to set number of cores available and if 4 or more available set number for make to use
# as one less than actual available, if 6 or more set to two less than available, otherwise use all cores
RUN \
 CPU_CORES=$( < /proc/cpuinfo grep -c processor ) || echo "failed cpu look up" && \
 if echo $CPU_CORES | grep -E  -q '^[0-9]+$'; then \
        	: ; \
	if [ "$CPU_CORES" -gt 7 ]; then \
		CPU_CORES=$(( CPU_CORES  / 2 )); \
	elif [ "$CPU_CORES" -gt 5 ]; then \
		CPU_CORES=$(( CPU_CORES  - 2 )); \
	elif [ "$CPU_CORES" -gt 3 ]; then \
		CPU_CORES=$(( CPU_CORES  - 1 )); \
	fi; \
 else CPU_CORES="1"; \
 fi && \

 echo "$CPU_CORES" > /tmp/cpu-cores

# compile xvid
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/xvidcore*/build/generic && \
 ./configure \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile libvpx
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/libvpx-${LIBVPX_VER} && \
 sed -i 's/cp -p/cp/' build/make/Makefile && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile opencore_amr
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/opencore-amr-${OPENCORE_AMR_VER} && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile vo-amrwbenc
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/vo-amrwbenc-${VO_AMRWBENC_VER} && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile soxr
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/soxr-${SOXR_VER}-Source && \
 cmake -G "Unix Makefiles" \
	-DBUILD_SHARED_LIBS:bool=off -DWITH_OPENMP:bool=off \
	-DBUILD_TESTS:bool=off \
	-DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" \
	-Wno-dev && \
 make -j $CPU_CORES && \
 make install

# compile opus
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/opus-${OPUS_VER} && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile fdk-aac
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/fdk-aac-${FDK_AAC_VER} && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile libpng
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/libpng-${LIBPNG_VER} && \
 LIBS=-lpthread ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile freetype 1st pass
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/freetype-${FREETYPE_VER} && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" \
	--without-harfbuzz && \
 make -j $CPU_CORES && \
 make install && \
 ln -s "$HOME/ffmpeg_build"/include/freetype2 "$HOME/ffmpeg_build"/include/freetype2/freetype

# compile harfbuzz 1st pass
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/harfbuzz-${HARFBUZZ_VER} && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile freetype 2nd pass
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/freetype-${FREETYPE_VER} && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install && \
 ln -s "$HOME/ffmpeg_build"/include/freetype2 "$HOME/ffmpeg_build"/include/freetype2/freetype

# compile harfbuzz 2nd pass
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/harfbuzz-${HARFBUZZ_VER} && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile fontconfig
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/fontconfig-${FONTCONFIG_VER} && \
 ./configure \
	--disable-docs \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile fribidi
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/fribidi-${FRIBIDI_VER} && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile libass
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/libass-${LIBASS_VER} && \
 ./autogen.sh && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile frei0r-plugins
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 mkdir -p \
	${BUILD_ROOT}/frei0r-plugins-${FREI0R_VER}/build && \
 cd ${BUILD_ROOT}/frei0r-plugins-${FREI0R_VER}/build && \
 cmake -G "Unix Makefiles" \
	-DBUILD_SHARED_LIBS=OFF \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" \
	-Wno-dev .. && \
 make -j $CPU_CORES && \
 make install

# compile libjpeg-turbo
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/libjpeg-turbo-${LIBJPEG_TURBO_VER}  && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" \
	--with-jpeg8 && \
 make -j $CPU_CORES && \
 make install

# compile libtiff
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cp /tmp/patches/config_guess/config.* ${BUILD_ROOT}/tiff-${LIBTIFF_VER}/config/ && \
 cd ${BUILD_ROOT}/tiff-${LIBTIFF_VER} && \
 ./configure \
	--disable-shared \
	--enable-jpeg \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" \
	--with-jpeg-include-dir="$HOME/ffmpeg_build/include" \
	--with-jpeg-lib-dir="$HOME/ffmpeg_build/lib" && \
 make -j $CPU_CORES && \
 make install

# compile little cms2
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/lcms2-${LCMS2_VER} && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" \
	--with-jpeg="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile openjpeg
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/openjpeg-${OPENJPEG_VER} && \
 cmake -G "Unix Makefiles" \
	-DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" \
# 	-DBUILD_SHARED_LIBS:bool=off \
	-DBUILD_THIRDPARTY=on && \
 make -j $CPU_CORES && \
 make install

# compile zlib
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/zlib-${ZLIB_VER} && \
 ./configure \
	--prefix="$HOME/ffmpeg_build" \
	--static && \
 make -j $CPU_CORES && \
 make install

# compile giflib
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/giflib-${GIFLIB_VER} && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile libwebp
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/libwebp-${LIBWEBP_VER} && \
 ac_cv_search_png_get_libpng_ver="none required" \
 LIBPNG_CONFIG="$HOME/ffmpeg_build/bin/libpng-config" \
 ./configure \
	--disable-shared \
	--enable-libwebpdecoder \
	--enable-libwebpdemux \
	--enable-libwebpextras \
	--enable-libwebpmux \
	--enable-static \
	--enable-swap-16bit-csp \
	--prefix="$HOME/ffmpeg_build" \
	--with-gifincludedir="$HOME/ffmpeg_build/include" \
	--with-giflibdir="$HOME/ffmpeg_build/lib" \
	--with-jpegincludedir="$HOME/ffmpeg_build/include" \
	--with-jpeglibdir="$HOME/ffmpeg_build/lib" \
	--with-pkgconfigdir="$HOME/ffmpeg_build/lib/pkgconfig" \
	--with-pngincludedir="$HOME/ffmpeg_build/include" \
	--with-tiffincludedir="$HOME/ffmpeg_build/include" \
	--with-tifflibdir="$HOME/ffmpeg_build/lib" && \
 make -j $CPU_CORES && \
 make install

# compile openssl
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/openssl-${OPENSSL_VER} && \
 ./config \
	no-idea \
	no-mdc2 \
	no-rc5 \
	no-shared \
	--openssldir="$HOME/ffmpeg_build/etc/ssl" \
	--prefix="$HOME/ffmpeg_build" \
	zlib -I"$HOME/ffmpeg_build/include" -L"$HOME/ffmpeg_build/lib" && \
 make depend && \
 make -j $CPU_CORES && \
 make install

# compile rtmp
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 RTMP_VER=$(printf "%.7s" $RTMP_COMMIT) && \
 cd ${BUILD_ROOT}/rtmpdump-${RTMP_VER} && \
 make \
	SHARED= \
	SYS=posix \
	XCFLAGS="-fpic -I$HOME/ffmpeg_build/include" \
	XLDFLAGS=-L"$HOME/ffmpeg_build/lib" \
	XLIBS=-ldl && \
 make install \
	prefix=$HOME/ffmpeg_build \
	SHARED=

# compile libogg
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/libogg-${LIBOGG_VER} && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile speex
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/speex-${SPEEX_VER} && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile speexdsp
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/speexdsp-${SPEEX_DSP_VER} && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile libvorbis
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/libvorbis-${LIBVORBIS_VER} && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile libtheora
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/libtheora-${LIBTHEORA_VER} && \
 sed -i 's/png_\(sizeof\)/\1/g' examples/png2theora.c && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile lame
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/lame-${LAME_VER} && \
 ./configure \
	--disable-shared \
	--enable-mp3rtp \
	--enable-nasm \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile zimg
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/zimg-release-${ZIMG_VER} && \
 ./autogen.sh && \
 ./configure \
	--disable-shared \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile vidstab
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/vid.stab-${VIDSTAB_VER} && \
 sed -i "s/BUILD_SHARED_LIBS/BUILD_STATIC_LIBS/" ./CMakeLists.txt && \
 cmake -G "Unix Makefiles" \
	-DCMAKE_INSTALL_PREFIX:PATH="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile x264
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/x264-snapshot* && \
 ./configure \
	--bindir="$HOME/bin" \
	--disable-opencl \
	--enable-static \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# compile x265
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/x265_${X265_VER}/build/linux && \
 cmake -G "Unix Makefiles" \
	-DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" \
	-DENABLE_SHARED:bool=off \
	../../source && \
 make -j $CPU_CORES && \
 make install

# compile ffmpeg
RUN set -ex && CPU_CORES=$( cat /tmp/cpu-cores ) && export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" && \
 cd ${BUILD_ROOT}/ffmpeg* && \
 for i in /tmp/patches/ffmpeg/*.patch; do patch -p1 -i $i; done && \
 ./configure \
	--bindir="$HOME/bin" \
	--disable-debug \
	--disable-doc \
	--enable-ffplay \
	--enable-ffserver \
	--enable-fontconfig \
	--enable-frei0r \
	--enable-gpl \
	--enable-libass \
	--enable-libfdk-aac \
	--enable-libfreetype \
	--enable-libfribidi \
	--enable-libmp3lame \
	--enable-libopencore-amrnb \
	--enable-libopencore-amrwb \
	--enable-libopenjpeg \
	--enable-libopus \
	--enable-librtmp \
	--enable-libsoxr \
	--enable-libspeex \
	--enable-libtheora \
	--enable-libvidstab \
	--enable-libvo-amrwbenc \
	--enable-libvorbis \
	--enable-libvpx \
	--enable-libwebp \
	--enable-libx264 \
	--enable-libx265 \
	--enable-libxvid \
	--enable-libzimg \
	--enable-nonfree \
	--enable-openssl \
	--enable-pic \
#	--enable-vaapi \
	--enable-version3 \
	--extra-cflags="-I$HOME/ffmpeg_build/include" \
#	--extra-ldexeflags="-static" \
	--extra-ldflags="-L$HOME/ffmpeg_build/lib" \
	--pkg-config-flags="--static" \
	--prefix="$HOME/ffmpeg_build" && \
 make -j $CPU_CORES && \
 make install

# archive artefacts
RUN \
 mkdir -p \
	/package && \
 tar -cvf /package/ffmpeg.tar -C /root/bin/ ffmpeg ffprobe ffserver && \
 chmod -R 777 /package

CMD ["cp", "-avr", "/package", "/mnt/"]
