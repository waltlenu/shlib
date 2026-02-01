#!/usr/bin/env bash
# shellcheck disable=SC2034

# changelog.sh - Generate changelog from git history
#
# Usage:
#   ./hack/changelog.sh                          # auto-detect tags, write to changelog.md
#   ./hack/changelog.sh v0.4.0 v0.3.0            # explicit current and previous tags
#   ./hack/changelog.sh --stdout                 # output to stdout
#   ./hack/changelog.sh v0.4.0 v0.3.0 --stdout   # explicit tags, output to stdout
#
# Environment:
#   GITHUB_REPOSITORY - Repository for comparison URL (e.g., "owner/repo")
#                       Falls back to git remote origin
#
# This script:
#   - Categorizes commits by conventional commit type (feat, fix, docs, etc.)
#   - Generates markdown changelog with sections per category
#   - Includes full changelog comparison URL

set -euo pipefail

# Parse arguments
current_tag=""
prev_tag=""
to_stdout=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --stdout)
            to_stdout=1
            shift
            ;;
        -h | --help)
            echo "Usage: $0 [current_tag] [prev_tag] [--stdout]" >&2
            echo "" >&2
            echo "Arguments:" >&2
            echo "  current_tag  Tag for this release (default: auto-detect)" >&2
            echo "  prev_tag     Previous tag for comparison (default: auto-detect)" >&2
            echo "  --stdout     Output to stdout instead of changelog.md" >&2
            exit 0
            ;;
        -*)
            echo "Error: Unknown option: $1" >&2
            echo "Usage: $0 [current_tag] [prev_tag] [--stdout]" >&2
            exit 1
            ;;
        *)
            if [[ -z "$current_tag" ]]; then
                current_tag="$1"
            elif [[ -z "$prev_tag" ]]; then
                prev_tag="$1"
            else
                echo "Error: Too many arguments" >&2
                echo "Usage: $0 [current_tag] [prev_tag] [--stdout]" >&2
                exit 1
            fi
            shift
            ;;
    esac
done

# Auto-detect current tag if not provided
if [[ -z "$current_tag" ]]; then
    current_tag=$(git describe --tags --abbrev=0 HEAD 2>/dev/null || echo "")
    if [[ -z "$current_tag" ]]; then
        echo "Error: No tags found and no current_tag specified" >&2
        exit 1
    fi
fi

# Auto-detect previous tag if not provided
if [[ -z "$prev_tag" ]]; then
    prev_tag=$(git describe --tags --abbrev=0 "${current_tag}^" 2>/dev/null || echo "")
fi

# Get repository URL for comparison link
if [[ -n "${GITHUB_REPOSITORY:-}" ]]; then
    repo_url="https://github.com/${GITHUB_REPOSITORY}"
else
    # Try to extract from git remote
    remote_url=$(git remote get-url origin 2>/dev/null || echo "")
    if [[ "$remote_url" == *"github.com"* ]]; then
        # Handle both HTTPS and SSH URLs
        repo_url=$(echo "$remote_url" | sed 's|git@github.com:|https://github.com/|' | sed 's|\.git$||')
    else
        repo_url=""
    fi
fi

# Determine commit range
if [[ -n "$prev_tag" ]]; then
    range="${prev_tag}..${current_tag}"
else
    range="$current_tag"
fi

# Function to get commits matching a pattern
get_commits() {
    local pattern="$1"
    local result
    result=$(git log "$range" --pretty=format:"- %s" --grep="^${pattern}" 2>/dev/null || true)
    echo "$result"
}

# Function to clean commit prefix
clean_prefix() {
    local pattern="$1"
    # Remove "type:" or "type(scope):" prefix
    # Pattern handles both "feat: msg" and "feat(scope): msg"
    sed "s/^- ${pattern}[^:]*: /- /"
}

# Generate changelog content
generate_changelog() {
    echo "## What's Changed"
    echo ""

    # Features (feat:)
    local features
    features=$(get_commits "feat")
    if [[ -n "$features" ]]; then
        echo "### Features"
        echo ""
        echo "$features" | clean_prefix "feat"
        echo ""
    fi

    # Bug fixes (fix:)
    local fixes
    fixes=$(get_commits "fix")
    if [[ -n "$fixes" ]]; then
        echo "### Bug Fixes"
        echo ""
        echo "$fixes" | clean_prefix "fix"
        echo ""
    fi

    # Documentation (docs:)
    local docs
    docs=$(get_commits "docs")
    if [[ -n "$docs" ]]; then
        echo "### Documentation"
        echo ""
        echo "$docs" | clean_prefix "docs"
        echo ""
    fi

    # Refactoring (refactor:)
    local refactor
    refactor=$(get_commits "refactor")
    if [[ -n "$refactor" ]]; then
        echo "### Refactoring"
        echo ""
        echo "$refactor" | clean_prefix "refactor"
        echo ""
    fi

    # Tests (test:)
    local tests
    tests=$(get_commits "test")
    if [[ -n "$tests" ]]; then
        echo "### Tests"
        echo ""
        echo "$tests" | clean_prefix "test"
        echo ""
    fi

    # Chores (chore:)
    local chores
    chores=$(get_commits "chore")
    if [[ -n "$chores" ]]; then
        echo "### Chores"
        echo ""
        echo "$chores" | clean_prefix "chore"
        echo ""
    fi

    # Other changes (everything else)
    local other
    other=$(git log "$range" --pretty=format:"- %s" \
        --invert-grep \
        --grep="^feat" \
        --grep="^fix" \
        --grep="^docs" \
        --grep="^refactor" \
        --grep="^test" \
        --grep="^chore" 2>/dev/null || true)
    if [[ -n "$other" ]]; then
        echo "### Other Changes"
        echo ""
        echo "$other"
        echo ""
    fi

    echo "---"
    echo ""

    # Full changelog link
    if [[ -n "$repo_url" ]]; then
        local compare_base
        if [[ -n "$prev_tag" ]]; then
            compare_base="$prev_tag"
        else
            compare_base=$(git rev-list --max-parents=0 HEAD 2>/dev/null | head -1)
        fi
        echo "**Full Changelog**: ${repo_url}/compare/${compare_base}...${current_tag}"
    fi
}

# Output changelog
if [[ $to_stdout -eq 1 ]]; then
    generate_changelog
else
    generate_changelog >changelog.md
    echo "Generated changelog.md for ${current_tag}"
fi
