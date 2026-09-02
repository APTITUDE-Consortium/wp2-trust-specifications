```json
{
  "name": "Dutch Bank Customer Onboarding",
  "sub_ln": "Dutch Bank N.V.",
  "sub": "LEIXG-724500VKKSH9QOLTFR81",
  "country": "NL",
  "registry_uri": "https://wrp-register.nl/api/v1/relying-parties/NL-WRP-00234",
  "entitlements": [
    "https://uri.etsi.org/19475/Entitlement/Service_Provider",
    "https://uri.etsi.org/19475/SubEntitlement/psp/psp-as"
  ],
  "purpose": [
    { "lang": "en-US", "value": "Identity verification and KYC check for bank account opening" }
  ],
  "credentials": [
    {
      "format": "dc+sd-jwt",
      "meta": { "vct_values": ["https://credentials.example.eu/pid"] },
      "claim": [
        { "path": ["family_name"] }, { "path": ["given_name"] },
        { "path": ["birth_date"] }, { "path": ["nationality"] },
        { "path": ["resident_address"] }, { "path": ["personal_identifier"] }
      ]
    },
    {
      "format": "dc+sd-jwt",
      "meta": { "vct_values": ["https://credentials.example.eu/address-attestation"] },
      "claim": [
        { "path": ["resident_address"] }, { "path": ["resident_country"] }
      ]
    }
  ],
  "privacy_policy": "https://dutchbank.nl/privacy",
  "supervisory_authority": {
    "uri": "https://autoriteitpersoonsgegevens.nl",
    "email": "info@autoriteitpersoonsgegevens.nl"
  },
  "public_body": false,
  "policy_id": ["0.4.0.19475.3.1"],
  "iat": 1704067200,
  "status": { "status_list": { "idx": 89, "uri": "https://status.wrp-register.nl/statuslist/1" } }
}
```
