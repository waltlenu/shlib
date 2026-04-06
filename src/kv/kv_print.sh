# Print key-value pairs inline with custom separators
declare -A telescope
telescope[aperture]="200mm"
telescope[focal_length]="1000mm"
telescope[filter]="H-alpha"
echo "kv_print (default): $(shlib::kv_print telescope)"
echo "kv_print (custom):  $(shlib::kv_print telescope ":" ", ")"
