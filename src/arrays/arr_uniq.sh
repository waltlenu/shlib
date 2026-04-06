# Remove duplicate elements from an array
readings=(muon quark muon boson quark lepton muon)
echo "Before: (${readings[*]})"
shlib::arr_uniq readings
echo "After arr_uniq: (${readings[*]})"
