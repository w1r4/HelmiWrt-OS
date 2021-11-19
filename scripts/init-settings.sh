#!/bin/bash
#=================================================
# File name: init-settings.sh
# Description: This script will be executed during the first boot
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================
#--------------------------------------------------------
#   If you use some codes frome here, please give credit to www.helmiau.com
#--------------------------------------------------------

# Disable autostart by default for some packages
rm -f /etc/rc.d/S98udptools || true
rm -f /etc/rc.d/S99dockerd || true
rm -f /etc/rc.d/S99dockerman || true
rm -f /etc/rc.d/S30stubby || true
rm -f /etc/rc.d/S90stunnel || true

# Check file system during boot
uci set fstab.@global[0].check_fs=1
uci commit

# Disable opkg signature check
sed -i 's/option check_signature/# option check_signature/g' /etc/opkg.conf

#-----------------------------------------------------------------------------
#   Start of @helmiau additionals menu
#-----------------------------------------------------------------------------

# Set Argon theme to light on first boot
uci set argon.@global[0].mode='light'

# Set hostname to HelmiWrt
uci set system.@system[0].hostname='HelmiWrt'

# Set Timezone to Asia/Jakarta
uci set system.@system[0].timezone='WIB-7'
uci set system.@system[0].zonename='Asia/Jakarta'
uci commit system

# Set default wifi name to HelmiWrt
sed -i "s#option ssid 'OpenWrt'#option ssid 'HelmiWrt'#iIg" /etc/config/wireless

# Add shadowsocksr shortcut
chmod +x /bin/ssr

# Added neofetch on oh-my-zsh
echo "neofetch" > /root/.oh-my-zsh/custom/example.zsh
chmod +x /bin/neofetch
neofetch

# Vmess creator shortcut
chmod +x /bin/vmess

# Add ram checker from wegare123
# run "ram" using terminal to check ram usage
chmod +x /bin/ram

# Add fix download file.php for xderm and libernet
# run "fixphp" using terminal for use
chmod +x /bin/fixphp

# Add IP Address Info Checker
# run "myip" using terminal for use
chmod +x /bin/myip

# Add Samba Allowed Guest Setup
# run "sambaset" using terminal to set it up
chmod +x /bin/sambaset

# Add refresh IP Address for QMI Modems, such as LT4220
# Script by Rudi Hartono https://www.facebook.com/rud18
chmod +x /bin/ipqmi

# Fix luci-app-atinout-mod by 4IceG
chmod +x /usr/bin/luci-app-atinout

# Fix for xderm mini gui if trojan is not installed
ln -sf /usr/sbin/trojan /usr/bin/trojan

# HelmiWrt Patches
chmod +x /bin/helmiwrt
helmiwrt

# HelmiWrt Patches
if ! grep -q "helmiwrt" /etc/rc.local; then
	sed -i 's#exit 0#\n#g' /etc/rc.local
	cat << 'EOF' >> /etc/rc.local

chmod +x /bin/helmiwrt
/bin/helmiwrt
exit 0
EOF
	logger "  helmilog : helmipatch already applied to on-boot..."
	echo -e "  helmilog : helmipatch already applied to on-boot..."
fi

# Set default theme to luci-theme-argon and delete default watchcat setting
echo -e "uci set luci.main.mediaurlbase='/luci-static/argon'\nuci commit luci\n" > /bin/default-theme
echo -e "uci delete system.@watchcat[0]\nuci commit" >> /bin/default-theme
chmod +x /bin/default-theme
default-theme

# Add my Load Balance settings
chmod +x /bin/helmilb
#helmilb

# Add clashcs script : OpenClash Core switcher
chmod +x /bin/ocsm

# Add : v2rayA Script Manager : This script will help you to install v2rayA software to your openwrt device
# read more about v2rayA here
chmod +x /bin/vasm

# Bye-bye zh_cn
opkg remove $(opkg list-installed | grep zh-cn)

# start v2rayA service on boot
sed -i "s#option enabled.*#option enabled '1'#g" /etc/config/v2raya
/etc/init.d/v2raya enable
/etc/init.d/v2raya start
/etc/init.d/v2raya reload
/etc/init.d/v2raya restart

# activate TUN TAP interface
/usr/sbin/openvpn --mktun --dev tun0
/usr/sbin/openvpn --mktun --dev tun1

# Apply your own customization on boot features
if grep -q "helmiwrt.sh" /boot/helmiwrt.sh; then
	logger "  helmilog : detected helmiwrt.sh boot script, running script..."
	echo -e "  helmilog : detected helmiwrt.sh boot script, running script..."
	chmod +x /boot/helmiwrt.sh
	./boot/helmiwrt.sh
	logger "  helmilog : helmiwrt.sh boot script running done!"
	echo -e "  helmilog : helmiwrt.sh boot script running done!"
fi

# Disable etc/config/xmm-modem on boot first
if [[ -f /etc/config/xmm-modem ]]; then
	logger "  helmilog : detected helmiwrt.sh boot script, running script..."
	echo -e "  helmilog : detected helmiwrt.sh boot script, running script..."
	sed -i "s#option enable.*#option enable '0'#g" /etc/config/xmm-modem
	logger "  helmilog : helmiwrt.sh boot script running done!"
	echo -e "  helmilog : helmiwrt.sh boot script running done!"
fi

# Set Custom TTL
cat << 'EOF' >> /etc/firewall.user

# Set Custom TTL
iptables -t mangle -I POSTROUTING -o  -j TTL --ttl-set 65
iptables -t mangle -I PREROUTING -i  -j TTL --ttl-set 65
ip6tables -t mangle -I POSTROUTING ! -p icmpv6 -o  -j HL --hl-set 65
ip6tables -t mangle -I PREROUTING ! -p icmpv6 -i  -j HL --hl-set 65

EOF
/etc/config/firewall restart

# Fix Architecture overview for s9xxx amlogic
if ! grep -q "amlogic" /sbin/cpuinfo; then
	cat << 'EOF' >> /sbin/cpuinfo

# Amlogic board
if grep -q "amlogic" "/tmp/sysinfo/board_name"; then
	cpu_freq="$(expr $(cat /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_cur_freq) / 1000)MHz"
	big_cpu_freq="$(expr $(cat /sys/devices/system/cpu/cpufreq/policy4/cpuinfo_cur_freq 2>"/dev/null") / 1000 2>"/dev/null")"
	[ -n "${big_cpu_freq}" ] && big_cpu_freq="${big_cpu_freq}MHz "
	cpu_temp="$(awk "BEGIN{printf (\"%.1f\n\",$(cat /sys/class/thermal/thermal_zone0/temp)/1000) }")°C"
	echo -n "${cpu_arch} x ${cpu_cores} (${big_cpu_freq}${cpu_freq}, ${cpu_temp})"
fi

EOF
fi

# Fix 3ginfo
chmod +x /etc/init.d/3ginfo
chmod +x /usr/share/3ginfo/scripts/*
chmod +x /usr/share/3ginfo/cgi-bin/*

#-----------------------------------------------------------------------------
#   Start of @helmiau additionals menu
#-----------------------------------------------------------------------------

exit 0
