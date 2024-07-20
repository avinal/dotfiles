#!/bin/bash

COUNT=$(dunstctl count waiting)
status=""
class=""
tooltip="Notifications are "
if dunstctl is-paused | grep -q "false" ; then
    status="NOT"
    tooltip+="active"
else
    status="DND"
    class="dnd"
    tooltip+="paused"
fi

if [ $COUNT != 0 ]; then text+=":$COUNT"; fi
printf '{"text":"%s","tooltip":"%s","class":"%s"}' "$status" "$tooltip" "$class" | jq --unbuffered --compact-output
