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
	chan = "#kaoslan"

        mpr("NICK IamGawk")
        mpr("USER IamGawk IamGawk IamGawk :IamGawk") 
	mpr("JOIN "chan)
        while ((server |& getline)>0) {
                print "Got: " $0
                if (/^PING/) {
                        mpr("PONG " $2) 
                }
		if (/!awk /) {
			sted=$NF

			gsub("[^a-Z]","",sted);
			cmd="./master.sh "sted
			print "cmd: ",cmd
			$0 = ""
			cmd | getline;
			if (length > 0)
				msg = $0
			else
				msg = "Fant ikke stedet. (din nisse)"
				
			print "PRIVMSG "chan" :", msg |& server
		}
        }
}

