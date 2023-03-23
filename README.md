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
  -v ${PWD}/config/tyk:/output/dist \
  --env-file .tyk.operator.env \
  --env AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  --env AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  --env AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
  alexchesser/tyk-operator-wrapper \
  /workspace/connect-and-export.sh
```
