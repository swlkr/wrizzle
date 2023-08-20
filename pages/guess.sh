
WORD=$(cat data/wordoftheday)

function error() {
    ERROR='<p class="text-red-500" id="error" hx-swap-oob="true">'"$1"'</p>'
}
if [[ "$REQUEST_METHOD" == "POST" ]]; then
  GUESS=$(echo "${FORM_DATA[guess]}" | sed 's/[^a-zA-Z]//g' | tr '[:lower:]' '[:upper:]' )
  GUESS_COUNT=$(wc -l data/guess | cut -d' ' -f1)
  if [[ "$GUESS_COUNT" -gt 5 ]]; then
    error "You are out of guesses!"
  elif [[ "${#GUESS}" != 5 ]]; then
    error "Your guess must be 5 letters!"
  elif ! grep -q "$GUESS" static/guessable-words; then
    error "Your guess must be a real word!"
  else
    echo "$GUESS" >> data/guess
    if [[ "$GUESS" == "$WORD" ]]; then
        error ""
    fi
  fi
  FORM=$(component '/form')
fi


function render() {
    local TYPE
    local CLASS
    while IFS= read -r line; do
        echo -n "<div>"
        INDEX=0
        WRONG_LETTERS=""
        OUTPUT=""
        while read -rn1 char; do
            if [[ "$char" != "" ]]; then
                RIGHT_LETTER=${WORD:$INDEX:1}
                ((INDEX++))
                if [[ "$RIGHT_LETTER" == "$char" ]]; then
                    TYPE="right"
                else
                    WRONG_LETTERS+="$RIGHT_LETTER"
                    TYPE="wrong"
                fi
                # echo "<span TYPE='$TYPE'>$char</span>"
                OUTPUT+="$char $TYPE
"
            fi
        done < <(echo "$line")
        while IFS= read -r letter_string; do
            if [[ "$letter_string" != "" ]]; then
                LETTER=${letter_string:0:1}
                TYPE=${letter_string:2}
                if [[ "$TYPE" == "right" ]]; then
                    CLASS="bg-green-500"
                elif [[ "$WRONG_LETTERS" =~ $LETTER ]]; then
                    WRONG_LETTERS=${WRONG_LETTERS/$LETTER}
                    CLASS="bg-yellow-500"
                else
                    CLASS="bg-gray-500"
                fi
                echo "<span class='inline-block text-center rounded-md h-6 w-6 $CLASS'>$LETTER</span>"
            fi
        done < <(echo "$OUTPUT")
        echo -n "</div>"
    done
}

GUESSES="$(cat data/guess | render)"
htmx_page << EOF
  ${ERROR}
  ${FORM}
  ${GUESSES}
EOF
