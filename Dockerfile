FROM lsiobase/xenial-root-x86
MAINTAINER sparklyballs

# install build packages
RUN \
 apt-get update && \
 DEBIAN_FRONTEND="noninteractive" apt-get install -y \
	autoconf \
	automake \
	bash \
	build-essential \
	bzip2 \
	cmake \
	curl \
	frei0r-plugins-dev \
	gawk \
	libass-dev \
	libfontconfig-dev \
	libsdl1.2-dev \
	libtool \
	libva-dev \
	libvdpau-dev \
	libvo-amrwbenc-dev \
	libwebp-dev \
	libxcb1-dev \
	libxcb-shm0-dev \
	libxcb-xfixes0-dev \
	libxvidcore-dev \
	lsb-release \
	perl \
	pkg-config \
	sudo \
	tar \
	texi2html \
	wget \
	xz-utils \
	yasm && \
 rm -rf \
	/var/lib/apt/lists/*

# package versions
ARG FFMPEG_VER="3.3.3"
ARG FREETYPE_VER="2.7.1"
ARG FRIBIDI_VER="0.19.7"
ARG HARFBUZZ_VER="1.5.0"
ARG LAME_VER="3.99.5"
ARG LIBASS_VER="0.13.7"
ARG LIBOGG_VER="1.3.2"
ARG LIBTHEORA_VER="1.2.0alpha1"
ARG LIBVORBIS_VER="1.3.5"
ARG NASM_VER="2.13.01"
ARG O_AMR_VER="0.1.5"
ARG OPENJPEG_VER="2.2.0"
ARG OPENSSL_VER="1.0.2l"
ARG OPUS_VER="1.2.1"
ARG RTMP_COMMIT="fa8646daeb19dfd12c181f7d19de708d623704c0"
ARG SOXR_VER="0.1.2"
ARG SPEEX_VER="1.2.0"
ARG VIDSTAB_VER="1.1.0"
ARG VPX_VER="1.6.1"
ARG X265_VER="2.5"
ARG ZIMG_VER="2.6a"
ARG ZLIB_VER="1.2.11"

# environment variables
ARG BUILD_ROOT="/tmp/build-root"
ARG SOURCE_FOLDER="/tmp/source-folder"

# copy patches
COPY patches/ /tmp/patches/

# make folders
RUN \
 mkdir -p \
	${BUILD_ROOT} \
	${SOURCE_FOLDER} && \
 rm -rf ${BUILD_ROOT}/* \
	${SOURCE_FOLDER}/*

# fetch source codes
RUN set -ex && \
 RTMP_VER=$(printf "%.7s" $RTMP_COMMIT) && \
 curl -o \
	${SOURCE_FOLDER}/fdk-aac.tar.gz -L \
	https://github.com/mstorsjo/fdk-aac/tarball/master && \
 curl -o \
	${SOURCE_FOLDER}/ffmpeg.tar.bz2 -L \
	http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VER}.tar.bz2 && \
 curl -o \
	${SOURCE_FOLDER}/freetype-${FREETYPE_VER}.tar.gz -L \
	http://download.savannah.gnu.org/releases/freetype/freetype-${FREETYPE_VER}.tar.gz && \
 curl -o \
	${SOURCE_FOLDER}/fribidi-${FRIBIDI_VER}.tar.bz2 -L \
	http://fribidi.org/download/fribidi-${FRIBIDI_VER}.tar.bz2 && \
 curl -o \
	${SOURCE_FOLDER}/harfbuzz-${HARFBUZZ_VER}.tar.bz2 -L \
	https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${HARFBUZZ_VER}.tar.bz2 && \
 curl -o \
	${SOURCE_FOLDER}/lame-${LAME_VER}.tar.gz -L \
	http://downloads.sourceforge.net/project/lame/lame/${LAME_VER%.*}/lame-${LAME_VER}.tar.gz && \
 curl -o \
	${SOURCE_FOLDER}/last_x264.tar.bz2 -L \
	http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2 && \
 curl -o \
	${SOURCE_FOLDER}/${LIBASS_VER}.tar.gz -L \
	https://github.com/libass/libass/archive/${LIBASS_VER}.tar.gz && \
 curl -o \
	${SOURCE_FOLDER}/libogg-${LIBOGG_VER}.tar.gz -L \
	http://downloads.xiph.org/releases/ogg/libogg-${LIBOGG_VER}.tar.gz && \
curl -o \
	${SOURCE_FOLDER}/libtheora-${LIBTHEORA_VER}.tar.gz -L \
	http://downloads.xiph.org/releases/theora/libtheora-${LIBTHEORA_VER}.tar.gz && \
 curl -o \
	${SOURCE_FOLDER}/libvorbis-${LIBVORBIS_VER}.tar.gz -L \
	http://downloads.xiph.org/releases/vorbis/libvorbis-${LIBVORBIS_VER}.tar.gz && \
 curl -o \
	${SOURCE_FOLDER}/nasm-${NASM_VER}.tar.bz2 -L \
	http://www.nasm.us/pub/nasm/releasebuilds/${NASM_VER}/nasm-${NASM_VER}.tar.bz2 && \
 curl -o \
	${SOURCE_FOLDER}/opus-${OPUS_VER}.tar.gz -L \
	https://archive.mozilla.org/pub/opus/opus-${OPUS_VER}.tar.gz && \
 curl -o \
	${SOURCE_FOLDER}/release-${ZIMG_VER}.tar.gz -L \
	https://github.com/sekrit-twc/zimg/archive/release-${ZIMG_VER}.tar.gz && \
 curl -o \
	${SOURCE_FOLDER}/rtmpdump-${RTMP_VER}.tgz -L \
	https://git.ffmpeg.org/gitweb/rtmpdump.git/snapshot/${RTMP_COMMIT}.tar.gz && \
 curl -o \
	${SOURCE_FOLDER}/soxr-${SOXR_VER}-Source.tar.xz -L \
	https://sourceforge.net/projects/soxr/files/soxr-${SOXR_VER}-Source.tar.xz && \
 curl -o \
	${SOURCE_FOLDER}/speex-${SPEEX_VER}.tar.gz -L \
	http://downloads.us.xiph.org/releases/speex/speex-${SPEEX_VER}.tar.gz && \
 curl -o \
	${SOURCE_FOLDER}/v${OPENJPEG_VER}.tar.gz -L \
	https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG_VER}.tar.gz && \
 curl -o \
	${SOURCE_FOLDER}/v${VIDSTAB_VER}.tar.gz -L \
	https://github.com/georgmartius/vid.stab/archive/v${VIDSTAB_VER}.tar.gz && \
 curl -o \
	${SOURCE_FOLDER}/v${VPX_VER}.tar.gz -L \
	https://github.com/webmproject/libvpx/archive/v${VPX_VER}.tar.gz && \
 curl -o \
	${SOURCE_FOLDER}/x265_${X265_VER}.tar.gz -L \
	https://bitbucket.org/multicoreware/x265/downloads/x265_${X265_VER}.tar.gz && \
 curl -o \
	${SOURCE_FOLDER}/v${ZLIB_VER}.tar.gz -L \
	https://github.com/madler/zlib/archive/v${ZLIB_VER}.tar.gz && \
 curl -o \
	${SOURCE_FOLDER}/openssl-${OPENSSL_VER}.tar.gz -L \
	https://www.openssl.org/source/openssl-${OPENSSL_VER}.tar.gz && \
 curl -o \
	${SOURCE_FOLDER}/opencore-amr-${O_AMR_VER}.tar.gz -L \
	http://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-${O_AMR_VER}.tar.gz

# unpack source codes
RUN set -ex && \
 for file in ${SOURCE_FOLDER}/* ; do tar xvf $file -C ${BUILD_ROOT} ; done

# compile nasm
RUN set -ex && \
 cd ${BUILD_ROOT}/nasm-${NASM_VER} && \
 ./autogen.sh && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile zlib
RUN set -ex && \
 cd ${BUILD_ROOT}/zlib-${ZLIB_VER} && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --static && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile openssl
RUN set -ex && \
 cd ${BUILD_ROOT}/openssl-${OPENSSL_VER} && \
 PATH="$HOME/bin:$PATH" ./config \
	no-shared \
	zlib \
	--openssldir="$HOME/ffmpeg_build/etc/ssl" \
	--prefix="$HOME/ffmpeg_build" && \
 PATH="$HOME/bin:$PATH" make depend && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile libogg
RUN set -ex && \
 cd ${BUILD_ROOT}/libogg-${LIBOGG_VER} && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile speex
RUN set -ex && \
 cd ${BUILD_ROOT}/speex-${SPEEX_VER} && \
 ./configure --prefix="$HOME/ffmpeg_build" --disable-shared --enable-sse  --disable-oggtest --with-ogg="$HOME/ffmpeg_build" && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile libvorbis
RUN set -ex && \
 cd ${BUILD_ROOT}/libvorbis-${LIBVORBIS_VER} && \
 ./configure --prefix="$HOME/ffmpeg_build" --disable-shared --disable-oggtest && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile libtheora
RUN set -ex && \
 cd ${BUILD_ROOT}/libtheora-${LIBTHEORA_VER} && \
 ./configure --prefix="$HOME/ffmpeg_build" --disable-shared --disable-oggtest --disable-examples --with-ogg="$HOME/ffmpeg_build" && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile x264
RUN set -ex && \
 cd ${BUILD_ROOT}/x264-snapshot* && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --disable-opencl && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile x265
RUN set -ex && \
 cd ${BUILD_ROOT}/x265_${X265_VER}/build/linux && \
 PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile libfdk-aac
RUN set -ex && \
 cd ${BUILD_ROOT}/mstorsjo-fdk-aac* && \
 autoreconf -fiv && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile harfbuzz
RUN set -ex && \
 cd ${BUILD_ROOT}/harfbuzz-${HARFBUZZ_VER} && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared --enable-static && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile freetype
RUN set -ex && \
 cd ${BUILD_ROOT}/freetype-${FREETYPE_VER} && \
 ./configure --prefix="$HOME/ffmpeg_build" --disable-shared --enable-static --without-png && \
 make install && ln -s "$HOME/ffmpeg_build"/include/freetype2 "$HOME/ffmpeg_build"/include/freetype2/freetype

# compile fribidi
RUN set -ex && \
 cd ${BUILD_ROOT}/fribidi-${FRIBIDI_VER} && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared --enable-static && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile libass
RUN set -ex && \
 cd ${BUILD_ROOT}/libass-${LIBASS_VER} && \
 ./autogen.sh && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile lame
RUN set -ex && \
 cd ${BUILD_ROOT}/lame-${LAME_VER} && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --enable-nasm --disable-shared && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile opus
RUN set -ex && \
 cd ${BUILD_ROOT}/opus-${OPUS_VER} && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile opencore-amr
RUN set -ex && \
 cd ${BUILD_ROOT}/opencore-amr-${O_AMR_VER} && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile libvpx
RUN set -ex && \
 cd ${BUILD_ROOT}/libvpx-${VPX_VER} && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-pic && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile rtmp
RUN set -ex && \
 RTMP_VER=$(printf "%.7s" $RTMP_COMMIT) && \
 cd ${BUILD_ROOT}/rtmpdump-${RTMP_VER} && \
 PATH="$HOME/bin:$PATH" make SYS=posix SHARED= XCFLAGS="-fpic -I$HOME/ffmpeg_build/include" XLDFLAGS=-L"$HOME/ffmpeg_build/lib" XLIBS=-ldl && \
 make install prefix=$HOME/ffmpeg_build SHARED=

# compile soxr
RUN set -ex && \
 cd ${BUILD_ROOT}/soxr-${SOXR_VER}-Source && \
 PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DBUILD_SHARED_LIBS:bool=off -DWITH_OPENMP:bool=off -DBUILD_TESTS:bool=off && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile vidstab
RUN set -ex && \
 cd ${BUILD_ROOT}/vid.stab-${VIDSTAB_VER} && \
 sed -i "s/BUILD_SHARED_LIBS/BUILD_STATIC_LIBS/" ./CMakeLists.txt && \
 PATH="$HOME/bin:$PATH" cmake -DCMAKE_INSTALL_PREFIX:PATH="$HOME/ffmpeg_build" && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile openjpeg
RUN set -ex && \
 cd ${BUILD_ROOT}/openjpeg-${OPENJPEG_VER} && \
 PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DBUILD_SHARED_LIBS:bool=off -DBUILD_THIRDPARTY=on && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile zimg
RUN set -ex && \
 cd ${BUILD_ROOT}/zimg-release-${ZIMG_VER} && \
 ./autogen.sh && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared --enable-static && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile ffmpeg
RUN set -ex && \
 cd ${BUILD_ROOT}/ffmpeg* && \
 patch -p1 -i /tmp/patches/openjpeg-2.2.patch && \
 PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
	--bindir="$HOME/bin" \
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
	--enable-pic \
	--enable-vaapi \
	--enable-version3 \
	--extra-cflags="-I$HOME/ffmpeg_build/include" \
	--extra-ldexeflags="-static" \
	--extra-ldflags="-L$HOME/ffmpeg_build/lib" \
	--pkg-config-flags="--static" \
	--prefix="$HOME/ffmpeg_build" && \
 PATH="$HOME/bin:$PATH" make && \
 make install && \
 hash -r

# archive artefacts
RUN \
 mkdir -p \
	/package && \
 tar -cvf /package/ffmpeg.tar -C /root/bin/ ffmpeg ffprobe ffserver && \
 chmod -R 777 /package

CMD ["cp", "-avr", "/package", "/mnt/"]
