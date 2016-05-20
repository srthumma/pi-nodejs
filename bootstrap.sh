#!/bin/bash -x


if [ -d /opt/apps/${GITHUB_PROJECT} ]
then
    echo "Project Directory exists.. backing up node_modules"  >> /logs/gitupdate.log
    mv /opt/apps/${GITHUB_PROJECT}/node_modules /opt/apps
    rm -rf /opt/apps/${GITHUB_PROJECT}
fi

GITHUB_AUTH_PREFIX=""
if [ ! -z "${GITHUB_TOKEN}" ]; then
    echo -e "************************************\nGitHub token: ${GITHUB_TOKEN}" `date` >> /logs/gitupdate.log
    GITHUB_AUTH_PREFIX=${GITHUB_TOKEN}"@"
fi

if [ ! -z "${GITHUB_PROJECT}" ] && [ ! -z "${GITHUB_USER}" ]; then
    echo -e "************************************\nGitHub User: ${GITHUB_USER} Project: ${GITHUB_PROJECT}" `date` >> /logs/gitupdate.log
    cd /opt/apps
    echo "Cloning project ${GITHUB_USER}:${GITHUB_PROJECT} " `date` >> /logs/gitupdate.log
    git clone --depth 1 https://${GITHUB_AUTH_PREFIX}github.com/${GITHUB_USER}/${GITHUB_PROJECT}.git
    echo "Cloning completed ${GITHUB_USER}:${GITHUB_PROJECT} " `date` >> /logs/gitupdate.log
    cd /opt/apps/${GITHUB_PROJECT}
    
    if [ -d /opt/apps/node_modules ]
    then
        echo "Restoring node_moudles folder" `date` >> /logs/gitupdate.log
        mv  /opt/apps/node_modules /opt/apps/${GITHUB_PROJECT}
    fi
    
    
    if [ ! -z "${NPM_ROOT_MODULES}" ]; then
      echo "Running npm" `date` >> /logs/gitupdate.log
      npm install -g ${NPM_ROOT_MODULES}
    fi
  
    npm install
    echo "NPM Completed" `date` >> /logs/gitupdate.log
else
   echo "GITHUB USER:${GITHUB_USER} or Project:${GITHUB_PROJECT} not set" >> /logs/gitupdate.log
fi

    
# exec CMD
echo ">> exec docker CMD"
echo "$@"
"$@"
