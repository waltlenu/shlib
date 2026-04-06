# Render ASCII art banner using toilet
if shlib::cmd_exists toilet; then
    shlib::banner_toilet "QUASAR" "" "gay"
else
    echo "(toilet not installed, skipping)"
fi
