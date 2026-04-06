# Remove all entries from an associative array
declare -A catalog
catalog[M31]="Andromeda"
catalog[M42]="Orion Nebula"
catalog[M45]="Pleiades"
echo "Before: $(shlib::kv_len catalog) entries"
shlib::kv_clear catalog
echo "After kv_clear: $(shlib::kv_len catalog) entries"
