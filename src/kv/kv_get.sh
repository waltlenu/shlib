_header shlib::kv_get
declare -A telescope
telescope[aperture]="200mm"
telescope[focal_length]="1000mm"
telescope[filter]="H-alpha"
_eval shlib::kv_get telescope "aperture"
_eval shlib::kv_get telescope "filter"
