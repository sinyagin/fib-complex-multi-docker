docker build -t andreysinyagin/fib-client:latest -t andreysinyagin/fib-client:$SHA -f client/Dockerfile ./client
docker build -t andreysinyagin/fib-server:latest -t andreysinyagin/fib-server:$SHA -f server/Dockerfile ./server
docker build -t andreysinyagin/fib-worker:latest -t andreysinyagin/fib-worker:$SHA -f worker/Dockerfile ./worker
docker push andreysinyagin/fib-client:latest
docker push andreysinyagin/fib-server:latest
docker push andreysinyagin/fib-worker:latest

docker push andreysinyagin/fib-client:$SHA
docker push andreysinyagin/fib-server:$SHA
docker push andreysinyagin/fib-worker:$SHA
kubectl apply -f k8s

kubectl set image deployments/server-deployment server=andreysinyagin/fib-server:$SHA
kubectl set image deployments/client-deployment client=andreysinyagin/fib-client:$SHA
kubectl set image deployments/worker-deployment worker=andreysinyagin/fib-worker:$SHA
