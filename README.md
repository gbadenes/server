# TCP Server Parser
Python TCP server parser

## Scope
The scope of the code is to deploy a Docker container is a given server (centos 7/RHEL) that listens to port TCP 4321, parses the received messages and prints the timestamp and the message body in JSON to the stdout.

Format of the messages sent to the servers should have the following format:
```
[DD/MM/YYYY HH:MM] MESSAGE BODY
```
The output from the server will be like the following:
```
{"timestamp": "EPOCH", "message": "MESSAGE BODY", "hostname": "hostname", "container": "docker container"}
```
Example:
```
echo -n '[17/06/2018 12:30] Hello world!' | nc localhost 4321
```
Server output:
```
{"timestamp": "1529238600.0", "message": "Hello world!", "hostname": "vps487290.ovh.net", "container": "817358119d9c"}
```


