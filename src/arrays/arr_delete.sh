_header shlib::arr_delete
particles=(muon quark boson lepton)
echo "Before: (${particles[*]})"
_run shlib::arr_delete particles 1
echo "After: (${particles[*]})"
