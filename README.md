# TCP Server Parser
The scope of the code is to deploy a Docker container is a given server that listens to port 4321, parses the received messages and prints the timestamp and the message body in JSON to the stdout.

Format of the messages sent to the servers should have the following format:
```
[DD/MM/YYYY HH:MM] MESSAGE BODY
```
The Output from the server will be like the following:
```
{"timestamp": "EPOCH", "message": "MESSAGE BODY", "hostname": "hostname", "container": "docker container"}
```

