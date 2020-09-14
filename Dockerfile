FROM debian:buster-slim
COPY ./bin/dyndns-api /dyndns-api
ENTRYPOINT [/dyndns-api]