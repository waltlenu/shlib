# Apply a transformation to all values
declare -A catalog
catalog[m31]="andromeda"
catalog[m42]="orion nebula"
echo "Before: $(shlib::kv_print catalog)"
shlib::kv_map catalog 'tr a-z A-Z'
echo "After kv_map (uppercase): $(shlib::kv_print catalog)"
