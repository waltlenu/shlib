# Merge multiple arrays into one
inner=(Mercury Venus Earth Mars)
outer=(Jupiter Saturn Uranus Neptune)
# shellcheck disable=SC2034
dwarf=(Pluto Ceres Eris)
echo "inner: (${inner[*]})"
echo "outer: (${outer[*]})"
echo "dwarf: (${dwarf[*]})"
shlib::arr_merge solar_system inner outer dwarf
# shellcheck disable=SC2154
echo "After arr_merge: (${solar_system[*]})"
