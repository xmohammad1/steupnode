Link="$1"
# config file
FILE="/root/config.cfg"
# Check if the file exists
if [ -f "$FILE" ]; then
    echo "The file $FILE exists."
elif [ -z "${Link}" ]; then
    # Prompt the user to input the certificate
    echo -e "Please paste the content of the Client Certificate, and press ENTER on a new line when finished:"
    
    # Read the certificate content
    CERT_CONTENT=""
    while IFS= read -r line; do
        if [[ -z $line ]]; then
            break
        fi
        CERT_CONTENT+="$line\n"
    done
    
    # Use sed to replace the existing CERT_CONTENT in the config file
    sed -i "s|CERT_CONTENT=\".*\"|CERT_CONTENT=\"${CERT_CONTENT}\"|g" "$FILE"
else
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
