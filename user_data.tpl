
#!/bin/bash
set -euxo pipefail

# Save installation output for troubleshooting
exec > >(tee -a /var/log/user-data.log) 2>&1

# Update Ubuntu and install required packages
apt-get update -y
apt-get install -y git python3 python3-venv python3-pip

# Create application directory
mkdir -p /opt/app

# Clone the GitHub repository
git clone https://github.com/DavidClusker/CloudApplicationDevelopmentV1.git /opt/app/repository

# Create Python virtual environment
python3 -m venv /opt/app/venv

# Install Python dependencies
/opt/app/venv/bin/pip install --upgrade pip
/opt/app/venv/bin/pip install -r /opt/app/repository/backend/requirements.txt

# Give Ubuntu permission to access the application
chown -R ubuntu:ubuntu /opt/app

# Create a systemd service to keep the backend running
cat > /etc/systemd/system/backend.service <<EOF
[Unit]
Description=Python FastAPI Backend
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/opt/app/repository/backend
ExecStart=/opt/app/venv/bin/uvicorn main:app --host 0.0.0.0 --port ${app_port}
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start the backend automatically
systemctl daemon-reload
systemctl enable backend
systemctl start backend
