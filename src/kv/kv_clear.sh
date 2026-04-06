_header shlib::kv_clear
declare -A catalog
catalog[M31]="Andromeda"
catalog[M42]="Orion Nebula"
catalog[M45]="Pleiades"
echo "Before: $(shlib::kv_len catalog) entries"
_run shlib::kv_clear catalog
echo "After: $(shlib::kv_len catalog) entries"
