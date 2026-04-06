# Check if one timestamp is after another
ts1=1704153600 # Jan 2, 2024
ts2=1704067200 # Jan 1, 2024
if shlib::dt_is_after "$ts1" "$ts2"; then
    echo "dt_is_after: $ts1 is after $ts2 (true)"
fi
