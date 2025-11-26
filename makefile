BROKER_BINARY=brokerApp
LOGGER_BINARY=loggerApp
AUTH_BINARY=authApp
MOVIEDB_BINARY=moviedbApp

## build_broker: builds the broker binary as a linux executable
build_app: build_broker build_logger build_auth build_moviedb build_producer_service build_payment_service

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