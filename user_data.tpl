#!/bin/bash

# Install your Python environment
apt-get update -y
apt-get install -y python3.14-venv
python3.14 -m venv venv
source venv/bin/activate

# Clon the latest app directly onto the server
git clone https://github.com/DavidClusker/CloudApplicationDevelopmentV1.git
cd backend
pip install -r requirements.txt

# Run Uvicorn on port 80 bound to all interfaces
uvicorn main:app --host 0.0.0.0 --port ${app_port} > uvicorn.log 2>&1 &
