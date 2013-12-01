#!/bin/bash

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
	else 
	
		run $@
	fi

}

init $1
