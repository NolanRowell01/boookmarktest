#!/bin/bash
# This script reindexes the profile manager database in OS X Server

# Moving this to launchd where it will run on a schedule as root
# test if run as sudo/root
#if [ $(whoami) != "root" ]; then
#        echo "Please run as sudo/root"
#        exit 1
#fi

# declare some variables
PGUSER=_devicemgr
PMSOCKET="/Library/Server/ProfileManager/Config/var/PostgreSQL/"
PSQL=/Applications/Server.app/Contents/ServerRoot/usr/bin/psql
TABLEFILE=/tmp/PMTables.txt

# stopping profile manager
#echo "Stopping Profile Manager..."
serveradmin stop devicemgr

# starting postgres
#echo "Starting PostgreSQL..."
serveradmin start postgres

# dig the different tables from the PSQL database and store it to TABLEFILE
$PSQL -c "SELECT table_name FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE';" -h $PMSOCKET -U $PGUSER -d devicemgr_v2m0 >> $TABLEFILE
# because the output is "ugly", make it usable by removing unnecessary stuff
# such as first two lines and the last two lines
sed -i "" -e '1,2d' -i "" -e '$!{N;N;H;}' $TABLEFILE

#the Table names should be of format name_of_the_table, thus readable simply with read
while read line; do
#	echo "Reindexing table public.$line..."
	$PSQL -U $PGUSER -h $PMSOCKET -d devicemgr_v2m0 -c "REINDEX table public.$line;"
done <$TABLEFILE

#echo "Reindexing complete, starting Profile Manager..."
serveradmin start devicemgr
exit 0
