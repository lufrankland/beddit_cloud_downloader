#!/bin/bash

# This script was created as Beddit was saying they were taking their web services offline
# and with that, all likely hope of getting raw access to your sleep data now that the 
# almighty Apple corp own them outright.
# 
# I am also looking at making my own self-hosted version for monitoring sleep info but
# its like most developer side projects, half-finished.
# 
# I would say if I've helped you, donate some bitcoin over to:
# bitcoin:1NEJcdBSbmGnsihKUiK5h4XrQ8rA3r4tgk
# 
# If you don't want to donate, thats cool too - you do you!
# 
# Now onto the script!

echo '-----------------------'
echo ' Running Beddit Script'
echo '-----------------------'
echo $' Made hastily by @ne0 \n\n'

# Your beddit cloud username
BEDDIT_USERNAME=youremail@address.com

# Your beddit cloud password
BEDDIT_PASSWORD=SuPerTopSecret

# Limit per page so as to not hit the 60s timeout
SESSION_LIMIT=200

# Api types to get. Sleep and Session are the only worthwhile ones
DATA_TYPES=("sleep" "session")

# Name of the folder you will be saving this to
DATA_FOLDER=raw_export_files

# Regex that will be used to parse the next date and prevent duplicates/loops
REGEX_FOR_PAGING='s/^.*\"updated\": ([0-9]+).*$/\1/'

##############################################
# You don't have to edit past here really    #
# All the hard work is over.                 #
# Fill up the folder this is in with data    #
##############################################

# Lets log you in and get your beddit API token! We'll do it silently to look slick (pretend it's not just cURL)
BEDDIT_LOGIN_RESPONSE=$(curl -s https://cloudapi.beddit.com/api/v1/auth/authorize -H 'Host: cloudapi.beddit.com' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'User-Agent: Beddit/423 CFNetwork/897.15 Darwin/17.5.0' -H 'Accept: */*' -H 'Accept-Language: en-gb' -H 'Authorization: Application beddit:x5Q6w68KwwTZ3bD8rAPO427j' -H 'BEDDIT_APP_VERSION: iOS 2.9.0 (423)' --data-binary "username="$BEDDIT_USERNAME"&password="$BEDDIT_PASSWORD"&agreements=privacy_policy%2C%20terms_and_conditions%2C%20data_collection&grant_type=password")

# Gets the auth token
BEDDIT_TOKEN=$($BEDDIT_LOGIN_RESPONSE | sed -E 's/^.*\"access_token\": \"([a-zA-Z0-9]+)\".*$/\1/')

# Gets the user id for the REST commands
BEDDIT_USER_ID=$($BEDDIT_LOGIN_RESPONSE | sed -E 's/^.*\"user\": ([0-9]+).*$/\1/')

# If you don't get a token, your credentials are incorrect so display an error message
if [ ${#BEDDIT_TOKEN} -gt 32 ]; then echo "Your credentials are incorrect. Please edit this bash file with your correct credentials you use to login to Beddit within the app" ; exit 1
else echo "We have logged you in with the username "$BEDDIT_USERNAME" and have been given the token '"$BEDDIT_TOKEN"' for all future requests"
fi

for CURRENT_FILE_TYPE in ${DATA_TYPES[@]};
do

	# Set the first date you want - I'm just setting it back to before Beddit began
	CURRENT_PAGINATION_DATE=1293840000

	mkdir -p $DATA_FOLDER

	while [ 1 ]; do

		echo "Downloading "$SESSION_LIMIT" "$CURRENT_FILE_TYPE" records from Beddit's Servers for the date starting "$(date -r "$CURRENT_PAGINATION_DATE")$'\n'

		SECTION_FILENAME=$DATA_FOLDER"/"$CURRENT_FILE_TYPE".after."$CURRENT_PAGINATION_DATE"."$SESSION_LIMIT".json"

		curl -H 'Host: cloudapi.beddit.com' -H 'Accept: */*' -H 'User-Agent: Beddit/423 CFNetwork/897.15 Darwin/17.5.0' -H 'Authorization: UserToken '$BEDDIT_TOKEN -H 'Accept-Language: en-gb' -H 'BEDDIT_APP_VERSION: iOS 2.9.0 (423)' --compressed 'https://cloudapi.beddit.com/api/v1/user/'$BEDDIT_USER_ID'/'$CURRENT_FILE_TYPE'?updated_after='$CURRENT_PAGINATION_DATE'&limit='$SESSION_LIMIT -o $SECTION_FILENAME

		echo "" # Laziest method for a newline ever but I just want my data out ASAP so this will do!


		CURRENT_PAGINATION_DATE=$(cat $SECTION_FILENAME | sed -E "${REGEX_FOR_PAGING}" )

		# Calculate the filesize from last download
		LAST_FILE_SIZE=$(du -s $SECTION_FILENAME | cut -f1)


		if [ "$LAST_FILE_SIZE" -lt "20" ] || [ $CURRENT_PAGINATION_DATE == "[]" ];
		then
			printf "\n\nThe last file has been downloaded\n\n"
			rm $SECTION_FILENAME
			break
		fi

		# Fix for rounding errors on timestamp decimals
		CURRENT_PAGINATION_DATE=$((CURRENT_PAGINATION_DATE + 1))
	done;

	echo "----------------------------------------------------------------------"
	echo " Completed Download of "$FILE_COUNT" "$CURRENT_FILE_TYPE" files"
	echo "----------------------------------------------------------------------"

done;