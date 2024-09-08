sudo apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
source /root/config.cfg
#!/bin/bash

versionWgcf="2.2.11"
downloadFilenameWgcf="wgcf_${versionWgcf}_linux_amd64"
configWgcfBinPath="/usr/local/bin"
configWgcfConfigFolderPath="${HOME}/wireguard"
configWgcfAccountFilePath="${configWgcfConfigFolderPath}/wgcf-account.toml"
configWgcfProfileFilePath="${configWgcfConfigFolderPath}/wgcf-profile.conf"
configWARPPortFilePath="${configWgcfConfigFolderPath}/warp-port"
configWireGuardConfigFileFolder="/etc/wireguard"
configWireGuardConfigFilePath="/etc/wireguard/wgcf.conf"
configWireGuardDNSBackupFilePath="/etc/resolv_warp_bak.conf"
configWarpPort="40000"
osKernelVersionFull=$(uname -r)
osKernelVersionBackup=$(uname -r | awk -F "-" '{print $1}')
osKernelVersionShort=$(uname -r | cut -d- -f1 | awk -F "." '{print $1"."$2}')
osKernelBBRStatus=""

function getGithubLatestReleaseVersion(){
    # https://github.com/p4gefau1t/trojan-go/issues/63
    wget --no-check-certificate -qO- https://api.github.com/repos/$1/tags | grep 'name' | cut -d\" -f4 | head -1 | cut -b 2-
}

