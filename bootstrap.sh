#!/usr/bin/env bash
cd $( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
git clone https://vcs.firestormviewer.org/phoenix-firestorm
git clone https://vcs.firestormviewer.org/fs-build-variables
wget https://github.com/Kitware/CMake/releases/download/v3.18.0/cmake-3.18.0.tar.gz
