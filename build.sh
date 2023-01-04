#!/usr/bin/env bash

set -euo pipefail

if [ "$1" == "macos-12" ] ; then
    ARCH=aarch64
    OS=macos
    DIST=apple-darwin
    EXE=""
elif [ "$1" == "ubuntu-latest" ] ; then
    ARCH=x86_64
    OS=linux
    DIST=unknown-linux-gnu
    EXE=""
elif [ "$1" == "windows-latest" ] ; then
    ARCH=x86_64
    OS=windows
    DIST=pc-windows-msvc-static
    EXE=.exe
fi

mkdir -p dist/${OS}-${ARCH}

pushd ${OS}-${ARCH}
[ -f scie-jump-${OS}-${ARCH} ] || wget https://github.com/a-scie/jump/releases/download/v0.8.0/scie-jump-${OS}-${ARCH}${EXE}
[ -f scie-jump-${OS}-${ARCH}.sha256 ] || wget https://github.com/a-scie/jump/releases/download/v0.8.0/scie-jump-${OS}-${ARCH}${EXE}.sha256
[ -f cpython-3.9.14+20221002-${ARCH}-${DIST}-install_only.tar.gz ] || wget https://github.com/indygreg/python-build-standalone/releases/download/20221002/cpython-3.9.14+20221002-${ARCH}-${DIST}-install_only.tar.gz
[ -f cpython-3.9.14+20221002-${ARCH}-${DIST}-install_only.tar.gz.sha256 ] || wget https://github.com/indygreg/python-build-standalone/releases/download/20221002/cpython-3.9.14+20221002-${ARCH}-${DIST}-install_only.tar.gz.sha256

echo $(cat cpython-3.9.14+20221002-${ARCH}-${DIST}-install_only.tar.gz.sha256) '*'cpython-3.9.14+20221002-${ARCH}-${DIST}-install_only.tar.gz | shasum -a 256 -c || exit 1
shasum -a 256 -c scie-jump-${OS}-${ARCH}${EXE}.sha256 || exit 1
chmod a+x scie-jump-${OS}-${ARCH}${EXE}
popd

./pants package ::
${OS}-${ARCH}/scie-jump-${OS}-${ARCH}${EXE} ${OS}-${ARCH}
