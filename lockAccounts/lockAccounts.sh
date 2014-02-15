#!/bin/bash

# lockAccounts
# Copyright (C) 2013 Seth Johnson and Josh Max
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

run_updater() {

	#Download and run the USU updater script
	if ! [ -w "/tmp/" ]; then

		echo "ERROR: /tmp/ is not writable! Cannot continue."
		return -1
	fi

	# Hard-coded program updater URL
	echo "Downloading updater..."
	updater_url="https://raw.github.com/CP-Team-06-0003/Useful-Scripts/master/UsefulScriptUpdater/usu.sh"
	temp_usu_save_file="/tmp/usu_updater_$RANDOM.sh"
	curl -# $updater_url > $temp_usu_save_file
	chmod 755 $temp_usu_save_file

	# Start USU
	# Aguments: Remote Script Dir, Remote Script Filename, Local Script Filename, Arguments/(Git commit)
	bash -c "$temp_usu_save_file lockAccounts lockAccounts.sh $(readlink -f $0) $2"
	exit

}

show_usage() {
	
	echo "Uses passwd -l to lock all the user accounts passed as arguments"

}

run() {
	
	for i in $@
	do
	
		echo "Locking $i"
		echo $(passwd -l $i)
	done
	
}

init() {
	
	if [ -z "$1" ]; then
	
		echo "No arguments provided!"
	elif [ "$1" = "--help" ]; then
	
		show_usage
	elif [ "$1" = "--update" ]; then

        run_updater "$1" "$2" # Check for script updates (Advanced options) force an update to a certain revision
	else
	
		run $@
	fi

}

init $@
