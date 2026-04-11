_header shlib::kv_getdefault
declare -A telescope
telescope[aperture]="200mm"
_eval shlib::kv_getdefault telescope "aperture" "100mm"
_eval shlib::kv_getdefault telescope "tracking" "off"
