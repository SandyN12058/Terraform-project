#!/bin/bash

# update packages
apt update -y

# install python3
apt install -y python3

# create app2 directory under /home/ubuntu
mkdir -p /home/ubuntu/app1

# create an index.html inside app2
cat << EOF > /home/ubuntu/app1/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Terraform-project</title>
</head>
<body>
  <h1>Hello from EC2 Server 1!</h1>
  <p>This is a sample HTML page served through the load balancer.</p>
</body>
</html>
EOF

# move to the /home/ubuntu dir and run server
cd /home/ubuntu
nohup python3 -m http.server 8000 &
