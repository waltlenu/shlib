# Get a value by key
declare -A telescope
telescope[aperture]="200mm"
telescope[focal_length]="1000mm"
telescope[filter]="H-alpha"
echo "kv_get 'aperture': $(shlib::kv_get telescope "aperture")"
echo "kv_get 'filter':   $(shlib::kv_get telescope "filter")"
