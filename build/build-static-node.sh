#!/bin/bash

# Usage:
#
# build-static-node <node-version>
#
# IMPORTANT - this will build a static Node against the libc installed on your machine. As noted
#   in the NodeJS wiki, some features may still require a matching version of libc to be
#   installled on the target machine.


NODE_VERSION=$1
BASE=$(dirname $(dirname $(readlink -f $0)))
shift

if [[ -z "$NODE_VERSION" ]]; then
    echo "build-static-node <node-version>";
    exit 1
fi

SRC_TAR_GZ="node-v${NODE_VERSION}.tar.gz"
SRC_URL="https://nodejs.org/dist/v${NODE_VERSION}/${SRC_TAR_GZ}"
THREADS=$(grep -c ^processor /proc/cpuinfo)

# create the build folder
TMPDIR=$(mktemp)

# download and extract the source
echo "downloading ${SRC_URL} to ${TMPDIR}..."
wget -nc -P "$TMPDIR" "$SRC_URL"
if [[ $? != 0 ]]; then
    echo "Failed to download source tarball: $SRC_URL";
    exit 1
fi

echo "extracting..."
cd "${TMPDIR}"
tar -zxf "./${SRC_TAR_GZ}"
if [[ $? != 0 ]]; then
    echo "Failed to extract source tarball: ${TMPDIR}/${SRC_TAR_GZ}";
    exit 1
fi

cd "${TMPDIR}/node-v${NODE_VERSION}"
./configure --fully-static $@
make -j$THREADS

OUT="${BASE}/dist/v${NODE_VERSION}"
mkdir -p "${OUT}"
cp -H ./node "${OUT}/node"