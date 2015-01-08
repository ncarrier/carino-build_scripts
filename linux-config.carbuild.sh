#!/bin/bash

package_name=linux

build_dir=${BUILD_DIR}/${package_name}
mkdir -p ${build_dir}

cd ${PACKAGES_DIR}/${package_name}
ARCH=arm CROSS_COMPILE=${TOOLCHAIN_PREFIX} \
     make xconfig O=${build_dir} -j 8

cp ${build_dir}/.config ${CONFIG_DIR}/kernel_config
echo new kernel config stored in ${CONFIG_DIR}/kernel_config

