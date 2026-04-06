# Delete a key from an associative array
declare -A elements
elements[hydrogen]="1"
elements[helium]="2"
elements[lithium]="3"
echo "Before: $(shlib::kv_print elements)"
shlib::kv_delete elements "lithium"
echo "After kv_delete 'lithium': $(shlib::kv_print elements)"
