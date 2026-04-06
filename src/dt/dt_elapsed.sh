# Format elapsed time since a start timestamp
start=$(shlib::dt_now)
sleep 1
echo "dt_elapsed: $(shlib::dt_elapsed "$start")"
