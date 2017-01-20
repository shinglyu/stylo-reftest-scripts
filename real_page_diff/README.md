# Purpose

These scripts help you download websites and generate a reftest.list. You can use it to test if Stylo renders exactly like Gecko.

# How to use

* Add the URL you want to test in `alexa.txt`
* Run `bash create_reftest.sh`, a folder called `alexa` will be generated.
* `cd alexa/`
* Run `bash ./download_pages.sh`, it will take a few minutes for the pages to be downloaded
* Copy the `alexa/` folder to your mozilla-central directory, run `./mach reftest --log-html stylo-reftest.html --disable-e10s alexa/reftest.list --setpref=reftest.compareStyloToGecko=true`, you can see the `stylo-reftest.html` log to find the screenshots.

# Known Issue

* Twitter.com is painfully slow to download
