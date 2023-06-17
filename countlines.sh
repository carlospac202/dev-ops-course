#!/bin/bash

while getopts ":o:m:" opt; do
  case $opt in
    o)
      owner="$OPTARG"
      ;;
    m)
      month="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

month_abbr=$(echo "$month" | tr '[:upper:]' '[:lower:]')


if [ -n "$owner" ] && [ -n "$month" ]; then
  files=$(find . -maxdepth 1 -type f -printf "%u %TY-%Tm %p\n" | awk -v owner="$owner" -v month="$month_abbr" '$1 == owner && $2 == month {print $3}')
elif [ -n "$owner" ]; then
  files=$(find . -maxdepth 1 -type f -user "$owner")
elif [ -n "$month" ]; then
  files=$(find . -maxdepth 1 -type f -printf "%TY-%Tm %p\n" | awk -v month="$month_abbr" '$1 == month {print $2}')
else
  files=$(find . -maxdepth 1 -type f)
fi

total_lines=0
for file in $files; do
  lines=$(wc -l < "$file")
  echo "$file: $lines lines"
  total_lines=$((total_lines + lines))
done

echo "Total lines: $total_lines"