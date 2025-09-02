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
echo     https://docs.zephyrproject.org/latest/boards/pjrc/teensy4/doc/index.html
echo     eg: teensy40


echo ===========================================================================================================

# after everything is installed and u've build and flashed before, u can just do:
  #cd ~  or some place else....
  cd $INSTALLTO
    cd ./zephyrproject
    source ./.venv/bin/activate
    cd zephyr
    # teensy40 is a pre-canned target that has a nxp imxrt1062 in it.
    west build -p always -b teensy40 --sysbuild samples/hello_world



# - west flash: using runner teensy
# FATAL ERROR: required program teensy_loader_cli not found; install it or add its location to PATH
 # get it: https://www.pjrc.com/teensy/loader_cli.html or https://github.com/PaulStoffregen/teensy_loader_cli
 #if not this directory: teensy_loader_cli
    if [ ! -d $INSTALLTO/zephyrproject/teensy_loader_cli ]; then
    cd $INSTALLTO/zephyrproject
    sudo apt-get install libusb-dev
    git clone https://github.com/PaulStoffregen/teensy_loader_cli
    cd teensy_loader_cli
    make
    PATH=$INSTALLTO/zephyrproject/teensy_loader_cli:$PATH
    wget https://www.pjrc.com/teensy/00-teensy.rules
    sudo cp 00-teensy.rules /etc/udev/rules.d/00-teensy.rules 
    sudo udevadm control --reload-rules
    cd -
    fi


    west flash

echo ===========================================================================================================


# add your own github remote/fork to the main repo and optionally push there.

# todo.. just set zephyr,console = &usb_serial; in your DT.  Multiple boards do this, take a look at ./boards/xtensa/esp32s3_luatos_core/esp32s3_luatos_core_usb.dts for an example.
