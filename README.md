# shack kiosk_v5 Configuration

NixOS configuration files for kiosk_v5.

`pull-update.sh` gets all configuration files from the NixOS device.

## `configuration.nix`
Contains the NixOS configuration.

## `i3-config`
`~/.i3/config` on the device. Contains the configuration for i3 to start the chromium in kiosk mode and provide a basic "desktop" environment.

## `touch-driver/…`
Contains the modified touch driver with adjustments to NixOS.
`eGTouch_v2.5.6722.L-x.tar.gz` is the original driver.

Modifications are done with `patchelf` to set a fitting *rpath* and SO *interpreter*.
