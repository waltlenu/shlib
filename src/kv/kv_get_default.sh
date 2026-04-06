_header shlib::kv_get_default
declare -A telescope
telescope[aperture]="200mm"
_eval shlib::kv_get_default telescope "aperture" "100mm"
_eval shlib::kv_get_default telescope "tracking" "off"
