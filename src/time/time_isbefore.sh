_header shlib::time_isbefore
ts1=1704067200 # Jan 1, 2024
ts2=1704153600 # Jan 2, 2024
_show shlib::time_isbefore "$ts1" "$ts2"
if shlib::time_isbefore "$ts1" "$ts2"; then
    echo "true"
fi
