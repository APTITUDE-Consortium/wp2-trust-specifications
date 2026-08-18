```json
{
  "legalPerson": {
    "legalName": ["ExampleBank S.A."]
  },
  "identifier": [
    {
      "type": "http://data.europa.eu/eudi/id/EUID",
      "identifier": "FR-EUID-123456789"
    },
    {
      "type": "http://data.europa.eu/eudi/id/VATIN",
      "identifier": "FR12345678901"
    }
  ],
  "postalAddress": [
    "10 Rue Exemple, 75000 Paris, FR"
  ],
  "country": "FR",
  "email": [
    "wallet-rp-registration@examplebank.eu"
  ],
  "phone": [
    "+33100000000"
  ],
  "infoURI": [
    "https://examplebank.eu"
  ],
  "providerType": "WalletRelyingParty",
  "policy": [
    {
      "type": "http://data.europa.eu/eudi/policy/terms-and-conditions",
      "policyURI": "https://examplebank.eu/terms"
    },
    {
      "type": "http://data.europa.eu/eudi/policy/privacy-policy",
      "policyURI": "https://examplebank.eu/privacy"
    }
  ],
  "tradeName": "ExampleBank Mobile",
  "supportURI": [
    "https://examplebank.eu/support"
  ],
  "srvDescription": [
    [
      { "lang": "en", "content": "Retail banking services for individuals." },
      { "lang": "fr", "content": "Services bancaires pour particuliers." }
    ]
  ],
  "isPSB": false,
  "entitlement": [
    "https://uri.etsi.org/19475/Entitlement/Service_Provider"
  ],
  "supervisoryAuthority": {
    "legalPerson": {
      "legalName": ["Autorité de supervision Exemple"]
    },
    "country": "FR",
    "email": ["contact@supervisor.example.fr"],
    "infoURI": ["https://supervisor.example.fr"]
  },
  "registryURI": "https://registry.example.fr/api",
  "isIntermediary": false,
  "intendedUse": [
    {
      "intendedUseIdentifier": "iu-001",
      "purpose": [
        { "lang": "en", "content": "Open a bank account remotely." }
      ],
      "privacyPolicy": [
        {
          "type": "http://data.europa.eu/eudi/policy/privacy-statement",
          "policyURI": "https://examplebank.eu/privacy/wallet"
        }
      ],
      "credential": [
        {
          "format": "dc+sd-jwt",
          "meta": {
            "vct": "https://example.eu/schema/pid"
          },
          "claim": [
            { "path": ["family_name"] },
            { "path": ["given_name"] },
            { "path": ["birth_date"] }
          ]
        }
      ],
      "createdAt": "2026-01-01"
    }
  ]
}
```
