#!/bin/bash

# This script packs the mod into a zip file for distribution.

project_dir=$(dirname "$(dirname "$0")")
out_dir="$project_dir/out"
temp_dir="$out_dir/temp"

# read info.json
info_file="$project_dir/info.json"
if [ ! -f "$info_file" ]; then
    echo "Error: info.json not found in $project_dir"
    exit 1
fi

info=$(jq -r '.name, .version' "$info_file")
if [ "${#info}" -le 0 ]; then
    echo "Error: Failed to read info.json"
    exit 1
fi

# extract mod name and version
mod_name=$(echo "$info" | sed -n '1p')
mod_version=$(echo "$info" | sed -n '2p')

# print mod name and version
echo "Packing mod: $mod_name (version: $mod_version)"

# create temp directory in out
rm -rf "$out_dir"
mkdir -p "$temp_dir"

# copy mod files into temp directory
cp "$info_file" "$temp_dir"
cp -r "$project_dir/src"/* "$temp_dir"

# switch into the temp directory
cd "$temp_dir" || exit 1
# create zip file
zip -r "${mod_name}.zip" .
# move back to the project directory
cd "$project_dir" || exit 1
# move zip file to out directory
mv "$temp_dir/${mod_name}.zip" "$out_dir/${mod_name}_${mod_version}.zip"

# delete the temp directory
rm -rf "$temp_dir"

# check if the zip file was created successfully
if [ ! -f "$out_dir/${mod_name}_${mod_version}.zip" ]; then
    echo "Error: Failed to create mod zip file."
    exit 1
fi

# print success message
echo "Mod packed successfully: $out_dir/${mod_name}_${mod_version}.zip"

# exit with success
exit 0