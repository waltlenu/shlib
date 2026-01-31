#!/usr/bin/env bash

#
# Example: Date and time functions from shlib
#

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../shlib.sh"

shlib::headern "Date and Time Functions"

# Current date/time
echo "Current timestamps:"
echo "  dt_now:     $(shlib::dt_now)"
echo "  dt_now_iso: $(shlib::dt_now_iso)"
echo "  dt_now_iso local: $(shlib::dt_now_iso local)"
echo "  dt_today:   $(shlib::dt_today)"
echo

# Formatting timestamps
echo "Formatting timestamps:"
now=$(shlib::dt_now)
echo "  Current timestamp: $now"
echo "  dt_from_unix \$now \"%Y-%m-%d %H:%M:%S\": $(shlib::dt_from_unix "$now" "%Y-%m-%d %H:%M:%S")"
echo "  dt_from_unix \$now \"%A, %B %d, %Y\": $(shlib::dt_from_unix "$now" "%A, %B %d, %Y")"
echo

# Parsing dates
echo "Parsing dates:"
echo "  dt_to_unix \"2024-01-01\": $(shlib::dt_to_unix "2024-01-01")"
echo

# Timestamp arithmetic
echo "Timestamp arithmetic:"
base=1704067200
echo "  Base timestamp: $base ($(shlib::dt_from_unix $base "%Y-%m-%d %H:%M:%S" 2>/dev/null || echo "2024-01-01 00:00:00 UTC"))"
echo "  dt_add \$base 1 days:   $(shlib::dt_add $base 1 days)"
echo "  dt_add \$base 12 hours: $(shlib::dt_add $base 12 hours)"
echo "  dt_add \$base -1 weeks: $(shlib::dt_add $base -1 weeks)"
echo

# Differences
echo "Timestamp differences:"
ts1=1704153600 # Jan 2, 2024
ts2=1704067200 # Jan 1, 2024
echo "  ts1=$ts1, ts2=$ts2"
echo "  dt_diff \$ts1 \$ts2 seconds: $(shlib::dt_diff $ts1 $ts2 seconds)"
echo "  dt_diff \$ts1 \$ts2 hours:   $(shlib::dt_diff $ts1 $ts2 hours)"
echo "  dt_diff \$ts1 \$ts2 days:    $(shlib::dt_diff $ts1 $ts2 days)"
echo

# Comparisons
echo "Timestamp comparisons:"
if shlib::dt_is_before $ts2 $ts1; then
    echo "  dt_is_before \$ts2 \$ts1: true (ts2 is earlier)"
fi
if shlib::dt_is_after $ts1 $ts2; then
    echo "  dt_is_after \$ts1 \$ts2: true (ts1 is later)"
fi
echo

# Duration formatting
echo "Duration formatting:"
secs=90061 # 1 day, 1 hour, 1 minute, 1 second
echo "  dt_duration $secs (short):   $(shlib::dt_duration $secs)"
echo "  dt_duration $secs long:      $(shlib::dt_duration $secs long)"
echo "  dt_duration $secs compact:   $(shlib::dt_duration $secs compact)"
echo "  dt_duration 3600:            $(shlib::dt_duration 3600)"
echo "  dt_duration 45:              $(shlib::dt_duration 45)"
echo

# Elapsed time
echo "Elapsed time:"
start=$(shlib::dt_now)
echo "  Started at: $start"
sleep 1
echo "  dt_elapsed \$start: $(shlib::dt_elapsed "$start")"
echo

# Validation
echo "Date validation:"
if shlib::dt_is_valid "2024-01-01"; then
    echo "  dt_is_valid \"2024-01-01\": true"
fi
if ! shlib::dt_is_valid "not-a-date"; then
    echo "  dt_is_valid \"not-a-date\": false"
fi
