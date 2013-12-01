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

	echo -e "pid2cmd version 0.1.2, by Josh Max (Bitwise) and Seth Johnson.\n"
	echo "ABOUT:" $0 "| Dumps the command used to execute a selected process."
	echo "USAGE:" $0 "-a, --all | List the commands of all processes."
	echo "      " $0 "--update (--force) | Check for updates to this script."
	echo "      " $0 "[PID]"

}

run_updater() {

	#Download and run the USU updater script
	if ! [ -w "/tmp/" ]; then

		echo "ERROR: /tmp/ is not writable! Cannot continue."
		return -1
	fi

	# Hard-coded program updater URL
	updater_url="https://raw.github.com/CP-Team-06-0003/Useful-Scripts/master/UsefulScriptUpdater/usu.sh"
	temp_usu_save_file="/tmp/usu_updater_$RANDOM.sh"
	curl $updater_url > $temp_usu_save_file
	chmod 755 $temp_usu_save_file

	# Start USU
	# Aguments: Remote Script Dir, Remote Script Filename, Local Script Filename, Arguments/(Git commit)
	bash -c "$temp_usu_save_file pid2cmd pid2cmd.sh $(readlink -f $0) $2"
	exit

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
