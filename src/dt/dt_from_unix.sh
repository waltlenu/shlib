# Format a Unix timestamp
ts=1704067200 # Jan 1, 2024
echo "dt_from_unix (date):     $(shlib::dt_from_unix "$ts" "%Y-%m-%d")"
echo "dt_from_unix (datetime): $(shlib::dt_from_unix "$ts" "%Y-%m-%d %H:%M:%S")"
