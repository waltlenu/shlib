#!/usr/bin/env bash
# shellcheck disable=SC2034

########################################################################
#                                                                      #
#  shlib - A library of reusable Bash shell functions (examples)       #
#                                                                      #
#  Usage: bash shlib.example.bash                                      #
#  License: MIT                                                        #
#                                                                      #
########################################################################

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the library
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/shlib.bash"

shlib::banner_toilet "shlib" "" "gay"

shlib::headern "shlib Examples"
echo

#######################################
# _core
#######################################

echo "shlib::list_functions (first 10):"
shlib::list_functions | head -10
echo "... ($(shlib::list_functions | wc -l | tr -d ' ') total functions)"

echo "shlib::list_variables:"
shlib::list_variables

echo "shlib::version: $(shlib::version)"

#######################################
# arrays
#######################################

# Append elements to an array
planets=(Mercury Venus Earth)
echo "Before: (${planets[*]})"
shlib::arr_append planets "Mars" "Jupiter"
echo "After arr_append: (${planets[*]})"

# Delete an element by index
particles=(muon quark boson lepton)
echo "Before: (${particles[*]})"
shlib::arr_delete particles 1
echo "After arr_delete at index 1: (${particles[*]})"

# Insert an element at a specific index
planets=(Mercury Venus Mars Jupiter)
echo "Before: (${planets[*]})"
shlib::arr_insert planets 2 "Earth"
echo "After arr_insert 2 \"Earth\": (${planets[*]})"

# Get the number of elements in an array
stars=(Sirius Vega Rigel Altair Polaris)
echo "Stars: (${stars[*]})"
echo "arr_len: $(shlib::arr_len stars)"

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

# Remove the last element from an array
moons=(Io Europa Ganymede Callisto)
echo "Before: (${moons[*]})"
shlib::arr_pop moons
echo "After arr_pop: (${moons[*]})"

# Print array elements with custom separators
quarks=(up down charm strange top bottom)
echo "arr_print with space: $(shlib::arr_print quarks)"
echo "arr_print with comma: $(shlib::arr_print quarks ",")"
echo "arr_print with ' | ': $(shlib::arr_print quarks " | ")"

# Print array elements one per line
constellations=(Orion Cassiopeia Ursa Lyra)
echo "arr_printn:"
shlib::arr_printn constellations

# Reverse an array in place
planets=(Mercury Venus Earth Mars Jupiter)
echo "Before: (${planets[*]})"
shlib::arr_reverse planets
echo "After arr_reverse: (${planets[*]})"

# Sort an array in lexicographic order
stars=(Rigel Altair Sirius Vega Betelgeuse)
echo "Before: (${stars[*]})"
shlib::arr_sort stars
echo "After arr_sort: (${stars[*]})"

# Remove duplicate elements from an array
readings=(muon quark muon boson quark lepton muon)
echo "Before: (${readings[*]})"
shlib::arr_uniq readings
echo "After arr_uniq: (${readings[*]})"

#######################################
# dt
#######################################

# Add time to a timestamp
base=1704067200 # Jan 1, 2024 00:00:00 UTC
echo "Base: $base ($(shlib::dt_from_unix "$base" "%Y-%m-%d" 2>/dev/null || echo "2024-01-01"))"
echo "dt_add 1 days:   $(shlib::dt_add "$base" 1 days)"
echo "dt_add 12 hours: $(shlib::dt_add "$base" 12 hours)"
echo "dt_add -1 weeks: $(shlib::dt_add "$base" -1 weeks)"

# Calculate difference between timestamps
ts1=1704153600 # Jan 2, 2024
ts2=1704067200 # Jan 1, 2024
echo "ts1=$ts1 (Jan 2), ts2=$ts2 (Jan 1)"
echo "dt_diff in seconds: $(shlib::dt_diff "$ts1" "$ts2" seconds)"
echo "dt_diff in hours:   $(shlib::dt_diff "$ts1" "$ts2" hours)"
echo "dt_diff in days:    $(shlib::dt_diff "$ts1" "$ts2" days)"

# Format seconds as human-readable duration
secs=90061 # 1 day, 1 hour, 1 minute, 1 second
echo "dt_duration $secs (short):   $(shlib::dt_duration $secs)"
echo "dt_duration $secs (long):    $(shlib::dt_duration $secs long)"
echo "dt_duration $secs (compact): $(shlib::dt_duration $secs compact)"
echo "dt_duration 3600:            $(shlib::dt_duration 3600)"

# Format elapsed time since a start timestamp
start=$(shlib::dt_now)
sleep 1
echo "dt_elapsed: $(shlib::dt_elapsed "$start")"

