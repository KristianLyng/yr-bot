

sted=$(echo "$1" | sed 's/[^a-Z]//')
url=$(gawk -v sted=$sted '$4 == "By" && $0 ~ sted { print $(NF-2); ex=0; } BEGIN { ex=2 } END { exit(ex) }' noreg.txt)
if [ "x$url" != "x" ]; then
	GET $url | ./yr.awk
fi
