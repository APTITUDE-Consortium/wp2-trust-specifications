```json
{
  "name": "University of Amsterdam Credential Service",
  "sub_ln": "Universiteit van Amsterdam",
  "sub": "NTRNLD-KVK34567890",
  "country": "NL",
  "registry_uri": "https://wrp-register.nl/api/v1/relying-parties/NL-WRP-00456",
  "srv_description": [
    {
      "lang": "nl-NL",
      "value": "Uitgifte van digitale studentenkaarten en academische credentials"
    },
    {
      "lang": "en-US",
      "value": "Issuance of digital student cards and academic credentials"
    }
  ],
  "entitlements": [
    "https://uri.etsi.org/19475/Entitlement/Non_Q_EAA_Provider"
  ],
  "provides_attestations": [
    {
      "format": "dc+sd-jwt",
      "meta": {
        "vct_values": [
          "https://credentials.uva.nl/student-id"
        ]
      },
      "claim": [
        { "path": ["family_name"] },
        { "path": ["given_name"] },
        { "path": ["student_id"] },
        { "path": ["faculty"] },
        { "path": ["program"] },
        { "path": ["enrollment_date"] },
        { "path": ["expected_graduation"] },
        { "path": ["student_status"] }
      ]
    },
    {
      "format": "dc+sd-jwt",
      "meta": {
        "vct_values": [
          "https://credentials.uva.nl/diploma"
        ]
      },
      "claim": [
        { "path": ["family_name"] },
        { "path": ["given_name"] },
        { "path": ["degree_title"] },
        { "path": ["field_of_study"] },
        { "path": ["graduation_date"] },
        { "path": ["honors"] },
        { "path": ["diploma_number"] }
      ]
    }
  ],
  "privacy_policy": "https://uva.nl/privacy",
  "info_uri": "https://credentials.uva.nl",
  "supervisory_authority": {
    "uri": "https://autoriteitpersoonsgegevens.nl",
    "email": "info@autoriteitpersoonsgegevens.nl",
    "phone": "+31 70 888 85 00"
  },
  "public_body": false,
  "policy_id": [
    "0.4.0.19475.3.1"
  ],
  "certificate_policy": "https://pki.uva.nl/wrprc-policy",
  "iat": 1704067200,
  "exp": 1735689600,
  "status": {
    "status_list": {
      "idx": 78,
      "uri": "https://status.uva.nl/wrprc/statuslist/1"
    }
  }
}
```
