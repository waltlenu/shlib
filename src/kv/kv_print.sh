_header shlib::kv_print
declare -A telescope
telescope[aperture]="200mm"
telescope[focal_length]="1000mm"
telescope[filter]="H-alpha"
_eval shlib::kv_print telescope
_eval shlib::kv_print telescope ":" ", "
