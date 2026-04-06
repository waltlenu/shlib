_header shlib::kv_set
declare -A telescope
_run shlib::kv_set telescope "aperture" "200mm"
_run shlib::kv_set telescope "focal_length" "1000mm"
_run shlib::kv_set telescope "filter" "H-alpha"
echo "Result:"
shlib::kv_printn telescope
