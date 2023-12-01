FROM ubuntu:20.04 as build-stage
ENV DEBIAN_FRONTEND=noninteractive

# Update repo and existing packages
RUN apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade

# Get all the required libs
RUN apt-get install -y libgl1-mesa-dev libglu1-mesa-dev libpulse-dev build-essential python3-pip git libssl-dev libxinerama-dev libxrandr-dev libfontconfig1-dev libfreetype6-dev

# Install all build tools
RUN apt-get install -y build-essential gdb mesa-common-dev unzip \
  x11proto-dri2-dev x11proto-dri3-dev x11proto-randr-dev x11proto-xf86dri-dev \
  x11proto-xinerama-dev x11proto-scrnsaver-dev xcb xcb-proto git

# Copy and build CMAKE
RUN mkdir /src
COPY cmake-3.18.0.tar.gz /src
RUN cd /src && tar xvf cmake-3.18.0.tar.gz && cd cmake-3.18.0 && \
  ./bootstrap --parallel=$(nproc) --prefix=/usr && \
  make -j $(nproc) && make install

# Upgrade pip and Install autobuild
RUN pip3 install --upgrade pip && pip3 install git+https://bitbucket.org/lindenlab/autobuild.git#egg=autobuild

# Copy all source code and set the autobuild environment
COPY fs-build-variables /src/fs-build-variables
COPY phoenix-firestorm /src/phoenix-firestorm
ENV AUTOBUILD_VARIABLES_FILE=/src/fs-build-variables/variables

# Configure and build
RUN cd /src/phoenix-firestorm && autobuild configure -A 64 -c ReleaseFS_open
RUN cd /src/phoenix-firestorm && autobuild build -A 64 -c ReleaseFS_open

# Copy the resulting viewer package to the host
From scratch AS export-stage
COPY --from=build-stage /src/phoenix-firestorm/build-linux-x86_64/newview/Phoenix*.tar* .

