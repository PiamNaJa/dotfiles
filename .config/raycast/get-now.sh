#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Get Now
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Get Now in MS

echo -n $(( $(date +%s)*1000 + $(date +%N)/1000000 )) | pbcopy