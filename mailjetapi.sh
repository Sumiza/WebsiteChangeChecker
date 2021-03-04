#!/bin/bash

#--- Generic api file to take inputs

apikey=""
apipass=""

#--- temporary workaround
message=$(echo "$4" | tr '\n' ' ')
#---
curl -X POST --user "$apikey:$apipass" https://api.mailjet.com/v3/send \
	-H 'Content-Type: application/json' \
	-d '{	"FromEmail":'\""$1"\"',
		"FromName":'\""$2"\"',
		"Subject":'\""$3"\"',
		"Text-part":'\""$message"\"',
		"Recipients":[{"Email":'\""$5"\"'}]}'
