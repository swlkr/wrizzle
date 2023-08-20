
source config.sh

RESET_BUTTON='<button hx-post="/reset" hx-swap="none" class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded">New Game</button>'

GUESS_FORM="
<input autofocus type=\"text\" name=guess id=guess placeholder=\"guess here\" class=\"uppercase\" autocomplete=\"off\"></input>
<button _=\"on htmx:afterRequest get #guess then put '' into its value\" type=\"submit\" hx-post=\"/guess\" hx-swap=\"none\" class=\"bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded\">Guess</button>
"

LAST_GUESS=$(tail -n1 data/guess)
GUESS_COUNT=$(wc -l data/guess | cut -d' ' -f1)
WORD=$(cat data/wordoftheday)

function form() {
  FORM="<div class='flex flex-col justify-center w-full'><p class='text-center'>$1</p>$RESET_BUTTON</div>"
}
if [[ "$LAST_GUESS" == "$WORD" ]]; then
  form "You won in $GUESS_COUNT guesses! :D"
elif [[ "$GUESS_COUNT" -gt 5 ]]; then
  form "Game over :( the correct word was '$WORD'"
else
  FORM="$GUESS_FORM"
fi

htmx_page << EOF
  <form hx-swap-oob="true" id="guess-form" class="flex justify-center">
    ${FORM}
  </form>
EOF
