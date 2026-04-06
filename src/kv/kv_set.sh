# Set key-value pairs in an associative array
declare -A telescope
shlib::kv_set telescope "aperture" "200mm"
shlib::kv_set telescope "focal_length" "1000mm"
shlib::kv_set telescope "filter" "H-alpha"
echo "After kv_set:"
shlib::kv_printn telescope
