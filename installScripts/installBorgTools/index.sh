#!/bin/bash
set -e 

BORG_REPO=$(jq -r '.borgRepo' config.json)

if [[ $BORG_REPO = '' ]] || [[ $BORG_REPO = 'null' ]]; then
    echo "No borg repo set in config.json"
    echo "Skipping install of borg tools and systemd borg services"
    exit 0
fi

# This script has some dependencies before it can be run that must be run at least
# once:
#  * /configScripts/setup-borg-env.sh -- Runs early on in /index.js to collect the password.
#  * In /index.js, this must run *after* borg is installed.
#  * configScripts/link-configs.sh must run before this to set up the systemd units.

sudo cp installScripts/installBorgTools/borg-home-backup.sh /usr/local/bin

systemctl --user enable borg-home-backup.timer
systemctl --user start borg-home-backup.timer