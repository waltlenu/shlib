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

# Example helpers
_header() { shlib::headern "${1#shlib::}"; }
_run() {
    echo "> $*"
    "$@"
}
_show() { echo "> $*"; }
# shellcheck disable=SC2005
_eval() {
    echo "> $*"
    echo "$("$@")"
}

#######################################
# _core
#######################################

_header shlib::list_functions
_show shlib::list_functions
shlib::list_functions | head -10
echo "... ($(shlib::list_functions | wc -l | tr -d ' ') total functions)"
echo

_header shlib::list_variables
_run shlib::list_variables
echo

_header shlib::version
_eval shlib::version
echo

#######################################
# arrays
#######################################

_header shlib::arr_append
planets=(Mercury Venus Earth)
echo "Before: (${planets[*]})"
_run shlib::arr_append planets "Mars" "Jupiter"
echo "After: (${planets[*]})"
echo

_header shlib::arr_delete
particles=(muon quark boson lepton)
echo "Before: (${particles[*]})"
_run shlib::arr_delete particles 1
echo "After: (${particles[*]})"
echo

_header shlib::arr_insert
planets=(Mercury Venus Mars Jupiter)
echo "Before: (${planets[*]})"
_run shlib::arr_insert planets 2 "Earth"
echo "After: (${planets[*]})"
echo

_header shlib::arr_len
stars=(Sirius Vega Rigel Altair Polaris)
echo "Stars: (${stars[*]})"
_eval shlib::arr_len stars
echo

_header shlib::arr_merge
inner=(Mercury Venus Earth Mars)
outer=(Jupiter Saturn Uranus Neptune)
# shellcheck disable=SC2034
dwarf=(Pluto Ceres Eris)
echo "inner: (${inner[*]})"
echo "outer: (${outer[*]})"
echo "dwarf: (${dwarf[*]})"
_run shlib::arr_merge solar_system inner outer dwarf
# shellcheck disable=SC2154
echo "Result: (${solar_system[*]})"
echo

_header shlib::arr_pop
moons=(Io Europa Ganymede Callisto)
echo "Before: (${moons[*]})"
_run shlib::arr_pop moons
echo "After: (${moons[*]})"
echo

_header shlib::arr_print
quarks=(up down charm strange top bottom)
_eval shlib::arr_print quarks
_eval shlib::arr_print quarks ","
_eval shlib::arr_print quarks " | "
echo

_header shlib::arr_printn
constellations=(Orion Cassiopeia Ursa Lyra)
_run shlib::arr_printn constellations
echo

_header shlib::arr_reverse
planets=(Mercury Venus Earth Mars Jupiter)
echo "Before: (${planets[*]})"
_run shlib::arr_reverse planets
echo "After: (${planets[*]})"
echo

_header shlib::arr_sort
stars=(Rigel Altair Sirius Vega Betelgeuse)
echo "Before: (${stars[*]})"
_run shlib::arr_sort stars
echo "After: (${stars[*]})"
echo

_header shlib::arr_uniq
readings=(muon quark muon boson quark lepton muon)
echo "Before: (${readings[*]})"
_run shlib::arr_uniq readings
echo "After: (${readings[*]})"
echo

#######################################
# dt
#######################################

_header shlib::dt_add
base=1704067200 # Jan 1, 2024 00:00:00 UTC
echo "Base: $base ($(shlib::dt_from_unix "$base" "%Y-%m-%d" 2>/dev/null || echo "2024-01-01"))"
_eval shlib::dt_add "$base" 1 days
_eval shlib::dt_add "$base" 12 hours
_eval shlib::dt_add "$base" -1 weeks
echo

_header shlib::dt_diff
ts1=1704153600 # Jan 2, 2024
ts2=1704067200 # Jan 1, 2024
echo "ts1=$ts1 (Jan 2), ts2=$ts2 (Jan 1)"
_eval shlib::dt_diff "$ts1" "$ts2" seconds
_eval shlib::dt_diff "$ts1" "$ts2" hours
_eval shlib::dt_diff "$ts1" "$ts2" days
echo

_header shlib::dt_duration
secs=90061 # 1 day, 1 hour, 1 minute, 1 second
_eval shlib::dt_duration $secs
_eval shlib::dt_duration $secs long
_eval shlib::dt_duration $secs compact
_eval shlib::dt_duration 3600
echo

_header shlib::dt_elapsed
start=$(shlib::dt_now)
sleep 1
_eval shlib::dt_elapsed "$start"
echo

_header shlib::dt_from_unix
ts=1704067200 # Jan 1, 2024
_eval shlib::dt_from_unix "$ts" "%Y-%m-%d"
_eval shlib::dt_from_unix "$ts" "%Y-%m-%d %H:%M:%S"
echo

