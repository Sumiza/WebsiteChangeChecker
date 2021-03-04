#!/bin/bash

websites=(
www.example.com
)

function sayit {
        #---contact api goes here --
        echo "$site""$1"
}

for site in "${websites[@]}"; do
        newsite=$(lynx -dump "$site")
        oldsite=$(cat "$site.local" 2>/dev/null) 
        if [ "$newsite" != "$oldsite" ]; then
                if [ "$oldsite" = "" ] && [ "$newsite" != "" ]; then
                        sayit " - is online"
                elif [ "$newsite" = "" ] && [ "$oldsite" != "" ]; then
                        sayit " - is offline"
                else
                        difference=$(diff -B <(echo "$newsite") <(echo "$oldsite"))
                        sayit " - $difference"
                fi
                echo "$newsite" > "$site.local"
        fi
done
