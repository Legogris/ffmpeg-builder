FROM ubuntu:xenial

ARG DEBIAN_FRONTEND="noninteractive"
ARG BUILD_PACKAGES="\
	autoconf \
	automake \
	build-essential \
	cmake \
	curl \
	git \
	libass-dev \
	libfreetype6-dev \
	libtheora-dev \
	libtool \
	libva-dev \
	libvdpau-dev \
	libvorbis-dev \
	mercurial \
	pkg-config \
	texinfo \
	wget \
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
	~/ffmpeg_sources

# compile yasm
RUN \
 cd ~/ffmpeg_sources && \
 wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz && \
 tar xzvf yasm-1.3.0.tar.gz && \
 cd yasm-1.3.0 && \
 ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
 make && \
 make install

# compile nasm
RUN \
 cd ~/ffmpeg_sources && \
 wget http://www.nasm.us/pub/nasm/releasebuilds/2.13.01/nasm-2.13.01.tar.bz2 && \
 tar xjvf nasm-2.13.01.tar.bz2 && \
 cd nasm-2.13.01 && \
 ./autogen.sh && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile x264
RUN \
 cd ~/ffmpeg_sources && \
 wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2 && \
  tar xjvf last_x264.tar.bz2 && \
 cd x264-snapshot* && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --disable-opencl && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile x265
RUN \
 cd ~/ffmpeg_sources && \
 hg clone https://bitbucket.org/multicoreware/x265 && \
 cd ~/ffmpeg_sources/x265/build/linux && \
 PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source && \
 make && \
 make install

# compile libfdk-aac
RUN \
 cd ~/ffmpeg_sources && \
 wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master && \
 tar xzvf fdk-aac.tar.gz && \
 cd mstorsjo-fdk-aac* && \
 autoreconf -fiv && \
 ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
 make && \
 make install

# compile lame
RUN \
 cd ~/ffmpeg_sources && \
 wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz && \
 tar xzvf lame-3.99.5.tar.gz && \
 cd lame-3.99.5 && \
 ./configure --prefix="$HOME/ffmpeg_build" --enable-nasm --disable-shared && \
 make && \
 make install

# compile opus
RUN \
 cd ~/ffmpeg_sources && \
 wget https://archive.mozilla.org/pub/opus/opus-1.1.5.tar.gz && \
 tar xzvf opus-1.1.5.tar.gz && \
 cd opus-1.1.5 && \
 ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
 make && \
 make install

# compile libvpx
RUN \
 cd ~/ffmpeg_sources && \
 git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
 cd libvpx && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile harfbuzz
RUN \
 cd ~/ffmpeg_sources && \
 wget https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.4.6.tar.bz2 && \
 tar xjvf harfbuzz-1.4.6.tar.bz2 && \
 cd harfbuzz-1.4.6 && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared --enable-static && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile fribidi
RUN \
 cd ~/ffmpeg_sources && \
 wget http://fribidi.org/download/fribidi-0.19.7.tar.bz2 && \
 tar xjvf fribidi-0.19.7.tar.bz2 && \
 cd fribidi-0.19.7 && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared --enable-static && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile libass
RUN \
 cd ~/ffmpeg_sources && \
 wget https://github.com/libass/libass/archive/0.13.7.tar.gz && \
 tar xvf 0.13.7.tar.gz && \
 cd libass-0.13.7 && \
 ./autogen.sh && \
 PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
 PATH="$HOME/bin:$PATH" make && \
 make install

# compile ffmpeg
RUN \
 cd ~/ffmpeg_sources && \
 wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
 tar xjvf ffmpeg-snapshot.tar.bz2 && \
 cd ffmpeg && \
 PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
	--prefix="$HOME/ffmpeg_build" \
	--pkg-config-flags="--static" \
	--extra-cflags="-I$HOME/ffmpeg_build/include" \
	--extra-ldflags="-L$HOME/ffmpeg_build/lib" \
	--extra-ldexeflags="-static" \
	--bindir="$HOME/bin" \
	--disable-ffplay \
	--enable-gpl \
	--enable-libass \
	--enable-libfdk-aac \
	--enable-libfreetype \
	--enable-libmp3lame \
	--enable-libopus \
	--enable-libtheora \
	--enable-libvorbis \
	--enable-libvpx \
	--enable-libx264 \
	--enable-libx265 \
	--enable-nonfree \
	--enable-static \
	--enable-vaapi && \
 PATH="$HOME/bin:$PATH" make && \
 make install && \
 hash -r

RUN \
 apt-get purge -y --auto-remove \
	${BUILD_PACKAGES}
