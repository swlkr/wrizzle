PROJECT_NAME=wrizzle
TAILWIND=on

if [[ ! -f data/wordoftheday ]]; then
    shuf -n1 static/words > data/wordoftheday
fi
