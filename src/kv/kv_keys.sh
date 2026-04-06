# Get all keys from an associative array
declare -A orbit_au
orbit_au[Mercury]="0.39"
orbit_au[Venus]="0.72"
orbit_au[Earth]="1.00"
shlib::kv_keys names orbit_au
# shellcheck disable=SC2154
echo "kv_keys: (${names[*]})"
