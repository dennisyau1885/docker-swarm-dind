DOCKER_MANAGER=docker exec -it manager1
DOCKER_WORKER1=docker exec -it worker1
DOCKER_WORKER2=docker exec -it worker2
all: up

restart: down up
up:
	docker compose up -d
	sleep 2
	$(DOCKER_MANAGER) docker swarm init
	$(DOCKER_MANAGER) sh -c "docker swarm join-token -q worker >/swarm/token"
	sleep 1
	$(DOCKER_WORKER1) sh -c 'docker swarm join --token $$(cat /swarm/token) manager1:2377'
	sleep 1
	$(DOCKER_WORKER2) sh -c 'docker swarm join --token $$(cat /swarm/token) manager1:2377'
	$(DOCKER_MANAGER) docker run -it -d -p 8081:8080 -v /var/run/docker.sock:/var/run/docker.sock dockersamples/visualizer
	$(DOCKER_MANAGER) docker service create --name backend --replicas 2 --publish 8080:80 nginxdemos/hello:plain-text

# `watch make watch` in a seperate window
watch: curl
	docker ps
	$(DOCKER_MANAGER) docker node ls
	$(DOCKER_MANAGER) docker service ps backend

curl:
	curl --max-time 1 -s localhost:8080 |grep name

# {worker1,worker2,manager1}_{up,down}
%_up:
	docker unpause $$(basename $@ _up)
%_down:
	docker pause $$(basename $@ _down)

scale_%:
	$(DOCKER_MANAGER) docker service scale backend=$$(echo $@ |cut -d_ -f2)

rebalance:
	$(DOCKER_MANAGER) docker service update --force backend

down:
	docker compose down
