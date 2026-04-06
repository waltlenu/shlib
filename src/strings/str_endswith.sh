# Check if a string ends with a suffix
if shlib::str_endswith "supernova.fits" ".fits"; then
    echo "str_endswith \"supernova.fits\" \".fits\": true"
fi
if ! shlib::str_endswith "supernova.fits" ".csv"; then
    echo "str_endswith \"supernova.fits\" \".csv\": false"
fi
