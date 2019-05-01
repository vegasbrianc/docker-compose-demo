# docker-compose scaling web service demo
A short demo on how to use docker-compose to create a Web Service connected to a load balancer and a Redis Database. Be sure to check out my blog post on the full overview - [brianchristner.io](https://www.brianchristner.io/how-to-scale-a-docker-container-with-docker-compose/)

# Install
The instructions assume that you have already installed [Docker](https://docs.docker.com/installation/) and [Docker Compose](https://docs.docker.com/compose/install/). 

In order to get started be sure to clone this project onto your Docker Host. Create a directory on your host. Please note that the demo webservices will inherit the name from the directory you create. If you create a folder named test. Then the services will all be named test-web, test-redis, test-lb. Also, when you scale your services it will then tack on a number to the end of the service you scale. 

    
    git clone https://github.com/vegasbrianc/docker-compose-demo.git .
    

# How to get up and running
Once you've cloned the project to your host we can now start our demo project. Easy! Navigate to the directory in which you cloned the project. Run the following commands from this directory 
    

    docker-compose up -d

The  docker-compose command will pull the images from Docker Hub and then link them together based on the information inside the docker-compose.yml file. This will create ports, links between containers, and configure applications as requrired. After the command completes we can now view the status of our stack

    docker-compose ps

Verify our service is running by either curlng the IP from the command line or view the IP from a web browser. You will notice that the each time you run the command the number of times seen is stored in the Redis Database which increments. The hostname is also reported.

###Curling from the command line
    
    ```
    curl -H Host:whoami.docker.localhost http://127.0.0.1
    
    Hostname: 2e28ecacc04b
    IP: 127.0.0.1
    IP: 172.26.0.2
    GET / HTTP/1.1
    Host: whoami.docker.localhost
    User-Agent: curl/7.54.0
    Accept: */*
    Accept-Encoding: gzip
    X-Forwarded-For: 172.26.0.1
    X-Forwarded-Host: whoami.docker.localhost
    X-Forwarded-Port: 80
    X-Forwarded-Proto: http
    X-Forwarded-Server: a00d29b3a536
    X-Real-Ip: 172.26.0.1
    ``` 
    
It is also possible to open a browser tab with the URL `http://whoami.docker.localhost/`

# Scaling
Now comes the fun part of compose which is scaling. Let's scale our web service from 1 instance to 5 instances. This will now scale our web service container. We now should run an update on our stack so the Loadbalancer is informed about the new web service containers.

    docker-compose scale whoami=5
    
Now run our curl command again on our web services and we will now see the hostname change. To get a deeper understanding tail the logs of the stack to watch what happens each time you access your web services.

    ```
    docker-compose logs whoami
    whoami_5         | Starting up on port 80
    whoami_4         | Starting up on port 80
    whoami_3         | Starting up on port 80
    whoami_2         | Starting up on port 80
    whoami_1         | Starting up on port 80
    ```

Here's the output from my docker-compose logs after I curled the `whoami` application  so it is clear that the round-robin is sent to all 5 web service containers.

    ```
    reverse-proxy_1  | 172.26.0.1 - - [01/May/2019:19:16:34 +0000] "GET /favicon.ico HTTP/1.1" 200 647 "http://whoami.docker.localhost/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36" 10 "Host-whoami-docker-localhost-1" "http://172.26.0.2:80" 1ms
    ```
    
