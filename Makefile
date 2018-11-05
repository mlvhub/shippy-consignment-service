build:
	protoc -I. --go_out=plugins=micro:. \
		proto/consignment/consignment.proto
	docker build -t mlopez1506/consignment:latest .
	docker push mlopez1506/consignment:latest

run:
	docker run -d --net="host" \
		-p 50052 \
		-e MICRO_SERVER_ADDRESS=:50052 \
		-e MICRO_REGISTRY=mdns \
		-e DISABLE_AUTH=true \
		consignment-service

deploy:
	sed "s/{{ UPDATED_AT }}/$(shell date)/g" ./deployments/deployment.tmpl > ./deployments/deployment.yml
	kubectl replace -f ./deployments/deployment.yml
