# Check if a string starts with a prefix
if shlib::str_startswith "NGC 4321" "NGC"; then
    echo "str_startswith \"NGC 4321\" \"NGC\": true"
fi
if ! shlib::str_startswith "NGC 4321" "IC"; then
    echo "str_startswith \"NGC 4321\" \"IC\": false"
fi
