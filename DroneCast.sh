#!/bin/bash

pywu fetch {apikey}  'Maidstone,UK'

echo "########################"
echo "Temperature"
echo "########################"

#temp=`grep 'temp_c' /tmp/pywu.cache.json | cut -d \: -f 2 | cut -d \, -f 1`

temp=`pywu current temp_c`
currenttempstring="current temp= "$temp
echo $currenttempstring

if [ $temp -le 10 ]
then
	echo "too cold"
	condition1="0"
	echo $condition1
else
	echo "temperature OK"
	condition1="1"
	echo $condition1
fi

echo "########################"
echo "Rainfall"
echo "########################"
raincm=`pywu current prec_day_cm`
echo $raincm

echo "########################"
echo "Wind Speed"
echo "########################"

wind=`pywu current wind`
currentwindstring="current wind= "$wind
echo $currentwindstring

echo "########################"
echo "Visibility"
echo "########################"

visi=`pywu current visibility_mi`
currentvisistring="current visi= "$visi
echo $currentvisistring

visi2=$( printf "%.0f" $visi )

if [ $visi2 -le 5 ]
then
        echo "Visibilty Poor"
        condition1="0"
        echo $condition3
else
        echo "Visibility Good"
        condition1="1"
        echo $condition2
fi
