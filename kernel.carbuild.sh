#!/bin/bash

package_name=kernel

build_dir=${BUILD_DIR}/${package_name}
mkdir -p ${build_dir}

cp ${CONFIG_DIR}/kernel_config ${build_dir}/.config

cd ${PACKAGES_DIR}/linux
ARCH=arm CROSS_COMPILE=${TOOLCHAIN_PREFIX} \
     LOADADDR=0x40008000 \
     make uImage dtbs O=${build_dir} -j 8

