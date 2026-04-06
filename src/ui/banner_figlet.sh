_header shlib::banner_figlet
if shlib::cmd_exists figlet; then
    _run shlib::banner_figlet "PULSAR"
else
    echo "(figlet not installed, skipping)"
fi
