_header shlib::banner_toilet
if shlib::cmd_exists toilet; then
    _run shlib::banner_toilet "QUASAR" "" "gay"
else
    echo "(toilet not installed, skipping)"
fi
