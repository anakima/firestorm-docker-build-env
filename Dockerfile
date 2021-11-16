FROM ubuntu:18.04 as build-stage

# Update repo and existing packages
RUN apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade

# Get all the required libs
RUN apt-get install -y libatk1.0-dev libatk-bridge2.0-dev \
  libatspi2.0-dev/bionic libcups2-dev libcurl4-openssl-dev libfreetype6-dev \
  libglu1-mesa-dev libgtk2.0-dev libgtkglext1-dev libnss3-dev libssl-dev libpango1.0-dev \
  libpangox-1.0-dev libpangomm-1.4-dev libx11-xcb1 libxcb1-dev libxcb-composite0-dev libxcb-cursor-dev \
  libxcb-dri3-dev libxcb-screensaver0-dev libxcb-util-dev libxcb-util0-dev libxcb-xkb-dev libxcomposite-dev \
  libxcursor-dev libxdamage-dev libxi-dev libxinerama-dev libxkbcommon-x11-dev libxrandr-dev \
  libxss-dev 

# Install all build tools
RUN apt-get install -y build-essential gdb mesa-common-dev python-pip unzip \
  x11proto-dri2-dev x11proto-dri3-dev x11proto-randr-dev x11proto-xf86dri-dev \
  x11proto-xinerama-dev x11proto-scrnsaver-dev xcb xcb-proto git

# Copy and build CMAKE
RUN mkdir /src 
COPY cmake-3.18.0.tar.gz /src
RUN cd /src && tar xvf cmake-3.18.0.tar.gz && cd cmake-3.18.0 && \
  ./bootstrap --parallel=$(nproc) --prefix=/usr && \
  make -j $(nproc) && make install

# Upgrade pip and Install autobuild
RUN pip install --upgrade pip && pip install autobuild

# Copy all source code and set the autobuild environment
COPY fs-build-variables /src/fs-build-variables
COPY phoenix-firestorm /src/phoenix-firestorm
ENV AUTOBUILD_VARIABLES_FILE=/src/fs-build-variables/variables

# Configure and build
RUN cd /src/phoenix-firestorm && autobuild configure -A 64 -c ReleaseFS_open
RUN cd /src/phoenix-firestorm && autobuild build -A 64 -c ReleaseFS_open

# Copy the resulting viewer package to the host
From scratch AS export-stage
COPY --from=build-stage /src/phoenix-firestorm/build-linux-x86_64/newview/Phoenix_FirestormOS*.tar.xz .
