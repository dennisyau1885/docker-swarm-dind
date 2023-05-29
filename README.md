# Docker Swarm POC
Create a docker swarm of 1 manager and 2 worker nodes using dind (docker in docker)

## Start up swarm, with `backend` service of 2 nginx/hello containers
```
make up
```

## Watch services
```
open http://localhost:8081 # opens visualiser in browser
open http://localhost:8080 # opens nginx/hello in browser (container server name doesn't change?)
make watch                 # open CLI visualiser, see container server name change
```
## Test endpoint
```
make curl
```
## Scale services
```
make scale_${X}  # where X is in {0..4}
```
## start/stop nodes
```
make ${NODE}_${UP_OR_DOWN}
e.g.
make worker1_up
make worker2_down
```
## Rebalance service across nodes
```
make rebalance
```
## Shutdown
```
make down
```

## Inspiration
https://xxradar.medium.com/running-docker-swarm-s-in-docker-on-mac-4dad93800274
