#!/bin/bash

# for updating the busybox configuration, just do :
# cd out/build/busybox/build/
# CROSS_COMPILE=arm-linux-gnueabihf- make KBUILD_SRC=../busybox-1.23.0/ \
#      -f ../busybox-1.23.0/Makefile menuconfig
# cp .config ~/carino/config/busybox_config
# a configure script would have been nice, but I can't do that since It would
# involve getting sure the source have been unpacked before

package_name=busybox

build_dir=${BUILD_DIR}/${package_name}
src_dir=${build_dir}/busybox-1.23.0
mkdir -p ${build_dir}
cd ${build_dir}

# extract
tar xf ${PACKAGES_DIR}/archives/${package_name}/busybox-1.23.0.tar.bz2
mkdir -p build
cd build

# TODO apply the patches

# use the versionned busybox configuration
cp ${CONFIG_DIR}/busybox_config .config

# do build
CROSS_COMPILE=${TOOLCHAIN_PREFIX} \
	make KBUILD_SRC=${src_dir} -f ${src_dir}/Makefile -j 8

# install the needed bits at the right place
make CONFIG_PREFIX=${FINAL_DIR} install
