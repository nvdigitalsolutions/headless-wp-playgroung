# Headless WordPress + WooCommerce Playground

A portable, containerised environment for developing and testing WordPress/WooCommerce plugins **headlessly** with GraphQL support.

## Contents

- **docker-compose.yml** – spins up MariaDB + WordPress/PHP‑Apache + WP‑CLI.
- **scripts/bootstrap.sh** – one‑click site installer (core + WooCommerce + WPGraphQL).
- **.github/workflows/ci.yml** – GitHub Actions CI that mirrors the stack in the cloud.
- **.env.example** – sample environment variables. Copy to `.env` and tweak credentials, site URL & component versions.
- **plugins/** – mount your plugin code here (hot‑reloaded inside the container).

## Quick start

```bash
# create your environment file
cp .env.example .env

# start the containers and install WordPress
./scripts/bootstrap.sh
```

Once the script finishes, visit **http://localhost:8888/wp-admin** and log in with the admin credentials from `.env`.

## Continuous Integration

Pushing to **main** (or opening a PR) triggers the `Plugin CI` workflow which:

1. Spins up the same Docker Compose stack.
2. Runs PHPUnit inside the `wpcli` container.
3. Shuts everything down and uploads logs if tests fail.

## Customisation tips

- **Multiple PHP versions**: add a matrix in `.github/workflows/ci.yml`.
- **Front‑end**: uncomment the `frontend` service in `docker-compose.yml`.
- **MailHog/Xdebug/e2e**: see comments in the compose file & script.

Happy hacking! 🚀
