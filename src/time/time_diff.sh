_header shlib::time_diff
ts1=1704153600 # Jan 2, 2024
ts2=1704067200 # Jan 1, 2024
echo "ts1=$ts1 (Jan 2), ts2=$ts2 (Jan 1)"
_eval shlib::time_diff "$ts1" "$ts2" seconds
_eval shlib::time_diff "$ts1" "$ts2" hours
_eval shlib::time_diff "$ts1" "$ts2" days
