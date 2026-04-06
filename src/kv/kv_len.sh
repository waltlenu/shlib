# Get the count of entries
declare -A orbit_au
orbit_au[Mercury]="0.39"
orbit_au[Venus]="0.72"
orbit_au[Earth]="1.00"
orbit_au[Mars]="1.52"
echo "Contents: $(shlib::kv_print orbit_au)"
echo "kv_len: $(shlib::kv_len orbit_au)"
