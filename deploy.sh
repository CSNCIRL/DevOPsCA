#!/usr/bin/env bash 

CURRENT_INSTANCE=$(docker ps -a -q --filter ancestor="$IMAGE_NAME:$IMAGE_TAG" --format="{{.ID}}")
if [ "$CURRENT_INSTANCE" ]
then
  docker rm $(docker stop $CURRENT_INSTANCE)
fi

docker pull $IMAGE_NAME:$IMAGE_TAG

CONTAINER_EXISTS=$(docker ps -a | grep $CONTAINER_NAME)
if [ "$CONTAINER_EXISTS" ] 
then
  docker rm $CONTAINER_NAME
fi

docker create -p $PUBLIC_PORT:$INTERNAL_PORT --name $CONTAINER_NAME $IMAGE_NAME:$IMAGE_TAG
echo $PRIVATE_KEY > privatekey.pem
echo $SERVER > server.crt
docker cp ./privatekey.pem $CONTAINER_NAME:/privatekey.pem
docker cp ./server.crt $CONTAINER_NAME:/server.crt
docker start $CONTAINER_NAME