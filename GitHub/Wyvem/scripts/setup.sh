#!/usr/bin/env bash
set -euo pipefail

echo "Running Wyvem setup (scaffold)..."
if [ -f composer.json ]; then
  if command -v composer >/dev/null 2>&1; then
    composer install --no-interaction --prefer-dist
  else
    echo "composer not found; please install Composer inside the container or host."
  fi
fi

if [ -f package.json ]; then
  if command -v npm >/dev/null 2>&1; then
    npm install
  else
    echo "npm not found; please install Node.js/npm or run inside a dev container."
  fi
fi

echo "Setup complete. Edit .env and run migrations when backend is implemented."
#!/usr/bin/env bash
set -euo pipefail

echo "Running Wyvem setup (scaffold)..."
if [ -f composer.json ]; then
  if command -v composer >/dev/null 2>&1; then
    composer install --no-interaction --prefer-dist
  else
    echo "composer not found; please install Composer inside the container or host."
  fi
fi

if [ -f package.json ]; then
  if command -v npm >/dev/null 2>&1; then
    npm install
  else
    echo "npm not found; please install Node.js/npm or run inside a dev container."
  fi
fi

echo "Setup complete. Edit .env and run migrations when backend is implemented."
