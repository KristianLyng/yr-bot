#!/usr/bin/gawk -f

# Downloads images from IRC
# Allan Clark - <napta2k@gmail.com>
# Core code written by Kristian Lyngstøl - <kristian@bohemians.org>
# 2010-09-09
# NOTE: No sanitization is performed on the URL before it's passed to the shell!

function mpr(content) {
        print content |& server
        print "sent: " content
}

BEGIN {
        server="/inet/tcp/0/efnet.xs4all.nl/6667"

        mpr("NICK IamGawk")
        mpr("USER IamGawk IamGawk IamGawk :IamGawk") 
	mpr("JOIN #kaoslan")
        while ((server |& getline)>0) {
                print "Got: " $0
                if (/^PING/) {
                        mpr("PONG " $2) 
                }
		if (/!awk /) {
			sted=$NF

			gsub("[^a-Z]","",sted);
			cmd="./master.sh "sted
			cmd | getline;
			print "PRIVMSG #kaoslan :", $0 |& server
		}
        }
}

