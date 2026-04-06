# Merge multiple associative arrays (later overrides earlier)
declare -A defaults
defaults[tracking]="off"
defaults[exposure]="30s"
defaults[filter]="none"
declare -A overrides
overrides[exposure]="120s"
overrides[filter]="H-alpha"
echo "defaults:  $(shlib::kv_print defaults)"
echo "overrides: $(shlib::kv_print overrides)"
declare -A config
shlib::kv_merge config defaults overrides
echo "After kv_merge: $(shlib::kv_print config)"
