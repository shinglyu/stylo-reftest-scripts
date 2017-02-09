#!/usr/bin/env bash

UA="Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0"
mkdir alexa
echo "#!/usr/bin/env bash" > alexa/download_pages.sh
echo "" > alexa/reftest.list
while read line
do
  #echo "wget -r -np -k ${line}" >> alexa/download_pages.sh
  # echo "wget --user-agent='User-Agent: ${UA}' -E -H -k -p ${line}" >> alexa/download_pages.sh

  hostname=$(echo ${line} | awk -F/ '{print $3}')
  mkdir "alexa/${hostname}"
  path="${hostname}/index.html"
  echo "../automate-save-page-as/save_page_as '${line}' --browser 'chromium-browser' --destination '${path}'" >> alexa/download_pages.sh
  echo "== ${path} ${path}" >> alexa/reftest.list
done < alexa.txt

echo 'find . -type f -print0 | xargs -0 sed -i "s/http//g"' >> alexa/download_pages.sh

