#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <PTERO_API_URL> <PTERO_API_KEY>"
  exit 2
fi

API_URL="$1"
API_KEY="$2"

echo "Calling Wyvem backend migration endpoint with source $API_URL"

curl -sS -X POST "http://localhost:8080/api/v1/pterodactyl/migrate" \
  -H "Content-Type: application/json" \
  -d "{ \"api_url\": \"${API_URL}\", \"api_key\": \"${API_KEY}\" }"
#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <PTERO_API_URL> <PTERO_API_KEY>"
  exit 2
fi

API_URL="$1"
API_KEY="$2"

echo "Calling Wyvem backend migration endpoint with source $API_URL"

curl -sS -X POST "http://localhost:8080/api/v1/pterodactyl/migrate" \
  -H "Content-Type: application/json" \
  -d "{ \"api_url\": \"${API_URL}\", \"api_key\": \"${API_KEY}\" }"
