#!/bin/bash

# USU, the Useful Script Updater
# Copyright (C) 2013 Josh Max & Rainbowdash
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

usu_do_update() {

	# Tell the user that USU is starting
	echo "Starting the Useful Script Updater..."

	# This is a really, really big function, but it shouldn't be spaghetti code
	# If you think that you've found some minified code that does the same thing,
	# Just tell me in the GitHub issue tracker. -Josh
	# Check to see if we have read/write permissions for the updater
	if ! [ -w "/tmp/" ]; then

		echo "ERROR: /tmp/ is not writable! Cannot continue."
		return -1
	elif ! [ -w "$3" ]; then

		echo "ERROR: The file $3 is not writable! Cannot continue."
		return -1
	fi

	# Begin main updater function code
	strlength=$(echo $4 | wc -c)
	if ! [ -z "$4" ] && [ "$4" != "--force" ] && [ "$strlength" = "41" ]; then # strlength = sizeof(sha1sum) + "\0"

		# TODO
		echo "Updating to specific revisions is not yet implemented. Sorry."
	else

		# Hard-coded program updates URL
		echo "Downloading file and checking for update..."
		updates_url="https://raw.github.com/CP-Team-06-0003/Useful-Scripts/master/$1/$2"
		temp_save_file="/tmp/$(echo "$2" | cut -d'.' -f1)-update-data_$RANDOM.sh"
		curl -# $updates_url > $temp_save_file # Graham was here

		# Get the md5sums of the two scripts
		compstr1=$(md5sum $temp_save_file | cut -b-32)
		compstr2=$(md5sum $3 | cut -b-32)

		if [ "$2" = "--force" ]; then # Check if the user wants to force an update

			echo "WARNING: Forcing update... Your cat and/or computer might spontaneously combust!"
			cp $temp_save_file $3
			echo "UPDATE COMPLETE! I think."

		# Use md5sum to see if the script needs an update
		elif [ "$compstr1" != "$compstr2" ]; then

			echo "INFO: Update found... Type 'y' to apply it!"
			read -n 1 input # Check and see if the user wants to continue

			if [ $input = "y" ]; then # All hail the nested if statements

				echo -e "\nUPDATING..."
				# Run a simple sanity check to see if the file downloaded correctly

				if [ $(head -n 1 $temp_save_file) != "#!/bin/bash" ]; then

					echo "ERROR: Download sanity check failed. Check your internet connection."
					echo "If you are positive that this occured in error, please file an USU bug report."
				else # Houston, we're good here

					cp $temp_save_file $3
					echo "UPDATE COMPLETE! I think."
				fi
			else

				echo -e "\nAbort."
			fi
		else

			echo "No updates found, sorry."
			echo "If you are positive that this occured in error, please file a bug report."
		fi

		# Clean-up
		rm $temp_save_file
		echo "Thanks for using USU!"
		rm $0 && $("$3") # All done here
	fi

}

usu_do_update "$1" "$2" "$3" "$4" # Remote Script Dir, Remote Script Filename, Local Script Filename, Arguments/(Git commit)
