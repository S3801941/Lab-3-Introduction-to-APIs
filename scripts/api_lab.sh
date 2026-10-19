#!/usr/bin/env bash

# This bash file is where we will be making cURL requests and the formating them.
# This script will include setting for a clean fail if it happens. I will also clean up at the very end.
# This script will also log what is happening to logs/lab3.log.
# This is a bash script so everything will be different to what you would expect with python.

# This will allow the script to fain cleanly if anything goes wrong.
set -euo pipefail

# This line will allow us to add a new line and tab to be placed.
long_pause=$'\n\t'

# This function will send logs to logs/lab3.log

alfred="logs/lab3.log"

log() {
    local message=$1
    echo "$message" >> "$alfred"
}

log "LAB3_START"
echo "Master Control booting up."

# Creating a cleanup trap for when the script exits.

cleanup () {
    echo "Cleanup Running"
    rm -rf /data/*
    echo "Cleanup Done"
}

echo "Creating API URL variables..."
# Creating Variables for API URLs

riddler=https://icanhazdadjoke.com/

royal_flush_gang=https://deckofcardsapi.com/api/deck

echo "API URL variables created."

# Creating variables for API output paths

echo "Creating API output variables..."

king=data/dad_joke.json

queen=data/dad_joke.txt

jack=data/deck_create.json

ace=data/deck_draw.json

joker=data/deck_summary.txt

echo "API output variables created."



# All variables created and prerequisets checked. Logging BASH_OK.

log "BASH_OK"

echo "Master Control Systems online and functioning. Workign on tasks provided."

# Getting dad joke and saving it to data/dad_joke.json

batman=$(curl -sS -H 'Accept: application/json' -o "$king" -w '%{http_code}' "$riddler")

    # Checking HTTPS status code
    if [ $batman -eq 200 ]; then
        log "CURL_JOKE_OK"
    else
        log "CURL_JOKE_FAIL"
        cleanup
    fi

# Extracting Joke ID and Joke from data/dad_joke.json file.

if jq -r '.id, .joke' "$king" > "$queen"; then
    echo "Successfully Copied joke and ID to data/dad_joke.txt"
    log "JQ_JOKE_OK"
else
    echo "Failed to Copy joke and ID to data/dad_joke.txt"
    log "JQ_JOKE_FAILED"
    cleanup
fi

echo "Joke created and stored. Moving on to card values."

# From here we will be working with deck of cards API.
# We will first create the deck of cards, and then we will start pulling information form the deck.

robin=$(curl -sS -H 'Accept: application/json' -o "$jack" -w '%{http_code}' "$royal_flush_gang/new/shuffle/?deck_count=1")

    # Checking HTTPS status code.
    if [ $robin -eq 200 ]; then
        log "DECK_CREATED_OK"
    else
        log "DECK_CREATION_FAILED"
        cleanup
    fi

# Get deck_ID from file data/deck_create.json
gorden=$(jq -r '.deck_id' "$jack")

# Drawing cards from the deck we created above.
redhood=$(curl -sS -H 'Accept: application/json' -o "$ace" -w '%{http_code}' "$royal_flush_gang/$gorden/draw/?count=2")

    # Checking HTTPS status code
    if [ $redhood -eq 200 ]; then
        log "DECK_DRAW_OK"
    else
        log "DECK_DRAW_FAILED"
        cleanup
    fi

if jq -r '.cards[] | "\(.value) of \(.suit)"' "$ace" > "$joker"; then
    echo "Successfully Copied card information to data/deck_summary.txt"
    log "JQ_DECK_OK"
else
    echo "Failed to copy card values to data/deck_summary.txt"
    log "JQ_DECK_FAILED"
    cleanup
fi

echo "Card values received and stored. Shutting down Master Control processes."
echo "End of line"

log "LAB3_END"