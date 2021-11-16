This is a portable environment to build the Linux version of the [Phoenix Firestorm viewer for Second Life and OpenSIM](https://www.firestormviewer.org/).

It uses an Ubuntu 18.04 image and basically follows [the build instructions from the Firestorm Wiki](https://wiki.firestormviewer.org/fs_compiling_firestorm_linux).

# How can I use it?

Just clone this repo and run the included `./bootstrap.sh` to download all the required source files.

Once downloaded, you can make your desired modifications to the viewer source code in `./phoenix-firestorm`.

In order to build it, just build the docker container via

```
DOCKER_BUILDKIT=1 docker build -t fs/custom --output out .
```

Once the build is finished, you will find the resulting `.tar.xz` file in a new `./out` folder.


# Requirements

You'll need a docker version of at least `19.03.0` to make use of the `DOCKER_BUILDKIT` environment variable to directly copy the resulting viewer from inside the docker image to your host. With older versions of docker, you might need to copy the file by other means.
