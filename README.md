# DockerBuild

This projects contains files you can kickstart your new Docker project with. It is designed for the purpuse of sharing builds of infra-system-parts, but not necessarily constrained to that.

## Files

### Makefile
The Makefile is suited to compress the basic docker commands for building and running containers. You can do things like this:
```
make test build run run="whoami"

# this shorter-cut should also just work
make run="whoami"
make run="/bin/bash"

# rebuild the whole thing, test and cleanup
make rebuild test clean
```

### Dockerfile 
Tiny Alpine (multi-stage) container with bash added for fun and practice. This includes automatic setup of USER/ UID within your container. This Dockerfile is meant to run along with the Makefile (variables are retrieved and re-exported from there), and meant to be modified to include your own work.

### docker-compose.yml
Like the Dockerfile, this file is also meant to go along with the Makefile and meant to get the basics of USER/ UID setup correctly.

## MORE
The use-case for this project will be discussed in an article on Medium soon. When this article gets published, the link will be copied here.
