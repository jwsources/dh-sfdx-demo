#!/bin/bash

DURATION=1

if [ "$#" -eq 1 ]; then
  DURATION=$1
fi

sfdx force:org:delete -p -u dhpack
sfdx shane:org:create -u jwadmin -o whizzhouse.demo -a dhpack -d $DURATION -s -f config/project-scratch-def.json
#sfdx force:source:push
#sfdx force:user:permset:assign -n dreamhouse
sfdx force:org:list | grep dhpack
sfdx force:org:open -p /lightning/page/home
echo "Org is set up"
