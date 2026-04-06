_header shlib::kv_map
declare -A catalog
catalog[m31]="andromeda"
catalog[m42]="orion nebula"
echo "Before: $(shlib::kv_print catalog)"
_run shlib::kv_map catalog 'tr a-z A-Z'
echo "After: $(shlib::kv_print catalog)"
