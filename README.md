# traditional-ha
Docker compose setup for a traditional Cloudbees CI installation in HA (active/active) mode

## Intro
The setup consists of the following containers:
- Operations center
- Controller 1
- Controller 2
- SSH-Agent 1
- HAProxy Load Balancer
- Browser

The setup does not require any modifications on the Docker host or anywhere else outside of the docker compose environment. Local paths on the docker host are used as persistence volumes on the controllers. The Operations Center and both controllers are behind HAProxy. 

## Deploy
Examine `env.sh` and modify if needed.
- `OC_URL` is the URL you want the operations center to respond on.
- `CLIENTS_URL` is for the controllers. There is only one URL for both controllers.
- `DOCKER_IMAGE_OC` and `DOCKER_IMAGE_CLIENT` are the CB CI versions on operations center and controllers
- `IP_PREFIX` is a prefix for the internal docker compose network
- `PERSISTENCE_PREFIX` is the path for the persistence volumes on the docker host

Examine `docker-compose.yaml.template` and modify if needed.
This template is used to render the `docker-compose.yaml` file using the environment variables in `env.sh`. Please do not modify docker-compose.yaml directly, since it will be overwritten by `up.sh`.

To deploy the setup, just run `up.sh`. This is a helper script to create the persistence volumes and render the docker-compose.yaml from the template. `sudo` is used to create the persistence volumes and assign the permissions.
