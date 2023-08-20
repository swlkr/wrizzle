
source config.sh

htmx_page << EOF
  <div class="dark:bg-slate-950 dark:text-white grid place-content-center h-screen">
    <div class="flex flex-col gap-8 w-full max-w-md">
      <h1 class="text-blue-500 text-4xl">${PROJECT_NAME}</h1>

      <div hx-ext="sse" sse-connect="/sse">
      <div hx-get="/reset" hx-trigger="sse:reset"></div>
      <div id="guesses" hx-get="/guess" hx-trigger="sse:guess">
        $(component '/guess')
      </div>
      </div>
      <p id="error"></p>
      $(component '/form')
    </div>
  </div>
EOF
