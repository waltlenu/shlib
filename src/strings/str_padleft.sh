_header shlib::str_padleft
_show shlib::str_padleft "42" 6 "0"
echo "[$(shlib::str_padleft "42" 6 "0")]"
_show shlib::str_padleft "NGC" 8
echo "[$(shlib::str_padleft "NGC" 8)]"
