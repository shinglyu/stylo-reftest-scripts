mkdir alexa
echo "#!/usr/bin/env bash" > alexa/download_pages.sh
echo "" > alexa/reftest.list
while read line
do
  #echo "wget -r -np -k ${line}" >> alexa/download_pages.sh
  echo "wget -E -H -k -p ${line}" >> alexa/download_pages.sh
  path=$(echo ${line} | sed -e 's/http:\/\///g')
  path="${path}/index.html"
  echo "== ${path} ${path}" >> alexa/reftest.list
done < alexa.txt

echo 'find alexa -type f -print0 | xargs -0 sed -i "s/http//g"' >> alexa/download_pages.sh

