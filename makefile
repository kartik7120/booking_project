BROKER_BINARY=brokerApp

## build_broker: builds the broker binary as a linux executable
build_broker:
	@echo "Building broker binary..."
	cd ../booking_broker-service && env GOOS=linux CGO_ENABLED=0 go build -o ${BROKER_BINARY} ./main.go
	@echo "Done!"
