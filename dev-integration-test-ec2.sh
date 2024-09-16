#!/bin/bash
echo "Intergation test........"

URL=3.140.244.188

if [[ "$URL" != '' ]]; then
    http_code=$(curl -s -o /dev/null -w "%{http_code}" http://$URL:3333/live)
    planet_data=$(curl -s -XPOST http://$URL:3333/planet -H "Content-Type: application/json" -d '{"id": "3"}')
    planet_name=$(echo $planet_data | jq .name -r)

    if [[ "$http_code" -eq 200 && "$planet_name" -eq "Earth"  ]]; 
        then
            echo "HTTP Status Code and Planet Name Tests Passed"
        else
            echo "One or more test(s) failed"
            exit 1;
    fi;

else
        echo "Issues with URL; Check/Debug line 4"
        exit 1;
fi;