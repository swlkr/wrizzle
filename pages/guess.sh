
WORD=$(cat data/wordoftheday)

function error() {
    ERROR='<p class="text-red-500" id="error" hx-swap-oob="true">'"$1"'</p>'
}

GUESS_COUNT=$(wc -l data/guess | cut -d' ' -f1)

if [[ "$REQUEST_METHOD" == "POST" ]]; then
  GUESS=$(echo "${FORM_DATA[guess]}" | sed 's/[^a-zA-Z]//g' | tr '[:lower:]' '[:upper:]' )
  if [[ "$GUESS_COUNT" -gt 5 ]]; then
    error "You are out of guesses!"
  elif [[ "${#GUESS}" != 5 ]]; then
    error "Your guess must be 5 letters!"
  elif ! grep -q "$GUESS" static/guessable-words; then
    error "Your guess must be a real word!"
  else
    echo "$GUESS" >> data/guess
    event guess | publish game
    if [[ "$GUESS" == "$WORD" ]]; then
        error ""
    fi
  fi
fi

if [[ "$INTERNAL_REQUEST" != "true" ]]; then
  FORM=$(component '/form')
  KEYBOARD=$(component '/keyboard')
fi

function render() {
    local TYPE
    local CLASS
    while IFS= read -r line; do
        echo -n "<div class='justify-center flex gap-1'>"
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
                    CLASS="dark:bg-gray-500 bg-gray-300"
                fi
                echo "<span class='font-bold inline-block text-center align-middle leading-9 rounded-md h-9 w-9 $CLASS'>$LETTER</span>"
            fi
        done < <(echo "$OUTPUT")
        echo -n "</div>"
    done
}

GUESSES="$(cat data/guess | render)"
BLANK_COUNT=$(( 6 - GUESS_COUNT ))
BLANKS=""
for i in $(seq 1 $BLANK_COUNT); do
  BLANKS+="<div class='justify-center flex gap-1'>"
    for j in {1..5}; do
      BLANKS+="<span class='inline-block text-center align-middle leading-9 rounded-md h-9 w-9 border-2 dark:border-gray-800 border-gray-300'>&nbsp;</span>"
    done
  BLANKS+="</div>"
done
htmx_page << EOF
  ${ERROR}
  ${FORM}
  ${GUESSES}
  ${BLANKS}
  ${KEYBOARD}
EOF
