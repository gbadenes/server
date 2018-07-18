# TCP Server Parser
Python Dockerized TCP server parser.

## Scope
The scope of the code is to deploy a Docker container in a given server (CentOS7/RHEL) that listens to port TCP 4321, parses the received messages and prints the timestamp and the message body in JSON to the stdout.

Format of the messages sent to the servers should have the following format:
```
[DD/MM/YYYY HH:MM] MESSAGE BODY
```
The output from the server will be like the following:
```
{"timestamp": "EPOCH", "message": "MESSAGE BODY", "hostname": "hostname", "container": "docker container"}
```
Example of use:
```
echo -n '[17/06/2018 12:30] Hello world!' | nc localhost 4321
```
Server output:
```
{"timestamp": "1529238600.0", "message": "Hello world!", "hostname": "my_server", "container": "817358119d9c"}
```
## Deployment of the server
In order to deploy the server Ansible configuration management tool has been used, there is a playbook that sets up the target CentOS server. It installs all the required dependencies and sets the environment for running the Docker container that runs the TCP server itself.

In order to deploy the solution first set up the target server ip in the inventory file:
```
[server]
192.168.10.10
```
Then run the ansible playbook:
```
ansible-playbook /ansible/deployServer.yml -i /ansible/inventory -u <username> -k -K
```
## Docker container
Once playbook is run, ssh to target server set up in the inventory file and check that the docker container is running:
```
docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.RunningFor}} ago\t{{.Status}}\t{{.Command}}' --filter status=running
```
Output should be like the following:
```
NAMES               IMAGE               CREATED             STATUS              COMMAND
myTCPserver         tcppython           39 minutes ago      Up 37 minutes       "python server.py"
```
Where it can be seen the image used to run the container, the name of the container etc. In order to test it the examples given in the Scope part can be used.

## Monitoring
The deployed server is provisioned with a monitoring tool that checks the status of the container. The container will be restarted automatically in case of failure, but if in the event that it gets exited for whatever reason the user will be notified by email. Email example:
Email Subject:
```
CRITICAL: Docker Container: myTCPserver NOT Running
````
Body:
```
Docker Container stopped:
NAMES               IMAGE               CREATED              STATUS                        COMMAND
myTCPserver         tcppython           About a minute ago   Exited (137) 30 seconds ago   "python server.py"
````
This is Health Check is done by a script that runs every 15 mins in crontab of root user, it accepts to parameters, one is the email address and the other one is the container name.
```
*/15 * * * * /root/deployment/healthCheck.sh my@email.com myTCPserver >/dev/null 2>&1
```
## SW versions
* ansible 2.6.0
* Docker version 1.13.1
* Python 2.7.5

## Notes
If server is given another string as input different to the following format:
```
[DD/MM/YYYY HH:MM] MESSAGE BODY
```
It wont promt any output or message you should Ctrl+c and send the message in the correct format.

