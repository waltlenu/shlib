# Check if a value exists in an associative array
declare -A spectral_class
spectral_class[Sirius]="A"
spectral_class[Vega]="A"
spectral_class[Betelgeuse]="M"
echo "kv_has_value 'A': $(shlib::kv_has_value spectral_class "A" && echo "true" || echo "false")"
echo "kv_has_value 'G': $(shlib::kv_has_value spectral_class "G" && echo "true" || echo "false")"
