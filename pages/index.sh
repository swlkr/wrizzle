
source config.sh

htmx_page << EOF
  <div class="dark:bg-slate-950 dark:text-white grid place-content-center h-screen">
    <div class="flex flex-col gap-8 w-full max-w-md">
      <h1 class="text-blue-500 text-4xl">${PROJECT_NAME}</h1>
      <div id="guesses">
        $(component '/guess')
      </div>
      <form id="win">
        <input type="text" name=guess placeholder="guess here" class="uppercase"></input>

      
        <button type="submit" hx-post="/guess" hx-target="#guesses" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">Guess</button>
        <button hx-post="/reset" hx-target="#guesses" class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded">Reset</button>
      </form>
      </form>
    </div>
  </div>
EOF
