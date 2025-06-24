#!/usr/bin/env bash
set -euo pipefail

# Load environment variables from .env if it exists
if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  . ./.env
  set +a
fi

echo "⏳ Starting containers…"
docker compose up -d db wordpress

echo "🧘 Waiting for WordPress to respond…"
until docker compose exec wordpress curl -s http://localhost/wp-login.php >/dev/null 2>&1 ; do
  sleep 2
done

echo "⚙️  Installing core site"
docker compose run --rm wpcli core install \
  --url="$WP_SITE_URL" \
  --title="$WP_TITLE" \
  --admin_user="$WP_ADMIN_USER" \
  --admin_password="$WP_ADMIN_PASSWORD" \
  --admin_email="$WP_ADMIN_EMAIL" \
  --skip-email

echo "🔌 Installing & activating plugins"
docker compose run --rm wpcli plugin install woocommerce --version="$WC_VERSION" --activate
docker compose run --rm wpcli plugin install wp-graphql --activate
docker compose run --rm wpcli plugin install wp-graphql-woocommerce --activate

echo "🔧 Tweaking settings"
docker compose run --rm wpcli option update permalink_structure '/%postname%/'
docker compose run --rm wpcli rewrite flush --hard

echo "✅  All set! Visit $WP_SITE_URL/wp-admin"