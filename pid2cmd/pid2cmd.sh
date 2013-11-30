#!/bin/bash
 
# pid2cmd
# Copyright (C) 2013 Josh Max
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

show_usage(){

	echo -e "pid2cmd version 0.1.1, by Josh Max (Bitwise) and Seth Johnson.\n"
	echo "ABOUT:" $0 "| Dumps the command used to execute a selected process."
	echo "USAGE:" $0 "-a, --all | List the commands of all processes."
	echo "      " $0 "--update (--force) | Check for updates to this script."
	echo "      " $0 "[PID]"

}

run_updater() {

	# This is a really, really big function, but it shouldn't be spaghetti code
	# If you think that you've found some minified code that does the same thing,
	# Just tell me in the GitHub issue tracker. -Josh
	# Check to see if we have read/write permissions for the updater
	if ! [ -w "/tmp/" ]; then
		echo "ERROR: /tmp/ is not writable! Cannot continue."
		return -1
	elif ! [ -w $0 ]; then
		echo "ERROR: The file $0 is not writable! Cannot continue."
		return -1
	fi

	# Begin main updater function code
	strlength=$(echo $2 | wc -c)
	if ! [ -z "$2" ] && [ "$2" != "--force" ] && [ "$strlength" = "41" ]; then # strlength = sizeof(sha1sum) + "\0"
		# TODO
		ls > /dev/null # Delete this
	else
		# Hard-coded program updates URL
		updates_url="https://raw.github.com/CP-Team-06-0003/Useful-Scripts/master/pid2cmd/pid2cmd.sh"
		temp_save_file="/tmp/pid2cmd-update-data_$RANDOM.sh"
		curl $updates_url > $temp_save_file # Graham was here
		if [ "$2" = "--force" ]; then # Check if the user wants to force an update
			echo "WARNING: Forcing update... Your cat and/or computer might spontaneously combust!"
			cp $temp_save_file $0
			echo "UPDATE COMPLETE! I think."
		# Use md5sum to see if the script needs an update
		compstr1=$(md5sum $temp_save_file | cut -b-32)
		compstr2=$(md5sum $0 | cut -b-32)
		elif [ $compstr1 != $compstr2 ]; then
			echo "INFO: Update found... Type 'y' to apply it!"
			read -n 1 input # Check and see if the user wants to continue
			if [ $input = "y" ]; then # All hail the nested if statements
				echo -e "\nUPDATING..."
				# Run a simple sanity check to see if the file downloaded correctly
				if [ $(head -n 1 $temp_save_file) != "#!/bin/bash" ]; then
					echo "ERROR: Download sanity check failed. Check your internet connection."
					echo "If you are positive that this occured in error, please file a bug report."
				else # Houston, we're good here
					cp $temp_save_file $0
					echo "UPDATE COMPLETE! I think."
				fi
			else
				echo -e "\nAbort."
			fi
		else
			echo "No updates found, sorry."
			echo "If you are positive that this occured in error, please file a bug report."
		fi
		rm $temp_save_file # Clean-up
	fi

}

get_cmd() {

	# Make sure the argument is an integer
	if ! [ ! -z "${1###[!0-9]#}" ]; then
		echo -e "Error, argument is not a valid PID!\n"
		show_usage;
	else
		if ! [ -f "/proc/$1/cmdline" ]; then # Check if the PID exists
			echo "Error proccessing PID $1. File does not exist."
		else
			cat /proc/$1/cmdline | sed 's/\x0/ /g' | strings # Strip out null characters
		fi
	fi

}

get_all_cmds() {
    
    for i in $(ps -Ao pid); do
        if [ $i != "PID" ]; then # TODO: MAKE THIS LESS HACKISH!
        	echo $($0 $i) | sed '/^$/d'  # Evaluate PID's bin and add it to output.txt for further processing (below)
        fi
    done

}

init() {

	if [ -z "$1" ]; then
		show_usage # Argument paramater can not be empty
	elif [ "$1" = "-a" ] || [ "$1" = "--all" ]; then
        get_all_cmds # Print out the commands of all processes
	elif [ "$1" = "--update" ]; then
        run_updater "$1" "$2" # Check for script updates (Advanced options) force an update to a certain revision
    else
		get_cmd "$1"
	fi

}

init "$1" "$2" # Intitialize Pid2Cmd