# traditional-ha
Docker compose setup for a traditional Cloudbees CI installation in HA (active/active) mode

## TLDR
- `up.sh` to start
- `down.sh` to stop
- `delete_volumes.sh` to cleanup
- See [How to operate](#operate) section below


## Intro
The setup consists of the following containers:
- Operations center
- Controller 1
- Controller 2
- SSH-Agent 1
- HAProxy Load Balancer
- Linux box with Firefox accessible via VNC from an external browser

The setup is self sufficient and does not require any modifications on the Docker host or anywhere else outside of the docker compose environment, except for the persistence - local paths on the docker host are used as persistence volumes. NFS volumes are not used at the moment.
Controller 1 and Controller 2 share the same $JENKINS_HOME dir.

The Operations Center and both controllers are behind HAProxy. 
- If a request comes to HAProxy with $OC_URL host header, it is forwarded to the operations center container
- If a request comes with $CLIENTS_URL host header, it is load balanced between all client controllers
- The load balancing for client controllers has sticky sessions enabled

## Prerequisites

- Docker engine
- Enough disk space on Docker host to keep $JENKINS_HOME folders of the operations center and controllers (typically 2-3GB for demo purposees)
- Enough RAM to run the OC and both client controllers (1-2GB each for demo purposes)
- If you want to access the OC and controllers from outside, ex. your laptop's browser, you need to have port 80 free on your Docker host so that HAProxy can be exposed on it. If you don't want it exposed, comment the line in docker-compose.yaml.template
- 
  
## Files

### env.sh
Used to define some environment variables used in docker-compose.yaml.template

- `OC_URL` is the URL you want the operations center to respond on.
- `CLIENTS_URL` is for the controllers. There is only one URL for both controllers.
- `DOCKER_IMAGE_OC` and `DOCKER_IMAGE_CLIENT` are the CB CI versions on operations center and controllers
- `IP_PREFIX` is a prefix for the internal docker compose network
- `PERSISTENCE_PREFIX` is the path for the persistence volumes on the docker host

### docker-compose.yaml.template
This template is used to render the `docker-compose.yaml` file using the environment variables in `env.sh`. Please do not modify docker-compose.yaml directly, since it will be overwritten by `up.sh`. Modify this template instead.
  
### up.sh
A helper script.
- Creates the persistence volumes
- Renders the docker-compose.yaml from the template.
  - `sudo` is used to create the persistence volumes and assign the permissions.
- Runs `docker compose up`

## Deploy
- Examine `env.sh` and modify if needed.
- Examine `docker-compose.yaml.template` and modify if needed.
- Run `up.sh` .

## Operate <a id="operate"></a>
The `browser` container exposes port 6080 to the docker host. 
To access the Operations Center:
- open a browser on your laptop and point it to http://docker-host-ip:6080. This will open a VNC session to the Linux container.
- From the start menu open Firefox browser.
- Point the Firefox browser to http://$OC_URL  (by default this is http://oc.ha/ )
- In the Operations Center, create a client controller item.
- Push the configuration to http://$CLIENTS_URL  (by default this is http://client.ha/ )
- Try to access http://$CLIENTS_URL/ in Firefox (VNC)
- Install HA plugin (active/active) on http://$CLIENTS_URL/
- Controller 2 will begin starting when controller 1 is ready
- You can see the HA status in the controllers` Manage Jenkins section

If you don't want to use the provided browser container, you could use a browser on your laptop, but you need to put $OC_URL and $CLIENTS_URL in your `hosts` file, pointing to the Docker host IP address. HAProxy is exposed to the Docker host on port 80 by default.


### Agent (optional)

Create a key pair with: `ssh-keygen -t rsa -f agent-key`

Put the contents of agent-key.pub in the env var JENKINS_AGENT_SSH_PUBKEY in docker-compose.yaml.template.
Use the private part in the Controller when defining credentials to connect to the agent.
Choose credentials with username and private key. Username is jenkins.

## Stop
Run `down.sh`. This will issue docker compose down to stop the running containers.

## Clean up
- Stop the running containers using `down.sh`. Then,
- Run `delete_volumes.sh`. This will delete the persistence directories on the host (docker volumes)
 


## TODO
- CasC
- Automate agent
  - Creating agent key pair in up.sh
  - Fill the public part automatically in docker compose template (with envsubst in up.sh)
- SSL
