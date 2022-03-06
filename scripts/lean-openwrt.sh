#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================

HWOSDIR="package/base-files/files"

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' $HWOSDIR/bin/config_generate

# Switch dir to package/lean
pushd package/lean

# Add luci-app-ssr-plus
git clone --depth=1 https://github.com/fw876/helloworld

# Remove luci-app-uugamebooster and luci-app-xlnetacc
rm -rf luci-app-uugamebooster
rm -rf luci-app-xlnetacc

# Exit from package/lean dir
popd

# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall
[ ! -d openwrt-passwall/luci-app-passwall ] && svn co https://github.com/NueXini/NueXini_Packages/trunk/luci-app-passwall openwrt-passwall/luci-app-passwall
sed -i 's/ upx\/host//g' openwrt-passwall/v2ray-plugin/Makefile
grep -lr upx/host openwrt-passwall/* | xargs -t -I {} sed -i '/upx\/host/d' {}

# Add OpenClash
git clone --depth=1 -b dev https://github.com/vernesong/OpenClash

# Add luci-app-diskman
git clone --depth=1 https://github.com/SuLingGG/luci-app-diskman
mkdir parted
cp luci-app-diskman/Parted.Makefile parted/Makefile

# Add luci-app-dockerman
rm -rf ../lean/luci-app-docker
git clone --depth=1 https://github.com/lisaac/luci-app-dockerman
git clone --depth=1 https://github.com/lisaac/luci-lib-docker

# Add luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config

#-----------------------------------------------------------------------------
#   Start of @helmiau additionals packages for cloning repo 
#-----------------------------------------------------------------------------

# Add modeminfo
git clone --depth=1 https://github.com/koshev-msk/luci-app-modeminfo

# Add luci-app-smstools3
git clone --depth=1 https://github.com/koshev-msk/luci-app-smstools3

# Add luci-app-mmconfig : configure modem cellular bands via mmcli utility
git clone --depth=1 https://github.com/koshev-msk/luci-app-mmconfig

# Add support for Fibocom L860-GL l850/l860 ncm
git clone --depth=1 https://github.com/koshev-msk/xmm-modem

# Add 3ginfo, luci-app-3ginfo
git clone --depth=1 https://github.com/4IceG/luci-app-3ginfo

# Add luci-app-sms-tool
git clone --depth=1 https://github.com/4IceG/luci-app-sms-tool

# Add luci-app-atinout-mod
git clone --depth=1 https://github.com/4IceG/luci-app-atinout-mod

# HelmiWrt packages
git clone --depth=1 https://github.com/helmiau/helmiwrt-packages
rm -rf helmiwrt-packages/luci-app-v2raya

# Add themes from kenzok8 openwrt-packages
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-atmaterial_new kenzok8/luci-theme-atmaterial_new
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-edge kenzok8/luci-theme-edge
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-ifit kenzok8/luci-theme-ifit
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-mcat kenzok8/luci-theme-mcat
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-tomato kenzok8/luci-theme-tomato

# Add luci-theme-neobird theme
git clone --depth=1 https://github.com/helmiau/luci-theme-neobird

# Add Xradio kernel for Orange Pi Zero
svn co https://github.com/melsem/openwrt-lede_xradio-xr819_soc-audio/trunk/xradio-Openwrt_kernel-5.4.xx melsem/xradio
sed -i "s/ +wpad-mini//g" melsem/xradio/Makefile

# Add luci-app-amlogic
git clone --depth=1 https://github.com/ophub/luci-app-amlogic

# Add p7zip
git clone --depth=1 https://github.com/hubutui/p7zip-lede

# Add LuCI v2rayA
git clone --depth=1 https://github.com/zxlhhyccc/luci-app-v2raya

# HelmiWrt additional packages (telegrambot)
git clone --depth=1 https://github.com/helmiau/helmiwrt-adds
rm -rf helmiwrt-adds/build-ipk
rm -rf helmiwrt-adds/packages/kernel
rm -rf helmiwrt-adds/packages/lang

#-----------------------------------------------------------------------------
#   End of @helmiau additionals packages for cloning repo 
#-----------------------------------------------------------------------------

# Add luci-app-oled (R2S Only)
git clone --depth=1 https://github.com/NateLol/luci-app-oled

# Add extra wireless drivers
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06-k5.4/package/kernel/rtl8812au-ac
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06-k5.4/package/kernel/rtl8821cu
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06-k5.4/package/kernel/rtl8192du
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06-k5.4/package/kernel/rtl88x2bu
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06-k5.4/package/kernel/rtl8188eu
if [[ "$WORKFLOWNAME" == *"x86"* ]] ; then
	echo "x86 build detected, adding x86 kernel patches realtek additions..."
	#rtl8188eu patches
	sed -i 's/aircrack-ng/helmiau/g' rtl8188eu/Makefile
	sed -i 's/2021-02-06/2022-02-05/g' rtl8188eu/Makefile
	sed -i 's/1e7145f3237b3eeb3baf775f4a883e6d79c1cfe6/f2a36630006ceedd7fc275b3190afe733f5080b8/g' rtl8188eu/Makefile
	sed -i '/PKG_MIRROR_HASH/d' rtl8188eu/Makefile
	[ -f rtl8188eu/patches/030-wireless-5.8.patch ] && rm -f rtl8188eu/patches/030-wireless-5.8.patch
	#rtl8812au-ac patches
	sed -i 's/2021-05-22/2022-02-05/g' rtl8812au-ac/Makefile
	sed -i 's/0b87ed921a8682856aed5a3e68344b0087f3c93c/37e27f9165300c89607144b646545fac576ec510/g' rtl8812au-ac/Makefile
	sed -i '/PKG_MIRROR_HASH/d' rtl8812au-ac/Makefile
	[ -f rtl8812au-ac/patches/040-wireless-5.8.patch ] && rm -f rtl8812au-ac/patches/040-wireless-5.8.patch
	#rtl8821cu patches
	sed -i 's/2020-12-19/2021-11-14/g' rtl8821cu/Makefile
	sed -i 's/428a0820487418ec69c0edb91726d1cf19763b1e/ef3ff12118a75ea9ca1db8f4806bb0861e4fffef/g' rtl8821cu/Makefile
	sed -i '/PKG_MIRROR_HASH/d' rtl8821cu/Makefile
	[ -f rtl8821cu/patches/040-wireless-5.8.patch ] && rm -f rtl8821cu/patches/040-wireless-5.8.patch
fi


popd

# Mod zzz-default-settings for HelmiWrt
pushd package/lean/default-settings/files
sed -i '/http/d' zzz-default-settings
sed -i '/18.06/d' zzz-default-settings
export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
export date_version=$(date -d "$(rdate -n -4 -p pool.ntp.org)" +'%Y-%m-%d')
sed -i "s/${orig_version}/${orig_version} ${date_version}/g" zzz-default-settings
sed -i "s/zh_cn/auto/g" zzz-default-settings
sed -i "s/uci set system.@system[0].timezone=CST-8/uci set system.@system[0].hostname=HelmiWrt\nuci set system.@system[0].timezone=WIB-7/g" zzz-default-settings
sed -i "s/Shanghai/Jakarta/g" zzz-default-settings
popd

# Fix mt76 wireless driver
pushd package/kernel/mt76
sed -i '/mt7662u_rom_patch.bin/a\\techo mt76-usb disable_usb_sg=1 > $\(1\)\/etc\/modules.d\/mt76-usb' Makefile
popd

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' $HWOSDIR/etc/passwd

# x86 Patches
if [[ "$WORKFLOWNAME" == *"x86"* ]] ; then
	pushd package
	# Add rtl8723bu for x86
	svn co https://github.com/radityabh/raditya-package/trunk/rtl8723bu kernel/rtl8723bu
	wget -q https://raw.githubusercontent.com/WYC-2020/lede/205d384f392ee6307fc73e083c67064ef6eaac65/package/kernel/linux/modules/crypto.mk -O kernel/linux/modules/crypto.mk
	wget -q https://raw.githubusercontent.com/WYC-2020/lede/71e0b9d1334a8dc735231da4ff81e60c3006410d/package/kernel/mac80211/patches/ath/001-fix-wil6210-build-with-kernel-5.15.patch -O kernel/mac80211/patches/ath/001-fix-wil6210-build-with-kernel-5.15.patch
	wget -q https://raw.githubusercontent.com/WYC-2020/lede/893ba3d9e6984f90560a0f93921f651ee3ae96cf/package/kernel/mac80211/patches/rt2x00/651-rt2x00-driver-compile-with-kernel-5.15.patch -O kernel/mac80211/patches/rt2x00/651-rt2x00-driver-compile-with-kernel-5.15.patch
	wget -q https://raw.githubusercontent.com/WYC-2020/lede/3cc62304a7829cb0dc95328cb6809cf57e3dba40/package/kernel/mt76/patches/001-fix-mt76-driver-build-with-kernel-5.15.patch -O kernel/mt76/patches/001-fix-mt76-driver-build-with-kernel-5.15.patch
	popd

	pushd target
	wget -q https://raw.githubusercontent.com/WYC-2020/lede/0bdae446b37ca151de2c17902635df59770c5c25/target/linux/generic/backport-5.15/001-fix-kmod-iwlwifi-build-on-kernel-5.15.patch -O linux/generic/backport-5.15/001-fix-kmod-iwlwifi-build-on-kernel-5.15.patch
	wget -q https://raw.githubusercontent.com/WYC-2020/lede/9ea4c2e7634d73645bd3274f2d5fd8437580ea77/target/linux/generic/backport-5.15/003-add-module_supported_device-macro.patch -O linux/generic/backport-5.15/003-add-module_supported_device-macro.patch
	wget -q https://raw.githubusercontent.com/WYC-2020/lede/f60db604f07165d5cd8f7a98be6890180c790513/target/linux/generic/pending-5.15/613-netfilter_optional_tcp_window_check.patch -O linux/generic/pending-5.15/613-netfilter_optional_tcp_window_check.patch
	wget -q https://raw.githubusercontent.com/WYC-2020/lede/01358c12ec1bfa6d5237eadecbd5ac404705cab3/target/linux/generic/backport-5.15/004-add-old-kernel-macros.patch -O linux/generic/backport-5.15/004-add-old-kernel-macros.patch
	popd
fi

#-----------------------------------------------------------------------------
#   Start of @helmiau terminal scripts additionals menu
#-----------------------------------------------------------------------------
rawgit="https://raw.githubusercontent.com"

# Add vmess creator account from racevpn.com
# run "vmess" using terminal to create free vmess account
# wget --show-progress -qO $HWOSDIR/bin/vmess "$rawgit/ryanfauzi1/vmesscreator/main/vmess"

# Add ram checker from wegare123
# run "ram" using terminal to check ram usage
wget --show-progress -qO $HWOSDIR/bin/ram "$rawgit/wegare123/ram/main/ram.sh"

# Add fix download file.php for xderm and libernet
# run "fixphp" using terminal for use
wget --show-progress -qO $HWOSDIR/bin/fixphp "$rawgit/helmiau/openwrt-config/main/fix-xderm-libernet-gui"

# Add wegare123 stl tools
# run "stl" using terminal for use
usergit="wegare123"
mkdir -p $HWOSDIR/root/akun $HWOSDIR/usr/bin
wget --show-progress -qO $HWOSDIR/usr/bin/stl "$rawgit/$usergit/stl/main/stl/stl.sh"
wget --show-progress -qO $HWOSDIR/usr/bin/gproxy "$rawgit/$usergit/stl/main/stl/gproxy.sh"
wget --show-progress -qO $HWOSDIR/usr/bin/autorekonek-stl "$rawgit/$usergit/stl/main/stl/autorekonek-stl.sh"
wget --show-progress -qO $HWOSDIR/root/akun/tunnel.py "$rawgit/$usergit/stl/main/stl/tunnel.py"
wget --show-progress -qO $HWOSDIR/root/akun/ssh.py "$rawgit/$usergit/stl/main/stl/ssh.py"
wget --show-progress -qO $HWOSDIR/root/akun/inject.py "$rawgit/$usergit/stl/main/stl/inject.py"

# Add wifi id seamless autologin by kopijahe
# run "kopijahe" using terminal for use
wget --show-progress -qO $HWOSDIR/bin/kopijahe "$rawgit/kopijahe/wifiid-openwrt/master/scripts/kopijahe"

#-----------------------------------------------------------------------------
#   End of @helmiau terminal scripts additionals menu
#-----------------------------------------------------------------------------
