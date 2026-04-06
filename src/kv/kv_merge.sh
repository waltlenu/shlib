_header shlib::kv_merge
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
_run shlib::kv_merge config defaults overrides
echo "Result: $(shlib::kv_print config)"
