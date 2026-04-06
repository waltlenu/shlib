_header shlib::kv_find
declare -A spectral_class
spectral_class[Sirius]="A"
spectral_class[Vega]="A"
spectral_class[Betelgeuse]="M"
spectral_class[Rigel]="B"
_run shlib::kv_find class_a spectral_class "A"
# shellcheck disable=SC2154
echo "Stars with class A: (${class_a[*]})"
