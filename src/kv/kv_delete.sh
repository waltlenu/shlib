_header shlib::kv_delete
declare -A elements
elements[hydrogen]="1"
elements[helium]="2"
elements[lithium]="3"
echo "Before: $(shlib::kv_print elements)"
_run shlib::kv_delete elements "lithium"
echo "After: $(shlib::kv_print elements)"
