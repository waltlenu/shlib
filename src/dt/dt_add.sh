# Add time to a timestamp
base=1704067200 # Jan 1, 2024 00:00:00 UTC
echo "Base: $base ($(shlib::dt_from_unix "$base" "%Y-%m-%d" 2>/dev/null || echo "2024-01-01"))"
echo "dt_add 1 days:   $(shlib::dt_add "$base" 1 days)"
echo "dt_add 12 hours: $(shlib::dt_add "$base" 12 hours)"
echo "dt_add -1 weeks: $(shlib::dt_add "$base" -1 weeks)"
