#!/bin/bash -x

export INSTALLTO=/home/buzz2
# will end up as: home/buzz2/zephyrproject
SDK_VER=0.17.4
CMAKE_PREFIX_PATH=$HOME/zephyr-sdk-$SDK_VER/


# cmake --version
# python3 --version
# dtc --version

if [ ! -d $INSTALLTO/zephyrproject ]; then
  echo 'project missing run the setup scrit first'
  exit 1
else 
    echo 'Zephyr prpoject already setup, skipping re-init.'
    cd $INSTALLTO/zephyrproject
    source ./.venv/bin/activate
    #west update
    # 'Export a Zephyr CMake package. This allows CMake to automatically load boilerplate code required for building Zephyr applications.''
    #west zephyr-export
    #pip install -r ./zephyr/scripts/requirements.txt
    #west packages pip --install
fi



echo determine supported board name and while there see if has any extra instructions:
echo     https://docs.zephyrproject.org/latest/boards/index.html#boards
echo     eg: esp32s3_devkitm

echo esp32s3:
    west blobs fetch hal_espressif
echo     needs "--sysbuild" added to build steps below...

echo tip:  '-p always' option forces a pristine build, and is recommended for new users.

echo -----------------------------------------------------------------------------------------------------------

echo Build the Blinky Sample:

#     cd $INSTALLTO/zephyrproject/zephyr
#     #west build -p always -b <your-board-name> samples/basic/blinky
#     #west build -p always -b esp32s3_devkitm --sysbuild samples/basic/blinky  [fails]
#     #[works]:
#     west build -p always -b esp32s3_devkitm/esp32s3/procpu --sysbuild samples/hello_world 
#     #west build -p always -b esp32s3_devkitm/esp32s3/appcpu --sysbuild samples/hello_world 
# echo -----------------------------------------------------------------------------------------------------------


# echo Flash the Sample:
#     west flash

    # results:
    #     (.venv) [ ... zephyr]$ west flash
    #     -- west flash: rebuilding
    #     [0/6] Performing build step for 'hello_world'
    #     ninja: no work to do.
    #     [1/6] Performing build step for 'mcuboot'
    #     ninja: no work to do.
    #     [6/6] Completed 'mcuboot'
    #     -- west flash: using runner esp32
    #     -- runners.esp32: reset after flashing requested
    #  ....
    #     Uploading stub...
    #     Running stub...
    #     Stub running...
    #     Changing baud rate to 921600
    #     Changed.
    #     Configuring flash size...
    #     Auto-detected Flash size: 8MB
    #     Flash will be erased from 0x00010000 to 0x00024fff...
    #     Wrote 98304 bytes at 0x00010000 in 0.5 seconds (1584.5 kbit/s)...
    #     Hash of data verified.

    #     Leaving...
    #     Hard resetting via RTS pin...

    #west espressif monitor

#echo -----------------------------------------------------------------------------------------------------------


# echo If doing ESP32-S3:
# echo esp32-s3:  https://docs.zephyrproject.org/latest/boards/espressif/esp32s3_devkitm/doc/index.html

# echo to see the output of the program running after flash run: 'west espressif monitor'
        # zephyr]$ west espressif monitor
        # Serial port /dev/ttyUSB0
        # Connecting....
        # Detecting chip type... ESP32-S3
        # --- idf_monitor on /dev/ttyUSB0 115200 ---
        # [snip bootloader output]
        # *** Booting Zephyr OS build v3.6.0-1544-g397b8465dc6b ***
        # Hello World! esp32s3_devkitm/esp32s3/procpu


#esp32-s3 tips:  
#    it appears u can build/flash/upload/monitor connected to EITHER of the usb ports on the devkitm (labeled USB and UART), but 
#    the 'monitor' output only shows up when connected on the UART port.   i suspect this means u can't gdb-debug and monitor at the same time.?

# echo debugging esp32s3 :

# TODO determine if the -as-shipped one is still 0.11.x and if so this is still needed.

