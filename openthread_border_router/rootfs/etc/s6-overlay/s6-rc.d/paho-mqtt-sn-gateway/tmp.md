ssh root@192.168.0.204 -p 22222
docker exec -it addon_local_openthread_border_router /bin/bash

https://www.kernel.org/doc/Documentation/admin-guide/devices.txt
mknod /dev/ttyACM0 c 166 0

"C:/Program Files (x86)/Nordic Semiconductor/nrf-command-line-tools/bin/nrfjprog.exe" --iface IP --ip 192.168.0.203 -f nrf52 --verify --chiperase --program Downloads/rcp-pca10059.hex

sudo ./script/build nrf52840 USB_trans -DOT_COMMISSIONER=ON -DOT_JOINER=ON -DOT_JAM_DETECTION=ON

arm-none-eabi-objcopy -O ihex build/bin/ot-rcp rcp-pca10059.hex && nrfjprog --iface IP --ip 192.168.0.203 -f nrf52 --verify --chiperase --program rcp-pca10059.hex



# FROM $BUILD_FROM AS addon_build
# WORKDIR /tmp/linux-src
# RUN \
# set -x \
# && apt-get update \
# && apt-get install -y --no-install-recommends \
# ca-certificates \
# libc-dev \
# linux-headers-generic \
# libssl-dev \
# libelf-dev \
# curl \
# gcc \
# bison \
# flex \
# make\
# musl-dev \
# bc \
# python3 \
# && KERNELVER=$(uname -r | cut -d '-' -f 1) \
# && curl -fsSL https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.15.57.tar.gz | tar -xzf - --strip-components=1 \
# && make defconfig \
# && ([ ! -f /proc/1/root/proc/config.gz ] || zcat /proc/1/root/proc/config.gz > .config) \
# && printf '%s\n' 'CONFIG_USBIP_CORE=m' 'CONFIG_USBIP_VHCI_HCD=m' 'CONFIG_USBIP_VHCI_HC_PORTS=8' 'CONFIG_USBIP_VHCI_NR_HCS=1' >> .config \
# && make oldconfig modules_prepare \
# && make M=drivers/usb/usbip \
# && mkdir -p /dist \
# && cd drivers/usb/usbip \
# && cp usbip-core.ko vhci-hcd.ko /dist \
# && echo -e '[General]\nAutoFind=0\n' > /dist/.vhui \
# && curl -fsSL https://www.virtualhere.com/sites/default/files/usbclient/vhclientx86_64 -o /dist/vhclientx86_64 \
# && chmod +x /dist/vhclientx86_64
