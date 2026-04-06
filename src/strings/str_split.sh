# Split a string into an array
csv="Sirius,Vega,Rigel,Altair"
shlib::str_split star_list "$csv" ","
# shellcheck disable=SC2154
echo "str_split \"$csv\" by \",\": (${star_list[*]})"
echo "Count: ${#star_list[@]}"