# Format a Unix timestamp
ts=1704067200 # Jan 1, 2024
echo "dt_from_unix (date):     $(shlib::dt_from_unix "$ts" "%Y-%m-%d")"
echo "dt_from_unix (datetime): $(shlib::dt_from_unix "$ts" "%Y-%m-%d %H:%M:%S")"

# Check if one timestamp is after another
ts1=1704153600 # Jan 2, 2024
ts2=1704067200 # Jan 1, 2024
if shlib::dt_is_after "$ts1" "$ts2"; then
    echo "dt_is_after: $ts1 is after $ts2 (true)"
fi

# Check if one timestamp is before another
ts1=1704067200 # Jan 1, 2024
ts2=1704153600 # Jan 2, 2024
if shlib::dt_is_before "$ts1" "$ts2"; then
    echo "dt_is_before: $ts1 is before $ts2 (true)"
fi

# Get current Unix timestamp
echo "dt_now: $(shlib::dt_now)"

# Get current datetime in ISO 8601 format
echo "dt_now_iso (UTC):   $(shlib::dt_now_iso)"
echo "dt_now_iso (local): $(shlib::dt_now_iso local)"

# Get today's date
echo "dt_today: $(shlib::dt_today)"

#######################################
# kv
#######################################

# Remove all entries from an associative array
declare -A catalog
catalog[M31]="Andromeda"
catalog[M42]="Orion Nebula"
catalog[M45]="Pleiades"
echo "Before: $(shlib::kv_len catalog) entries"
shlib::kv_clear catalog
echo "After kv_clear: $(shlib::kv_len catalog) entries"

# Copy an associative array to another
declare -A source_catalog
source_catalog[M31]="Andromeda"
source_catalog[M42]="Orion Nebula"
declare -A backup_catalog
shlib::kv_copy backup_catalog source_catalog
echo "Original: $(shlib::kv_print source_catalog)"
echo "Copy:     $(shlib::kv_print backup_catalog)"

# Delete a key from an associative array
declare -A elements
elements[hydrogen]="1"
elements[helium]="2"
elements[lithium]="3"
echo "Before: $(shlib::kv_print elements)"
shlib::kv_delete elements "lithium"
echo "After kv_delete 'lithium': $(shlib::kv_print elements)"

# Check if a key exists
declare -A elements
elements[hydrogen]="1"
elements[helium]="2"
echo "kv_exists 'hydrogen': $(shlib::kv_exists elements "hydrogen" && echo "true" || echo "false")"
echo "kv_exists 'lithium':  $(shlib::kv_exists elements "lithium" && echo "true" || echo "false")"

# Find all keys with a specific value
declare -A spectral_class
spectral_class[Sirius]="A"
spectral_class[Vega]="A"
spectral_class[Betelgeuse]="M"
spectral_class[Rigel]="B"
shlib::kv_find class_a spectral_class "A"
# shellcheck disable=SC2154
echo "Stars with class A: (${class_a[*]})"

# Get a value by key
declare -A telescope
telescope[aperture]="200mm"
telescope[focal_length]="1000mm"
telescope[filter]="H-alpha"
echo "kv_get 'aperture': $(shlib::kv_get telescope "aperture")"
echo "kv_get 'filter':   $(shlib::kv_get telescope "filter")"

# Get a value with fallback default
declare -A telescope
telescope[aperture]="200mm"
echo "kv_get_default 'aperture' '100mm': $(shlib::kv_get_default telescope "aperture" "100mm")"
echo "kv_get_default 'tracking' 'off':   $(shlib::kv_get_default telescope "tracking" "off")"

# Check if a value exists in an associative array
declare -A spectral_class
spectral_class[Sirius]="A"
spectral_class[Vega]="A"
spectral_class[Betelgeuse]="M"
echo "kv_has_value 'A': $(shlib::kv_has_value spectral_class "A" && echo "true" || echo "false")"
echo "kv_has_value 'G': $(shlib::kv_has_value spectral_class "G" && echo "true" || echo "false")"

# Get all keys from an associative array
declare -A orbit_au
orbit_au[Mercury]="0.39"
orbit_au[Venus]="0.72"
orbit_au[Earth]="1.00"
shlib::kv_keys names orbit_au
# shellcheck disable=SC2154
echo "kv_keys: (${names[*]})"

# Get the count of entries
declare -A orbit_au
orbit_au[Mercury]="0.39"
orbit_au[Venus]="0.72"
orbit_au[Earth]="1.00"
orbit_au[Mars]="1.52"
echo "Contents: $(shlib::kv_print orbit_au)"
echo "kv_len: $(shlib::kv_len orbit_au)"

# Apply a transformation to all values
declare -A catalog
catalog[m31]="andromeda"
catalog[m42]="orion nebula"
echo "Before: $(shlib::kv_print catalog)"
shlib::kv_map catalog 'tr a-z A-Z'
echo "After kv_map (uppercase): $(shlib::kv_print catalog)"

