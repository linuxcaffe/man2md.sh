#!/bin/bash

# Check if a manpage file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input_manpage> <output_markdown>"
    exit 1
fi

# Input and output files
INPUT_FILE="$1"
OUTPUT_FILE="$2"

# Ensure the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File $INPUT_FILE not found"
    exit 1
fi

# Decompress if it's a gzipped file
if [[ "$INPUT_FILE" == *.gz ]]; then
    INPUT_CONTENT=$(zcat "$INPUT_FILE")
else
    INPUT_CONTENT=$(cat "$INPUT_FILE")
fi

# Convert the manpage to markdown
convert_manpage() {
    local content="$1"
    
    echo "$content" | sed -e '/^\.\\"/d' \
        | sed -e 's/^\.TH \([^ ]*\) \([0-9]\) \(.*\)$/# \1(\2) - \3/g' \
        | sed -e 's/^\.SH \(.*\)$/## \1/g' \
        | sed -e 's/^\.SS \(.*\)$/### \1/g' \
        | sed -e 's/^\.B \(.*\)$/**\1**/g' \
        | sed -e 's/^\.I \(.*\)$/*\1*/g' \
        | sed -e '/^\.RS$/,/^\.RE$/ {
            s/^\.RS$/```/
            s/^\.RE$/```/
            s/^\.B \(.*\)$/**\1**/g
            s/^\.I \(.*\)$/*\1*/g
        }' \
        | sed -e 's/^\.TP$/- /g' \
        | sed -e 's/^\.BR \([^ ]*\) (\([0-9]\))$/`\1`(\2)/g' \
        | sed -e '/^\.br$/d' \
        | sed -e '/^\.RS$/d' \
        | sed -e '/^\.RE$/d' \
        | sed -e 's/^\.PP$/\n/g'
}

# Convert and save to output file
convert_manpage "$INPUT_CONTENT" > "$OUTPUT_FILE"

echo "Converted $INPUT_FILE to $OUTPUT_FILE"
