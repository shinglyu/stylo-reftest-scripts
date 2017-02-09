# Purpose

These scripts help you download websites and generate a reftest.list. You can use it to test if Stylo renders exactly like Gecko.

# Installation
* Git clone or download the [automate-save-page-as](https://github.com/abiyani/automate-save-page-as) repo into the `./automate-save-page-as` folder

# How to use

* Add the URL you want to test in `alexa.txt`
* Run `bash create_reftest.sh`, a folder called `alexa` will be generated.
* `cd alexa/`
* Run `bash ./download_pages.sh`, it will take a few minutes for the pages to be downloaded. (You can skip this if you wish to download the page manually)
* Copy the `alexa/` folder to your mozilla-central directory, run `./mach reftest --log-html stylo-reftest.html --disable-e10s alexa/reftest.list --setpref=reftest.compareStyloToGecko=true`, you can see the `stylo-reftest.html` log to find the screenshots.

# Cleaning the pages
* Load the pages in your browser to verify if it loads correctly. If not, you can try to download the page manually.
  * Create a folder under `alexa`, using the hostname as the folder name.
  * Load the page in Firefox, the right click > Save Page As, name the page `alexa/<hostname>/index.html`
  * Sometimes Chrome handles the download better then Firefox, try different browser if the result is not satisfying.
* If the page encoding is wrong, you can run `test_server.sh` and visit `http://localhost:8000`. This will set the encoding to UTF-8
* The reftest runner does not allow you to access remote resources, so we can corrupt the `http[s]` links to force the page not to load them: 

```
cd alexa
find . -type f -print0 | xargs -0 sed -i "s/http//g"
find . -type f -print0 | xargs -0 sed -i "s/wss//g" # WebSocket links
```

* Sometimes the JavaScript will break the test flow, so you might need to remove the js files.
  * espn.com has a `responder.js` that makes the page hang, remove it
  * Google doc will pop up an alert because the page does not run as expected. Remove all the js file it includes will hide the alert.
  * Google doc will try to redirect you to it's troubleshooting page using the `window.location.href = <url to support page>` JavaScript in `index.html`, try to use `sed` to remove the `window.location.href` code.
