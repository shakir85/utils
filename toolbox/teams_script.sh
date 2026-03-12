#!/bin/bash
caffeinate -d &
while true;
do
    osascript -e 'tell application "Microsoft Teams" to activate'
    osascript -e 'tell application "System Events" to keystroke "2" using {command down}'
    echo "Status Refreshed"
    sleep 300
done
