#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2001

# sort-bats-tests.sh - Sort @test blocks alphabetically within bats test files
#
# Usage:
#   ./scripts/sort-bats-tests.sh tests/strings.bats           # output to stdout
#   ./scripts/sort-bats-tests.sh tests/strings.bats > out.bats # redirect to file
#
# This script preserves:
#   - File header (shebang, shellcheck directives, comments)
#   - setup() function block
#   - Test block structure and content
#
# Tests are sorted case-insensitively by their test name.

set -euo pipefail

# Check arguments
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <file.bats>" >&2
    exit 1
fi

input_file="$1"

if [[ ! -f "$input_file" ]]; then
    echo "Error: File not found: $input_file" >&2
    exit 1
fi

# Create temp directory for test blocks
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# Read file into array using while loop (Bash 3 compatible)
line_count=0
while IFS= read -r line || [[ -n "$line" ]]; do
    lines[line_count]="$line"
    line_count=$((line_count + 1))
done <"$input_file"

# Find header end - everything up through the end of setup() function
# Header includes: shebang, shellcheck, comments, blank lines, and setup() block
header_end=0
in_setup=0
setup_brace_depth=0

for ((i = 0; i < line_count; i++)); do
    line="${lines[i]}"

    # Check for start of setup() function
    if [[ "$line" == "setup()"* ]]; then
        in_setup=1
        # Count opening braces on this line
        opening=$(echo "$line" | tr -cd '{' | wc -c)
        closing=$(echo "$line" | tr -cd '}' | wc -c)
        setup_brace_depth=$((opening - closing))

        # If setup is on single line with braces balanced, we're done
        if [[ $setup_brace_depth -eq 0 && $opening -gt 0 ]]; then
            header_end=$((i + 1))
            break
        fi
        continue
    fi

    if [[ $in_setup -eq 1 ]]; then
        # Track brace depth within setup()
        opening=$(echo "$line" | tr -cd '{' | wc -c)
        closing=$(echo "$line" | tr -cd '}' | wc -c)
        setup_brace_depth=$((setup_brace_depth + opening - closing))

        # Check if setup() ended
        if [[ $setup_brace_depth -eq 0 ]]; then
            header_end=$((i + 1))
            break
        fi
    fi
done

# Output header
for ((i = 0; i < header_end; i++)); do
    echo "${lines[i]}"
done

# Parse test blocks
current_line=$header_end
test_count=0
in_test=0
test_block=""
test_name=""
brace_depth=0

# Skip any blank lines after header
while [[ $current_line -lt $line_count && -z "${lines[current_line]}" ]]; do
    current_line=$((current_line + 1))
done

while [[ $current_line -lt $line_count ]]; do
    line="${lines[current_line]}"

    if [[ $in_test -eq 0 ]]; then
        # Look for start of @test block
        if [[ "$line" == "@test "* ]]; then
            in_test=1
            test_block="$line"
            brace_depth=0

            # Extract test name from @test "name" {
            # The name is between the first pair of quotes
            test_name=$(echo "$line" | sed 's/^@test "\([^"]*\)".*/\1/')

            # Count opening braces
            opening=$(echo "$line" | tr -cd '{' | wc -c)
            closing=$(echo "$line" | tr -cd '}' | wc -c)
            brace_depth=$((opening - closing))
        fi
    else
        # Continue collecting test block
        test_block="$test_block"$'\n'"$line"

        # Track brace depth
        opening=$(echo "$line" | tr -cd '{' | wc -c)
        closing=$(echo "$line" | tr -cd '}' | wc -c)
        brace_depth=$((brace_depth + opening - closing))

        # Check if test ended (closing brace at depth 0)
        if [[ "$line" == "}" && $brace_depth -eq 0 ]]; then
            # Sanitize test name for filename (replace special chars with underscores)
            safe_name=$(echo "$test_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g')

            # Save test block to temp file
            echo "$test_block" >"$tmpdir/test_${safe_name}_${test_count}"
            test_count=$((test_count + 1))

            in_test=0
            test_block=""
            test_name=""
            brace_depth=0
        fi
    fi

    current_line=$((current_line + 1))
done

# Get all test files, sort them, and output
test_files=()
i=0
for f in "$tmpdir"/test_*; do
    if [[ -f "$f" ]]; then
        test_files[i]="$f"
        i=$((i + 1))
    fi
done

if [[ ${#test_files[@]} -gt 0 ]]; then
    # Sort test files by filename (which includes lowercase test name)
    sorted_files=$(printf '%s\n' "${test_files[@]}" | sort)

    first=1
    while IFS= read -r f; do
        if [[ -f "$f" ]]; then
            if [[ $first -eq 1 ]]; then
                echo "" # Blank line after header
                first=0
            else
                echo "" # Blank line between tests
            fi
            cat "$f"
        fi
    done <<<"$sorted_files"
fi