#     echo get experimental esp32 debugger:   https://github.com/erhankur/openocd-esp32/tree/zephyr_riscv_thread_awareness
#     cd ~/.espressif/tools/
#     git clone https://github.com/erhankur/openocd-esp32 openocd-esp32-zephyr
#     cd openocd-esp32-zephyr
#     git checkout ephyr_riscv_thread_awareness
#     ./bootstrap
#     # install-it-over-the-top  / put it at the same path as my 'west -v debug' command was looking for it:
#     mkdir -p /home/buzz/zephyr-sdk-0.17.4/sysroots/x86_64-pokysdk-linux/usr
#     ./configure --prefix=/home/buzz/zephyr-sdk-0.17.4/sysroots/x86_64-pokysdk-linux/usr
#     make
#     sudo make install

#     # zephyr did/may ship/s with a version thats too old:
#     # https://github.com/zephyrproject-rtos/zephyr/issues/66379
#     # echo check openocd version:    
#     /home/buzz/zephyr-sdk-0.17.4/sysroots/x86_64-pokysdk-linux/usr/bin/openocd --version
#         #Open On-Chip Debugger 0.11.0+dev-00728-gb6f95a16c (2024-02-17-23:51)
    
#     #hack to use the newer "non experimental" openocd version:
#     #cd /home/buzz/zephyr-sdk-0.17.4/sysroots/x86_64-pokysdk-linux/usr/
#     #wget https://github.com/espressif/openocd-esp32/releases/download/v0.12.0-esp32-20240318/openocd-esp32-linux-amd64-0.12.0-esp32-20240318.tar.gz
#     #tar --strip-components=1  -zxvpf openocd-esp32-linux-amd64-0.12.0-esp32-20240318.tar.gz

#     # also need espressifs gdb version: https://github.com/zephyrproject-rtos/zephyr/issues/3550#issuecomment-331657018

#     #source /home/buzz2/ardupilot/modules/esp_idf/export.sh 

#     #... after a 'west build xxx'
#     #... and after a 'west flash'
#     #west debug
#     west -v debug

#exit

echo ===========================================================================================================

# after everything is installed and u've build and flashed before, u can just do:
  #cd ~  or some place else....
  cd $INSTALLTO
    cd ./zephyrproject
    source ./.venv/bin/activate
    cd zephyr
    west build -p always -b esp32s3_devkitm/esp32s3/procpu --sysbuild samples/hello_world
    #west build -p always -b esp32s3_devkitm/esp32s3/appcpu --sysbuild samples/hello_world

    #west build -p always -b esp32s3_devkitm --sysbuild samples/hello_world -DOPENOCD="/home/buzz/.espressif/tools/openocd-esp32/v0.12.0-esp32-20230921/openocd-esp32/bin/openocd" -DOPENOCD_DEFAULT_PATH="/home/buzz/.espressif/tools/openocd-esp32/v0.12.0-esp32-20230921/openocd-esp32/share"

    #west build -p always -b esp32s3_devkitm --sysbuild samples/hello_world -DOPENOCD="~/.espressif/tools/zephyr/openocd-esp32/bin/openocd" -DOPENOCD_DEFAULT_PATH="~/.espressif/tools/zephyr/openocd-esp32/share" -DGDB="/home/buzz/.espressif/tools/xtensa-esp-elf-gdb/11.2_20220823/xtensa-esp-elf-gdb/bin/xtensa-esp32s3-elf-gdb"

    west flash
    west espressif monitor
    west -v debug
    # note the path above that openocd is found at.. eg: 'runners.openocd: /home/buzz/zephyr-sdk-0.17.4/sysroots/x86_64-pokysdk-linux/usr/bin/openocd ...'
    # use that path below to put an updated ocd version in the same spot:


    # cd /home/buzz2/zephyrproject/zephyr/
    # rm -rf build
    # west build -p always -b esp32s3_devkitm/esp32s3/procpu --sysbuild samples/hello_world
    # west flash
    # west -v debug

echo ===========================================================================================================


# add your own github remote/fork to the main repo and optionally push there.

# todo.. just set zephyr,console = &usb_serial; in your DT.  Multiple boards do this, take a look at ./boards/xtensa/esp32s3_luatos_core/esp32s3_luatos_core_usb.dts for an example.
exit


# cd ./zephyrproject
# source ./.venv/bin/activate
# cd zephyr
# rm -rf build
# west build -p always -b esp32s3_devkitm --sysbuild samples/ardupilot
# west flash
# west -v debug