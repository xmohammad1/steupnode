tmux new-session -d -s update-session 'sudo apt update -y && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y && bash <(curl -LS https://raw.githubusercontent.com/xmohammad1/bbr/main/bbr.sh)'
tmux attach -t update-session

# Wait until the tmux session ends (updates completed)
tmux wait-for -S update-session

# Path to the script you want to run after reboot
SCRIPT_PATH="/root/after_reboot.sh"
sudo wget --header="Authorization: token $GITHUB_TOKEN" https://raw.githubusercontent.com/xmohammad1/steupnode/main/after_reboot.sh -O "$SCRIPT_PATH"
# Ensure the script is executable
chmod +x "$SCRIPT_PATH"

# Define the cron job
CRON_JOB="@reboot sudo $SCRIPT_PATH"
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
echo "Cron job added: $CRON_JOB"
sleep 15
# Reboot the system
sudo reboot
