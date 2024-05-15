#!/bin/bash
# Name: days.sh
# Purpose: Find days left to expire the Linux user account
# Author: Vivek Gite {https://www.cyberciti.biz/} under GPL v2.x+ 
# ----------------------------------------------------------------
_user="${1?:User name missing. Bye}"
current_date="$(date +"%b %d, %Y")"
 
# Check for the root user 
if [[ $EUID -ne 0 ]]
then
	echo "Error: $0 - script must be run as root." 1>&2
	exit 1
fi
 
# Calculate the days between two Linux dates
calculate_days(){
	local e_date t1 t2 t_diff xdays
	# input 
	e_date="$1"
	# convert the dates to Unix timestamps:
	t1=$(date -d "$current_date" +%s) 
	t2=$(date -d "$e_date" +%s)
	# calculate the difference in Unix timestamps
	t_diff=$((t2 - t1))
	# convert the difference to days:
	xdays=$((t_diff / 86400)) 
	# print it
	echo "$xdays"
}
 
# Ensure user exits else die
if grep -q -w "^${_user}" /etc/passwd 
then
	account_expire_date=$(chage -l "$_user"	| awk -F':' '/Account expires/{ gsub(/^ /, "", $2); print $2}')
	password_expire_date=$(chage -l "$_user"| awk -F':' '/Password expires/{ gsub(/^ /, "", $2); print $2}')
 
	if [ "$account_expire_date" == "never" ] 
	then
		echo "Warning: $0 - account aging [account expire date] not set for the $_user account."
	else
		output=$(calculate_days "$account_expire_date")
		echo "The $_user account has $output day(s) left to expire their account."
	fi
 
	if [ "$password_expire_date" == "never" ] 
	then
		echo "Warning: $0 - account aging [password expire date] not set for the $_user account."
	else
		output=$(calculate_days "$password_expire_date")
		echo "The $_user account has $output day(s) left to expire their password."
	fi
 
else
	echo "Error: $0 - $_user username not found in the /etc/passwd file."
fi