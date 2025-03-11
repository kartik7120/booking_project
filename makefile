BROKER_BINARY=brokerApp
LOGGER_BINARY=loggerApp
AUTH_BINARY=authApp

## build_broker: builds the broker binary as a linux executable
build_app: build_broker build_logger build_auth
	@echo "Building app docker image..."
	docker build -t booking-app .
	@echo "Done!"

# build_broker: builds the broker binary as a linux executable
build_broker:
	@echo "Building broker binary..."
	cd ../booking_broker-service && env GOOS=linux CGO_ENABLED=0 go build -o ${BROKER_BINARY} ./cmd/main.go
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
