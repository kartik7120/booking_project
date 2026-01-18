BROKER_BINARY=brokerApp
LOGGER_BINARY=loggerApp
AUTH_BINARY=authApp
MOVIEDB_BINARY=moviedbApp

## build_broker: builds the broker binary as a linux executable
build_app: build_broker build_logger build_auth build_moviedb build_producer_service build_payment_service build_moviedb_docker_image build_auth_docker_image build_payment_docker_image build_rabbitmq_producer_service build_broker_service_docker_image build_front_end_docker_image

# build_broker: builds the broker binary as a linux executable
build_broker:
	@echo "Building broker binary..."
	cd ../booking_broker_service && env GOOS=linux CGO_ENABLED=0 go build -o ${BROKER_BINARY} ./cmd/main.go
	@echo "Done!"

# build_logger: builds the logger binary as a linux executable
build_logger:
	@echo "Building logger binary..."
	cd ../booking_logger_service && env GOOS=linux CGO_ENABLED=0 go build -o ${LOGGER_BINARY} ./cmd/main.go
	@echo "Done!"

# build_auth: builds the auth binary as a linux executable
build_auth:
	@echo "Building auth binary..."
	cd ../booking_auth_service && env GOOS=linux CGO_ENABLED=0 go build -o ${AUTH_BINARY} ./cmd/main.go
	@echo "Done!"

# build_moviedb: builds the moviedb binary as a linux executable
build_moviedb:
	@echo "Building moviedb binary.."
	cd ../booking_moviedb_service && env GOOS=linux CGO_ENABLED=0 go build -o ${MOVIEDB_BINARY} ./cmd/main.go
	@echo "Done!"

build_producer_service:
	@echo "Building producer service binary..."
	cd ../rabbitmq_producer_service && env GOOS=linux CGO_ENABLED=0 go build -o producerServiceApp ./cmd/main.go
	@echo "Done!"

build_payment_service:
	@echo "Building payment service binary..."
	cd ../booking_payment_service && env GOOS=linux CGO_ENABLED=0 go build -o paymentServiceApp ./cmd/main.go
	@echo "Done!"

build_moviedb_docker_image:
	@echo "Building moviedb service docker image..."	
	cd ../booking_moviedb_service && docker buildx build \
        -t kartik7120/booking_moviedb_service:10.7 \
        --build-arg DSN="postgresql://neondb_owner:npg_TqmOohyS6f9z@ep-fancy-dream-adr87jwi-pooler.c-2.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require" \
        --build-arg STRAPI_API_TOKEN="b2c45366d1f87c8873314c35b29fd4d66116dca3b2862d5bbbb76d60d423faea855779c2588b836735be37be93099c653c9159355b3e42899ab094e99c01e42a86ba675f9334f86bb0279fe5f733693f22b9aa9954fb7f3562d1e41a0925356f9af153fd3f6ef8ee149a3b4751b0389f9ad2180784353a1bcc3fd0bfabb60a52" \
        --build-arg STRAPI_URL="http://host.docker.internal:1337" \
        --build-arg ENV="production" \
        --build-arg RABBITMQ_URL="amqps://ocqkiseh:n8wVT03jcyGQtqUH0MASZEDPK5TuMl3V@gorilla.lmq.cloudamqp.com/ocqkiseh" \
        -f booking_moviedb_service.dockerfile . && \
    docker image push kartik7120/booking_moviedb_service:10.7
	@echo "Done!"
 
# Redis instance password: 		// Password: "dhTPjHzsbKyVmZDcwhPOCna97epC69LY",

build_auth_docker_image:
	@echo "Building auth service docker image..."
	cd ../booking_auth_service && docker buildx build \
	-t kartik7120/auth_service:1.3 \
	--build-arg DSN="postgresql://neondb_owner:npg_TqmOohyS6f9z@ep-fancy-dream-adr87jwi-pooler.c-2.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require" \
	--build-arg ENV="production" \
	-f auth_service.dockerfile . && \
	docker image push kartik7120/auth_service:1.3
	@echo "Done!"

build_payment_docker_image:
	@echo "Building payment service docker image..."
	cd ../booking_payment_service && docker buildx build \
	-t kartik7120/payment_service:3.0 \
	--build-arg DODOPAYMENT_TOKEN="JETucopgupgGWFiO.xsDxn8UqkLrwue0EoM5xw7iazGjiwOnbk1V8Vov0HQkVx5cp" \
	--build-arg DB_URL="postgresql://neondb_owner:npg_TqmOohyS6f9z@ep-fancy-dream-adr87jwi-pooler.c-2.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require" \
	--build-arg MOVIEDB_URL="booking-moviedb-service-198155959998.europe-west1.run.app:443" \
	--build-arg REDIRECT_URL="https://booking-front-end-198155959998.europe-west1.run.app/confirmingBooking" \
	-f payment_service.dockerfile . && \
	docker image push kartik7120/payment_service:3.0
	@echo "Done!"

build_rabbitmq_producer_service:
	@echo "Building rabbitmq producer service docker image"
	cd ../rabbitmq_producer_service && docker buildx build \
	-t kartik7120/rabbitmq_producer_service:2.9 \
	--build-arg RABBITMQ_URL="amqps://ocqkiseh:n8wVT03jcyGQtqUH0MASZEDPK5TuMl3V@gorilla.lmq.cloudamqp.com/ocqkiseh" \
	-f rabbitmq_producer_service.dockerfile . && \
	docker image push kartik7120/rabbitmq_producer_service:2.9
	@echo "Done!"

build_broker_service_docker_image:
	@echo "Building broker service..."
	cd ../booking_broker_service && docker buildx build \
	-t kartik7120/broker_service:6.7 \
	--build-arg REDIS_PROD_PASS="dhTPjHzsbKyVmZDcwhPOCna97epC69LY" \
	--build-arg MOVIEDB_SERVICE_URL="booking-moviedb-service-198155959998.europe-west1.run.app:443" \
	--build-arg PAYMENT_SERVICE_URL="payment-service-198155959998.europe-west1.run.app:443" \
	--build-arg AUTH_SERVICE_URL="auth-service-198155959998.europe-west1.run.app:443" \
	--build-arg RABBITMQ_PRODUCER_SERVICE="rabbitmq-producer-service-198155959998.europe-west1.run.app:443" \
	--build-arg MAILJET_USERNAME="60cfcdc130411760178fb8ec44133564" \
	--build-arg MAILJET_PASSWORD="31528205ce1385dbf066f457765f4234" \
	-f Dockerfile . && \
	docker image push kartik7120/broker_service:6.7
	@echo "Done!"

build_front_end_docker_image:
	@echo "Building front end service..."
	cd ../booking_front_end && docker buildx build \
	-t kartik7120/booking_front_end:5.7 \
	--build-arg VITE_BROKER_URL="https://broker-service-198155959998.europe-west1.run.app" \
	-f front-end-dev.dockerfile . && \
	docker image push kartik7120/booking_front_end:5.7
	@echo "Done!"
