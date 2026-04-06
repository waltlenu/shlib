_header shlib::arr_uniq
readings=(muon quark muon boson quark lepton muon)
echo "Before: (${readings[*]})"
_run shlib::arr_uniq readings
echo "After: (${readings[*]})"
