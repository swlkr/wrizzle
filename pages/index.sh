
source config.sh

htmx_page << EOF
  <div class="dark:bg-slate-950 dark:text-white grid place-content-center h-screen">
    <div class="flex flex-col gap-8 w-full max-w-md">
      <h1 class="text-blue-500 text-4xl">${PROJECT_NAME}</h1>
      <div id="guesses">
        $(component '/guess')
      </div>
        <p id="error"></p>
        $(component '/form')
    </div>
  </div>
EOF
