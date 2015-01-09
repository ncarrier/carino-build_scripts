#!/bin/bash

package_name=linux

build_dir=${BUILD_DIR}/${package_name}
mkdir -p ${build_dir}

# use the versionned kernel configuration
cp ${CONFIG_DIR}/kernel_config ${build_dir}/.config

# do build
cd ${PACKAGES_DIR}/${package_name}
ARCH=arm CROSS_COMPILE=${TOOLCHAIN_PREFIX} \
     LOADADDR=0x40008000 \
     make uImage dtbs O=${build_dir} -j 8

# install the needed bits at the right place
cp ${build_dir}/arch/arm/boot/dts/sun7i-a20-pcduino3.dtb ${BOOT_DIR}/
cp ${build_dir}/arch/arm/boot/uImage ${BOOT_DIR}/

