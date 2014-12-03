#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -e

if [ "$BZDB_PORT_3306_TCP_ADDR" == "" ]; then
    echo "Error: container invoked improperly. please link to a bzdb container"
    exit 1
fi

# Ensure Bugzilla Git clone is up to date
cd $BUGZILLA_HOME
/usr/bin/git pull --rebase

# We need to replace some variables in the config files first
sed -e "s?%BUGS_DB_DRIVER%?$BUGS_DB_DRIVER?g" --in-place checksetup_answers.txt
sed -e "s?%BUGS_DB_NAME%?$BUGS_DB_NAME?g" --in-place checksetup_answers.txt
sed -e "s?%BUGS_DB_PASS%?$BUGS_DB_PASS?g" --in-place checksetup_answers.txt
sed -e "s?%BUGS_DB_HOST%?$BZDB_PORT_3306_TCP_ADDR?g" --in-place checksetup_answers.txt
sed -e "s?%BUGZILLA_USER%?$BUGZILLA_USER?g" --in-place checksetup_answers.txt
sed -e "s?%BUGZILLA_URL%?$BUGZILLA_URL?g" --in-place checksetup_answers.txt
sed -e "s?%ADMIN_EMAIL%?$ADMIN_EMAIL?g" --in-place checksetup_answers.txt
sed -e "s?%ADMIN_PASSWORD%?$ADMIN_PASSWORD?g" --in-place checksetup_answers.txt
sed -e "s?%BUGZILLA_HOME%?$BUGZILLA_HOME?g" --in-place /etc/httpd/conf.d/bugzilla.conf
sed -e "s?%WEB_HOME%?$WEB_HOME?g" --in-place /etc/httpd/conf.d/bugzilla.conf
sed -e "s?User apache?User $BUGZILLA_USER?g" --in-place /etc/httpd/conf/httpd.conf
sed -e "s?Group apache?Group $BUGZILLA_USER?g" --in-place /etc/httpd/conf/httpd.conf

# If we start this and the BZDB container at the same time, MySQL may not be
# running yet. Wait for it.
sleep 5

# Run checksetup.pl twice
./checksetup.pl checksetup_answers.txt
./checksetup.pl checksetup_answers.txt

# Final permissions fix
/bin/chown -R $BUGZILLA_USER:$BUGZILLA_USER *

# Start
exec $@

