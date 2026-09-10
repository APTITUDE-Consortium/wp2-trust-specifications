**Header:**

```json
{
  "alg": "ES256",
  "typ": "statuslist+jwt",
  "x5c": [
    "MIIDqjCCApKgAwIBAgIESLNEvDA...",
    "MIICwzCCAasCCQCKVy9eKjvi+jA...",
    "MIIDTDCCAjSgAwIBAgIJAPlnQYH..."
  ]
}
```

**Payload:**

```json
{
  "sub": "https://example-issuer.com/statuslists/1",
  "iat": 1686920170,
  "exp": 2291720170,
  "status_list": {
    "bits": 1,
    "lst": "eNrbuRgAAhcBXQ"
  },
  "ttl": 43200
}
```
