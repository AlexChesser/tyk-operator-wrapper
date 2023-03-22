## How to push the container to dockerhub

https://docs.docker.com/engine/reference/commandline/push/

`docker build . -t alexchesser/tyk-operator-wrapper`   
`docker login`  
`docker push alexchesser/tyk-operator-wrapper`  

# Required environment variables

see the values in `.tyk.operator.env.sample` they must be set for this to function as intended 

## How to execute an export

```
docker run -it --rm \
  -v ${PWD}/api-endpoint-configuration:/output \
  --env-file .tyk.operator.env \
  alexchesser/tyk-operator-wrapper \
  /workspace/connect-and-export.sh
```