_header shlib::dt_is_after
ts1=1704153600 # Jan 2, 2024
ts2=1704067200 # Jan 1, 2024
_show shlib::dt_is_after "$ts1" "$ts2"
if shlib::dt_is_after "$ts1" "$ts2"; then
    echo "true"
fi
echo

_header shlib::dt_is_before
ts1=1704067200 # Jan 1, 2024
ts2=1704153600 # Jan 2, 2024
_show shlib::dt_is_before "$ts1" "$ts2"
if shlib::dt_is_before "$ts1" "$ts2"; then
    echo "true"
fi
echo

_header shlib::dt_now
_eval shlib::dt_now
echo

_header shlib::dt_now_iso
_eval shlib::dt_now_iso
_eval shlib::dt_now_iso local
echo

_header shlib::dt_today
_eval shlib::dt_today
echo

#######################################
# kv
#######################################

_header shlib::kv_clear
declare -A catalog
catalog[M31]="Andromeda"
catalog[M42]="Orion Nebula"
catalog[M45]="Pleiades"
echo "Before: $(shlib::kv_len catalog) entries"
_run shlib::kv_clear catalog
echo "After: $(shlib::kv_len catalog) entries"
echo

_header shlib::kv_copy
declare -A source_catalog
source_catalog[M31]="Andromeda"
source_catalog[M42]="Orion Nebula"
declare -A backup_catalog
_run shlib::kv_copy backup_catalog source_catalog
echo "Original: $(shlib::kv_print source_catalog)"
echo "Copy:     $(shlib::kv_print backup_catalog)"
echo

_header shlib::kv_delete
declare -A elements
elements[hydrogen]="1"
elements[helium]="2"
elements[lithium]="3"
echo "Before: $(shlib::kv_print elements)"
_run shlib::kv_delete elements "lithium"
echo "After: $(shlib::kv_print elements)"
echo

_header shlib::kv_exists
declare -A elements
elements[hydrogen]="1"
elements[helium]="2"
_show shlib::kv_exists elements "hydrogen"
shlib::kv_exists elements "hydrogen" && echo "true" || echo "false"
_show shlib::kv_exists elements "lithium"
shlib::kv_exists elements "lithium" && echo "true" || echo "false"
echo

_header shlib::kv_find
declare -A spectral_class
spectral_class[Sirius]="A"
spectral_class[Vega]="A"
spectral_class[Betelgeuse]="M"
spectral_class[Rigel]="B"
_run shlib::kv_find class_a spectral_class "A"
# shellcheck disable=SC2154
echo "Stars with class A: (${class_a[*]})"
echo

_header shlib::kv_get
declare -A telescope
telescope[aperture]="200mm"
telescope[focal_length]="1000mm"
telescope[filter]="H-alpha"
_eval shlib::kv_get telescope "aperture"
_eval shlib::kv_get telescope "filter"
echo

_header shlib::kv_get_default
declare -A telescope
telescope[aperture]="200mm"
_eval shlib::kv_get_default telescope "aperture" "100mm"
_eval shlib::kv_get_default telescope "tracking" "off"
echo

_header shlib::kv_has_value
declare -A spectral_class
spectral_class[Sirius]="A"
spectral_class[Vega]="A"
spectral_class[Betelgeuse]="M"
_show shlib::kv_has_value spectral_class "A"
shlib::kv_has_value spectral_class "A" && echo "true" || echo "false"
_show shlib::kv_has_value spectral_class "G"
shlib::kv_has_value spectral_class "G" && echo "true" || echo "false"
echo

_header shlib::kv_keys
declare -A orbit_au
orbit_au[Mercury]="0.39"
orbit_au[Venus]="0.72"
orbit_au[Earth]="1.00"
_run shlib::kv_keys names orbit_au
# shellcheck disable=SC2154
echo "Result: (${names[*]})"
echo

_header shlib::kv_len
declare -A orbit_au
orbit_au[Mercury]="0.39"
orbit_au[Venus]="0.72"
orbit_au[Earth]="1.00"
orbit_au[Mars]="1.52"
echo "Contents: $(shlib::kv_print orbit_au)"
_eval shlib::kv_len orbit_au
echo

_header shlib::kv_map
declare -A catalog
catalog[m31]="andromeda"
catalog[m42]="orion nebula"
echo "Before: $(shlib::kv_print catalog)"
_run shlib::kv_map catalog 'tr a-z A-Z'
echo "After: $(shlib::kv_print catalog)"
echo

_header shlib::kv_merge
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
_run shlib::kv_merge config defaults overrides
echo "Result: $(shlib::kv_print config)"
echo

_header shlib::kv_print
declare -A telescope
telescope[aperture]="200mm"
telescope[focal_length]="1000mm"
telescope[filter]="H-alpha"
_eval shlib::kv_print telescope
_eval shlib::kv_print telescope ":" ", "
echo

