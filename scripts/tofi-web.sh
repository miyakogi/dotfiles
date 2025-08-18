#!/usr/bin/env bash

# query=$(echo "" | tofi --prompt-text "WebSearch: " --require-match false)
# if [ -n "$query" ]; then
#   encoded=$(printf '%s' "$query" | jq -sRr @uri)
#   echo "$encoded"
#   app2unit -- xdg-open "https://search.brave.com/search?q=${encoded}"
# fi


#!/bin/bash
# tofi-multi-search.sh

# Allow free input with no predefined candidates
query=$(printf ' : Brave\ng: Google\nb: Bing\n' | tofi --prompt-text "WebSearch: " --require-match false --output "$1")

# Run only if the input is not empty
if [ -n "$query" ]; then
  engine="brave"  # Default search engine
  keyword="$query"

  # Switch search engine based on prefix
  case "$query" in
    g:*)
      engine="google"
      keyword="${query#g:}"
      ;;
    b:*)
      engine="bing"
      keyword="${query#b:}"
      ;;
  esac

  # URL encode using jq
  encoded=$(printf '%s' "$keyword" | jq -sRr @uri)

  # Execute search
  case "$engine" in
    brave)
      url="https://search.brave.com/search?q=${encoded}"
      ;;
    google)
      url="https://www.google.com/search?q=${encoded}"
      ;;
    bing)
      url="https://www.bing.com/search?q=${encoded}"
      ;;
  esac
  app2unit -- xdg-open "$url" &>/dev/null &
fi

