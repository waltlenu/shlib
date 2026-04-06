_header shlib::arr_pop
moons=(Io Europa Ganymede Callisto)
echo "Before: (${moons[*]})"
_run shlib::arr_pop moons
echo "After: (${moons[*]})"
