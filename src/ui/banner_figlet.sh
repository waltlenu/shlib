# Render ASCII art banner using figlet
if shlib::cmd_exists figlet; then
    shlib::banner_figlet "PULSAR"
else
    echo "(figlet not installed, skipping)"
fi
