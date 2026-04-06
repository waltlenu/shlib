_header shlib::str_startswith
_show shlib::str_startswith "NGC 4321" "NGC"
if shlib::str_startswith "NGC 4321" "NGC"; then
    echo "true"
fi
_show shlib::str_startswith "NGC 4321" "IC"
if ! shlib::str_startswith "NGC 4321" "IC"; then
    echo "false"
fi
