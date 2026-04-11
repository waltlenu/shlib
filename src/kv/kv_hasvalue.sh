_header shlib::kv_hasvalue
declare -A spectral_class
spectral_class[Sirius]="A"
spectral_class[Vega]="A"
spectral_class[Betelgeuse]="M"
_show shlib::kv_hasvalue spectral_class "A"
shlib::kv_hasvalue spectral_class "A" && echo "true" || echo "false"
_show shlib::kv_hasvalue spectral_class "G"
shlib::kv_hasvalue spectral_class "G" && echo "true" || echo "false"
