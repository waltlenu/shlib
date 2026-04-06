# @description List all shlib global variables
# @stdout One variable name per line, sorted alphabetically
# @exitcode 0 Always succeeds
shlib::list_variables() {
    compgen -v | while read -r name; do
        if [[ "$name" == SHLIB_* ]]; then
            echo "$name"
        fi
    done | sort
}
