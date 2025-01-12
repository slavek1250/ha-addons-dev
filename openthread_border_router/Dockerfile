ARG BUILD_FROM

FROM $BUILD_FROM AS mqttsn_build

ARG PAHO_MQTT_SN_VERSION=master

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV PAHO_MQTT_SN_OPTIONS "-DSENSORNET=udp6"

# Required and installed for MQTT-SN can be removed after build
ENV PAHO_MQTT_SN_DEPS git make libssl-dev build-essential ninja-build cmake

WORKDIR /usr/src

RUN \
    set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       ${PAHO_MQTT_SN_DEPS} \
    && git clone https://github.com/eclipse/paho.mqtt-sn.embedded-c.git \
    && cd paho.mqtt-sn.embedded-c \
    && git checkout ${PAHO_MQTT_SN_VERSION} \
    && mkdir output \
    && cd output \
    && cmake .. ${PAHO_MQTT_SN_OPTIONS} \
    && make \
    && apt-get purge -y --auto-remove \
       git \
       ${PAHO_MQTT_SN_DEPS}

FROM $BUILD_FROM

ARG BUILD_ARCH

ARG OTBR_VERSION=9fea68cfbeae472dc628d7c8735b442a5b657ff1

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# ENV INFRA_IF_NAME eth0
ENV BORDER_ROUTING 1
ENV BACKBONE_ROUTER 0
ENV OTBR_OPTIONS "-DOTBR_DBUS=OFF -DOT_POSIX_CONFIG_RCP_BUS=UART -DOT_DIAGNOSTIC=1 -DOT_LINK_RAW=1 -DOTBR_VENDOR_NAME=HomeAssistant -DOTBR_PRODUCT_NAME=OpenThreadBorderRouter"
ENV PLATFORM debian
ENV RELEASE 1
ENV WEB_GUI 1
ENV REST_API 1
ENV DOCKER 1

COPY 0001-Avoid-writing-to-system-console.patch /usr/src

# Required and installed (script/bootstrap) can be removed after build
ENV OTBR_BUILD_DEPS build-essential ninja-build cmake wget ca-certificates \
  libreadline-dev libncurses-dev libcpputest-dev libdbus-1-dev libavahi-common-dev \
  libavahi-client-dev libboost-dev libboost-filesystem-dev libboost-system-dev \
  libnetfilter-queue-dev

# Installed during build (script/bootstrap) but unused in our configuration
ENV OTBR_UNUSED_DEBS libavahi-client3 avahi-daemon rsyslog


WORKDIR /usr/src

# Install npm/nodejs for WebUI manually to avoid systemd getting pulled in
RUN \
    set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       git \
       iproute2 \
       libssl-dev \
       lsb-release \
       make \
       nodejs \
       npm \
       sudo \
    && git clone --depth 1 -b main \
       https://github.com/openthread/ot-br-posix.git \
    && cd ot-br-posix \
    && git fetch origin ${OTBR_VERSION} \
    && git checkout ${OTBR_VERSION} \
    && git submodule update --init \
    && ./script/bootstrap \
    && patch -p1 < /usr/src/0001-Avoid-writing-to-system-console.patch \
    && ./script/setup \
    && apt-get purge -y --auto-remove \
       git \
       ${OTBR_BUILD_DEPS} \
       ${OTBR_UNUSED_DEBS} \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/src/*

# COPY rootfs /
COPY --from=mqttsn_build /usr/src/paho.mqtt-sn.embedded-c/MQTTSNGateway/bin/MQTT* /usr/sbin/
COPY --from=mqttsn_build /usr/src/paho.mqtt-sn.embedded-c/output/MQTTSNPacket/src/libMQTTSNPacket.so /usr/local/lib/
