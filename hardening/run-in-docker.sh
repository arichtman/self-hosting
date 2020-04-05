
# Install packages
dnf install docker-ce docker-ce-cli containerd.io -y

# Build image
docker build --tag hardening:latest /tmp

# Run in background with localhost connectivity
docker container run hardening:latest --detach --network="host" --name='hardening' --rm
# Wait till finish
docker container wait 'hardening'
# Remove everything from docker
docker system prune --force