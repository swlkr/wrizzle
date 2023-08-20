if [[ "$REQUEST_METHOD" != "POST" ]]; then
  # only allow POST to this endpoint
  return $(status_code 405)
fi

rm data/guess
touch data/guess

cat /usr/share/dict/american-english \
| tr '[:lower:]' '[:upper:]' \
| egrep '^[A-Z]{5}$' \
| shuf \
| head -n1 > data/wordoftheday

component '/guess'
