# Remove the existing /etc/resolv.conf file
rm /etc/resolv.conf
# Create a new /etc/resolv.conf file
cat <<EOL > /etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
nameserver 9.9.9.9
nameserver 127.0.0.53
EOL
tmux new-session -d -s update-session 'bash <(curl -u xmohammad1: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 -LS https://raw.githubusercontent.com/xmohammad1/steupnode/main/node.sh) install'
tmux attach -t update-session
# Wait until the tmux session ends (node setup ends)
tmux wait-for -S update-session
# Remove the cron job to ensure this script only runs once
crontab -l | grep -v "@reboot /root/after_reboot.sh" | crontab -
