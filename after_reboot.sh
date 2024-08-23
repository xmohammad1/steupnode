
status_code=$(curl -o /dev/null -s -w "%{http_code}" https://get.docker.com)

if [ "$status_code" -eq 403 ]; then
  rm /etc/resolv.conf
  cat <<EOL > /etc/resolv.conf
nameserver 78.157.42.100
nameserver 78.157.42.101
EOL
fi
bash <(curl -u xmohammad1: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 -LS https://raw.githubusercontent.com/xmohammad1/steupnode/main/node.sh) install
# Remove the cron job to ensure this script only runs once
sudo crontab -l | grep -v '@reboot sudo /root/after_reboot.sh' | sudo crontab -
bash <(curl -LS https://raw.githubusercontent.com/xmohammad1/linux_security/main/main.sh)
# Remove the existing /etc/resolv.conf file
rm /etc/resolv.conf
# Create a new /etc/resolv.conf file
cat <<EOL > /etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
nameserver 127.0.0.53
EOL
