# Arch Linux install

See `docs/INSTALL_LINUX.md` for generic Docker-based instructions.
# Detailed Installation — Arch Linux

Install Docker and run the scaffold on Arch Linux.

```bash
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm docker docker-compose
sudo systemctl enable --now docker

git clone <repo-url> wyvem
cd wyvem
cp .env.example .env
docker compose up -d --build
```

Backend setup inside container (same as other distros):

```bash
docker compose exec panel bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan queue:work &
```
