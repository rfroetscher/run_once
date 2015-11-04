# Run Once

This is an experimental proof of concept for a super simple bash script to run a given container if there are containers running on an EC2 instance aside from the ecs-agent.

Think sumologic collector, cadvisor, or others that you want to ensure are running on an instance where your other containers are running. However, you don't want to add them to your task definitions because you don't want to end up with more than one of them.

Pass the image name and the startup command of the conatiner you'd like to start if there are other containers running, like:
```
 docker run -v /var/run/docker.sock:/var/run/docker.sock  \
            -v $(which docker | awk '{print $NF}'):/bin/docker  \
            -it \
            run_once:latest \
            bash run_once.sh -i nginx:latest -s 'docker run -d nginx:latest'

```

Make sure you mount the docker binary and the docker socket as shown above so the container can communicate with the docker daemon.
