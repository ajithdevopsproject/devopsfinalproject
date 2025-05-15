#!/bin/bash
docker rm -f devops-app || true
docker run -d --name devops-app -p 80:80 ajithdocgym/dev:latest
echo "App deployed at http://<your-ec2-ip>:80"
