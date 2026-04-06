# @description Print the library version
# @stdout The version string
# @exitcode 0 Always succeeds
shlib::version() {
    echo "${SHLIB_VERSION}"
}
