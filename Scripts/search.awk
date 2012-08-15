# usage: busybox awk -f Scripts\search.awk <fromfile.txt >reports\tofile.txt
{if  ($0 ~ /da /) print }
