_header shlib::str_split
csv="Sirius,Vega,Rigel,Altair"
_run shlib::str_split star_list "$csv" ","
# shellcheck disable=SC2154
echo "Result: (${star_list[*]})"
echo "Count: ${#star_list[@]}"
