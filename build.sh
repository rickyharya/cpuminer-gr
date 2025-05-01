#!/bin/bash
# build.sh untuk Orange Pi Zero2

rm -v build.log 2>/dev/null
echo "Build started at $(date)" | tee -a build.log

make distclean | tee -a build.log
rm -f config.status | tee -a build.log
./autogen.sh | tee -a build.log

# Set arsitektur untuk ARMv8 + crypto
ARCH="armv8-a+crypto"
MFPU=""

echo "Detected ARMv8 system with crypto optimization" | tee -a build.log

# Optimasi tambahan untuk Cortex-A53
CFLAGS="-O3 -march=${ARCH} -mtune=cortex-a53 -flto -funroll-loops"
CXXFLAGS="${CFLAGS} -std=c++11"

# Konfigurasi dan build
./configure --with-curl CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" | tee -a build.log
make -j2 | tee -a build.log

# Strip hasil build agar lebih kecil
strip -s cpuminer | tee -a build.log

echo "Build ended at $(date)" | tee -a build.log
