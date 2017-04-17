echo LAST CHANCE - THIS KILLS AND DELETES EVERYTHING FROM DOCKER
echo and CLEARS .kitchen/*.yml
read temp
docker stop $(docker ps -a -q) > /dev/null 2>&1  && echo Stopped containers || echo No containers
docker rm $(docker ps -a -q) > /dev/null 2>&1 && echo Removed containers || echo No containers
docker rmi $(docker images -a -q) > /dev/null 2>&1 && echo Removed images || echo No images
docker volume rm $(docker volume ls | awk {'print $2'}) > /dev/null 2>&1 && echo Removed volumes || echo No volumes
rm -f .kitchen/*.yml > /dev/null 2>&1 
