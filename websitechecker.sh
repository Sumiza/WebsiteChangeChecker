#!/bin/bash

websites=(
www.example.com
www.example2.com
)

function sayit {
        echo "$site""$1"
        #---contact api goes here --
        ./mailjetapi.sh "from@example.com" "Website Change Checker" "Website $site Changed" "$site $1" "to@example.com"
        #----------------------
}

for site in "${websites[@]}"; do
        newsite=$(lynx -dump "$site")
        site=$(echo "$site" | tr -d '/')
        oldsite=$(cat "$site.local" 2>/dev/null)
        if [ "$newsite" != "$oldsite" ]; then
                if [ "$oldsite" = "" ] && [ "$newsite" != "" ]; then
                        sayit " - is online"
                elif [ "$newsite" = "" ] && [ "$oldsite" != "" ]; then
                        sayit " - is offline"
                else
                        difference=$(diff -bBwy  --suppress-common-lines <(echo "$newsite") <(echo "$oldsite"))
                        sayit " - $difference"
                fi
                echo "$newsite" > "$site.local"
        fi
done