_header shlib::kv_printn
declare -A elements
elements[hydrogen]="1"
elements[helium]="2"
elements[carbon]="6"
elements[oxygen]="8"
_run shlib::kv_printn elements
echo

_header shlib::kv_set
declare -A telescope
_run shlib::kv_set telescope "aperture" "200mm"
_run shlib::kv_set telescope "focal_length" "1000mm"
_run shlib::kv_set telescope "filter" "H-alpha"
echo "Result:"
shlib::kv_printn telescope
echo

_header shlib::kv_values
declare -A orbit_au
orbit_au[Mercury]="0.39"
orbit_au[Venus]="0.72"
orbit_au[Earth]="1.00"
_run shlib::kv_values distances orbit_au
# shellcheck disable=SC2154
echo "Result: (${distances[*]})"
echo

#######################################
# logging
#######################################

_header shlib::cerror
_run shlib::cerrorn "CCD temperature out of range"
_run shlib::cerror "Guider lost lock on reference star"
echo " <- no newline variant" >&2
echo

_header shlib::cinfo
_run shlib::cinfon "Filter wheel moved to H-alpha"
_run shlib::cinfo "Dome rotation complete"
echo " <- no newline variant"
echo

_header shlib::cwarn
_run shlib::cwarnn "Moon illumination above 80%"
_run shlib::cwarn "Humidity rising"
echo " <- no newline variant"
echo

_header shlib::eerror
_run shlib::eerrorn "Mount connection lost"
_run shlib::eerror "Flat frame acquisition failed"
echo " <- no newline variant" >&2
echo

_header shlib::einfo
_run shlib::einfon "Dark frame calibration complete"
_run shlib::einfo "Image saved to FITS"
echo " <- no newline variant"
echo

_header shlib::error
_run shlib::errorn "Stellar parallax calculation failed"
_run shlib::error "Sensor calibration error"
echo " <- no newline variant" >&2
echo

_header shlib::ewarn
_run shlib::ewarnn "Cloud cover increasing"
_run shlib::ewarn "Battery below 20%"
echo " <- no newline variant"
echo

_header shlib::info
_run shlib::infon "Telescope aligned to Polaris"
_run shlib::info "Exposure started"
echo " <- no newline variant"
echo

_header shlib::warn
_run shlib::warnn "Atmospheric seeing degraded to 3 arcsec"
_run shlib::warn "Tracking drift detected"
echo " <- no newline variant"
echo

#######################################
# strings
#######################################

_header shlib::str_contains
_show shlib::str_contains "Andromeda Galaxy" "Galaxy"
if shlib::str_contains "Andromeda Galaxy" "Galaxy"; then
    echo "true"
fi
_show shlib::str_contains "Andromeda Galaxy" "Nebula"
if ! shlib::str_contains "Andromeda Galaxy" "Nebula"; then
    echo "false"
fi
echo

_header shlib::str_endswith
_show shlib::str_endswith "supernova.fits" ".fits"
if shlib::str_endswith "supernova.fits" ".fits"; then
    echo "true"
fi
_show shlib::str_endswith "supernova.fits" ".csv"
if ! shlib::str_endswith "supernova.fits" ".csv"; then
    echo "false"
fi
echo

_header shlib::str_is_empty
_show shlib::str_is_empty "   "
if shlib::str_is_empty "   "; then
    echo "true (whitespace only)"
fi
_show shlib::str_is_empty "quasar"
if ! shlib::str_is_empty "quasar"; then
    echo "false"
fi
echo

_header shlib::str_len
_eval shlib::str_len "Betelgeuse"
echo

_header shlib::str_ltrim
raw="   Horsehead Nebula"
echo "Before: [$raw]"
_show shlib::str_ltrim "$raw"
echo "After: [$(shlib::str_ltrim "$raw")]"
echo

_header shlib::str_padleft
_show shlib::str_padleft "42" 6 "0"
echo "[$(shlib::str_padleft "42" 6 "0")]"
_show shlib::str_padleft "NGC" 8
echo "[$(shlib::str_padleft "NGC" 8)]"
echo

_header shlib::str_padright
_show shlib::str_padright "M31" 8 "."
echo "[$(shlib::str_padright "M31" 8 ".")]"
_show shlib::str_padright "IC" 6
echo "[$(shlib::str_padright "IC" 6)]"
echo

_header shlib::str_repeat
_eval shlib::str_repeat "=-" 20
_eval shlib::str_repeat "*" 10
echo

_header shlib::str_rtrim
raw="Ring Nebula   "
echo "Before: [$raw]"
_show shlib::str_rtrim "$raw"
echo "After: [$(shlib::str_rtrim "$raw")]"
echo

