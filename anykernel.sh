# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers
# chipskernel changes by najahi

## AnyKernel setup
# begin properties
properties() { '
kernel.string=### Chips kernel for OnePlus 9/Pro ###
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=OnePlus9Pro
device.name2=lemonadep
device.name3=OnePlus9ProTMO
device.name4=lemonadept
device.name5=OnePlus9
device.name6=lemonade
device.name7=OnePlus9TMO
device.name8=lemonadet
device.name9=OnePlus9VZW
device.name10=lemonadev
supported.versions=11
supported.patchlevels=
'; } # end properties

# shell variables
block=boot;
is_slot_device=1;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 750 750 $ramdisk/*;


## Trim partitions
$bin/busybox fstrim -v /data;


## AnyKernel boot install
dump_boot;

# remove old root patch avoidance hack
patch_cmdline "skip_override" "";

write_boot;
## end boot install


# shell variables
block=vendor_boot;
is_slot_device=1;
ramdisk_compression=auto;

# reset for vendor_boot patching
reset_ak;


## AnyKernel vendor_boot install
split_boot;

# remove old root patch avoidance hack
patch_cmdline "skip_override" "";

flash_boot;
## end vendor_boot install
