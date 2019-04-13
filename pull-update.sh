#!/bin/bash

SOURCE=shack@lounge.kiosk.shack

scp ${SOURCE}:/etc/nixos/configuration.nix configuration.nix
scp ${SOURCE}:/home/shack/.i3/config i3-config
scp -r ${SOURCE}:/home/shack/touch-driver touch-driver
