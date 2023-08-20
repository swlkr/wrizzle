# headers
if [[ "$REQUEST_METHOD" != "POST" ]]; then
  # only allow POST to this endpoint
  return $(status_code 405)
fi

rm data/guess
touch data/guess

shuf -n1 static/words > data/wordoftheday

header "HX-Redirect" "/"
