#!/bin/sh
ln -s rpi-linux-4.14.71 linux
ln -s xenomai-3.0.7 xenomai
cd linux
git reset --hard df493abeaf1b0a2a83ebe21262758f802e567a38
cp ../xenomai-patches/irq-bcm2835.c drivers/irqchip/
cp ../xenomai-patches/irq-bcm2836.c drivers/irqchip/
../xenomai/scripts/prepare-kernel.sh --linux=./  --arch=arm  --ipipe=../xenomai-patches/ipipe-core-4.14.71-arm-3.patch 
make -j8 O=build ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
make O=build ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j8 menuconfig
make O=build ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j8 bzImage modules dtbs
make O=build ARCH=arm INSTALL_MOD_PATH=dist -j8 modules_install
make O=build ARCH=arm KBUILD_DEBARCH=armhf  CROSS_COMPILE=arm-linux-gnueabihf- -j8 deb-pkg
cd build/arch/arm/boot
tar -cjvf linux-dts-4.14.71-xeno3+.tar.bz2 dts
cd ../../../..
mkdir ../compiled_binaries
cp build/arch/arm/boot/linux-dts-4.14.71-xeno3+.tar.bz2 ../compiled_binaries/
cp linux-image-4.14.71-v7-xeno3+_4.14.71-v7-xeno3+-2_armhf.deb ../compiled_binaries/
cp linux-headers-4.14.71-v7-xeno3+_4.14.71-v7-xeno3+-2_armhf.deb ../compiled_binaries/
cp linux-dts-4.14.71-xeno3+.tar.bz2 ../compiled_binaries/

#Compiling Xenomai
  cd ../xenomai
  ./scripts/bootstrap
  ./configure --host=arm-linux-gnueabihf --enable-smp --with-core=cobalt
  make -j8
  make -j8 install DESTDIR=${PWD}/rpixeno
  cd rpixeno
  tar cjvf xenorpi3b+.tar.bz2 *
  cp xenorpi3b+.tar.bz2 ../compiled_binaries/
