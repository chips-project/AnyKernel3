#!/system/bin/sh

# (c) 2019-2021 changes for chipskernel by najahi

# Wait to set proper init values
sleep 30

# Disable zram
swapoff /dev/block/zram0

# Set TCP congestion algorithm
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control

# Tweak IO performance after boot complete
for device in a b c d e f; do
    echo "mq-deadline" > /sys/block/sd${device}/queue/scheduler
    echo 512 > /sys/block/sd${device}/queue/read_ahead_kb
    echo 128 > /sys/block/sd${device}/queue/nr_requests
done

# Input boost configuration
echo "0:1094400 1:0 2:0 3:0 4:0 5:0 6:0 7:0" > /sys/devices/system/cpu/cpu_boost/input_boost_freq
echo 500 > /sys/devices/system/cpu/cpu_boost/input_boost_ms

# Disable scheduler core_ctl
echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/enable
echo 0 > /sys/devices/system/cpu/cpu4/core_ctl/enable
echo 0 > /sys/devices/system/cpu/cpu7/core_ctl/enable

# Disable swap file
if [ ! -e /data/vendor/swap/zram_wb_chips ]; then
    rm -f /data/vendor/swap/zram_wb
    touch /data/vendor/swap/zram_wb_chips
    ln -s /data/vendor/swap/zram_wb_chips /data/vendor/swap/zram_wb
fi

# Set zram config
echo 1 > /sys/block/zram0/reset
echo "lzo-rle" > /sys/block/zram0/comp_algorithm
echo 2202009600 > /sys/block/zram0/disksize
mkswap /dev/block/zram0
swapon /dev/block/zram0 -p 32758

echo "Boot chipskernel completed" >> /dev/kmsg
