# DevOps Final Project

This project clones and dockerizes the application from:
https://github.com/sriram-R-krishnan/devops-build

Then it's customized and pushed to:

👉 Your GitHub Repo: https://github.com/ajithdevopsproject/devopsfinalproject.git  
👉 Docker Hub Dev: ajithdocgym/dev (Public)  
👉 Docker Hub Prod: ajithdocgym/prod (Private)

## Features
- Dockerfile and Docker Compose setup
- Bash scripts for build and deploy
- Jenkins CI/CD integration
- AWS EC2 deployment (port 80)
- Health Monitoring (open-source)

## Scripts
- `build.sh` – builds Docker image and tags for dev
- `deploy.sh` – deploys the image on port 80
