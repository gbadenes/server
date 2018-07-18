#!/bin/bash

# Monitor status of given Docker container
# If status is Exited send an email to given email address as argument
# example: ./healthCheck.sh <your@email.com>

# Check there are arguments
if [ $# -eq 0 ]
then
  echo "Missing arguments."
  echo "Usage: $0 <your@email.com> <docker container NAME>"
  exit 1
fi

# Check email address has correct format
if [[ "$1" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$ ]]
then
    echo "Email alerts will be sent to: $1"
else
    echo "Email address $email is invalid."
    echo "Usage: $0 <your@email.com> <docker container NAME>"
    exit 1	
fi

# Check docker container Name is not empty
if [ -z "$2" ]
  then
    echo "No Docker container name supplied"
    echo "Usage: $0 <your@email.com> <docker container NAME>"
    exit 1
fi

# Check status of TCPserver Container, if status is Exited send email alert.
if [ $(docker ps -a --filter status=exited | grep $2 | wc -l)  -eq 1 ]
then
    # Email Body to file
    echo "Docker Container stopped:" > /tmp/body.dat
    docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.RunningFor}} ago\t{{.Status}}\t{{.Command}}' --filter status=exited --filter name=$2 >> /tmp/body.dat
    # Send Email
    /usr/bin/mail -s "CRITICAL: Docker Container: $2  NOT Running" $1 < /tmp/body.dat
fi
