# TCP Server Parser
Python TCP server parser.

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
# Deployment of the server
In order to deploy the server Ansible(2.6.0) configuration management tool has been used, there is a playbook that sets up the target CentOS server. It installs all the required dependencies (Docker and mailx) and sets the environment for running the Docker container that runs the TCP server itself.

In order to deploy the solution first set up the target server ip in the inventory file:
```
[server]
192.168.10.10
```
Then run the ansible playbook:
```
ansible-playbook /ansible/deployServer.yml -i /ansible/inventory -u <username>
```


# SW versions
* ansible 2.6.0
* Docker version 1.13.1
* Python 2.7.5


