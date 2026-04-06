# Check if a key exists
declare -A elements
elements[hydrogen]="1"
elements[helium]="2"
echo "kv_exists 'hydrogen': $(shlib::kv_exists elements "hydrogen" && echo "true" || echo "false")"
echo "kv_exists 'lithium':  $(shlib::kv_exists elements "lithium" && echo "true" || echo "false")"
