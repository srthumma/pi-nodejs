#!/bin/bash -x

cd /opt/apps/${GITHUB_PROJECT}
npm install

if [ ! -z "${SETUP_SCRIPT}" ] && [ -f ${SETUP_SCRIPT} ];
then
    echo -e "------------\n executing setup script: ${SETUP_SCRIPT}" `date`  >> /logs/startapp.log
    cat $SETUP_SCRIPT >> /logs/startapp.log
    ${SETUP_SCRIPT} >> /tmp/setup_script.log
else
   echo " Script: ${SETUP_SCRIPT} is not set or does not exist" >> /logs/startapp.log
fi

exec node server.js
