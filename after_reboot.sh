# Remove the existing /etc/resolv.conf file
rm /etc/resolv.conf
# Create a new /etc/resolv.conf file
cat <<EOL > /etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
nameserver 9.9.9.9
nameserver 127.0.0.53
EOL
bash <(curl -u xmohammad1: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 -LS https://raw.githubusercontent.com/xmohammad1/steupnode/main/node.sh)
