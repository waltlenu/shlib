# @description List all shlib functions
# @stdout One function name per line, sorted alphabetically
# @exitcode 0 Always succeeds
shlib::list_functions() {
    declare -F | while read -r _ _ name; do
        if [[ "$name" == shlib::* ]]; then
            echo "$name"
        fi
    done | sort
}
