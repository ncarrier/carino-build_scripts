#!/bin/bash

package_name=u-boot

build_dir=${BUILD_DIR}/${package_name}
mkdir -p ${build_dir}

# use the default u-boot pcduino3 configuration
cd ${PACKAGES_DIR}/${package_name}
# TODO update the config only if needed
make CROSS_COMPILE=${TOOLCHAIN_PREFIX} \
		   Linksprite_pcDuino3_config \
		   O=${build_dir}

# do build
make CROSS_COMPILE=${TOOLCHAIN_PREFIX} \
		   O=${build_dir} \
		   -j 8

# install the needed bits at the right place
cp ${build_dir}/u-boot-sunxi-with-spl.bin ${U_BOOT_DIR}/
cp ${CONFIG_DIR}/uEnv.txt ${BOOT_DIR}/

