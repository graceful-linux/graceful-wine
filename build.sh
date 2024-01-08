#!/bin/bash
set -e

wineMajor=9
wineMinor=0
winePatch=0
wineTweak=4
wineVersion="${wineMajor}.${wineMinor}.${winePatch}-${wineTweak}"

packageMD5=""
curDir=$(dirname $(realpath -- "$0"))
workDir="${curDir}/out"
packageName="graceful-wine-${wineVersion}.tar.gz"
cpuCount=$(grep -c '^processor' /proc/cpuinfo)

[[ ${cpuCount} -le 0 ]] && cpuCount=2
[[ -d "${workDir}" ]] && rm -rf "${workDir}"
[[ ! -d "${workDir}" ]] && mkdir -p "${workDir}"

tar cf "${packageName}" ./ANNOUNCE.md \
    ./configure \
    ./dlls \
    ./libs \
    ./loader \
    ./po \
    ./server \
    ./AUTHORS \
    ./configure.ac \
    ./documentation \
    ./LICENSE \
    ./MAINTAINERS \
    ./programs \
    ./tools \
    ./aclocal.m4 \
    ./COPYING.LIB \
    ./fonts \
    ./include \
    ./LICENSE.OLD \
    ./nls \
    ./README.md \
    ./VERSION

[[ -f "./${packageName}" ]] && mv "./${packageName}" "${workDir}"
[[ -f "${workDir}/${packageName}" ]] && packageMD5=$(sha512sum "${workDir}/${packageName}" | awk '{print $1}')

cat << EOF > ${workDir}/PKGBUILD
# Maintainer: dingjing <dingjing@live.cn>

pkgname=graceful-wine
pkgver=${wineMajor}.${wineMinor}.${winePatch}
pkgrel=${wineTweak}
pkgdesc='Wine is a environment for runs windows application.'
url='https://github.com/graceful-linux/graceful-wine'
arch=('x86_64')
license=('MIT')
groups=('graceful-linux')
depends=(
    'xorg-server'
    'graceful-linux'
)
optdepends=(
    )
makedepends=('clang' 'gcc')
source=("${workDir}/${packageName}")

sha512sums=("${packageMD5}")
noextract=()
validpgpkeys=('18B65970A361B77D6C7C67C29EE375D12E7A3EB1')

prepare() {
  mkdir build && cd build
  ../configure --enable-win64 --prefix=/usr/ 
}

build() {
  cd build
  make -j${cpuCount}
}

package() {
  cd build
  make DESTDIR="\$pkgdir" install
}

EOF

cd "${workDir}"
makepkg --printsrcinfo > .SRCINFO
makepkg
cd "${curDir}"




