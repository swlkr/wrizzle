
KEYBOARD='QWERTYUIOP
ASDFGHJKL
ZXCVBNM'

function render() {
  while IFS= read -r line; do
    echo "<div class='text-center'>"
    while read -rn1 char; do
      if [[ "$char" != "" ]]; then
        GRAY=bg-gray-500
        if grep -q "$char" data/guess; then
          GRAY=bg-gray-800
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
