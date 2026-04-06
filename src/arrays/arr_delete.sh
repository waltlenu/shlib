# Delete an element by index
particles=(muon quark boson lepton)
echo "Before: (${particles[*]})"
shlib::arr_delete particles 1
echo "After arr_delete at index 1: (${particles[*]})"
