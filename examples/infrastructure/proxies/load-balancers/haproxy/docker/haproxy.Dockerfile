FROM haproxy:1.8.27
RUN apt-get update && apt-get install -y ca-certificates