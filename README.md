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
    curl 0.0.0.0
    
    Hello World!
    I have been seen 1 times.
    My Host name is 29c69c89417c

# Scaling
Now comes the fun part of compose which is scaling. Let's scale our web service from 1 instance to 5 instances. This will now scale our web service container. We now should run an update on our stack so the Loadbalancer is informed about the new web service containers.

    docker-compose scale web=5
    
Now run our curl command again on our web services and we will now see the number of times increase and the hostname change. To get a deeper understanding tail the logs of the stack to watch what happens each time you access your web services.

    docker-compose logs

Here's the output from my docker-compose logs after I curled my application 5 times so it is clear that the round-robin is sent to all 5 web service containers.

    web_5   | 172.17.1.140 - - [04/Sep/2015 14:11:34] "GET / HTTP/1.1" 200 -
    web_1   | 172.17.1.140 - - [04/Sep/2015 14:11:43] "GET / HTTP/1.1" 200 -
    web_2   | 172.17.1.140 - - [04/Sep/2015 14:11:46] "GET / HTTP/1.1" 200 -
    web_3   | 172.17.1.140 - - [04/Sep/2015 14:11:48] "GET / HTTP/1.1" 200 -
    web_4   | 172.17.1.140 - - [04/Sep/2015 14:14:19] "GET / HTTP/1.1" 200 -
    
# Version 2 Compose File
Version 2 docker-compose file is now available. In order to use the 'docker-compose-v2.yml' file the command changes slightly. Run the below command to launch a version 2 compose project. This project is also slightly changed as the jwilder/nginx doesn't support the v2 format. The v2 is now running the HAproxy from dockercloud.

A benefit of running this load balancer is it automatically detects the coming and going of containers and doesn't require any changes.

Run the below command to launch a version 2 compose project in the foreground.
    docker-compose -f docker-compose-v2.yml up

Open another terminal window to scale and run:
    docker-compose -f docker-compose-v2.yml scale web=5
