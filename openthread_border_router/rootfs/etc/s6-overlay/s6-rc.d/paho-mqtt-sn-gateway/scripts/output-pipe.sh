#!/usr/bin/with-contenv bashio

if [[ $1 == "out" ]]; then
    bashio::log.info "[MQTT-SN] $2"
elif [[ $1 == "err" ]]; then
    bashio::log.error "[MQTT-SN] $2"
else
    bashio::log.warning "[MQTT-SN] Unsupported pipe type!"
fi
