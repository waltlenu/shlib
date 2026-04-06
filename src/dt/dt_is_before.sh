# Check if one timestamp is before another
ts1=1704067200 # Jan 1, 2024
ts2=1704153600 # Jan 2, 2024
if shlib::dt_is_before "$ts1" "$ts2"; then
    echo "dt_is_before: $ts1 is before $ts2 (true)"
fi
