#!/usr/bin/env

# This bash file is where we will be making cURL requests and the formating them.
# This script will include setting for a clean fail if it happens. I will also clean up at the very end.
# This script will also log what is happening to logs/lab3.log.
# This is a bash script so everything will be different to what you would expect with python.

# This will allow the script to fain cleanly if anything goes wrong.
set -euo pipefail

# This line will allow us to add a new line and tab to be placed.
long_pause=$'\n\t'

# This function will send logs to logs/lab3.log
log() {
    local message=$1
    echo "message" >> "$SCRIBE"
}

log "LAB3_START"


# Creating a cleanup trap for when the script exits.

cleanup () {
    echo "Cleanup Running"
    rm -rf /data/*
    echo "Cleanup Done"
}

# Creating Variables for API URLs

riddler=https://icanhazdadjoke.com/

royal_flush_gang=https://deckofcardsapi.com/api/deck

# Creating variables for API output paths

king=data/dad_joke.json

queen=data/dad_joke.txt

jack=data/deck_create.json

ace=data/deck_draw.json

joker=data/deck_summary.txt

# Creating status variable

batman=$?

log "BASH_OK"