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

	echo -e "pid2cmd, by Josh Max (Bitwise).\n"
	echo "ABOUT:" $0 "| Dumps the command used to execute a selected process."
	echo "USAGE:" $0 "[PID]"

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

init() {

	if [ -z "$1" ]; then
		show_usage # Argument paramater can not be empty
	else
		get_cmd "$1"
	fi

}

init "$1" # Intitialize Pid2Cmd