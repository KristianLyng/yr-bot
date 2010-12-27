#!/usr/bin/gawk -f

# Copyright 2010, Kristian Lyngstøl <kristian@bohemians.org>
#
# Simple parsing of yr.no xml-data (needs tweaking)


/<name>/ && namn == "" {
	gsub("</?name>","")
	gsub("\r","")
	namn = $1

}
/lastupdate/ { 
	gsub("</?lastupdate>","")
	lastupdate = $1
}

/<tabular>/ { tab=1 }

/<time/ && tab==1 {
	gsub("(((to|from)=)|\")","")
	tidfra=$2
	tidtil=$3
}

/<symbol/ {
	if ($3 ~ "\"$") 
		hel=1;
	else
		hel=0
	symb=$3
	if (hel == 0) {
		symb=$3" "$4
	}
	gsub("(name=|\")","",symb)
}

/<temperature/ && tab==1 {
	gsub("(value=|\")","")
	printf("%s(%s): %s til %s: %s C (%s)\n",
		namn,fylke, tidfra, tidtil, $3, symb)
	exit
}
