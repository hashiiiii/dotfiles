#!/usr/bin/env zsh

readonly SUPPORTED_BASES=(2 8 10 16)
readonly DEFAULT_INPUT_BASE=10
readonly DEFAULT_OUTPUT_BASE=10

_num_show_help() {
    cat <<'EOF'
Usage: num [-i input_base] [-o output_base] <number>
Convert number between different bases (2, 8, 10, 16)
Options:
  -i <base>  Input base (default: 10, auto-detected from prefix)
  -o <base>  Output base (default: 10)
  -h         Show this help

Examples:
  num 170                 # Convert decimal 170 to decimal (shows: 170 (decimal → decimal))
  num -o 16 170           # Convert decimal 170 to hex (shows: 0xAA (decimal → hexadecimal))
  num -i 16 -o 10 AA      # Convert hex AA to decimal (shows: 170 (hexadecimal → decimal))
  num 0b10101010          # Auto-detect binary, convert to decimal (shows: 170 (binary → decimal))
  num -o 16 0b10101010    # Binary to hex (shows: 0xAA (binary → hexadecimal))
  num 0x280               # Auto-detect hex, convert to decimal (shows: 640 (hexadecimal → decimal))
EOF
}

_num_detect_base() {
    local number="$1"

    case "$number" in
        0[xX]*) echo 16 ;;
        0[bB]*) echo 2 ;;
        0[oO]*) echo 8 ;;
        *) echo "" ;;
    esac
}

_num_strip_prefix() {
    local number="$1"
    local base="$2"

    case "$base" in
        16) echo "${number#0[xX]}" ;;
        2)  echo "${number#0[bB]}" ;;
        8)  echo "${number#0[oO]}" ;;
        *)  echo "$number" ;;
    esac
}

_num_validate_base() {
    local base="$1"
    local base_name="$2"

    if [[ ! " ${SUPPORTED_BASES[@]} " =~ " ${base} " ]]; then
        echo "Error: $base_name base must be one of: ${SUPPORTED_BASES[*]}" >&2
        return 1
    fi
    return 0
}

_num_get_base_name() {
    local base="$1"
    case "$base" in
        2)  echo "binary" ;;
        8)  echo "octal" ;;
        10) echo "decimal" ;;
        16) echo "hexadecimal" ;;
    esac
}

_num_format_output() {
    local result="$1"
    local output_base="$2"

    case "$output_base" in
        2)  echo "0b$result" ;;
        8)  echo "0o$result" ;;
        16) echo "0x$result" ;;
        *)  echo "$result" ;;
    esac
}

_num_convert() {
    local number="$1"
    local input_base="$2"
    local output_base="$3"

    local bc_cmd="obase=$output_base; ibase=$input_base; $number"
    local result

    result=$(printf "%s\n" "$bc_cmd" | bc 2>/dev/null)

    if [[ $? -ne 0 ]] || [[ -z "$result" ]]; then
        echo "Error: Invalid number '$number' for base $input_base" >&2
        return 1
    fi

    echo "$result"
}

num() {
    local input_base=$DEFAULT_INPUT_BASE
    local output_base=$DEFAULT_OUTPUT_BASE
    local input_base_explicitly_set=false
    local OPTIND=1

    while getopts "i:o:h" opt; do
        case $opt in
            i)
                input_base="$OPTARG"
                input_base_explicitly_set=true
                ;;
            o)
                output_base="$OPTARG"
                ;;
            h)
                _num_show_help
                return 0
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    if [[ $# -eq 0 ]]; then
        echo "Usage: num [-i input_base] [-o output_base] <number>"
        echo "Use 'num -h' for detailed help"
        return 1
    fi

    local number="$1"
    local detected_base
    detected_base=$(_num_detect_base "$number")

    if [[ -n "$detected_base" ]]; then
        if [[ "$input_base_explicitly_set" = true ]] && [[ "$detected_base" != "$input_base" ]]; then
            echo "Error: Prefix indicates base $detected_base, but -i specifies base $input_base" >&2
            echo "Remove the prefix or use the correct -i option" >&2
            return 1
        fi

        if [[ "$input_base_explicitly_set" = false ]]; then
            input_base="$detected_base"
        fi

        number=$(_num_strip_prefix "$number" "$detected_base")
    fi

    _num_validate_base "$input_base" "Input" || return 1
    _num_validate_base "$output_base" "Output" || return 1

    number=$(echo "$number" | tr '[:lower:]' '[:upper:]')

    local result
    result=$(_num_convert "$number" "$input_base" "$output_base") || return 1

    local formatted_result
    formatted_result=$(_num_format_output "$result" "$output_base")

    local from_base_name=$(_num_get_base_name "$input_base")
    local to_base_name=$(_num_get_base_name "$output_base")

    echo "$formatted_result ($from_base_name → $to_base_name)"
}