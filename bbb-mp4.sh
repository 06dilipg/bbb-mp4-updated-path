#!/bin/bash

# Load .env variables
set -a
source <(cat  /var/www/bbb-mp4/.env | \
    sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g")
set +a

MEETING_ID=$1

echo "converting $MEETING_ID to mp4" |  systemd-cat -p warning -t bbb-mp4

sudo docker run --rm -d \
                --name $MEETING_ID \
                -v $COPY_TO_LOCATION:/usr/src/app/download \
                --env-file  /var/www/bbb-mp4/.env \
                --env REC_URL=https://$BBB_DOMAIN_NAME/mnt/scalelite-recordings/var/bigbluebutton/published/presentation/$MEETING_ID?meetingID=$MEETING_ID \
                bbb-mp4:2.3