#!/usr/bin/env bash

set -euo pipefail

ARCH=$(arch)
echo "Found CPU Architecture: ${ARCH}."

case $(arch) in
    arm64)
        ARCH=aarch64;;
    x86_64 | i386)
        ARCH=x86_64;;
    *)
        echo "Unsupported architecture: ${ARCH}, exiting."
        exit 1;;
esac

case ${1-default} in
    macos-12)
        OS=macos
        DIST=apple-darwin
        EXE="";;
    ubuntu-latest)
        OS=linux
        DIST=unknown-linux-gnu
        EXE="";;
    default | *)
        echo "Unsupported OS: ${1-default}, exiting."
        exit 1;;
esac

echo "Building for OS: ${OS}."

# TODO: implement working windows building
#elif [ "$1" == "windows-latest" ] ; then
#    OS=windows
#    DIST=pc-windows-msvc-static
#    EXE=.exe

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
