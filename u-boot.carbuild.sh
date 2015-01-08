#!/bin/bash

package_name=u-boot

build_dir=${BUILD_DIR}/${package_name}
mkdir -p ${build_dir}

cd ${PACKAGES_DIR}/${package_name}
make CROSS_COMPILE=${TOOLCHAIN_PREFIX} \
		   Linksprite_pcDuino3_config \
		   O=${build_dir}

make CROSS_COMPILE=${TOOLCHAIN_PREFIX} \
		   O=${build_dir} \
		   -j 8


