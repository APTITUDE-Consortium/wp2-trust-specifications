```json
{
  "legalPerson": {
    "legalName": ["ShopExample N.V."]
  },
  "identifier": [
    {
      "type": "http://data.europa.eu/eudi/id/EUID",
      "identifier": "NL-EUID-556677889"
    }
  ],
  "postalAddress": [
    "Damrak 50, 1012 LP Amsterdam, NL"
  ],
  "country": "NL",
  "email": ["wallet-rp@shopexample.example"],
  "infoURI": ["https://shopexample.example"],
  "providerType": "WalletRelyingParty",
  "policy": [
    {
      "type": "http://data.europa.eu/eudi/policy/terms-and-conditions",
      "policyURI": "https://shopexample.example/terms"
    },
    {
      "type": "http://data.europa.eu/eudi/policy/privacy-policy",
      "policyURI": "https://shopexample.example/privacy"
    }
  ],
  "tradeName": "ShopExample",
  "supportURI": ["https://shopexample.example/support"],
  "srvDescription": [
    [
      { "lang": "en", "content": "Online retail services." },
      { "lang": "nl", "content": "Online detailhandel." }
    ]
  ],
  "isPSB": false,
  "entitlement": [
    "https://uri.etsi.org/19475/Entitlement/Service_Provider"
  ],
  "intendedUse": [
    {
      "intendedUseIdentifier": "iu-age-verification",
      "purpose": [
        { "lang": "en", "content": "Verify the customer is of legal age for restricted product purchases." }
      ],
      "privacyPolicy": [
        {
          "type": "http://data.europa.eu/eudi/policy/privacy-statement",
          "policyURI": "https://shopexample.example/privacy/wallet"
        }
      ],
      "credential": [
        {
          "format": "mso_mdoc",
          "meta": {
            "doctype_value": "org.iso.18013.5.1.mDL"
          },
          "claim": [
            { "path": ["org.iso.18013.5.1", "age_over_18"] }
          ]
        }
      ],
      "createdAt": "2026-01-01"
    }
  ],
  "supervisoryAuthority": {
    "legalPerson": {
      "legalName": ["Autoriteit Persoonsgegevens"]
    },
    "country": "NL",
    "infoURI": ["https://autoriteitpersoonsgegevens.nl"]
  },
  "registryURI": "https://registry.example.nl/api",
  "isIntermediary": false,
  "usesIntermediary": [
    {
      "identifier": [
        {
          "type": "http://data.europa.eu/eudi/id/EUID",
          "identifier": "NL-EUID-112233445"
        }
      ],
      "tradeName": "TrustBridge",
      "registryURI": "https://registry.example.nl/api"
    }
  ]
}
```
