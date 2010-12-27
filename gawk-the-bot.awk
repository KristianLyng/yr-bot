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
		if ($4 == ":!awk" && chan == $3) {
			sted=$NF

			gsub("[^a-Z0-9]","",sted);
			cmd="./master.sh "sted
			print "cmd: ",cmd
			print "length: " length(cmd)
			$0 = ""
			cmd | getline
			print "ret: ",$0
			gsub("Kristiansand","K-town");
				
			if (length($0) > 0)
				msg = $0
			else
				msg = "Fant ikke stedet. (sikkert et gudsforlatt sted)."
			close(cmd)	
			print "PRIVMSG "chan" :", msg |& server
		}
        }
}

