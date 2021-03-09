#!/bin/bash

#--- Generic api file to take inputs

apikey=""
apipass=""

#--- multiline fix, there must be a better way
while read -r line; do
        message="$message$line\n"
done <<< "$4"
message=$(echo "$message" | tr -d '[{"]}' )
#---
curl -X POST --user "$apikey:$apipass" https://api.mailjet.com/v3/send \
        -H 'Content-Type: application/json' \
        -d '{   "FromEmail":'\""$1"\"',
                "FromName":'\""$2"\"',
                "Subject":'\""$3"\"',
                "Text-part":'\""$message"\"',
                "Recipients":[{"Email":'\""$5"\"'}]}'
