_header shlib::kv_values
declare -A orbit_au
orbit_au[Mercury]="0.39"
orbit_au[Venus]="0.72"
orbit_au[Earth]="1.00"
_run shlib::kv_values distances orbit_au
# shellcheck disable=SC2154
echo "Result: (${distances[*]})"
