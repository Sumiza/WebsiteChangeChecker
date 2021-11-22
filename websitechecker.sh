#!/bin/bash

websitechange=(
www.example.com
)

#format: "domain;words to search for"
websitefind=(
"https://www.example.ccom;word finder"
)
#Format: domain:port:tries:name
pingport=(
example.com:22010:2:Example
)

function sayit {
        echo "$1"
        #---contact api goes here --
        fromemail="from@example.com"
        toemail="example@gmail.com"
        ./mailjetapi.sh "$fromemail" "$1" "$2" "$3" "$toemail"
        #----------------------
}
if ping -q -w 1 -c 1 1.1.1.1 &>/dev/null || ping -q -w 1 -c 1 8.8.8.8 &>/dev/null; then
        for site in "${websitechange[@]}"; do
                oldsite=$(cat "$(echo "$site" | tr -d '/').local" 2>/dev/null)
                newsite=$(timeout 5 lynx -dump -nonumbers -image_links -useragent=Lynx "$site")
                if [ $? = 0 ] && [ "$newsite" != "$oldsite" ] && [ "$newsite" != "" ]; then
                        if [ "$oldsite" = "" ]; then
                                sayit "Website Change Checker" "Website $site Changed" "$site - Added"
                        else
                                difference=$(diff -bBwy  --suppress-common-lines <(echo "$newsite") <(echo "$oldsite"))
                                sayit "Website Change Checker" "Website $site Changed" "$site \n $difference"
                        fi
                        echo "$newsite" > "$(echo "$site" | tr -d '/').local"
                fi
        done
        #---------------------------------------------------------------
        for webfind in "${websitefind[@]}"; do
                website=$(cut -d ';' -f1 <<< "$webfind")
                findstring=$(cut -d ';' -f2 <<< "$webfind")
                wweb=$(timeout 5 lynx -dump -nonumbers -nolist -useragent=Lynx "$website")
                if [ $? = 0 ]; then
                        if  grep "$findstring" <<< "$wweb" &>/dev/null; then
                                if [ "$(cat "$(echo "$website" | tr -d '/').localfind" 2>/dev/null)" != "$findstring" ]; then
                                        sayit "Word Checker" "Found $findstring" "$website \n $findstring - Found"
                                        echo "$findstring" > "$(echo "$website" | tr -d '/').localfind"
                                fi
                        else
                                if [ "$(cat "$(echo "$website" | tr -d '/').localfind" 2>/dev/null)" != "NULL"  ]; then
                                        sayit "Word Checker" "NOT found $findstring" "$website \n $findstring - NOT found"
                                        echo "NULL" > "$(echo "$website" | tr -d '/').localfind"
                                fi
                        fi
                fi
        done
        #----------------------------------------------------------------
        for portping in "${pingport[@]}"; do
                if [ ! -f "$portping" ] &>/dev/null; then
                                echo "0" > "$portping"
                fi
                if (timeout 5 bash -c "</dev/tcp/$(cut -d ':' -f1 <<< "$portping")/$(cut -d ':' -f2 <<< "$portping")") &>/dev/null; then
                        if [ "$(cat "$portping")" = "0" ]; then
                                #echo "$portping ping up"
                                sayit "Ping Checker" "Ping UP $portping" "$portping - is up"
                        fi
                        echo "1" > "$portping"
                else
                        if [ "$(cut -d ':' -f3 <<< "$portping")" -le "$(cat "$portping")" ]; then
                                #echo "$portping ping down"
                                sayit "Ping Checker" "Ping DOWN $portping" "$portping - is Down"
                                echo "0" > "$portping"
                        else
                                if [ "$(cat "$portping")" != "0" ]; then
                                        echo "$(($(cat "$portping") + 1 ))" > "$portping"
                                fi
                        fi
                fi
        done
fi
