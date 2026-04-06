_header shlib::kv_has_value
declare -A spectral_class
spectral_class[Sirius]="A"
spectral_class[Vega]="A"
spectral_class[Betelgeuse]="M"
_show shlib::kv_has_value spectral_class "A"
shlib::kv_has_value spectral_class "A" && echo "true" || echo "false"
_show shlib::kv_has_value spectral_class "G"
shlib::kv_has_value spectral_class "G" && echo "true" || echo "false"
