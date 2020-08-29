
---
api:
  entrypoint: dashboard
defaultEntryPoints:
  - http
docker:
  domain: "${TOP_LEVEL_DOMAIN}"
  exposedbydefault: false
  network: web
  watch: true
entryPoints:
  dashboard:
    address: ":8080"
    auth:
      basic:
        users:
          - "${TRAEFIK_PASSWORD_ESCAPED}"
  http:
    address: ":80"
