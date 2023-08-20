
source config.sh

RESET_BUTTON='<button hx-post="/reset" hx-swap="none" class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded">Reset</button>'

GUESS_FORM="
<input type=\"text\" name=guess id=guess placeholder=\"guess here\" class=\"uppercase\" autocomplete=\"off\"></input>
<button _=\"on htmx:afterRequest get #guess then put '' into its value\" type=\"submit\" hx-post=\"/guess\" hx-swap=\"none\" class=\"bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded\">Guess</button>
"

LAST_GUESS=$(tail -n1 data/guess)
GUESS_COUNT=$(wc -l data/guess | cut -d' ' -f1)
WORD=$(cat data/wordoftheday)

if [[ "$LAST_GUESS" == "$WORD" ]]; then
  FORM="<p>You won in $GUESS_COUNT guesses! :D</p>$RESET_BUTTON"
elif [[ "$GUESS_COUNT" -gt 5 ]]; then
  FORM="<p>Game over :( the correct word was '$WORD'</p>$RESET_BUTTON"
else
  FORM="$GUESS_FORM"
fi

htmx_page << EOF
  <form hx-swap-oob="true" id="guess-form">
    ${FORM}
  </form>
EOF
