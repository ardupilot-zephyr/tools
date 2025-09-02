#!/bin/bash -x

export INSTALLTO=/home/buzz2
# will end up as: home/buzz2/zephyrproject

#echo repo:  https://github.com/zephyrproject-rtos/zephyr
echo repo:  https://github.com/ardupilot-zephyr/zephyr

echo docs: https://docs.zephyrproject.org/latest/

echo supported boards:  https://docs.zephyrproject.org/latest/boards/index.html

sudo apt-get install --no-install-recommends git cmake ninja-build gperf \
  ccache dfu-util device-tree-compiler wget \
  python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
  make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1

  # test if cmake version is new enough:
  # https://docs.zephyrproject.org/latest/develop/getting_started/installation_linux.html#cmake
cmake_version=$(cmake --version | head -n1 | awk '{print $3}')
required_min_version="3.20.5"
#if [ "$(printf '%s\n' "$required_min_version" "$cmake_version" | sort -V | head -n1)" != "$required_min_version" ]; then
# if it starts with a 4, its ok, or if it starts with 3.2x thats ok too
if [[ "$cmake_version" == 4.* || "$cmake_version" == 3.2[1-9]* ]]; then
    echo "CMake version $cmake_version is sufficient."
else
    echo "CMake version $cmake_version is too old. getting newer version..."
    cd ~
    wget https://github.com/Kitware/CMake/releases/download/v3.21.1/cmake-3.21.1-Linux-x86_64.sh
    chmod +x cmake-3.21.1-Linux-x86_64.sh
    sudo ./cmake-3.21.1-Linux-x86_64.sh --skip-license --prefix=/usr/local
    hash -r
fi

# DTC (Device Tree Compiler)
#A recent DTC version is required.

dtc_version=$(dtc --version | awk '{print $3}')
required_min_version="1.4.6"
# if it starts with 1.4.[6-9] or 1.5x or 2.x or 3.x or 4.x its ok
if [[ "$dtc_version" == 1.4.[6-9]* || "$dtc_version" == 1.[56789]* || "$dtc_version" == 2.* || "$dtc_version" == 3.* || "$dtc_version" == 4.* ]]; then
    echo "DTC version $dtc_version is sufficient."
else
    echo "DTC version $dtc_version is too old. getting newer version..."
    # a newer one comes with the zephyr-sdk, so skip this step for now.
    #sudo apt-get remove device-tree-compiler
fi

#Install the Zephyr Software Development Kit (SDK)
#The Zephyr Software Development Kit (SDK) contains toolchains for each of Zephyr’s supported architectures. It also includes additional host tools, such as custom QEMU and OpenOCD.
# https://docs.zephyrproject.org/latest/develop/getting_started/installation_linux.html#install-the-zephyr-software-development-kit-sdk
# is_sdk_dir_already_there=$(ls ~ | grep zephyr-sdk-0.17.4 | wc -l)
# if [ $is_sdk_dir_already_there -gt 0 ]; then
#     echo "Zephyr SDK already installed in ~/zephyr-sdk-0.17.4 , skipping re-install."
# else 
#     echo Install the Zephyr SDK into HOME:
#     #'It is recommended to extract the Zephyr SDK bundle at one of the following locations:' 
#     # this is "If you want to install Zephyr SDK without using the west sdk command, please see Zephyr SDK installation."
#     cd ~
#     # wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.17.4/zephyr-sdk-0.17.4_linux-x86_64.tar.xz
#     # wget -O - https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.17.4/sha256.sum | shasum --check --ignore-missing
# SDK_VER=0.17.4
#     wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.17.4/zephyr-sdk-0.17.4_linux-x86_64.tar.xz
#     wget -O - https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.17.4/sha256.sum | shasum --check --ignore-missing
#     tar xvf zephyr-sdk-0.17.4_linux-x86_64.tar.xz
#     cd zephyr-sdk-0.17.4
#     # avail targets:
#     #./setup.sh --help
#     #./setup.sh -t arm-zephyr-eabi -t xtensa-espressif_esp32_zephyr-elf -t xtensa-espressif_esp32s3_zephyr-elf
#     ./setup.sh -t all
#     #sudo cp ~/zephyr-sdk-0.17.4/sysroots/x86_64-pokysdk-linux/usr/share/openocd/contrib/60-openocd.rules /etc/udev/rules.d
#     #sudo udevadm control --reload
#     # when extracted under $HOME, the resulting installation path will be $HOME/zephyr-sdk-<version>
#     export ZEPHYR_SDK_INSTALL_DIR=$HOME/zephyr-sdk-$SDK_VER
# fi

# exit

#Install Requirements and Dependencies
# - a recent cmake thats newer than 3.20.5
# echo https://docs.zephyrproject.org/latest/develop/getting_started/index.html
# echo getting started on ubuntu:
#     wget https://apt.kitware.com/kitware-archive.sh
#     #sudo bash kitware-archive.sh
#     #'Only Ubuntu Focal (20.04) and Jammy (22.04) are supported. Aborting.'
#     sudo cp /etc/os-release /etc/os-release.old
#     sudo sed -i 's/mantic/jammy/' /etc/os-release.old
#     sudo sed -i 's/os-release/os-release.old/' kitware-archive.sh
#     sudo bash kitware-archive.sh

cmake --version
python3 --version
dtc --version

# https://docs.zephyrproject.org/latest/develop/getting_started/index.html#get-zephyr-and-install-python-dependencies
echo 'Get Zephyr and install Python dependencies'

if [ ! -d $INSTALLTO/zephyrproject ]; then
    echo 'NEW Zephyr prpoject seyup and install Python dependencies'
    #cd ~  or some place else....
    cd $INSTALLTO
    mkdir $INSTALLTO/zephyrproject/
    #rm -rf $INSTALLTO/zephyrproject - violnt, dont do unless ure sure.
    #rm -rf $INSTALLTO/zephyrproject/.venv/bin/python3
    sudo apt install python3-venv
    python3 -m venv ./zephyrproject/.venv
    source ./zephyrproject/.venv/bin/activate
    echo 'Remember to activate the virtual environment every time you start working.'
    # 'Install west:'
    pip install west
    # 'Get the Zephyr source code:'
    cd $INSTALLTO
    west init ./zephyrproject
    cd ./zephyrproject
    west update
    #'Install Python dependencies using west packages.'
    west packages pip --install
    # this is the more automated way of gettin gthe sdk, but we put it at $HOME/zephyr-sdk-0.17.4 above instead.
    # this,and the above manual download shouldnt both be needed, b buzz hasnt found a way to avoid this one:
    # for some reason, this fines 0.17.2 of th esdk, and puts it  here: /home/buzz/zephyr-sdk-0.17.2
    # cat /home/buzz2/zephyrproject/zephyr/SDK_VERSION
    cd $INSTALLTO/zephyrproject && west sdk install && cd -
  #cd ~  or some place else....
else 
    echo 'Zephyr prpoject already setup, skipping re-init.'
    cd $INSTALLTO/zephyrproject
    source ./.venv/bin/activate
    west update
    # 'Export a Zephyr CMake package. This allows CMake to automatically load boilerplate code required for building Zephyr applications.''
    west zephyr-export
    #pip install -r ./zephyr/scripts/requirements.txt
    west packages pip --install
fi

echo "please run the ./buzz.run.ubuntu.zephyr.sh script to build and flash a sample app."
export ZEPHYR_SDK_INSTALL_DIR=$HOME/zephyr-sdk-$SDK_VER
