# Installation — Linux (Debian / Ubuntu)

Quick way to run the scaffold using Docker.

```bash
git clone <repo-url> wyvem
cd wyvem
cp .env.example .env
docker compose up -d --build
```

Then run backend setup inside container if needed.
# Installation — Linux (Debian / Ubuntu)

This guide shows a quick way to get the scaffold running using Docker and Docker Compose. It installs required system components and brings up services defined in `docker-compose.yml`.

1) Install Docker & Docker Compose

Debian / Ubuntu (run as root or with sudo):

```bash
apt update
apt install -y ca-certificates curl gnupg lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

2) Start the scaffold

```bash
git clone <this-repo-url> wyvem
cd wyvem
cp .env.example .env
docker compose up -d
```

3) Next steps
- Edit `.env` to set `APP_KEY` and database credentials.
- Enter the `panel` container to run `composer install` and `php artisan migrate` once backend implemented.

This guide is intentionally concise — see the `docs/` folder for the SSO plan, migration tool spec, and more detailed distro instructions.
