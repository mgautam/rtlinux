# rtlinux
Patching Linux with xenomai for Raspberry Pi 3b+

Prerequisites
-------------
	sudo apt-get install gcc-arm-linux-gnueabihf
	sudo apt-get install --no-install-recommends ncurses-dev bc

Compilation
-----------
	Run build.sh

Select options as following:
	
  General setup  --->
	│ │(-v7-xeno3) Local version - append to kernel release
	│ │ Stack Protector buffer overflow detection (None)  --->
	 
  Kernel Features  --->
	│ │Preemption Model (Preemptible Kernel (Low-Latency Desktop))  --->
	│ │Timer frequency (1000 Hz)  --->
	│ │[ ] Allow for memory compaction
	│ │[ ] Contiguous Memory Allocator

  CPU Power Management  --->
	│ │CPU Frequency scaling  ---> 
		[ ] CPU Frequency scaling
									
  Kernel hacking  --->
	│ │[ ] KGDB: kernel debugger  ---
							
	
On Raspberry Pi 3b+
-------------------
copy the contents in compiled_binaries folder to home folder on raspberry pi (Raspbian stretch OS)
Execute the following commands on raspberry pi from the home folder
	sudo dpkg -i linux-image*
	sudo tar -xjvf linux-dts-4.14.71-xeno3+.tar.bz2
	cd dts/
	sudo cp -rf * /boot/
	sudo cp /boot/vmlinuz-4.14.71-v7-xeno3+ /boot/kernel.img
	sudo mv /boot/vmlinuz-4.14.71-v7-xeno3+ /boot/kernel7.img

Reboot the raspberry pi
	sudo reboot

Then execute the following commands:
	sudo dpkg -i linux-headers*
	cd /usr/src/linux-headers-4.14.71-v7-xeno3+/
	sudo make -i modules_prepare
	sudo tar xjvf xenorpi3b+.tar.bz2 -C /

	sudo vi /etc/ld.so.conf.d/xenomai.conf
	  #xenomai lib path
	  /usr/local/lib
	  /usr/xenomai/lib

	sudo vi /boot/cmdline.txt #Append to single (first) line
	  isolcpus=0,1 xenomai.supported_cpus=0x3

Reboot the raspberry pi
	sudo reboot

To test the system, run the following command
	sudo /usr/xenomai/bin/latency
