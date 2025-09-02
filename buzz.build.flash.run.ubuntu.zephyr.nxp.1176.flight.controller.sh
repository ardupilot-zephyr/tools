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
echo     https://docs.zephyrproject.org/latest/boards/nxp/vmu_rt1170/doc/index.html
echo     https://www.nxp.com/design/design-center/development-boards-and-designs/real-time-vehicle-management-unit-vmu:VEHICLE-MANAGEMENT-UNIT
echo     https://github.com/CogniPilot/NXP-VMU_RT117x-HW - open reference design
echo     https://docs.px4.io/main/en/flight_controller/nxp_mr_vmu_rt1176
echo     eg: vmu_rt1170/mimxrt1176/cm7

echo The VMU RT1170 features an i.MX RT1176 dual core MCU with the Cortex-M7 core at 1 GHz 
echo and a Cortex-M4 at 400 MHz. The i.MX RT1176 MCU offers support over a wide temperature 
echo range and is qualified for consumer, industrial and automotive markets. 
echo The VMU RT1170 is the default VMU for CogniPilot’s Cerebri, a Zephyr RTOS based Autopilot.



    # VMU RT1170 Schematics https://github.com/CogniPilot/NXP-VMU_RT117x-HW

    # i.MX RT1170 Datasheet https://www.nxp.com/docs/en/data-sheet/IMXRT1170CEC.pdf

    # i.MX RT1170 Reference Manual https://www.nxp.com/webapp/Download?colCode=IMXRT1170RM

    # random fact: The MIMXRT1170 SoC has 12 UARTs.


echo ===========================================================================================================

# after everything is installed and u've build and flashed before, u can just do:
  #cd ~  or some place else....
  cd $INSTALLTO
    cd ./zephyrproject
    source ./.venv/bin/activate
    cd zephyr
    # vmu_rt1170/mimxrt1176/cm7 is a pre-canned FLIGHT CONTROLLER target that has a nxp imxrt1176 in it.
    west build -p always -b vmu_rt1170/mimxrt1176/cm7 --sysbuild samples/hello_world

    # -- west flash: using runner jlink
    # -- runners.jlink: reset after flashing requested
    # FATAL ERROR: required program JLinkExe not found; install it or add its location to PATH
    if [ ! -f $INSTALLTO/zephyrproject/JLink_Linux_V864a_x86_64.deb.done ]; then
    if [ -f $INSTALLTO/zephyrproject/JLink_Linux_V864a_x86_64.deb ]; then
    cd $INSTALLTO/zephyrproject
    echo get the jlink tools from segger:
    #visit https://www.segger.com/downloads/jlink/JLink_Linux_x86_64.deb
    # agree, download, save to this folder.
    sudo dpkg -i JLink_Linux_V864a_x86_64.deb
    mv JLink_Linux_V864a_x86_64.deb JLink_Linux_V864a_x86_64.deb.done
    # default location is: /opt/SEGGER/JLink_V864a/JLinkExe and west expects it there.
    cd $INSTALLTO/zephyrproject/zephyr
    fi
    fi

    west flash

echo ===========================================================================================================


# add your own github remote/fork to the main repo and optionally push there.

# todo.. just set zephyr,console = &usb_serial; in your DT.  Multiple boards do this, take a look at ./boards/xtensa/esp32s3_luatos_core/esp32s3_luatos_core_usb.dts for an example.
