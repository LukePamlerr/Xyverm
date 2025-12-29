# Detailed Installation — Debian / Ubuntu

Steps to install Docker and run the scaffold on Debian/Ubuntu.

See repository README for quick start.
# Detailed Installation — Debian / Ubuntu

This guide walks through installing Wyvem scaffold using Docker on Debian/Ubuntu systems.

1) Install prerequisites

```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
```

2) Install Docker (official repository)

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl enable --now docker
```

3) Clone and run the scaffold

```bash
git clone <repo-url> wyvem
cd wyvem
cp .env.example .env
docker compose up -d --build
```

4) Backend setup inside container

```bash
docker compose exec panel bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan queue:work &
```

Notes:
- If `composer` isn't present on the host, run the `composer` commands inside the `panel` container as shown.
- For production, configure proper SSL, reverse proxy, and persistent volumes.
