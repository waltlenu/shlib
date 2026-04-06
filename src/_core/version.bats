@test "shlib::version format matches semver pattern" {
    run shlib::version
    # Match X.Y.Z pattern
    [[ "$output" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

@test "shlib::version outputs version string" {
    ver="$(shlib::version)"
    [[ "${ver}" == "${SHLIB_VERSION}" ]]
}
