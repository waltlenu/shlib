_header shlib::str_contains
_show shlib::str_contains "Andromeda Galaxy" "Galaxy"
if shlib::str_contains "Andromeda Galaxy" "Galaxy"; then
    echo "true"
fi
_show shlib::str_contains "Andromeda Galaxy" "Nebula"
if ! shlib::str_contains "Andromeda Galaxy" "Nebula"; then
    echo "false"
fi
