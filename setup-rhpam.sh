#!/bin/bash

OCP_PROJECT=""

if [ -z "$1" ]
  then
    echo USAGE:setup-rhpam.sh {OCP_PROJECT_NAME}
    echo "OCP_PROJECT_NAME will be automatically created"
    exit
else
    OCP_PROJECT=$1
    echo "OCP_PROJECT: " $OCP_PROJECT
fi

# create the project
oc new-project $OCP_PROJECT

# get the required rhpam image streams
oc create -f https://raw.githubusercontent.com/jboss-container-images/rhpam-7-openshift-image/rhpam70-dev/rhpam70-image-streams.yaml

# get the templates for the rhpam instances
oc create -f https://raw.githubusercontent.com/jboss-container-images/rhpam-7-openshift-image/rhpam70-dev/templates/rhpam70-trial-ephemeral.yaml

# create the apps in your project
# NOTE YOU NEED TO SET THE IMAGE_STREAM_NAMESPACE since all the image streams are local to 
# your project
oc new-app --name=pam-ephemeral --template=rhpam70-trial-ephemeral -p IMAGE_STREAM_NAMESPACE=${OCP_PROJECT}  -p IMAGE_STREAM_TAG=1.1
