#includes for TimeZones scripts

#Working Directories
TZWD="$HOME/Library/Caches/com.runningwithcrayons.Alfred-3/Workflow Data/carlosnz.timezones"
TZPREFS="$HOME/Library/Application Support/Alfred 3/Workflow Data/carlosnz.timezones"

CONFIG_EXTRA="$TZPREFS/configExtra"

function storePreference() {
   NAME=$1
   VALUE=$2
   
   grep -v "${NAME}|" "${CONFIG_EXTRA}" > /tmp/timezone.tmp
   
   echo "${NAME}|${VALUE}" >> /tmp/timezone.tmp
   
   cat /tmp/timezone.tmp > "${CONFIG_EXTRA}"
}

function getPreference() {
   NAME=$1
   DEFAULT=$2

   VALUE=$(grep "${NAME}|" "${CONFIG_EXTRA}" | awk -F"|" '{print $2}')
   
   VALUE=${VALUE:-"$DEFAULT"}
   echo "$VALUE"
}

#Enable aliases for this script
shopt -s expand_aliases

#Case-insensitive matching
shopt -s nocasematch

#First run check
if [ ! -e "$TZPREFS/config-1-5" ]; then
	old_timezone_file=$(cat "$TZPREFS/config")
	mv -f "$old_timezone_file" "$HOME/Desktop/timezones_OLD.txt"
	
	mkdir "$TZPREFS"
	cp default_timezones.txt "$TZPREFS/timezones.txt"
	rm "$TZPREFS"/config*
	echo "$TZPREFS/timezones.txt" > "$TZPREFS/config-1-5"
fi

#Load path to the user's timezones.txt file.
timezone_file=$(cat "$TZPREFS/config-1-5")

#Does the file actually exist?
if [ ! -e "$timezone_file" ]; then
	#If not, recreate it from defaults
	cp default_timezones.txt "$TZPREFS/timezones.txt"
	echo "$TZPREFS/timezones.txt" > "$TZPREFS/config-1-5"
	timezone_file=$(cat )
fi

if ! grep 'Version2.0' "$TZPREFS/timezones.txt" > /dev/null
then
	cp default_timezones.txt "$TZPREFS/timezones.txt"
fi


# Create an empty file (extra configuration) if it does not exist

if [[ ! -e "${CONFIG_EXTRA}"  ]]; then
	touch "${CONFIG_EXTRA}"
fi

TIME_FORMAT=$(getPreference "TIME_FORMAT" "24h" )
