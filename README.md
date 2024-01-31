# traditional-ha
Docker compose setup for a traditional Cloudbees CI installation in HA (active/active) mode

## Intro
The setup consists of the following containers:
- Operations center
- Controller 1
- Controller 2
- SSH-Agent 1
- HAProxy Load Balancer
- Linux box with Firefox accessible via VNC from an external browser

The setup is self sufficient and does not require any modifications on the Docker host or anywhere else outside of the docker compose environment, except for the persistence - local paths on the docker host are used as persistence volumes. NFS volumes are not used at the moment.

The Operations Center and both controllers are behind HAProxy. 
- If a request comes to HAProxy with $OC_URL host header, it is forwarded to the operations center container
- If a request comes with $CLIENTS_URL host header, it is load balanced between all client controllers
- The load balancing for client controllers has sticky sessions enabled

### env.sh
- `OC_URL` is the URL you want the operations center to respond on.
- `CLIENTS_URL` is for the controllers. There is only one URL for both controllers.
- `DOCKER_IMAGE_OC` and `DOCKER_IMAGE_CLIENT` are the CB CI versions on operations center and controllers
- `IP_PREFIX` is a prefix for the internal docker compose network
- `PERSISTENCE_PREFIX` is the path for the persistence volumes on the docker host

### docker-compose.yaml.template
This template is used to render the `docker-compose.yaml` file using the environment variables in `env.sh`. Please do not modify docker-compose.yaml directly, since it will be overwritten by `up.sh`. Modify this template instead.
  
### up.sh
A helper script to:
- Create the persistence volumes
- Render the docker-compose.yaml from the template.
  - `sudo` is used to create the persistence volumes and assign the permissions.
- Run `docker compose up`

## Deploy
- Examine `env.sh` and modify if needed.
- Examine `docker-compose.yaml.template` and modify if needed.
- Run `up.sh`. 

## Stop
Run `down.sh`. This will issue docker compose down to stop the running containers.

## Clean up
- Stop the running containers using `down.sh`. Then,
- Run `delete_volumes.sh`. This will delete the persistence directories on the host (docker volumes)
