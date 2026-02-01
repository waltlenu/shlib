#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2001

# sort-functions.sh - Sort functions alphabetically within sections
#
# Usage:
#   ./hack/sort-functions.sh shlib.sh           # sort in place (default)
#   ./hack/sort-functions.sh shlib.sh --stdout  # output to stdout
#
# This script preserves:
#   - File header (shebang, license, strict mode, global variables)
#   - Section structure (#\n# Section Name\n#)
#   - Function comments and bodies
#
# Functions are sorted case-insensitively within each section.

set -euo pipefail

# Check arguments
if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: $0 <file.sh> [--stdout]" >&2
    exit 1
fi

input_file="$1"
to_stdout=0

if [[ $# -eq 2 ]]; then
    if [[ "$2" == "--stdout" ]]; then
        to_stdout=1
    else
        echo "Error: Unknown option: $2" >&2
        echo "Usage: $0 <file.sh> [--stdout]" >&2
        exit 1
    fi
fi

if [[ ! -f "$input_file" ]]; then
    echo "Error: File not found: $input_file" >&2
    exit 1
fi

# Function to sort and output functions in a section
sort_and_output_functions() {
    local section_dir="$1"

    # Output section header
    if [[ -f "$section_dir/header" ]]; then
        cat "$section_dir/header"
        echo "" # Blank line after header
    fi

    # Output globals if any (for Global variables section)
    # Strip trailing blank lines to avoid double blank lines before next section
    if [[ -f "$section_dir/globals" ]]; then
        # Remove trailing blank lines using awk
        awk '/^$/{blank++; next} {for(i=0;i<blank;i++)print ""; blank=0; print}' "$section_dir/globals"
    fi

    # Get all function files, sort them, and output
    local func_files=()
    local i=0
    for f in "$section_dir"/func_*; do
        if [[ -f "$f" ]]; then
            func_files[i]="$f"
            i=$((i + 1))
        fi
    done

    if [[ ${#func_files[@]} -gt 0 ]]; then
        # Sort function files by filename (which includes lowercase function name)
        local sorted_files
        sorted_files=$(printf '%s\n' "${func_files[@]}" | sort)

        local first=1
        while IFS= read -r f; do
            if [[ -f "$f" ]]; then
                if [[ $first -eq 1 ]]; then
                    first=0
                else
                    echo "" # Blank line between functions
                fi
                cat "$f"
            fi
        done <<<"$sorted_files"
    fi
}

# Create temp directory for function blocks
tmpdir=$(mktemp -d)
output_file="$tmpdir/output"
trap 'rm -rf "$tmpdir"' EXIT

# Start output capture (all echo/cat will go to output_file)
exec 3>&1
exec >"$output_file"

# Read file into array using while loop (Bash 3 compatible)
line_count=0
while IFS= read -r line || [[ -n "$line" ]]; do
    lines[line_count]="$line"
    line_count=$((line_count + 1))
done <"$input_file"

# Find header end (line before first section marker)
# Section marker pattern: '#' alone, followed by '# SectionName', followed by '#'
header_end=0
for ((i = 0; i < line_count - 2; i++)); do
    if [[ "${lines[i]}" == "#" && "${lines[i + 1]}" == "# "* && "${lines[i + 2]}" == "#" ]]; then
        # Check if line i+1 is a section header (starts with "# " and has uppercase letter)
        section_line="${lines[i + 1]}"
        if [[ "$section_line" =~ ^#\ [A-Z] ]]; then
            header_end=$i
            break
        fi
    fi
done

# Output header
for ((i = 0; i < header_end; i++)); do
    echo "${lines[i]}"
done

# Parse sections and functions
current_line=$header_end
section_count=0
func_count=0
in_function=0
func_block=""
func_name=""
brace_depth=0
seen_func_in_section=0

while [[ $current_line -lt $line_count ]]; do
    line="${lines[current_line]}"

    # Check for section header (3-line pattern: #, # Name, #)
    if [[ "$line" == "#" && $((current_line + 2)) -lt $line_count ]]; then
        next1="${lines[current_line + 1]}"
        next2="${lines[current_line + 2]}"

        if [[ "$next1" == "# "* && "$next2" == "#" ]]; then
            # Check if this is a section header (uppercase letter after "# ")
            if [[ "$next1" =~ ^#\ [A-Z] ]]; then
                # Found section header - output previous section's sorted functions first
                if [[ $section_count -gt 0 ]]; then
                    sort_and_output_functions "$tmpdir/section_$((section_count - 1))"
                    echo "" # Blank line between sections
                fi

                # Start new section
                section_dir="$tmpdir/section_$section_count"
                mkdir -p "$section_dir"

                # Store section header
                {
                    echo "${lines[current_line]}"
                    echo "${lines[current_line + 1]}"
                    echo "${lines[current_line + 2]}"
                } >"$section_dir/header"

                current_line=$((current_line + 3))
                section_count=$((section_count + 1))
                func_count=0
                in_function=0
                func_block=""
                func_name=""
                brace_depth=0
                seen_func_in_section=0

                # Skip blank line after section header if present
                if [[ $current_line -lt $line_count && -z "${lines[current_line]}" ]]; then
                    current_line=$((current_line + 1))
                fi

                continue
            fi
        fi
    fi

    # We're inside a section - collect function blocks
    if [[ $section_count -gt 0 ]]; then
        section_dir="$tmpdir/section_$((section_count - 1))"

        if [[ $in_function -eq 0 ]]; then
            # Look for start of function (comment block or function declaration)
            if [[ "$line" == "# @description"* || "$line" == "shlib::"*"()"* ]]; then
                in_function=1
                seen_func_in_section=1
                func_block="$line"
                brace_depth=0

                # If this is the function declaration line, extract name and count braces
                if [[ "$line" == "shlib::"*"()"* ]]; then
                    func_name=$(echo "$line" | sed 's/shlib::\([^(]*\)().*/\1/')
                    # Count opening braces
                    opening=$(echo "$line" | tr -cd '{' | wc -c)
                    closing=$(echo "$line" | tr -cd '}' | wc -c)
                    brace_depth=$((opening - closing))
                fi
            elif [[ $seen_func_in_section -eq 0 ]]; then
                # Line outside function, before any functions (global var section)
                # Preserve blank lines too
                echo "$line" >>"$section_dir/globals"
            fi
        else
            # Continue collecting function block
            func_block="$func_block"$'\n'"$line"

            # If we haven't found function name yet, look for it
            if [[ -z "$func_name" && "$line" == "shlib::"*"()"* ]]; then
                func_name=$(echo "$line" | sed 's/shlib::\([^(]*\)().*/\1/')
            fi

            # Track brace depth
            opening=$(echo "$line" | tr -cd '{' | wc -c)
            closing=$(echo "$line" | tr -cd '}' | wc -c)
            brace_depth=$((brace_depth + opening - closing))

            # Check if function ended (lone closing brace at depth 0)
            if [[ "$line" == "}" && $brace_depth -eq 0 ]]; then
                # Save function block
                if [[ -n "$func_name" ]]; then
                    # Use lowercase name for sorting (Bash 3 compatible)
                    lower_name=$(echo "$func_name" | tr '[:upper:]' '[:lower:]')
                    echo "$func_block" >"$section_dir/func_${lower_name}_$func_count"
                    func_count=$((func_count + 1))
                fi
                in_function=0
                func_block=""
                func_name=""
                brace_depth=0
            fi
        fi
    fi

    current_line=$((current_line + 1))
done

# Output last section
if [[ $section_count -gt 0 ]]; then
    sort_and_output_functions "$tmpdir/section_$((section_count - 1))"
fi

# Restore stdout and handle output
exec 1>&3
exec 3>&-

if [[ $to_stdout -eq 1 ]]; then
    cat "$output_file"
else
    cp "$output_file" "$input_file"
fi
