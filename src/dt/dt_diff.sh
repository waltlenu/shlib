# Calculate difference between timestamps
ts1=1704153600 # Jan 2, 2024
ts2=1704067200 # Jan 1, 2024
echo "ts1=$ts1 (Jan 2), ts2=$ts2 (Jan 1)"
echo "dt_diff in seconds: $(shlib::dt_diff "$ts1" "$ts2" seconds)"
echo "dt_diff in hours:   $(shlib::dt_diff "$ts1" "$ts2" hours)"
echo "dt_diff in days:    $(shlib::dt_diff "$ts1" "$ts2" days)"
