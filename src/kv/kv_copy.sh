_header shlib::kv_copy
declare -A source_catalog
source_catalog[M31]="Andromeda"
source_catalog[M42]="Orion Nebula"
declare -A backup_catalog
_run shlib::kv_copy backup_catalog source_catalog
echo "Original: $(shlib::kv_print source_catalog)"
echo "Copy:     $(shlib::kv_print backup_catalog)"
