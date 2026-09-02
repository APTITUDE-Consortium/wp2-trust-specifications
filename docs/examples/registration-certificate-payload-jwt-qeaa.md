```json
{
  "name": "Spanish Driving License Attestation Service",
  "sub_ln": "Ministerio del Interior - Dirección General de Tráfico",
  "sub": "VATES-S2800001J",
  "country": "ES",
  "registry_uri": "https://registro.mineco.gob.es/wrp/api/v1/relying-parties/ES-WRP-00123",
  "srv_description": [
    {
      "lang": "es-ES",
      "value": "Servicio de emisión de permisos de conducir digitales y attestaciones relacionadas con la conducción"
    },
    {
      "lang": "en-US",
      "value": "Digital driving license and driving-related attestation issuance service"
    }
  ],
  "entitlements": [
    "https://uri.etsi.org/19475/Entitlement/QEAA_Provider",
    "https://uri.etsi.org/19475/Entitlement/PUB_EAA_Provider"
  ],
  "provides_attestations": [
    {
      "format": "dc+sd-jwt",
      "meta": {
        "vct_values": [
          "https://credentials.dgt.es/mobile-driving-license"
        ]
      },
      "claim": [
        { "path": ["family_name"] },
        { "path": ["given_name"] },
        { "path": ["birth_date"] },
        { "path": ["portrait"] },
        { "path": ["driving_privileges"] },
        { "path": ["issue_date"] },
        { "path": ["expiry_date"] },
        { "path": ["issuing_authority"] },
        { "path": ["document_number"] },
        { "path": ["issuing_country"] }
      ]
    },
    {
      "format": "mso_mdoc",
      "meta": {
        "doctype_value": "org.iso.18013.5.1.mDL"
      },
      "claim": [
        { "path": ["org.iso.18013.5.1", "family_name"] },
        { "path": ["org.iso.18013.5.1", "given_name"] },
        { "path": ["org.iso.18013.5.1", "birth_date"] },
        { "path": ["org.iso.18013.5.1", "portrait"] },
        { "path": ["org.iso.18013.5.1", "driving_privileges"] }
      ]
    }
  ],
  "privacy_policy": "https://dgt.es/privacy-policy",
  "info_uri": "https://dgt.es",
  "supervisory_authority": {
    "uri": "https://www.aepd.es",
    "email": "ciudadano@aepd.es",
    "phone": "+34 91 266 35 17"
  },
  "public_body": true,
  "policy_id": [
    "0.4.0.19475.3.1"
  ],
  "certificate_policy": "https://pki.dgt.es/wrprc-policy",
  "iat": 1704067200,
  "exp": 1735689600,
  "status": {
    "status_list": {
      "idx": 42,
      "uri": "https://status.dgt.es/wrprc/statuslist/1"
    }
  }
}
```
