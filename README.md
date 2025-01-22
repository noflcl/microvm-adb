# microvm-adb

This VM includes `tailscale` and can be removed if you prefer.

<mark>Note:</mark> VM set for `3 * 1024` of memory usage, known bug in `QEMU` setting `2 Gig` memory usage, recommended to set above or bellow.

### Adding USB devices to the VM

Run `lsusb` on your `VM Host` system to locate the devices `vendorID` and `productID`, you will need to add the `0x` within your nix config before each value.

`guest.nix`
```
microvm.devices = [
    { bus = "usb"; path = "vendorid=0x18d1,productid=0x4ee7"; }
];

```

Your `VM host` will need to set the systemd services file to pass the device to quem guests.

`host.nix`

```
###
# Services
###
services.udev.extraRules = ''
  SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee7", GROUP="kvm"
'';
```
### To-Do

  - [ ] Finish setting up `SOPS` to manage keys for reproducable ADB server
