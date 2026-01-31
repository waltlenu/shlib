#!/usr/bin/env bats
# shellcheck disable=SC2030,SC2031,SC2034

# ShellCheck Exclusions:
# - https://www.shellcheck.net/wiki/SC2030
# - https://www.shellcheck.net/wiki/SC2031
# - https://www.shellcheck.net/wiki/SC2034

setup() {
    load 'test_helper'
}

@test "shlib::kv_set sets a key-value pair" {
    declare -A kv
    shlib::kv_set kv "host" "localhost"
    [[ "${kv[host]}" == "localhost" ]]
}

@test "shlib::kv_set overwrites existing key" {
    declare -A kv
    kv[host]="old"
    shlib::kv_set kv "host" "new"
    [[ "${kv[host]}" == "new" ]]
}

@test "shlib::kv_set handles value with spaces" {
    declare -A kv
    shlib::kv_set kv "message" "hello world"
    [[ "${kv[message]}" == "hello world" ]]
}

@test "shlib::kv_set handles key with special characters" {
    declare -A kv
    shlib::kv_set kv "my-key_1" "value"
    [[ "${kv['my-key_1']}" == "value" ]]
}

@test "shlib::kv_set handles empty value" {
    declare -A kv
    shlib::kv_set kv "key" ""
    [[ "${kv[key]}" == "" ]]
    [[ -n "${kv[key]+exists}" ]]
}

@test "shlib::kv_get retrieves existing key" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_get kv "host"
    [[ "${status}" -eq 0 ]]
    [[ "${output}" == "localhost" ]]
}

@test "shlib::kv_get returns 1 for missing key" {
    declare -A kv
    run shlib::kv_get kv "missing"
    [[ "${status}" -eq 1 ]]
    [[ "${output}" == "" ]]
}

@test "shlib::kv_get handles value with spaces" {
    declare -A kv
    kv[message]="hello world"
    run shlib::kv_get kv "message"
    [[ "${output}" == "hello world" ]]
}

@test "shlib::kv_get handles empty value" {
    declare -A kv
    kv[empty]=""
    run shlib::kv_get kv "empty"
    [[ "${status}" -eq 0 ]]
    [[ "${output}" == "" ]]
}

@test "shlib::kv_get_default returns value when key exists" {
    declare -A kv
    kv[port]="3000"
    run shlib::kv_get_default kv "port" "8080"
    [[ "${output}" == "3000" ]]
}

@test "shlib::kv_get_default returns default when key missing" {
    declare -A kv
    run shlib::kv_get_default kv "port" "8080"
    [[ "${output}" == "8080" ]]
}

@test "shlib::kv_get_default returns empty value over default" {
    declare -A kv
    kv[empty]=""
    run shlib::kv_get_default kv "empty" "default"
    [[ "${output}" == "" ]]
}

@test "shlib::kv_get_default handles default with spaces" {
    declare -A kv
    run shlib::kv_get_default kv "missing" "hello world"
    [[ "${output}" == "hello world" ]]
}

@test "shlib::kv_delete removes a key" {
    declare -A kv
    kv[host]="localhost"
    kv[port]="8080"
    shlib::kv_delete kv "host"
    [[ -z "${kv[host]+exists}" ]]
    [[ "${kv[port]}" == "8080" ]]
}

@test "shlib::kv_delete handles missing key" {
    declare -A kv
    kv[host]="localhost"
    shlib::kv_delete kv "missing"
    [[ "${kv[host]}" == "localhost" ]]
}

