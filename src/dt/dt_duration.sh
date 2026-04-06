# Format seconds as human-readable duration
secs=90061 # 1 day, 1 hour, 1 minute, 1 second
echo "dt_duration $secs (short):   $(shlib::dt_duration $secs)"
echo "dt_duration $secs (long):    $(shlib::dt_duration $secs long)"
echo "dt_duration $secs (compact): $(shlib::dt_duration $secs compact)"
echo "dt_duration 3600:            $(shlib::dt_duration 3600)"
