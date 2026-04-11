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

shlib::ui_banner "shlib" "" "gay"

shlib::ui_headern "shlib Examples"
echo

# Example helpers
_header() { shlib::ui_headern "${1#shlib::}"; }
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
# cmd
#######################################

_header shlib::cmd_exists
_show shlib::cmd_exists git
if shlib::cmd_exists git; then
    shlib::msg_cinfon "git is installed"
else
    shlib::msg_cwarnn "git is not installed"
fi
_show shlib::cmd_exists nonexistent_cmd
if ! shlib::cmd_exists nonexistent_cmd; then
    shlib::msg_cwarnn "nonexistent_cmd not found (expected)"
fi
echo

_header shlib::cmd_locked
lockfile=$(mktemp -u)
_show shlib::cmd_locked "$lockfile" 0 echo "Protected operation"
if shlib::cmd_locked "$lockfile" 0 echo "Protected operation"; then
    shlib::msg_cinfon "Locked command executed successfully"
fi
# Demonstrate lock contention
mkdir "${lockfile}.lock"
echo $$ >"${lockfile}.lock/pid"
_show shlib::cmd_locked "$lockfile" 0 true
if ! shlib::cmd_locked "$lockfile" 0 true; then
    shlib::msg_cwarnn "Lock already held (expected)"
fi
rm -rf "${lockfile}.lock"
echo

_header shlib::cmd_retry
_show shlib::cmd_retry 3 0 true
if shlib::cmd_retry 3 0 true; then
    shlib::msg_cinfon "Command succeeded on first attempt"
fi
_show shlib::cmd_retry 2 0 false
if ! shlib::cmd_retry 2 0 false; then
    shlib::msg_cwarnn "Command failed after 2 attempts (expected)"
fi
echo

_header shlib::cmd_timeout
_show shlib::cmd_timeout 2 sleep 1
if shlib::cmd_timeout 2 sleep 1; then
    shlib::msg_cinfon "Command completed within timeout"
fi
_show shlib::cmd_timeout 1 sleep 5
if ! shlib::cmd_timeout 1 sleep 5; then
    shlib::msg_cwarnn "Command timed out (expected)"
fi
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

_header shlib::kv_getdefault
declare -A telescope
telescope[aperture]="200mm"
_eval shlib::kv_getdefault telescope "aperture" "100mm"
_eval shlib::kv_getdefault telescope "tracking" "off"
echo

_header shlib::kv_hasvalue
declare -A spectral_class
spectral_class[Sirius]="A"
spectral_class[Vega]="A"
spectral_class[Betelgeuse]="M"
_show shlib::kv_hasvalue spectral_class "A"
shlib::kv_hasvalue spectral_class "A" && echo "true" || echo "false"
_show shlib::kv_hasvalue spectral_class "G"
shlib::kv_hasvalue spectral_class "G" && echo "true" || echo "false"
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
# msg
#######################################

_header shlib::msg_cerror
_run shlib::msg_cerrorn "CCD temperature out of range"
_run shlib::msg_cerror "Guider lost lock on reference star"
echo " <- no newline variant" >&2
echo

_header shlib::msg_cinfo
_run shlib::msg_cinfon "Filter wheel moved to H-alpha"
_run shlib::msg_cinfo "Dome rotation complete"
echo " <- no newline variant"
echo

_header shlib::msg_cwarn
_run shlib::msg_cwarnn "Moon illumination above 80%"
_run shlib::msg_cwarn "Humidity rising"
echo " <- no newline variant"
echo

_header shlib::msg_eerror
_run shlib::msg_eerrorn "Mount connection lost"
_run shlib::msg_eerror "Flat frame acquisition failed"
echo " <- no newline variant" >&2
echo

_header shlib::msg_einfo
_run shlib::msg_einfon "Dark frame calibration complete"
_run shlib::msg_einfo "Image saved to FITS"
echo " <- no newline variant"
echo

_header shlib::msg_error
_run shlib::msg_errorn "Stellar parallax calculation failed"
_run shlib::msg_error "Sensor calibration error"
echo " <- no newline variant" >&2
echo

_header shlib::msg_ewarn
_run shlib::msg_ewarnn "Cloud cover increasing"
_run shlib::msg_ewarn "Battery below 20%"
echo " <- no newline variant"
echo

_header shlib::msg_info
_run shlib::msg_infon "Telescope aligned to Polaris"
_run shlib::msg_info "Exposure started"
echo " <- no newline variant"
echo

_header shlib::msg_statusfail
_run shlib::msg_statusfailn "Sensor readout failed"
echo

_header shlib::msg_statusok
_run shlib::msg_statusokn "Calibration complete"
echo

_header shlib::msg_statuspending
_run shlib::msg_statuspendingn "Awaiting dark frames..."
echo

_header shlib::msg_warn
_run shlib::msg_warnn "Atmospheric seeing degraded to 3 arcsec"
_run shlib::msg_warn "Tracking drift detected"
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

