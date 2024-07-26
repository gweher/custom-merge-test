#!/bin/sh

# Arguments:
# $1: path
# $2: base file (common ancestor)
# $3: current file (target branch, e.g., master)
# $4: other branch file (e.g., dev)

# Function to merge common.py, preserving TARGET_SCHEMA_NAME
merge_common_py() {
    # Extract TARGET_SCHEMA_NAME from the current file (target branch)
    grep -E '^TARGET_SCHEMA_NAME' "$3" > current_target_schema.py
    # Remove TARGET_SCHEMA_NAME from the other branch file
    grep -vE '^TARGET_SCHEMA_NAME' "$4" > merged_content.py
    # Merge contents, preserving TARGET_SCHEMA_NAME from the current file
    cat current_target_schema.py merged_content.py > "$3"
    rm current_target_schema.py merged_content.py
}

# Function to merge pyproject.toml, preserving version
merge_pyproject_toml() {
    # Extract version from the current file (target branch)
    grep -E '^version' "$3" > current_version.txt
    # Remove version from the other branch file
    grep -vE '^version' "$4" > merged_content.txt
    # Merge contents, preserving version from the current file
    cat current_version.txt merged_content.txt > "$3"
    rm current_version.txt merged_content.txt
}

# Function to merge pipelines_config.yaml, preserving target_schema
merge_pipelines_config_yaml() {
    # Extract the target_schema from the current file
    grep -E '^\s*target_schema' "$3" > current_target_schema.yaml
    # Remove the target_schema from the other branch file
    grep -vE '^\s*target_schema' "$4" > merged_content.yaml
    # Merge the content, preserving target_schema
    awk 'BEGIN {print_preserved=1} 
        /target_schema:/ {print_preserved=0} 
        {if (print_preserved) print; else if (/general:/) {print; print_preserved=1}}' "$3" > temp.yaml
    cat current_target_schema.yaml merged_content.yaml >> temp.yaml
    mv temp.yaml "$3"
    rm current_target_schema.yaml merged_content.yaml
}

# Specify the files to merge and call function
case "$1" in
    "new_to_card/common.py")
        merge_common_py
        ;;
    "pyproject.toml")
        merge_pyproject_toml
        ;;
    "new_to_card_config/pipelines_config.yaml")
        merge_pipelines_config_yaml
        ;;
    *)
        # Fallback to default merge behavior for other files
        git merge-file -p "$2" "$3" "$4"
        ;;
esac

exit 0
