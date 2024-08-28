Link="$1"
# config file
FILE="/root/config.cfg"
# Check if the file exists
if [ -f "$FILE" ]; then
    echo "The file $FILE exists."
else
    if [ -z "${Link}" ]; then
        echo "make a $FILE in your server or put your config address in front of script link."
        echo "Like bash <(curl -LS https://raw.githubusercontent.com/xmohammad1/steupnode/main/go.sh) https://raw.githubusercontent.com/xmohammad1/steupnode/main/config.cfg"
        exit 1
    fi
    wget $Link -O $FILE
fi
if [ -f /root/after_reboot.sh ]; then
    echo "Script runned once already"
    exit 1
fi
cd /root/
SCRIPT_PATH="/root/main.sh"
sudo wget https://raw.githubusercontent.com/xmohammad1/steupnode/main/main.sh -O $SCRIPT_PATH
chmod +x "$SCRIPT_PATH"
tmux new-session -d -s update-session 'bash /root/main.sh'
tmux attach -t update-session