_header shlib::str_split
csv="Sirius,Vega,Rigel,Altair"
_run shlib::str_split star_list "$csv" ","
# shellcheck disable=SC2154
echo "Result: (${star_list[*]})"
echo "Count: ${#star_list[@]}"
echo

_header shlib::str_startswith
_show shlib::str_startswith "NGC 4321" "NGC"
if shlib::str_startswith "NGC 4321" "NGC"; then
    echo "true"
fi
_show shlib::str_startswith "NGC 4321" "IC"
if ! shlib::str_startswith "NGC 4321" "IC"; then
    echo "false"
fi
echo

_header shlib::str_to_lower
_eval shlib::str_to_lower "SUPERNOVA"
echo

_header shlib::str_to_upper
_eval shlib::str_to_upper "pulsar"
echo

_header shlib::str_trim
raw="   Crab Nebula   "
echo "Before: [$raw]"
_show shlib::str_trim "$raw"
echo "After: [$(shlib::str_trim "$raw")]"
echo

#######################################
# system
#######################################

_header shlib::cmd_exists
_show shlib::cmd_exists git
if shlib::cmd_exists git; then
    shlib::cinfon "git is installed"
else
    shlib::cwarnn "git is not installed"
fi
_show shlib::cmd_exists nonexistent_cmd
if ! shlib::cmd_exists nonexistent_cmd; then
    shlib::cwarnn "nonexistent_cmd not found (expected)"
fi
echo

_header shlib::cmd_locked
lockfile=$(mktemp -u)
_show shlib::cmd_locked "$lockfile" 0 echo "Protected operation"
if shlib::cmd_locked "$lockfile" 0 echo "Protected operation"; then
    shlib::cinfon "Locked command executed successfully"
fi
# Demonstrate lock contention
mkdir "${lockfile}.lock"
echo $$ >"${lockfile}.lock/pid"
_show shlib::cmd_locked "$lockfile" 0 true
if ! shlib::cmd_locked "$lockfile" 0 true; then
    shlib::cwarnn "Lock already held (expected)"
fi
rm -rf "${lockfile}.lock"
echo

_header shlib::cmd_retry
_show shlib::cmd_retry 3 0 true
if shlib::cmd_retry 3 0 true; then
    shlib::cinfon "Command succeeded on first attempt"
fi
_show shlib::cmd_retry 2 0 false
if ! shlib::cmd_retry 2 0 false; then
    shlib::cwarnn "Command failed after 2 attempts (expected)"
fi
echo

_header shlib::cmd_timeout
_show shlib::cmd_timeout 2 sleep 1
if shlib::cmd_timeout 2 sleep 1; then
    shlib::cinfon "Command completed within timeout"
fi
_show shlib::cmd_timeout 1 sleep 5
if ! shlib::cmd_timeout 1 sleep 5; then
    shlib::cwarnn "Command timed out (expected)"
fi
echo

#######################################
# ui
#######################################

_header shlib::ansi_256_palette
_run shlib::ansi_256_palette
echo

_header shlib::ansi_bg_colors
_run shlib::ansi_bg_colors
echo

_header shlib::ansi_color_matrix
_run shlib::ansi_color_matrix
echo

_header shlib::ansi_color_matrix_bright
_run shlib::ansi_color_matrix_bright
echo

_header shlib::ansi_fg_colors
_run shlib::ansi_fg_colors
echo

_header shlib::ansi_styles
_run shlib::ansi_styles
echo

_header shlib::banner
_run shlib::banner "COSMOS"
echo

_header shlib::banner_builtin
_run shlib::banner_builtin "NOVA"
echo

_header shlib::banner_figlet
if shlib::cmd_exists figlet; then
    _run shlib::banner_figlet "PULSAR"
else
    echo "(figlet not installed, skipping)"
fi
echo

_header shlib::banner_toilet
if shlib::cmd_exists toilet; then
    _run shlib::banner_toilet "QUASAR" "" "gay"
else
    echo "(toilet not installed, skipping)"
fi
echo

_header shlib::header
_run shlib::header "Observation Log"
echo " <- no newline variant"
echo

_header shlib::headern
_run shlib::headern "Observation Log"
echo

_header shlib::hr
_run shlib::hrn
_run shlib::hrn "Telemetry" 40 "="
echo

_header shlib::hrn
_run shlib::hrn "Session Start"
_run shlib::hrn "" 50 "─"
echo

_header shlib::spinner
_show shlib::spinner "Processing star field" sleep 2
if shlib::spinner "Processing star field" sleep 2; then
    shlib::einfon "Processing complete"
fi
echo

_header shlib::status_fail
_run shlib::status_failn "Sensor readout failed"
echo

_header shlib::status_ok
_run shlib::status_okn "Calibration complete"
echo

_header shlib::status_pending
_run shlib::status_pendingn "Awaiting dark frames..."
echo
# End of File
