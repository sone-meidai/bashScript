#!/bin/bash

echo "==============================="
echo " DefectDojo macOS Auto-Install "
echo "==============================="


# --- 1. Install Homebrew (if missing) ---
if ! command -v brew &> /dev/null
then
    echo "[+] Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "[✔] Homebrew already installed"
fi


# --- 2. Check Docker Desktop installation ---
if [ -d "/Applications/Docker.app" ]; then
    echo "[✔] Docker Desktop already installed — skipping installation"
else
    echo "[+] Docker Desktop not found. Installing via Homebrew..."
    brew install --cask docker
fi


# --- 3. Ensure Docker Desktop is running ---
echo "[+] Launching Docker Desktop..."
open -a Docker

echo "[i] Waiting for Docker to start..."
while ! docker system info > /dev/null 2>&1; do
    sleep 2
done
echo "[✔] Docker is running"


# --- 4. Clone DefectDojo repo ---
if [ ! -d "django-DefectDojo" ]; then
    echo "[+] Cloning DefectDojo repository..."
    git clone https://github.com/DefectDojo/django-DefectDojo.git
else
    echo "[✔] DefectDojo repo already exists"
fi

cd django-DefectDojo || exit


# --- 5. Environment Check ---
echo "[+] Running environment check..."
chmod +x ./docker/docker-compose-check.sh
./docker/docker-compose-check.sh


# --- 6. Build Docker Images ---
echo "[+] Building Docker images (this may take several minutes)..."
docker compose build


# --- 7. Start DefectDojo ---
echo "[+] Starting DefectDojo containers..."
docker compose up -d


# --- 8. Retrieve admin password ---
echo "[i] Waiting for initializer to complete..."
sleep 10

echo "[+] Retrieving admin password..."
ADMIN_PASSWORD=$(docker compose logs initializer | grep "Admin password" | awk -F': ' '{print $2}')

echo
echo "======================================"
echo " DefectDojo Admin Login Credentials"
echo "======================================"
echo " URL:      http://localhost:8080/"
echo " Username: admin"

if [ -n "$ADMIN_PASSWORD" ]; then
    echo " Password: $ADMIN_PASSWORD"
else
    echo " Password not automatically detected."
    echo " Run this manually:"
    echo "   docker compose logs initializer | grep \"Admin password\""
fi

echo "======================================"
echo "[✔] DefectDojo installation complete!"
