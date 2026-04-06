# Print key-value pairs one per line
declare -A elements
elements[hydrogen]="1"
elements[helium]="2"
elements[carbon]="6"
elements[oxygen]="8"
echo "kv_printn:"
shlib::kv_printn elements
