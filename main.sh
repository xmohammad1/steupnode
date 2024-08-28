sudo apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
source /root/config.cfg
if [ "$install_bbr" == "yes" ]; then
  bash <(curl -LS https://raw.githubusercontent.com/xmohammad1/bbr/main/bbr.sh)
else
  echo "BBR installation is not enabled in config.cfg skipping."
fi
# Path to the script you want to run after reboot
SCRIPT_PATH="/root/after_reboot.sh"
sudo wget --header="Authorization: token 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" https://raw.githubusercontent.com/xmohammad1/steupnode/main/after_reboot.sh -O "$SCRIPT_PATH"
# Ensure the script is executable
sudo chmod +x "$SCRIPT_PATH"

# Define the cron job
CRON_JOB="@reboot tmux new-session -d -s update-session 'bash /root/after_reboot.sh' | bash"
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
echo "Cron job added: $CRON_JOB"
echo "Waiting 15 Sec before reboot"
sleep 15
# Reboot the system
sudo reboot
