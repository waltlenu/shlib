# Check if a string contains a substring
if shlib::str_contains "Andromeda Galaxy" "Galaxy"; then
    echo "str_contains \"Andromeda Galaxy\" \"Galaxy\": true"
fi
if ! shlib::str_contains "Andromeda Galaxy" "Nebula"; then
    echo "str_contains \"Andromeda Galaxy\" \"Nebula\": false"
fi
