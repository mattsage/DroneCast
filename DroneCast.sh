#!/bin/bash

##################################
#Name: DroneCast.sh
#Author: Matthew Sage
#Latest Update: 26/02/16
##################################

#Script ot be ran at 6am daily via cron job
#crontab -e
# 00 06 * * * /home/pi/Scripts/github/DroneCast/DroneCast.sh

#To Do
#[] Logic checks at each step
#[]Insert Final If to check all wetaher conditions a nd if all criteria is met send Pushbullet message to Phone
#[] Blink1 flash green if all cirtrea is good, red if not
#e.g. sudo /home/pi/blink1/commandline/blink1-tool --red --glimmer=10 

pywu fetch api 'Maidstone,UK' #Outputs File to /tmp/pywu.cache.json

echo "########################"
echo "Temperature"
echo "########################"

#temp=`grep 'temp_c' /tmp/pywu.cache.json | cut -d \: -f 2 | cut -d \, -f 1`

temp=`pywu current temp_c` #Grab Temp
currenttempstring="current temp= "$temp
echo $currenttempstring #echo to console for debugging

if [ $temp -le 5 ] #If check to see if Temp is < 5C
then
	echo "too cold"
	condition1="0"
	echo $condition1 #echo to console for debugging 
else
	echo "temperature OK"
	condition1="1"
	echo $condition1 #echo to console for debugging
fi

echo "########################"
echo "Rainfall"
echo "########################"
raincm=`pywu current prec_day_cm` #Show amount of Precip 
echo $raincm #echo to console for debugging

echo "########################"
echo "Wind Speed"
echo "########################"

wind=`pywu current wind` #Grab Windspeed
currentwindstring="current wind= "$wind
echo $wind | tr -d -c 0-9
#if [ `$wind | tr -d -c 0-9` -le 15 ]
#then
#	echo "wind good"
#else
#	echo "Too Windy"
#fi


#Need If statement here for check <15MPH
echo ""
echo "########################"
echo "Visibility"
echo "########################"

visi=`pywu current visibility_mi` #Grab Visibilty
currentvisistring="current visi= "$visi
echo $currentvisistring #echo to console for debugging

visi2=$( printf "%.0f" $visi ) #Convert to Int

if [ $visi2 -le 5 ] #If Visibilty is < 5 miles 
then
        echo "Visibilty Poor"
        condition1="0"
        echo $condition3
else
        echo "Visibility Good"
        condition1="1"
        echo $condition2
fi