@test "shlib::kv_delete on empty array" {
    declare -A kv=()
    shlib::kv_delete kv "key"
    [[ ${#kv[@]} -eq 0 ]]
}

@test "shlib::kv_exists returns 0 when key exists" {
    declare -A kv
    kv[host]="localhost"
    shlib::kv_exists kv "host"
}

@test "shlib::kv_exists returns 1 when key missing" {
    declare -A kv
    run shlib::kv_exists kv "missing"
    [[ "${status}" -eq 1 ]]
}

@test "shlib::kv_exists returns 0 for key with empty value" {
    declare -A kv
    kv[empty]=""
    shlib::kv_exists kv "empty"
}

@test "shlib::kv_exists on empty array" {
    declare -A kv
    run shlib::kv_exists kv "key"
    [[ "${status}" -eq 1 ]]
}

@test "shlib::kv_clear removes all entries" {
    declare -A kv
    kv[host]="localhost"
    kv[port]="8080"
    shlib::kv_clear kv
    [[ ${#kv[@]} -eq 0 ]]
}

@test "shlib::kv_clear on empty array" {
    declare -A kv
    shlib::kv_clear kv
    [[ ${#kv[@]} -eq 0 ]]
}

@test "shlib::kv_len returns correct count" {
    declare -A kv
    kv[a]="1"
    kv[b]="2"
    kv[c]="3"
    run shlib::kv_len kv
    [[ "${output}" == "3" ]]
}

@test "shlib::kv_len returns 0 for empty array" {
    declare -A kv=()
    run shlib::kv_len kv
    [[ "${output}" == "0" ]]
}

@test "shlib::kv_len returns 1 for single entry" {
    declare -A kv
    kv[only]="one"
    run shlib::kv_len kv
    [[ "${output}" == "1" ]]
}

@test "shlib::kv_keys extracts all keys" {
    declare -A kv
    kv[host]="localhost"
    kv[port]="8080"
    local -a keys
    shlib::kv_keys keys kv
    [[ ${#keys[@]} -eq 2 ]]
    # Keys may be in any order, check both exist
    local found_host=0 found_port=0
    for k in "${keys[@]}"; do
        [[ "$k" == "host" ]] && found_host=1
        [[ "$k" == "port" ]] && found_port=1
    done
    [[ $found_host -eq 1 ]]
    [[ $found_port -eq 1 ]]
}

@test "shlib::kv_keys handles empty array" {
    declare -A kv
    local -a keys
    shlib::kv_keys keys kv
    [[ ${#keys[@]} -eq 0 ]]
}

@test "shlib::kv_keys handles single entry" {
    declare -A kv
    kv[only]="value"
    local -a keys
    shlib::kv_keys keys kv
    [[ ${#keys[@]} -eq 1 ]]
    [[ "${keys[0]}" == "only" ]]
}

@test "shlib::kv_values extracts all values" {
    declare -A kv
    kv[a]="one"
    kv[b]="two"
    local -a values
    shlib::kv_values values kv
    [[ ${#values[@]} -eq 2 ]]
    local found_one=0 found_two=0
    for v in "${values[@]}"; do
        [[ "$v" == "one" ]] && found_one=1
        [[ "$v" == "two" ]] && found_two=1
    done
    [[ $found_one -eq 1 ]]
    [[ $found_two -eq 1 ]]
}

@test "shlib::kv_values handles empty array" {
    declare -A kv
    local -a values
    shlib::kv_values values kv
    [[ ${#values[@]} -eq 0 ]]
}

@test "shlib::kv_values handles values with spaces" {
    declare -A kv
    kv[msg]="hello world"
    local -a values
    shlib::kv_values values kv
    [[ ${#values[@]} -eq 1 ]]
    [[ "${values[0]}" == "hello world" ]]
}

@test "shlib::kv_print with default separators" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_print kv
    [[ "${output}" == "host=localhost" ]]
}

@test "shlib::kv_print with custom separators" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_print kv ":" ", "
    [[ "${output}" == "host:localhost" ]]
}

@test "shlib::kv_print handles empty array" {
    declare -A kv
    run shlib::kv_print kv
    [[ "${output}" == "" ]]
}

@test "shlib::kv_print handles multiple entries" {
    declare -A kv
    kv[a]="1"
    kv[b]="2"
    run shlib::kv_print kv "=" ", "
    # Output contains both, order may vary
    [[ "${output}" == *"a=1"* ]]
    [[ "${output}" == *"b=2"* ]]
}

@test "shlib::kv_printn prints one pair per line" {
    declare -A kv
    kv[host]="localhost"
    kv[port]="8080"
    run shlib::kv_printn kv
    [[ "${#lines[@]}" -eq 2 ]]
}

@test "shlib::kv_printn with custom separator" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_printn kv ":"
    [[ "${output}" == "host:localhost" ]]
}

@test "shlib::kv_printn handles empty array" {
    declare -A kv
    run shlib::kv_printn kv
    [[ "${output}" == "" ]]
}

@test "shlib::kv_has_value returns 0 when value exists" {
    declare -A kv
    kv[host]="localhost"
    shlib::kv_has_value kv "localhost"
}

@test "shlib::kv_has_value returns 1 when value missing" {
    declare -A kv
    kv[host]="localhost"
    run shlib::kv_has_value kv "missing"
    [[ "${status}" -eq 1 ]]
}

@test "shlib::kv_has_value handles empty array" {
    declare -A kv
    run shlib::kv_has_value kv "value"
    [[ "${status}" -eq 1 ]]
}

@test "shlib::kv_has_value finds empty string value" {
    declare -A kv
    kv[empty]=""
    shlib::kv_has_value kv ""
}

@test "shlib::kv_has_value handles duplicate values" {
    declare -A kv
    kv[a]="same"
    kv[b]="same"
    shlib::kv_has_value kv "same"
}

@test "shlib::kv_find returns keys with matching value" {
    declare -A roles
    roles[alice]="admin"
    roles[bob]="user"
    roles[carol]="admin"
    local -a result
    shlib::kv_find result roles "admin"
    [[ ${#result[@]} -eq 2 ]]
    local found_alice=0 found_carol=0
    for k in "${result[@]}"; do
        [[ "$k" == "alice" ]] && found_alice=1
        [[ "$k" == "carol" ]] && found_carol=1
    done
    [[ $found_alice -eq 1 ]]
    [[ $found_carol -eq 1 ]]
}

@test "shlib::kv_find returns empty when no match" {
    declare -A kv
    kv[a]="1"
    kv[b]="2"
    local -a result
    shlib::kv_find result kv "missing"
    [[ ${#result[@]} -eq 0 ]]
}

@test "shlib::kv_find handles empty array" {
    declare -A kv
    local -a result
    shlib::kv_find result kv "value"
    [[ ${#result[@]} -eq 0 ]]
}

@test "shlib::kv_find returns single match" {
    declare -A kv
    kv[a]="unique"
    kv[b]="other"
    local -a result
    shlib::kv_find result kv "unique"
    [[ ${#result[@]} -eq 1 ]]
    [[ "${result[0]}" == "a" ]]
}

@test "shlib::kv_copy copies all entries" {
    declare -A src
    src[host]="localhost"
    src[port]="8080"
    declare -A dest
    shlib::kv_copy dest src
    [[ ${#dest[@]} -eq 2 ]]
    [[ "${dest[host]}" == "localhost" ]]
    [[ "${dest[port]}" == "8080" ]]
}

@test "shlib::kv_copy overwrites destination" {
    declare -A src
    src[new]="value"
    declare -A dest
    dest[old]="data"
    shlib::kv_copy dest src
    [[ ${#dest[@]} -eq 1 ]]
    [[ "${dest[new]}" == "value" ]]
    [[ -z "${dest[old]+exists}" ]]
}

@test "shlib::kv_copy handles empty source" {
    declare -A src
    declare -A dest
    dest[old]="data"
    shlib::kv_copy dest src
    [[ ${#dest[@]} -eq 0 ]]
}

@test "shlib::kv_copy handles values with spaces" {
    declare -A src
    src[msg]="hello world"
    declare -A dest
    shlib::kv_copy dest src
    [[ "${dest[msg]}" == "hello world" ]]
}

@test "shlib::kv_merge combines multiple arrays" {
    declare -A a
    a[x]="1"
    declare -A b
    b[y]="2"
    declare -A c
    c[z]="3"
    declare -A result
    shlib::kv_merge result a b c
    [[ ${#result[@]} -eq 3 ]]
    [[ "${result[x]}" == "1" ]]
    [[ "${result[y]}" == "2" ]]
    [[ "${result[z]}" == "3" ]]
}

@test "shlib::kv_merge later arrays override earlier" {
    declare -A defaults
    defaults[host]="localhost"
    defaults[port]="80"
    declare -A overrides
    overrides[port]="8080"
    declare -A result
    shlib::kv_merge result defaults overrides
    [[ ${#result[@]} -eq 2 ]]
    [[ "${result[host]}" == "localhost" ]]
    [[ "${result[port]}" == "8080" ]]
}

@test "shlib::kv_merge handles empty arrays" {
    declare -A a
    a[x]="1"
    declare -A empty
    declare -A b
    b[y]="2"
    declare -A result
    shlib::kv_merge result a empty b
    [[ ${#result[@]} -eq 2 ]]
    [[ "${result[x]}" == "1" ]]
    [[ "${result[y]}" == "2" ]]
}

@test "shlib::kv_merge with single source" {
    declare -A src
    src[key]="value"
    declare -A result
    shlib::kv_merge result src
    [[ ${#result[@]} -eq 1 ]]
    [[ "${result[key]}" == "value" ]]
}

@test "shlib::kv_merge with no sources" {
    declare -A result
    shlib::kv_merge result
    [[ ${#result[@]} -eq 0 ]]
}

@test "shlib::kv_map transforms all values" {
    declare -A kv
    kv[name]="hello"
    kv[greeting]="world"
    shlib::kv_map kv 'tr a-z A-Z'
    [[ "${kv[name]}" == "HELLO" ]]
    [[ "${kv[greeting]}" == "WORLD" ]]
}

@test "shlib::kv_map handles empty array" {
    declare -A kv=()
    shlib::kv_map kv 'tr a-z A-Z'
    [[ ${#kv[@]} -eq 0 ]]
}

@test "shlib::kv_map with simple echo" {
    declare -A kv
    kv[a]="test"
    shlib::kv_map kv 'cat'
    [[ "${kv[a]}" == "test" ]]
}

@test "shlib::kv_map with sed replacement" {
    declare -A kv
    kv[path]="/old/path"
    shlib::kv_map kv "sed 's/old/new/'"
    [[ "${kv[path]}" == "/new/path" ]]
}

@test "shlib::kv_set with numeric key" {
    declare -A kv
    shlib::kv_set kv "123" "numeric key"
    [[ "${kv[123]}" == "numeric key" ]]
}

@test "shlib::kv_get with numeric key" {
    declare -A kv
    kv[123]="numeric value"
    run shlib::kv_get kv "123"
    [[ "${output}" == "numeric value" ]]
}

@test "shlib::kv_set handles value with quotes" {
    declare -A kv
    shlib::kv_set kv "msg" 'hello "world"'
    [[ "${kv[msg]}" == 'hello "world"' ]]
}

@test "shlib::kv_set handles value with backslash" {
    declare -A kv
    shlib::kv_set kv "path" 'C:\Users\test'
    [[ "${kv[path]}" == 'C:\Users\test' ]]
}

@test "shlib::kv_find searching for empty string value" {
    declare -A kv
    kv[empty1]=""
    kv[empty2]=""
    kv[filled]="value"
    local -a result
    shlib::kv_find result kv ""
    [[ ${#result[@]} -eq 2 ]]
}

@test "shlib::kv_map preserves keys when transforming values" {
    declare -A kv
    kv[key1]="value1"
    kv[key2]="value2"
    shlib::kv_map kv 'tr a-z A-Z'
    [[ -n "${kv[key1]+exists}" ]]
    [[ -n "${kv[key2]+exists}" ]]
    [[ "${kv[key1]}" == "VALUE1" ]]
    [[ "${kv[key2]}" == "VALUE2" ]]
}

@test "shlib::kv_set handles key with underscore and hyphen" {
    declare -A kv
    shlib::kv_set kv "my_key-name" "value"
    [[ "${kv['my_key-name']}" == "value" ]]
}

@test "shlib::kv_has_value with value containing special chars" {
    declare -A kv
    kv[special]='value*with[chars]'
    shlib::kv_has_value kv 'value*with[chars]'
}

@test "shlib::kv_merge with overlapping keys" {
    declare -A a
    a[x]="original"
    a[y]="keep"
    declare -A b
    b[x]="override"
    declare -A result
    shlib::kv_merge result a b
    [[ "${result[x]}" == "override" ]]
    [[ "${result[y]}" == "keep" ]]
}

@test "shlib::kv_copy handles values with newlines" {
    declare -A src
    src[multi]=$'line1\nline2'
    declare -A dest
    shlib::kv_copy dest src
    [[ "${dest[multi]}" == $'line1\nline2' ]]
}
