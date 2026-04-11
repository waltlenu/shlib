_header shlib::time_elapsed
start=$(shlib::time_now)
sleep 1
_eval shlib::time_elapsed "$start"
