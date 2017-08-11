FROM lsiobase/xenial-root-x86

ARG DEBIAN_FRONTEND="noninteractive"
ARG BUILD_PACKAGES="\
	autoconf \
	automake \
	bash \
	build-essential \
	bzip2 \
	cmake \
	curl \
	frei0r-plugins-dev \
	gawk \
	git \
	libass-dev \
	libfontconfig-dev \
	libfreetype6-dev \
	libopencore-amrnb-dev \
	libopencore-amrwb-dev \
	libsdl1.2-dev \
	libspeex-dev \
	libssl-dev \
	libtheora-dev \
	libtool \
	libva-dev \
	libvdpau-dev \
	libvo-amrwbenc-dev \
	libvorbis-dev \
	libwebp-dev \
	libxcb1-dev \
	libxcb-shm0-dev \
	libxcb-xfixes0-dev \
	libxvidcore-dev \
	lsb-release \
	mercurial \
	perl \
	pkg-config \
	sudo \
	tar \
	texi2html \
	wget \
	xz-utils \
	yasm \
	zlib1g-dev"

# install build packages
RUN \
 apt-get update && \
 apt-get install -y \
	${BUILD_PACKAGES} && \
 rm -rf \
	/var/lib/apt/lists/*

# make source folder
RUN \
 mkdir -p \
	/tmp/ffmpeg-source

# package versions
ARG FFMPEG_VER="3.3.3"
ARG FRIBIDI_VER="0.19.7"
ARG HARFBUZZ_VER="1.4.8"
ARG LAME_VER="3.99.5"
ARG LIBASS_VER="0.13.7"
ARG NASM_VER="2.13.01"
ARG OPENJPEG_VER="2.1.2"
ARG OPUS_VER="1.2.1"
ARG RTMP_VER="2.3"
ARG SOXR_VER="0.1.2"
ARG VIDSTAB_VER="release-0.98b"
ARG X265_VER="2.5"
ARG ZIMG_VER="2.5.1"

# compile nasm
RUN \
 cd /tmp/ffmpeg-source && \
 wget http://www.nasm.us/pub/nasm/releasebuilds/${NASM_VER}/nasm-${NASM_VER}.tar.bz2 && \
 tar xjvf nasm-${NASM_VER}.tar.bz2 && \
 cd nasm-${NASM_VER} && \
 ./autogen.sh && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile x264
RUN \
 cd /tmp/ffmpeg-source && \
 wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2 && \
 tar xjvf last_x264.tar.bz2 && \
 cd x264-snapshot* && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --disable-opencl && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile x265
RUN \
 cd /tmp/ffmpeg-source && \
 wget https://bitbucket.org/multicoreware/x265/downloads/x265_${X265_VER}.tar.gz && \
 tar xvf x265_${X265_VER}.tar.gz && \
 cd x265_${X265_VER}/build/linux && \
 PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile libfdk-aac
RUN \
 cd /tmp/ffmpeg-source && \
 wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master && \
 tar xzvf fdk-aac.tar.gz && \
 cd mstorsjo-fdk-aac* && \
 autoreconf -fiv && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile harfbuzz
RUN \
 cd /tmp/ffmpeg-source && \
 wget https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${HARFBUZZ_VER}.tar.bz2 && \
 tar xjvf harfbuzz-${HARFBUZZ_VER}.tar.bz2 && \
 cd harfbuzz-${HARFBUZZ_VER} && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared --enable-static && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile fribidi
RUN \
 cd /tmp/ffmpeg-source && \
 wget http://fribidi.org/download/fribidi-${FRIBIDI_VER}.tar.bz2 && \
 tar xjvf fribidi-${FRIBIDI_VER}.tar.bz2 && \
 cd fribidi-${FRIBIDI_VER} && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared --enable-static && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile libass
RUN \
 cd /tmp/ffmpeg-source && \
 wget https://github.com/libass/libass/archive/${LIBASS_VER}.tar.gz && \
 tar xvf ${LIBASS_VER}.tar.gz && \
 cd libass-${LIBASS_VER} && \
 ./autogen.sh && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile lame
RUN \
 cd /tmp/ffmpeg-source && \
 LAME_BRANCH=${LAME_VER%.*} && \
 wget http://downloads.sourceforge.net/project/lame/lame/${LAME_BRANCH}/lame-${LAME_VER}.tar.gz && \
 tar xzvf lame-${LAME_VER}.tar.gz && \
 cd lame-${LAME_VER} && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --enable-nasm --disable-shared && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile opus
RUN \
 cd /tmp/ffmpeg-source && \
 wget https://archive.mozilla.org/pub/opus/opus-${OPUS_VER}.tar.gz && \
 tar xzvf opus-${OPUS_VER}.tar.gz && \
 cd opus-${OPUS_VER} && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile libvpx
RUN \
 cd /tmp/ffmpeg-source && \
 git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
 cd libvpx && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile rtmp
RUN \
 cd /tmp/ffmpeg-source && \
 wget https://rtmpdump.mplayerhq.hu/download/rtmpdump-${RTMP_VER}.tgz && \
 tar xvf rtmpdump-${RTMP_VER}.tgz && \
 cd rtmpdump-${RTMP_VER} && \
 sed -i "s#prefix=.*#prefix=$HOME/ffmpeg_build#" ./Makefile && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile soxr
RUN \
 cd /tmp/ffmpeg-source && \
 wget https://sourceforge.net/projects/soxr/files/soxr-${SOXR_VER}-Source.tar.xz && \
 tar xvf soxr-${SOXR_VER}-Source.tar.xz && \
 cd soxr-${SOXR_VER}-Source && \
 PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DBUILD_SHARED_LIBS:bool=off -DWITH_OPENMP:bool=off -DBUILD_TESTS:bool=off && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile vidstab
RUN \
 cd /tmp/ffmpeg-source && \
 wget https://github.com/georgmartius/vid.stab/archive/${VIDSTAB_VER}.tar.gz && \
 tar xvf ${VIDSTAB_VER}.tar.gz && \
 cd vid.stab-${VIDSTAB_VER} && \
 sed -i "s/vidstab SHARED/vidstab STATIC/" ./CMakeLists.txt && \
 PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile openjpeg
RUN \
 cd /tmp/ffmpeg-source && \
 wget https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG_VER}.tar.gz && \
 tar xvf v${OPENJPEG_VER}.tar.gz && \
 cd openjpeg-${OPENJPEG_VER} && \
 PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DBUILD_SHARED_LIBS:bool=off && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile zimg
RUN \
 cd /tmp/ffmpeg-source && \
 wget https://github.com/sekrit-twc/zimg/archive/release-${ZIMG_VER}.tar.gz && \
 tar xvf release-${ZIMG_VER}.tar.gz && \
 cd zimg-release-${ZIMG_VER} && \
 ./autogen.sh && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared --enable-static && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile ffmpeg
RUN \
 cd /tmp/ffmpeg-source && \
 wget http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VER}.tar.bz2 && \
 tar xjvf ffmpeg-${FFMPEG_VER}.tar.bz2 && \
 cd ffmpeg-${FFMPEG_VER} && \
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

# archive artefacts
RUN \
 mkdir -p \
	/package && \
 tar -cvf /package/ffmpeg.tar -C /root/bin/ ffmpeg ffprobe x264 && \
 chmod -R 777 /package

CMD ["cp", "-avr", "/package", "/mnt/"]
