_header shlib::str_isempty
_show shlib::str_isempty "   "
if shlib::str_isempty "   "; then
    echo "true (whitespace only)"
fi
_show shlib::str_isempty "quasar"
if ! shlib::str_isempty "quasar"; then
    echo "false"
fi
