_header shlib::ui_banner_toilet
if shlib::cmd_exists toilet; then
    _run shlib::ui_banner_toilet "QUASAR" "" "gay"
else
    echo "(toilet not installed, skipping)"
fi
