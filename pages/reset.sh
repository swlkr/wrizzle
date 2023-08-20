# headers
if [[ "$REQUEST_METHOD" == "POST" ]]; then
  rm data/guess
  touch data/guess
  shuf -n1 static/words > data/wordoftheday
  event reset | publish game
fi

header "HX-Redirect" "/"