# Merge multiple associative arrays (later overrides earlier)
declare -A defaults
defaults[tracking]="off"
defaults[exposure]="30s"
defaults[filter]="none"
declare -A overrides
overrides[exposure]="120s"
overrides[filter]="H-alpha"
echo "defaults:  $(shlib::kv_print defaults)"
echo "overrides: $(shlib::kv_print overrides)"
declare -A config
shlib::kv_merge config defaults overrides
echo "After kv_merge: $(shlib::kv_print config)"

# Print key-value pairs inline with custom separators
declare -A telescope
telescope[aperture]="200mm"
telescope[focal_length]="1000mm"
telescope[filter]="H-alpha"
echo "kv_print (default): $(shlib::kv_print telescope)"
echo "kv_print (custom):  $(shlib::kv_print telescope ":" ", ")"

# Print key-value pairs one per line
declare -A elements
elements[hydrogen]="1"
elements[helium]="2"
elements[carbon]="6"
elements[oxygen]="8"
echo "kv_printn:"
shlib::kv_printn elements

# Set key-value pairs in an associative array
declare -A telescope
shlib::kv_set telescope "aperture" "200mm"
shlib::kv_set telescope "focal_length" "1000mm"
shlib::kv_set telescope "filter" "H-alpha"
echo "After kv_set:"
shlib::kv_printn telescope

# Get all values from an associative array
declare -A orbit_au
orbit_au[Mercury]="0.39"
orbit_au[Venus]="0.72"
orbit_au[Earth]="1.00"
shlib::kv_values distances orbit_au
# shellcheck disable=SC2154
echo "kv_values: (${distances[*]})"

#######################################
# logging
#######################################

# Print colorized error messages to stderr
shlib::cerrorn "CCD temperature out of range"
shlib::cerror "Guider lost lock on reference star"
echo " <- no newline variant" >&2

# Print colorized info messages to stdout
shlib::cinfon "Filter wheel moved to H-alpha"
shlib::cinfo "Dome rotation complete"
echo " <- no newline variant"

# Print colorized warning messages to stdout
shlib::cwarnn "Moon illumination above 80%"
shlib::cwarn "Humidity rising"
echo " <- no newline variant"

# Print emoji error messages to stderr
shlib::eerrorn "Mount connection lost"
shlib::eerror "Flat frame acquisition failed"
echo " <- no newline variant" >&2

# Print emoji info messages to stdout
shlib::einfon "Dark frame calibration complete"
shlib::einfo "Image saved to FITS"
echo " <- no newline variant"

# Print error messages to stderr
shlib::errorn "Stellar parallax calculation failed"
shlib::error "Sensor calibration error"
echo " <- no newline variant" >&2

# Print emoji warning messages to stdout
shlib::ewarnn "Cloud cover increasing"
shlib::ewarn "Battery below 20%"
echo " <- no newline variant"

# Print info messages to stdout
shlib::infon "Telescope aligned to Polaris"
shlib::info "Exposure started"
echo " <- no newline variant"

# Print warning messages to stdout
shlib::warnn "Atmospheric seeing degraded to 3 arcsec"
shlib::warn "Tracking drift detected"
echo " <- no newline variant"

#######################################
# strings
#######################################

# Check if a string contains a substring
if shlib::str_contains "Andromeda Galaxy" "Galaxy"; then
    echo "str_contains \"Andromeda Galaxy\" \"Galaxy\": true"
fi
if ! shlib::str_contains "Andromeda Galaxy" "Nebula"; then
    echo "str_contains \"Andromeda Galaxy\" \"Nebula\": false"
fi

# Check if a string ends with a suffix
if shlib::str_endswith "supernova.fits" ".fits"; then
    echo "str_endswith \"supernova.fits\" \".fits\": true"
fi
if ! shlib::str_endswith "supernova.fits" ".csv"; then
    echo "str_endswith \"supernova.fits\" \".csv\": false"
fi

# Check if a string is empty or whitespace-only
if shlib::str_is_empty "   "; then
    echo "str_is_empty \"   \": true (whitespace only)"
fi
if ! shlib::str_is_empty "quasar"; then
    echo "str_is_empty \"quasar\": false"
fi

# Get the length of a string
name="Betelgeuse"
echo "str_len \"$name\": $(shlib::str_len "$name")"

# Remove leading whitespace
raw="   Horsehead Nebula"
echo "Before: [$raw]"
echo "After str_ltrim: [$(shlib::str_ltrim "$raw")]"

# Pad a string on the left
echo "str_padleft \"42\" 6 \"0\": [$(shlib::str_padleft "42" 6 "0")]"
echo "str_padleft \"NGC\" 8:    [$(shlib::str_padleft "NGC" 8)]"

