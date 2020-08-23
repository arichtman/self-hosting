
---
api:
  entrypoint: dashboard
defaultEntryPoints:
  - http
docker:
  domain: "${MY_DOMAIN}"
  exposedbydefault: false
  network: "${DEFAULT_NETWORK}"
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
