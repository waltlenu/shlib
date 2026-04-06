_header shlib::str_is_empty
_show shlib::str_is_empty "   "
if shlib::str_is_empty "   "; then
    echo "true (whitespace only)"
fi
_show shlib::str_is_empty "quasar"
if ! shlib::str_is_empty "quasar"; then
    echo "false"
fi
