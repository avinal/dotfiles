#!/bin/bash

output=$(wakatime --today)

# Extract hours and minutes using awk and sum the total
total_minutes=$(echo "$output" | awk -F' ' '
{
    for (i=1; i<=NF; i++) {
        if ($i == "hrs" || $i == "hr") total += $(i-1) * 60;
        if ($i == "mins" || $i == "min") total += $(i-1);
    }
} END {print total}')

# Calculate total hours and remaining minutes
total_hours=$((total_minutes / 60))
remaining_minutes=$((total_minutes % 60))

# Print the results
printf '{"text":"%02dh %02dm","tooltip":"%s","class":"wakatime"}' $total_hours $remaining_minutes "$output" | jq --unbuffered --compact-output
