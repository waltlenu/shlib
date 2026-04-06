# Get a value with fallback default
declare -A telescope
telescope[aperture]="200mm"
echo "kv_get_default 'aperture' '100mm': $(shlib::kv_get_default telescope "aperture" "100mm")"
echo "kv_get_default 'tracking' 'off':   $(shlib::kv_get_default telescope "tracking" "off")"
