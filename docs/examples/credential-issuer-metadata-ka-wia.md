```json
{
  "credential_configurations_supported": {
    "example_device_bound_credential": {
      "format": "dc+sd-jwt",
      "cryptographic_binding_methods_supported": [
        "jwk"
      ],
      "wallet_attestation_status_management": {
        "issuance_check": "wia",
        "operational_check": "wia",
        "maximum_check_interval": 86400,
        "revocation_action": "revoke_credential",
        "policy_id": "urn:eu:eudi:wallet-wia-status-policy:continuous"
      },
      "key_attestation_status_management": {
        "issuance_check": "ka",
        "operational_check": "ka",
        "maximum_check_interval": 86400,
        "revocation_action": "revoke_credential",
        "policy_id": "urn:eu:eudi:wallet-ka-status-policy:continuous"
      }
    }
  }
}
```
