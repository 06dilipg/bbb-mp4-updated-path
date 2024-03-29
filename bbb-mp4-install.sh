#!/bin/bash

# Load .env variables
cp env-example .env
sed -i "s/BBB_DOMAIN_NAME=.*/BBB_DOMAIN_NAME=$(bbb-conf --secret | grep URL|  cut -d'/' -f3)/g" .env

set -a
source <(cat .env | \
    sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g")
set +a

chmod +x *.sh

echo "Adding bbb_mp4.rb"
chmod 777 bbb_mp4.rb
cp -r bbb_mp4.rb /mnt/scalelite-recordings/var/bigbluebutton/published/presentation/  


echo "Updating index.html"
if [ ! -f "/mnt/scalelite-recordings/var/bigbluebutton/published/presentation/2.3/index_default.html" ]; then
  
  echo "index_default.html doesn't exist. Proceed with replacing.";
  
  # index_default.html is backup of default index.html that comes with fresh bbb install. If you want to remove bbb-mp4, rename index_default.html to index.html.
  #cp /mnt/scalelite-recordings/var/bigbluebutton/published/presentation/2.3/index.html /var/bigbluebutton/playback/presentation/2.3/index_default.html
  
  # copying download-button.js
  cp download-button.js /mnt/scalelite-recordings/var/bigbluebutton/published/presentation/2.3/
  # Add js tag just befor closing body tag
  sed -i 's/<\/body>/<script src="\/playback\/presentation\/2.3\/download-button.js"><\/script><\/body>/g' /mnt/scalelite-recordings/var/bigbluebutton/published/presentation/2.3/index.html
else
  echo "index_default.html exists. Skipping replacing.";
fi

#creating Docker image.
echo "creating Docker image bbb-mp4:v1"
docker build -t bbb-mp4:2.3 .

