#!/bin/bash

# SETUP CONFIG FILES
# ---------------------------------------------------------------------------------------------

# Make sure that configuration is only run once
if [ ! -f "/etc/configuration_built" ]; then
  touch "/etc/configuration_built"
  setup.sh
fi

# LAUNCH ALL SERVICES
# ---------------------------------------------------------------------------------------------

echo "[INFO] Starting services"
exec s6-svscan /services
