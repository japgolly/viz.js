# Installation

1. Install emsdk following these instructions: https://emscripten.org/docs/getting_started/downloads.html

   The Arch Linux package doesn't work. (https://github.com/emscripten-core/emscripten/issues/11428#issuecomment-644848678)

2. `make setup`


# Building

`make` or `make clean dist`


# Testing

1. python3 -m http.server 8000
2. Open http://localhost:8000/test-browser/golly.html
3. Look at the console


# Running Browser Tests

1. python3 -m http.server 8000
2. Open http://localhost:8000/test-browser/golly.html

The browser tests can be run locally using Selenium WebDriver.

First, serve the project directory at http://localhost:8000.

    python3 -m http.server 8000

Then, run tests using test-browser/runner.js. For example, to run `test-browser/full.html` in Chrome:

    node test-browser/runner --file full.html --browser chrome
