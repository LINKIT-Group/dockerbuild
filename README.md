# DockerBuild
This projects contains files you can kickstart your new Docker project with. It is designed for the purpuse of sharing builds of infra-system-parts, but not necessarily constrained to that.

## Files

### Makefile
The Makefile is suited to compress the basic docker commands for building and running containers. You can do things like this:
```
make rebuild test shell cmd="whoami"

# these shortcuts also work
make cmd="whoami"
make shell

# rebuild the whole thing, test and cleanup
make rebuild test clean

make help
# Usage: make [TARGET] [EXTRA_ARGUMENTS]
# Targets:
#   build    	build docker --image-- for current user
#   rebuild  	rebuild docker --image-- for current user
#   test     	test docker --container-- for current user
#   service   	run as service --container-- for current user
#   login   	run as service and login --container-- for current user
#   clean    	remove docker --image-- for current user
#   prune    	shortcut for docker system prune -af. Cleanup inactive containers and cache.
#   shell      run docker --container-- for current user
#
# Extra arguments:
# cmd=:	make cmd="whoami"
# # user= and uid= allows to override current user. Might require additional privileges.
# user=:	make shell user=root (no need to set uid=0)
# uid=:	make shell user=dummy uid=4000 (defaults to 0 if user= set)
```

### Dockerfile 
Small Alpine (multi-stage) container with bash added for fun and practice. This includes automatic setup of USER/ UID within your container. This Dockerfile is meant to run along with the Makefile (variables are retrieved and re-exported from there), and meant to be modified to include your own work.

### docker-compose.yml
Like the Dockerfile, this file is also meant to go along with the Makefile and meant to get the basics of USER/ UID setup correctly.

## More
The use-case for this project will be discussed in an article on Medium soon. When this article gets published, the link will be copied here.
