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
#[X] Logic checks at each step
#[ ]Insert Final If to check all wetaher conditions a nd if all criteria is met send Pushbullet message to Phone
#[X] Blink1 flash green if all cirtrea is good, red if not

apikey=`cat /home/pi/APIConfigs/WUapikey.config` #Get WeatherUnderground API key from apikey.config
location=`cat /home/pi/APIConfigs/Wulocation.config`

pywu fetch $apikey $location #Outputs File to /tmp/pywu.cache.json

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
	conditionT="0"
else
	echo "temperature OK"
	conditionT="1"
fi

echo "########################"
echo "Rainfall"
echo "########################"
raincm=`pywu current prec_day_cm` #Show amount of Precip 
echo $raincm #echo to console for debugging
#conditionR

echo "########################"
echo "Wind Speed"
echo "########################"

wind=`pywu current wind` #Grab Windspeed
currentwindstring="Current Wind= "$wind
echo $currentwindstring
wind=`echo $wind | egrep -o [0-9]+`

if [ $wind -le 15 ]
then
       echo "Wind Good"
       conditionW="1"
else
       echo "Too Windy"
       conditionW="0"
fi

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
        conditionV="0"
else
        echo "Visibility Good"
        conditionV="1"
fi

#echo $conditionT 
#echo $conditionR
#echo $conditionW
#echo $conditionV


if [ $conditionT == 1 ] && [ $conditionW == 1 ] && [ $conditionV == 1 ]
then
	sudo /home/pi/blink1/commandline/blink1-tool --green --glimmer=10
else
	sudo /home/pi/blink1/commandline/blink1-tool --red --glimmer=10
fi