# Pad a string on the right
echo "str_padright \"M31\" 8 \".\": [$(shlib::str_padright "M31" 8 ".")]"
echo "str_padright \"IC\" 6:      [$(shlib::str_padright "IC" 6)]"

# Repeat a string N times
echo "str_repeat \"=-\" 20: $(shlib::str_repeat "=-" 20)"
echo "str_repeat \"*\" 10:  $(shlib::str_repeat "*" 10)"

# Remove trailing whitespace
raw="Ring Nebula   "
echo "Before: [$raw]"
echo "After str_rtrim: [$(shlib::str_rtrim "$raw")]"

# Split a string into an array
csv="Sirius,Vega,Rigel,Altair"
shlib::str_split star_list "$csv" ","
# shellcheck disable=SC2154
echo "str_split \"$csv\" by \",\": (${star_list[*]})"
echo "Count: ${#star_list[@]}"

# Check if a string starts with a prefix
if shlib::str_startswith "NGC 4321" "NGC"; then
    echo "str_startswith \"NGC 4321\" \"NGC\": true"
fi
if ! shlib::str_startswith "NGC 4321" "IC"; then
    echo "str_startswith \"NGC 4321\" \"IC\": false"
fi

# Convert a string to lowercase
echo "str_to_lower \"SUPERNOVA\": $(shlib::str_to_lower "SUPERNOVA")"

# Convert a string to uppercase
echo "str_to_upper \"pulsar\": $(shlib::str_to_upper "pulsar")"

# Remove leading and trailing whitespace
raw="   Crab Nebula   "
echo "Before: [$raw]"
echo "After str_trim: [$(shlib::str_trim "$raw")]"

#######################################
# system
#######################################

# Check if a command exists
if shlib::cmd_exists git; then
    shlib::cinfon "git is installed"
else
    shlib::cwarnn "git is not installed"
fi
if ! shlib::cmd_exists nonexistent_cmd; then
    shlib::cwarnn "nonexistent_cmd not found (expected)"
fi

# Run a command protected by file-based locking
lockfile=$(mktemp -u)
if shlib::cmd_locked "$lockfile" 0 echo "Protected operation"; then
    shlib::cinfon "Locked command executed successfully"
fi
# Demonstrate lock contention
mkdir "${lockfile}.lock"
echo $$ >"${lockfile}.lock/pid"
if ! shlib::cmd_locked "$lockfile" 0 true; then
    shlib::cwarnn "Lock already held (expected)"
fi
rm -rf "${lockfile}.lock"

# Retry a command with delay between attempts
if shlib::cmd_retry 3 0 true; then
    shlib::cinfon "Command succeeded on first attempt"
fi
if ! shlib::cmd_retry 2 0 false; then
    shlib::cwarnn "Command failed after 2 attempts (expected)"
fi

# Run a command with a timeout
if shlib::cmd_timeout 2 sleep 1; then
    shlib::cinfon "Command completed within timeout"
fi
if ! shlib::cmd_timeout 1 sleep 5; then
    shlib::cwarnn "Command timed out (expected)"
fi

#######################################
# ui
#######################################

# Display the 256-color ANSI palette
shlib::ansi_256_palette

# Display ANSI background colors
shlib::ansi_bg_colors

# Display standard foreground/background color combinations
shlib::ansi_color_matrix

# Display bright foreground/background color combinations
shlib::ansi_color_matrix_bright

# Display ANSI foreground colors
shlib::ansi_fg_colors

# Display ANSI text styles
shlib::ansi_styles

# Render ASCII art banner using best available method
shlib::banner "COSMOS"

# Render ASCII art banner using built-in block font
shlib::banner_builtin "NOVA"

# Render ASCII art banner using figlet
if shlib::cmd_exists figlet; then
    shlib::banner_figlet "PULSAR"
else
    echo "(figlet not installed, skipping)"
fi

# Render ASCII art banner using toilet
if shlib::cmd_exists toilet; then
    shlib::banner_toilet "QUASAR" "" "gay"
else
    echo "(toilet not installed, skipping)"
fi

# Print a bold header (without newline)
shlib::header "Observation Log"
echo " <- no newline variant"

# Print a bold header (with newline)
shlib::headern "Observation Log"

# Draw a horizontal rule
shlib::hrn
shlib::hrn "Telemetry" 40 "="

# Draw a horizontal rule (with newline)
shlib::hrn "Session Start"
shlib::hrn "" 50 "─"

# Run a command with spinner animation
if shlib::spinner "Processing star field" sleep 2; then
    shlib::einfon "Processing complete"
fi

# Print failure status indicator
shlib::status_failn "Sensor readout failed"

# Print success status indicator
shlib::status_okn "Calibration complete"

# Print pending status indicator
shlib::status_pendingn "Awaiting dark frames..."
# End of File
