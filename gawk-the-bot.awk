#!/usr/bin/gawk -f

# Do stuff on IRC!
# Copyright (C) 2010 Kristian Lyngstøl - <kristian@bohemians.org>
# 
# Inspired somewhat by Allan Clark/napta2k@gmail.com (as in: he took my
# munin-node-awk code to write an IRC bot and I took his IRC bot to write
# my IRC bot)
#
# Todo:
#  - Limit it to a channel
#  - Support asking for more than a-Z (ie: numbers)
#  - better stats
#  - i18n
#  - Goatse-ascii-art for kristiansand-people

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