function installSoftDownload(){

	PACKAGE_LIST=( "wget" "curl" "git" "unzip" "apt-transport-https" "cpu-checker" "bc" "cron" )
	
	# 检查所有软件包是否已安装
	for package in "${PACKAGE_LIST[@]}"; do
	  if ! dpkg -l | grep -qw "$package"; then
	      # green "$package is not installed. apt-get Installing..."
	      apt-get install -y "$package"
	  fi
	done

  if ! dpkg -l | grep -qw curl; then
    apt-get -y install wget curl git

  fi

      if ! dpkg -l | grep -qw ca-certificates; then
    apt-get -y install ca-certificates dmidecode
          update-ca-certificates
  fi


}
installSoftDownload
function installWireguard(){



    if [[ -f "${configWireGuardConfigFilePath}" ]]; then
        exit
    fi




    isKernelSupportWireGuardVersion="5.6"
    isKernelBuildInWireGuardModule="no"

    if versionCompareWithOp "${isKernelSupportWireGuardVersion}" "${osKernelVersionShort}" ">"; then
        isKernelBuildInWireGuardModule="no"
    else
        isKernelBuildInWireGuardModule="yes"
    fi
	isContinueInput=${isContinueInput:-Y}


    sudo apt --fix-broken install -y
    sudo apt-get update
    sudo apt install -y openresolv
    # sudo apt install -y resolvconf
    sudo apt install -y net-tools iproute2 dnsutils
    echo
    if [[ ${isKernelBuildInWireGuardModule} == "yes" ]]; then
        echo
        sudo apt install -y wireguard-tools
    else
        # 安装 wireguard-dkms 后 ubuntu 20 系统 会同时安装 5.4.0-71   内核
        echo
        sudo apt install -y wireguard
        # sudo apt install -y wireguard-tools
    fi

    # if [[ ! -L "/usr/local/bin/resolvconf" ]]; then
    #     ln -s /usr/bin/resolvectl /usr/local/bin/resolvconf
    # fi

    sudo systemctl enable systemd-resolved.service
    sudo systemctl start systemd-resolved.service

    installWGCF
}
function installWGCF(){

    versionWgcf=$(getGithubLatestReleaseVersion "ViRb3/wgcf")
    downloadFilenameWgcf="wgcf_${versionWgcf}_linux_amd64"

    mkdir -p ${configWgcfConfigFolderPath}
    mkdir -p ${configWgcfBinPath}
    mkdir -p ${configWireGuardConfigFileFolder}

    cd ${configWgcfConfigFolderPath}

    # https://github.com/ViRb3/wgcf/releases/download/v2.2.10/wgcf_2.2.10_linux_amd64
    wget -O ${configWgcfConfigFolderPath}/wgcf --no-check-certificate "https://github.com/ViRb3/wgcf/releases/download/v${versionWgcf}/${downloadFilenameWgcf}"


    if [[ -f ${configWgcfConfigFolderPath}/wgcf ]]; then
        echo
    else
        exit 255
    fi

    sudo chmod +x ${configWgcfConfigFolderPath}/wgcf
    cp ${configWgcfConfigFolderPath}/wgcf ${configWgcfBinPath}

    # ${configWgcfConfigFolderPath}/wgcf register --config "${configWgcfAccountFilePath}"

    if [[ -f ${configWgcfAccountFilePath} ]]; then
        echo
    else
        yes | ${configWgcfConfigFolderPath}/wgcf register
    fi
    isWARPLicenseKeyInput=$WARP_License
    isWARPLicenseKeyInput=${isWARPLicenseKeyInput:-n}

    if [[ ${isWARPLicenseKeyInput} == [Nn] ]]; then
        echo
    else
        sed -i "s/license_key =.*/license_key = \"${isWARPLicenseKeyInput}\"/g" ${configWgcfAccountFilePath}
        WGCF_LICENSE_KEY="${isWARPLicenseKeyInput}" wgcf update
    fi

    if [[ -f ${configWgcfProfileFilePath} ]]; then
        echo
    else
        yes | ${configWgcfConfigFolderPath}/wgcf generate
    fi


    cp ${configWgcfProfileFilePath} ${configWireGuardConfigFilePath}

    enableWireguardIPV6OrIPV4


    sudo wg-quick up wgcf

    echo "curl -6 ip.p3terx.com"
    curl -6 ip.p3terx.com
    isWireguardIpv6Working=$(curl -6 ip.p3terx.com | grep CLOUDFLARENET )
    sudo wg-quick down wgcf
    echo

    sudo systemctl daemon-reload

    # 设置开机启动
    sudo systemctl enable wg-quick@wgcf

    # 启用守护进程
    sudo systemctl start wg-quick@wgcf

    # (crontab -l ; echo "12 6 * * 1 systemctl restart wg-quick@wgcf ") | sort - | uniq - | crontab -

    checkWireguardBootStatus

}
function enableWireguardIPV6OrIPV4(){
    # https://p3terx.com/archives/use-cloudflare-warp-to-add-extra-ipv4-or-ipv6-network-support-to-vps-servers-for-free.html


    sudo systemctl stop wg-quick@wgcf

    cp /etc/resolv.conf ${configWireGuardDNSBackupFilePath}

    sed -i '/nameserver 2a00\:1098\:2b\:\:1/d' /etc/resolv.conf

    sed -i '/nameserver 8\.8/d' /etc/resolv.conf
    sed -i '/nameserver 9\.9/d' /etc/resolv.conf
    sed -i '/nameserver 1\.1\.1\.1/d' /etc/resolv.conf

	isAddNetworkIPv6Input=${isAddNetworkIPv6Input:-1}

	if [[ ${isAddNetworkIPv6Input} == [2] ]]; then

        # 为 IPv6 Only 服务器添加 IPv4 网络支持

        sed -i 's/^AllowedIPs = \:\:\/0/# AllowedIPs = \:\:\/0/g' ${configWireGuardConfigFilePath}
        sed -i 's/# AllowedIPs = 0\.0\.0\.0/AllowedIPs = 0\.0\.0\.0/g' ${configWireGuardConfigFilePath}

        sed -i 's/engage\.cloudflareclient\.com/\[2606\:4700\:d0\:\:a29f\:c001\]/g' ${configWireGuardConfigFilePath}
        sed -i 's/162\.159\.192\.1/\[2606\:4700\:d0\:\:a29f\:c001\]/g' ${configWireGuardConfigFilePath}

        sed -i 's/^DNS = 1\.1\.1\.1/DNS = 2620:fe\:\:10,2001\:4860\:4860\:\:8888,2606\:4700\:4700\:\:1111/g'  ${configWireGuardConfigFilePath}
        sed -i 's/^DNS = 8\.8\.8\.8,8\.8\.4\.4,1\.1\.1\.1,9\.9\.9\.10/DNS = 2620:fe\:\:10,2001\:4860\:4860\:\:8888,2606\:4700\:4700\:\:1111/g'  ${configWireGuardConfigFilePath}

        echo "nameserver 2a00:1098:2b::1" >> /etc/resolv.conf


    else

        # 为 IPv4 Only 服务器添加 IPv6 网络支持
        sed -i 's/^AllowedIPs = 0\.0\.0\.0/# AllowedIPs = 0\.0\.0\.0/g' ${configWireGuardConfigFilePath}
        sed -i 's/# AllowedIPs = \:\:\/0/AllowedIPs = \:\:\/0/g' ${configWireGuardConfigFilePath}

        sed -i 's/engage\.cloudflareclient\.com/162\.159\.192\.1/g' ${configWireGuardConfigFilePath}
        sed -i 's/\[2606\:4700\:d0\:\:a29f\:c001\]/162\.159\.192\.1/g' ${configWireGuardConfigFilePath}

        sed -i 's/^DNS = 1\.1\.1\.1/DNS = 8\.8\.8\.8,8\.8\.4\.4,1\.1\.1\.1,9\.9\.9\.10/g' ${configWireGuardConfigFilePath}
        sed -i 's/^DNS = 2620:fe\:\:10,2001\:4860\:4860\:\:8888,2606\:4700\:4700\:\:1111/DNS = 8\.8\.8\.8,1\.1\.1\.1,9\.9\.9\.10/g' ${configWireGuardConfigFilePath}

        echo "nameserver 8.8.8.8" >> /etc/resolv.conf
        echo "nameserver 8.8.4.4" >> /etc/resolv.conf
        echo "nameserver 1.1.1.1" >> /etc/resolv.conf
        #echo "nameserver 9.9.9.9" >> /etc/resolv.conf
        echo "nameserver 9.9.9.10" >> /etc/resolv.conf

    fi


    # -n 不为空
    if [[ -n $1 ]]; then
        sudo systemctl start wg-quick@wgcf
    else
        preferIPV4
    fi
}
function preferIPV4(){

    if [[ -f "/etc/gai.conf" ]]; then
        sed -i '/^precedence \:\:ffff\:0\:0/d' /etc/gai.conf
        sed -i '/^label 2002\:\:\/16/d' /etc/gai.conf
    fi

    # -z 为空
    if [[ -z $1 ]]; then

        echo "precedence ::ffff:0:0/96  100" >> /etc/gai.conf

    else

        isPreferIPv4Input=${isPreferIPv4Input:-2}

        if [[ ${isPreferIPv4Input} == [2] ]]; then

            # 设置 IPv6 优先
            echo "label 2002::/16   2" >> /etc/gai.conf

        elif [[ ${isPreferIPv4Input} == [3] ]]; then

            echo

        else
            # 设置 IPv4 优先
            echo "precedence ::ffff:0:0/96  100" >> /etc/gai.conf

        fi


        curl ip.p3terx.com


    fi

}
function checkWireguardBootStatus(){
    echo
    isWireguardBootSuccess=$(systemctl status wg-quick@wgcf | grep -E "Active: active")
    if [[ -z "${isWireguardBootSuccess}" ]]; then
        echo
    else
        echo "wgcf trace"
        wgcf trace
    fi
}
if [ "$WARP_IPv6" == "yes" ]; then
    installWireguard
else
    echo "skipping WARP installation"
fi
if [ "$install_bbr" == "yes" ]; then
  bash <(curl -LS https://raw.githubusercontent.com/xmohammad1/bbr/main/bbr.sh)
else
  echo "BBR installation is not enabled in config.cfg skipping."
fi
# Path to the script you want to run after reboot
SCRIPT_PATH="/root/after_reboot.sh"
sudo wget https://raw.githubusercontent.com/xmohammad1/steupnode/main/after_reboot.sh -O "$SCRIPT_PATH"
# Ensure the script is executable
sudo chmod +x "$SCRIPT_PATH"

# Define the cron job
CRON_JOB="@reboot tmux new-session -d -s update-session 'bash /root/after_reboot.sh'"
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
echo "Cron job added: $CRON_JOB"
echo "Waiting 15 Sec before reboot"
sleep 15
# Reboot the system
sudo reboot
