Link=""

# config file
FILE="/root/config.cfg"
# Check if the file exists
if [ -f "$FILE" ]; then
    echo "The file $FILE exists."
else
    if [ -z "${Link}" ]; then
        echo "The file $FILE does not exist."
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
sudo wget --header="Authorization: token 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" https://raw.githubusercontent.com/xmohammad1/steupnode/main/main.sh -O $SCRIPT_PATH
chmod +x "$SCRIPT_PATH"
tmux new-session -d -s update-session 'bash /root/main.sh'
tmux attach -t update-session
