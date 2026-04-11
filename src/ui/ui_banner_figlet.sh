_header shlib::ui_banner_figlet
if shlib::cmd_exists figlet; then
    _run shlib::ui_banner_figlet "PULSAR"
else
    echo "(figlet not installed, skipping)"
fi
