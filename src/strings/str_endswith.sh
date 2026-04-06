_header shlib::str_endswith
_show shlib::str_endswith "supernova.fits" ".fits"
if shlib::str_endswith "supernova.fits" ".fits"; then
    echo "true"
fi
_show shlib::str_endswith "supernova.fits" ".csv"
if ! shlib::str_endswith "supernova.fits" ".csv"; then
    echo "false"
fi
