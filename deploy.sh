docker build -t ovvn/multi-client:latest -t ovvn/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t ovvn/multi-server:latest -t ovvn/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t ovvn/multi-worker:latest -t ovvn/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push ovvn/multi-client:latest
docker push ovvn/multi-server:latest
docker push ovvn/multi-worker:latest

docker push ovvn/multi-client:$SHA
docker push ovvn/multi-server:$SHA
docker push ovvn/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=ovvn/multi-server:$SHA
kubectl set image deployments/client-deployment client=ovvn/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=ovvn/multi-worker:$SHA
