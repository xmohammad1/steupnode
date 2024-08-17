sudo apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
bash <(curl -LS https://raw.githubusercontent.com/xmohammad1/bbr/main/bbr.sh)
# Path to the script you want to run after reboot
SCRIPT_PATH="/root/after_reboot.sh"
sudo wget --header="Authorization: token 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" https://raw.githubusercontent.com/xmohammad1/steupnode/main/after_reboot.sh -O "$SCRIPT_PATH"
# Ensure the script is executable
chmod +x "$SCRIPT_PATH"

# Define the cron job
CRON_JOB="@reboot sudo $SCRIPT_PATH"
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
echo "Cron job added: $CRON_JOB"
echo "Waiting 15 Sec before reboot"
sleep 15
# Reboot the system
sudo reboot
