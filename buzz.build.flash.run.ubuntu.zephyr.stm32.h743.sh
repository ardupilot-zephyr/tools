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
echo     eg: nucleo_h743zi


echo ===========================================================================================================

# after everything is installed and u've build and flashed before, u can just do:
  #cd ~  or some place else....
  cd $INSTALLTO
    cd ./zephyrproject
    source ./.venv/bin/activate
    cd zephyr
    # nucleo_h743zi is a pre-canned target that has a STM32H743 in it.
    west build -p always -b nucleo_h743zi --sysbuild samples/hello_world

    #-- west flash: using runner stm32cubeprogrammer
    #  FATAL ERROR: required program /home/buzz/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin/STM32_Programmer_CLI not found; install it or add its location to PATH
    # get it: https://www.st.com/en/development-tools/stm32cubeprog.html
    #visisit there. click the download link, enter a n email address, wait ofr the email, click the link, get the file. eg: linux: stm32cubeprg-lin-v2-20-0.zip
    # cd $INSTALLTO
    # unzip $INSTALLTO/stm32cubeprg-lin-v2-20-0.zip
    # ./SetupSTM32CubeProgrammer-2.20.0.linux
    # # accept the terms in a GUI, install to the default location, as thats where west/zephyr expects to find it: /home/buzz/STMicroelectronics/STM32Cube/STM32CubeProgrammer
    # cd -


    west flash

echo ===========================================================================================================


# add your own github remote/fork to the main repo and optionally push there.

# todo.. just set zephyr,console = &usb_serial; in your DT.  Multiple boards do this, take a look at ./boards/xtensa/esp32s3_luatos_core/esp32s3_luatos_core_usb.dts for an example.
