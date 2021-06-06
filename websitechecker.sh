#!/bin/bash

websites=(
www.example.com
www.example2.com
)

function sayit {
        echo "$site""$1"
        #---contact api goes here --
        ./mailapi.sh "from@example.com" "Website Change Checker" "Website $site Changed" "$site $1" "to@example.com"
        #----------------------
}

if ping -q -w 1 -c 1 1.1.1.1 &>/dev/null || ping -q -w 1 -c 1 8.8.8.8 &>/dev/null; then
        for site in "${websites[@]}"; do
                newsite=$(lynx -dump "$site" | sed 's/\[.*\]//g')
                site=$(echo "$site" | tr -d '/')
                oldsite=$(cat "$site.local" 2>/dev/null)
                if [ "$newsite" != "$oldsite" ] && [ "$newsite" != "" ]; then
                        if [ "$oldsite" = "" ]; then
                                sayit " - Added"
                        else
                                difference=$(diff -bBwy  --suppress-common-lines <(echo "$newsite") <(echo "$oldsite"))
                                sayit "$difference"
                        fi
                        echo "$newsite" > "$site.local"
                fi
        done
fi
