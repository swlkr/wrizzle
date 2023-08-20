# headers

WORD=$(cat data/wordoftheday)
LAST_GUESS=$(tail -n1 data/guess)
GUESS_COUNT=$(wc -l data/guess | cut -d' ' -f1)

if [[ "$REQUEST_METHOD" == "POST" ]]; then
  if [[ "$GUESS_COUNT" -lt 6 ]] && [[ "$WORD" != "$LAST_GUESS" ]]; then
    end_headers
    end_headers
    return
  fi
  rm data/guess
  touch data/guess
  shuf -n1 static/words > data/wordoftheday
  event reset | publish game
fi

header "HX-Redirect" "/"
end_headers
end_headers
