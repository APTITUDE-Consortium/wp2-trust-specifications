```json
{
  "legalPerson": {
    "legalName": ["TrustBridge Services B.V."]
  },
  "identifier": [
    {
      "type": "http://data.europa.eu/eudi/id/EUID",
      "identifier": "NL-EUID-112233445"
    },
    {
      "type": "http://data.europa.eu/eudi/id/VATIN",
      "identifier": "NL112233445B01"
    }
  ],
  "postalAddress": [
    "Keizersgracht 100, 1015 CN Amsterdam, NL"
  ],
  "country": "NL",
  "email": ["wallet-intermediary@trustbridge.example"],
  "phone": ["+31200000000"],
  "infoURI": ["https://trustbridge.example"],
  "providerType": "WalletRelyingParty",
  "policy": [
    {
      "type": "http://data.europa.eu/eudi/policy/terms-and-conditions",
      "policyURI": "https://trustbridge.example/terms"
    },
    {
      "type": "http://data.europa.eu/eudi/policy/privacy-policy",
      "policyURI": "https://trustbridge.example/privacy"
    }
  ],
  "tradeName": "TrustBridge",
  "supportURI": ["https://trustbridge.example/support"],
  "srvDescription": [
    [
      {
        "lang": "en",
        "content": "Intermediary services for wallet-relying parties operating in the Netherlands."
      },
      {
        "lang": "nl",
        "content": "Intermediaire diensten voor wallet-relying parties in Nederland."
      }
    ]
  ],
  "isPSB": false,
  "entitlement": [
    "https://uri.etsi.org/19475/Entitlement/Service_Provider"
  ],
  "supervisoryAuthority": {
    "legalPerson": {
      "legalName": ["Autoriteit Persoonsgegevens"]
    },
    "country": "NL",
    "email": ["info@autoriteitpersoonsgegevens.nl"],
    "infoURI": ["https://autoriteitpersoonsgegevens.nl"]
  },
  "registryURI": "https://registry.example.nl/api",
  "isIntermediary": true
}
```
