#!/bin/sh

OutputFile="BounceEmail.txt"
InputFile="GroupMembers.txt"

if [ -f $OutputFile ]
then
rm $OutputFile
fi

mkdir -p split

if [ -f $InputFile ]
then
declare -a company=($(cut -d '@' -f 2 $InputFile | tr "[:upper:]" "[:lower:]" | sort | uniq))
	
	for x in "${company[@]}"
	do
		grep "@$x" $InputFile > split/$x.list
		declare -a MX=($(dig $x mx +short $1 | cut -d ' ' -f2))
		a=1
		mxPosLen=$(expr ${#MX[@]})
		mxPos=0
		while [ $a -eq 1 ]
		do
			expect -f mail.exp $x "${MX[$mxPos]}" split/$x.list $1
			a=$?
			mxPos=$(expr $mxPos + 1)
			if [ $mxPos -eq $mxPosLen ]
			then
				break
			fi
		done 
	done

fi



