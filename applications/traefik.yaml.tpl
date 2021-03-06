
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

# This appears to be being ignored and TLS 1.0 and 1.1 are still being allowed >:(
tls:
  options:
    default:
      # minVersion: VersionTLS12
      sniStrict: true
      cipherSuites:
        - TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        - TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305
        - TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305
    mintls13:
      minVersion: VersionTLS13
      sniStrict: true
