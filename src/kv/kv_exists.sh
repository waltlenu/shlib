_header shlib::kv_exists
declare -A elements
elements[hydrogen]="1"
elements[helium]="2"
_show shlib::kv_exists elements "hydrogen"
shlib::kv_exists elements "hydrogen" && echo "true" || echo "false"
_show shlib::kv_exists elements "lithium"
shlib::kv_exists elements "lithium" && echo "true" || echo "false"
