_header shlib::time_add
base=1704067200 # Jan 1, 2024 00:00:00 UTC
echo "Base: $base ($(shlib::time_fromunix "$base" "%Y-%m-%d" 2>/dev/null || echo "2024-01-01"))"
_eval shlib::time_add "$base" 1 days
_eval shlib::time_add "$base" 12 hours
_eval shlib::time_add "$base" -1 weeks
