# microvm-adb

This VM includes `tailscale` and can be removed if you prefer.

<mark>Note:</mark> VM set for `3 * 1024` of memory usage, known bug in `QEMU` setting `2 Gig` memory usage, recommended to set above or bellow.

### Test It

```
git clone https://github.com/noflcl/microvm-adb.git
cd microvm-adb

nix run .#vm-adb
```

### Adding Devices To VM

Permission setup is automatic for declared "pci' devices, but manual for "usb" devices. To pass a USB through run `lsusb` on your `VM Host` system to locate the devices `vendorID` and `productID`, you will need to add the prefix of `0x` to each ID within the guests configuration.

`guest.nix`
```
# lsusb to find vendorID & productID, add the `0x` prefix
devices = [
  { bus = "usb"; path = "vendorid=0x18d1,productid=0x4ee7"; }
  { bus = "usb"; path = "vendorid=0x18d1,productid=0x4ee0"; }
];

```

`host.nix`

USB device paths are not directly translatable to udev rules. Your `VM host` will need to setup a systemd services file to pass the devices to qemu guest. You can omit the `0x` at the beginning of your IDs here.

```
###
# Services
###
services.udev.extraRules = ''
  SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee7", GROUP="kvm"
  SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee0", GROUP="kvm"
'';
```
### To-Do

  - [ ] Upgrade to supported NixOS `24.11`
  - [ ] Finish setting up `SOPS` to manage keys for reproducible ADB server
