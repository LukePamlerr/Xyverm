# CentOS / RHEL install

See `docs/INSTALL_LINUX.md` for generic Docker-based instructions.
# Detailed Installation — CentOS / RHEL

This guide shows how to prepare a CentOS / RHEL server for the Wyvem scaffold using Docker.

1) Install Docker

```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
```

2) Run the scaffold

```bash
git clone <repo-url> wyvem
cd wyvem
cp .env.example .env
docker compose up -d --build
```

3) Backend tasks

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
- Use SELinux and firewall rules configured for production.
