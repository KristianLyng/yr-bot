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
	gsub("(name=|\")","")
	symb=$3
}

/<temperature/ && tab==1 {
	gsub("(value=|\")","")
	printf("%s: %s til %s: %s C (%s)\n",
		namn, tidfra, tidtil, $3, symb)
	exit
}
