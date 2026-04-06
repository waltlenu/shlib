# Check if a string is empty or whitespace-only
if shlib::str_is_empty "   "; then
    echo "str_is_empty \"   \": true (whitespace only)"
fi
if ! shlib::str_is_empty "quasar"; then
    echo "str_is_empty \"quasar\": false"
fi
