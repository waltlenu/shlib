# Remove the last element from an array
moons=(Io Europa Ganymede Callisto)
echo "Before: (${moons[*]})"
shlib::arr_pop moons
echo "After arr_pop: (${moons[*]})"
