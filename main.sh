tmux new-session -d -s update-session 'sudo apt update -y && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y && bash <(curl -LS https://raw.githubusercontent.com/xmohammad1/bbr/main/bbr.sh)'
tmux attach -t update-session
echo "Wait 20Sec to make sure all updates done"
sleep 20

reboot
