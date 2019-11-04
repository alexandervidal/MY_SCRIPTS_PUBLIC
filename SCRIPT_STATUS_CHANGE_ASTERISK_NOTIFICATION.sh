#!/bin/bash

#create: https://alexandervidalolortegui.com

#date variable
dt=$(date '+%d.%m.%Y %H:%M:%S');
peer=$1
peerfile='{status_folder}'$peer
peeroldstatus=$(cat {status_folder}$peer)
#Peer check status
peerstatus=$(/usr/sbin/asterisk -x "sip show peer $peer" | grep Status | grep OK | wc -l)
if [ $peerstatus = 1 ]
then
    #If peer was Online, and now is also Online, do nothing
    if [ $peeroldstatus = "1" ]
        then
        echo "$dt | $peer Online, making nothing"
    else
        #If you were not online and now you are sending email
        echo "$dt | $peer Online"
        echo 1 > $peerfile
        {sendmail_parameters}

    fi
else
    #If I was offline and still not do anything
    if [ $peeroldstatus = "0" ]
    then
        echo "$dt | $peer Offline, making nothing"
    else
        #If you are offline and change to active send email
        echo 0 > $peerfile
        echo "$dt | $peer Offline"
        {sendmail_parameters}
    fi
fi
