
status_code=$(curl -o /dev/null -s -w "%{http_code}" https://get.docker.com)

if [ "$status_code" -eq 403 ]; then
  rm /etc/resolv.conf
  cat <<EOL > /etc/resolv.conf
nameserver 78.157.42.100
nameserver 78.157.42.101
EOL
fi
bash <(curl -u xmohammad1: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 -LS https://raw.githubusercontent.com/xmohammad1/steupnode/main/node.sh) install
source /root/config.cfg
if [ "$instsll_security" == "yes" ]; then
  echo 1 | bash <(curl -LS https://raw.githubusercontent.com/xmohammad1/linux_security/main/main.sh)
else
  echo "Skipping Linxux security"
fi
source /root/config.cfg
if [ "$set_dns" == "yes" ]; then
  # Remove the existing /etc/resolv.conf file
  rm -f /etc/resolv.conf
  # Create a new /etc/resolv.conf file
  echo "$DNS_CONTENT" > /etc/resolv.conf
else
  echo "Skipping Set DNS"
fi
cat << 'EOF' >> ~/.bashrc
# Start of tmux auto-attach block
message="\033[1;34mYour Node Is Ready Sir\033[0m"
echo -e "$message"
sleep 1
sed -i '/# Start of tmux auto-attach block/,/# End of tmux auto-attach block/d' ~/.bashrc
# Remove this entire block after it runs
# End of tmux auto-attach block
EOF
message="\033[1;34mYour Node Is Ready Sir\033[0m"
# Get a list of all logged-in users and their TTYs
users=$(who | awk '{print $2}')
for user in $users
do
  echo -e "$message" > /dev/$user
  echo "Press Enter" > /dev/$user
done
# Remove the cron job to ensure this script only runs once
sudo crontab -l | grep -v "@reboot tmux new-session -d -s update-session 'bash /root/after_reboot.sh'" | sudo crontab -
