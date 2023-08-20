
KEYBOARD='QWERTYUIOP
ASDFGHJKL
ZXCVBNM'

function render() {
  while IFS= read -r line; do
    echo "<div class='text-center'>"
    while read -rn1 char; do
      if [[ "$char" != "" ]]; then
        GRAY="dark:bg-gray-500 bg-gray-300 font-bold"
        if grep -q "$char" data/guess; then
          if ! grep -q "$char" data/wordoftheday; then
            GRAY="dark:bg-gray-800 bg-gray-500 text-white"
          fi
        fi
        echo "<span class='align-middle leading-9 mt-1 w-7 h-9 rounded-md $GRAY inline-block text-center'>$char</span>"
      fi
    done < <(echo "$line")
    echo "</div>"
  done
}
RENDERED="$(echo "$KEYBOARD" | render)"

htmx_page << EOF
  <div hx-swap-oob="true" id="keyboard">$RENDERED</div>
EOF