_header shlib::str_isempty
_show shlib::str_isempty "   "
if shlib::str_isempty "   "; then
    echo "true (whitespace only)"
fi
_show shlib::str_isempty "quasar"
if ! shlib::str_isempty "quasar"; then
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

_header shlib::str_tolower
_eval shlib::str_tolower "SUPERNOVA"
echo

_header shlib::str_toupper
_eval shlib::str_toupper "pulsar"
echo

_header shlib::str_trim
raw="   Crab Nebula   "
echo "Before: [$raw]"
_show shlib::str_trim "$raw"
echo "After: [$(shlib::str_trim "$raw")]"
echo

#######################################
# time
#######################################

_header shlib::time_add
base=1704067200 # Jan 1, 2024 00:00:00 UTC
echo "Base: $base ($(shlib::time_fromunix "$base" "%Y-%m-%d" 2>/dev/null || echo "2024-01-01"))"
_eval shlib::time_add "$base" 1 days
_eval shlib::time_add "$base" 12 hours
_eval shlib::time_add "$base" -1 weeks
echo

_header shlib::time_diff
ts1=1704153600 # Jan 2, 2024
ts2=1704067200 # Jan 1, 2024
echo "ts1=$ts1 (Jan 2), ts2=$ts2 (Jan 1)"
_eval shlib::time_diff "$ts1" "$ts2" seconds
_eval shlib::time_diff "$ts1" "$ts2" hours
_eval shlib::time_diff "$ts1" "$ts2" days
echo

_header shlib::time_duration
secs=90061 # 1 day, 1 hour, 1 minute, 1 second
_eval shlib::time_duration $secs
_eval shlib::time_duration $secs long
_eval shlib::time_duration $secs compact
_eval shlib::time_duration 3600
echo

_header shlib::time_elapsed
start=$(shlib::time_now)
sleep 1
_eval shlib::time_elapsed "$start"
echo

_header shlib::time_fromunix
ts=1704067200 # Jan 1, 2024
_eval shlib::time_fromunix "$ts" "%Y-%m-%d"
_eval shlib::time_fromunix "$ts" "%Y-%m-%d %H:%M:%S"
echo

_header shlib::time_isafter
ts1=1704153600 # Jan 2, 2024
ts2=1704067200 # Jan 1, 2024
_show shlib::time_isafter "$ts1" "$ts2"
if shlib::time_isafter "$ts1" "$ts2"; then
    echo "true"
fi
echo

_header shlib::time_isbefore
ts1=1704067200 # Jan 1, 2024
ts2=1704153600 # Jan 2, 2024
_show shlib::time_isbefore "$ts1" "$ts2"
if shlib::time_isbefore "$ts1" "$ts2"; then
    echo "true"
fi
echo

_header shlib::time_now
_eval shlib::time_now
echo

_header shlib::time_nowiso
_eval shlib::time_nowiso
_eval shlib::time_nowiso local
echo

_header shlib::time_today
_eval shlib::time_today
echo

#######################################
# ui
#######################################

_header shlib::ui_ansi256palette
_run shlib::ui_ansi256palette
echo

_header shlib::ui_ansibgcolors
_run shlib::ui_ansibgcolors
echo

_header shlib::ui_ansicolormatrix
_run shlib::ui_ansicolormatrix
echo

_header shlib::ui_ansicolormatrix_bright
_run shlib::ui_ansicolormatrix_bright
echo

_header shlib::ui_ansifgcolors
_run shlib::ui_ansifgcolors
echo

_header shlib::ui_ansistyles
_run shlib::ui_ansistyles
echo

_header shlib::ui_banner
_run shlib::ui_banner "COSMOS"
echo

_header shlib::ui_banner_builtin
_run shlib::ui_banner_builtin "NOVA"
echo

_header shlib::ui_banner_figlet
if shlib::cmd_exists figlet; then
    _run shlib::ui_banner_figlet "PULSAR"
else
    echo "(figlet not installed, skipping)"
fi
echo

_header shlib::ui_banner_toilet
if shlib::cmd_exists toilet; then
    _run shlib::ui_banner_toilet "QUASAR" "" "gay"
else
    echo "(toilet not installed, skipping)"
fi
echo

_header shlib::ui_header
_run shlib::ui_header "Observation Log"
echo " <- no newline variant"
echo

_header shlib::ui_headern
_run shlib::ui_headern "Observation Log"
echo

_header shlib::ui_hr
_run shlib::ui_hrn
_run shlib::ui_hrn "Telemetry" 40 "="
echo

_header shlib::ui_hrn
_run shlib::ui_hrn "Session Start"
_run shlib::ui_hrn "" 50 "─"
echo

_header shlib::ui_spinner
_show shlib::ui_spinner "Processing star field" sleep 2
if shlib::ui_spinner "Processing star field" sleep 2; then
    shlib::msg_einfon "Processing complete"
fi
echo
# End of File
