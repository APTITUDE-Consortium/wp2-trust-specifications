# Registry — Additional JSON Examples

This file contains non-normative JSON examples complementing the two baseline examples in [Wallet-Relying Party Registration Certificate](#wallet-relying-party-registration-certificate) (§11). Each example illustrates a different registrant profile. Where meaningful, both the registration view (full, includes `postalAddress`) and the published API view (excludes `postalAddress`) are shown.

---

## 1. Attestation issuer — QEAA Provider (university issuing education credentials)

A university that issues Qualified Electronic Attestations of Attributes (diplomas). It also requests PID attributes to verify the holder's identity before issuance, so it has both `providesAttestations` (mandatory for `QEAA_Provider`) and `intendedUse`.

### 1.1 Registration view

````json
{
  "legalPerson": {
    "legalName": ["University of Example"],
    "establishedBylaw": [
      {
        "lang": "de",
        "legalBasis": "Hochschulgesetz des Landes Berlin, §1"
      }
    ]
  },
  "identifier": [
    {
      "type": "http://data.europa.eu/eudi/id/EUID",
      "identifier": "DE-EUID-987654321"
    }
  ],
  "postalAddress": [
    "Universitätsplatz 1, 10117 Berlin, DE"
  ],
  "country": "DE",
  "email": ["wallet-rp@example-uni.de"],
  "phone": ["+4930000000"],
  "infoURI": ["https://example-uni.de"],
  "providerType": "WalletRelyingParty",
  "policy": [
    {
      "type": "http://data.europa.eu/eudi/policy/terms-and-conditions",
      "policyURI": "https://example-uni.de/terms"
    },
    {
      "type": "http://data.europa.eu/eudi/policy/privacy-policy",
      "policyURI": "https://example-uni.de/privacy"
    }
  ],
  "tradeName": "UniExample Digital Credentials",
  "supportURI": ["https://example-uni.de/support"],
  "srvDescription": [
    [
      { "lang": "en", "content": "Issuance of qualified educational attestations." },
      { "lang": "de", "content": "Ausstellung qualifizierter Bildungsnachweise." }
    ]
  ],
  "isPSB": true,
  "entitlement": [
    "https://uri.etsi.org/19475/Entitlement/QEAA_Provider"
  ],
  "providesAttestations": [
    {
      "format": "dc+sd-jwt",
      "meta": {
        "vct_values": ["https://example-uni.de/schema/diploma"]
      },
      "claim": [
        { "path": ["family_name"] },
        { "path": ["given_name"] },
        { "path": ["degree_title"] },
        { "path": ["graduation_date"] },
        { "path": ["field_of_study"] }
      ]
    }
  ],
  "intendedUse": [
    {
      "intendedUseIdentifier": "iu-diploma-issuance",
      "purpose": [
        {
          "lang": "en",
          "content": "Verify holder identity before issuing a qualified diploma attestation."
        }
      ],
      "privacyPolicy": [
        {
          "type": "http://data.europa.eu/eudi/policy/privacy-statement",
          "policyURI": "https://example-uni.de/privacy/wallet"
        }
      ],
      "credential": [
        {
          "format": "dc+sd-jwt",
          "meta": {
            "vct_values": ["https://example.eu/schema/pid"]
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
  ],
  "supervisoryAuthority": {
    "legalPerson": {
      "legalName": ["Senatsverwaltung für Wissenschaft Berlin"]
    },
    "country": "DE",
    "email": ["contact@wissenschaft.berlin.de"],
    "infoURI": ["https://wissenschaft.berlin.de"]
  },
  "registryURI": "https://registry.example.de/api",
  "isIntermediary": false
}
````

### 1.2 Published API view (excludes `postalAddress`)

````json
{
  "legalPerson": {
    "legalName": ["University of Example"],
    "establishedBylaw": [
      {
        "lang": "de",
        "legalBasis": "Hochschulgesetz des Landes Berlin, §1"
      }
    ]
  },
  "identifier": [
    {
      "type": "http://data.europa.eu/eudi/id/EUID",
      "identifier": "DE-EUID-987654321"
    }
  ],
  "country": "DE",
  "email": ["wallet-rp@example-uni.de"],
  "phone": ["+4930000000"],
  "infoURI": ["https://example-uni.de"],
  "providerType": "WalletRelyingParty",
  "policy": [
    {
      "type": "http://data.europa.eu/eudi/policy/privacy-policy",
      "policyURI": "https://example-uni.de/privacy"
    }
  ],
  "tradeName": "UniExample Digital Credentials",
  "supportURI": ["https://example-uni.de/support"],
  "srvDescription": [
    [
      { "lang": "en", "content": "Issuance of qualified educational attestations." }
    ]
  ],
  "isPSB": true,
  "entitlement": [
    "https://uri.etsi.org/19475/Entitlement/QEAA_Provider"
  ],
  "providesAttestations": [
    {
      "format": "dc+sd-jwt",
      "meta": {
        "vct_values": ["https://example-uni.de/schema/diploma"]
      },
      "claim": [
        { "path": ["family_name"] },
        { "path": ["given_name"] },
        { "path": ["degree_title"] },
        { "path": ["graduation_date"] },
        { "path": ["field_of_study"] }
      ]
    }
  ],
  "intendedUse": [
    {
      "intendedUseIdentifier": "iu-diploma-issuance",
      "purpose": [
        {
          "lang": "en",
          "content": "Verify holder identity before issuing a qualified diploma attestation."
        }
      ],
      "privacyPolicy": [
        {
          "type": "http://data.europa.eu/eudi/policy/privacy-statement",
          "policyURI": "https://example-uni.de/privacy/wallet"
        }
      ],
      "credential": [
        {
          "format": "dc+sd-jwt",
          "meta": { "vct_values": ["https://example.eu/schema/pid"] },
          "claim": [
            { "path": ["family_name"] },
            { "path": ["given_name"] },
            { "path": ["birth_date"] }
          ]
        }
      ],
      "createdAt": "2026-01-01"
    }
  ],
  "supervisoryAuthority": {
    "legalPerson": {
      "legalName": ["Senatsverwaltung für Wissenschaft Berlin"]
    },
    "country": "DE",
    "infoURI": ["https://wissenschaft.berlin.de"]
  },
  "registryURI": "https://registry.example.de/api",
  "isIntermediary": false
}
````

---

## 2. Designated intermediary

An entity registered as a designated intermediary that acts on behalf of WRPs during wallet interactions. It has `isIntermediary: true` and does not declare `intendedUse` (not required when registering solely as an intermediary).

### 2.1 Registration view

````json
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
````

### 2.2 Published API view (excludes `postalAddress`)

````json
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
  "country": "NL",
  "email": ["wallet-intermediary@trustbridge.example"],
  "phone": ["+31200000000"],
  "infoURI": ["https://trustbridge.example"],
  "providerType": "WalletRelyingParty",
  "policy": [
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
    "infoURI": ["https://autoriteitpersoonsgegevens.nl"]
  },
  "registryURI": "https://registry.example.nl/api",
  "isIntermediary": true
}
````

---

## 3. WRP using a designated intermediary

A small e-commerce business that relies on TrustBridge (see example 2) to conduct wallet interactions on its behalf. It has `usesIntermediary` pointing to the intermediary's registry entry, and `isIntermediary: false`.

### 3.1 Registration view

````json
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
````

### 3.2 Published API view (excludes `postalAddress`)

````json
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
  "country": "NL",
  "email": ["wallet-rp@shopexample.example"],
  "infoURI": ["https://shopexample.example"],
  "providerType": "WalletRelyingParty",
  "policy": [
    {
      "type": "http://data.europa.eu/eudi/policy/privacy-policy",
      "policyURI": "https://shopexample.example/privacy"
    }
  ],
  "tradeName": "ShopExample",
  "supportURI": ["https://shopexample.example/support"],
  "srvDescription": [
    [
      { "lang": "en", "content": "Online retail services." }
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
````

---

## 4. Combined — Service provider and attestation issuer

A bank registered as both a service provider (requesting PID for KYC) and a `QEAA_Provider` (issuing bank account attestations to wallet units). It has both `intendedUse` and `providesAttestations`.

### 4.1 Registration view

````json
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
  "email": ["wallet-rp-registration@examplebank.eu"],
  "phone": ["+33100000000"],
  "infoURI": ["https://examplebank.eu"],
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
  "supportURI": ["https://examplebank.eu/support"],
  "srvDescription": [
    [
      { "lang": "en", "content": "Retail banking services for individuals." },
      { "lang": "fr", "content": "Services bancaires pour particuliers." }
    ],
    [
      { "lang": "en", "content": "Issuance of qualified bank account attestations." },
      { "lang": "fr", "content": "Délivrance d'attestations de compte bancaire qualifiées." }
    ]
  ],
  "isPSB": false,
  "entitlement": [
    "https://uri.etsi.org/19475/Entitlement/Service_Provider",
    "https://uri.etsi.org/19475/Entitlement/QEAA_Provider"
  ],
  "providesAttestations": [
    {
      "format": "dc+sd-jwt",
      "meta": {
        "vct_values": ["https://examplebank.eu/schema/bank-account"]
      },
      "claim": [
        { "path": ["iban"] },
        { "path": ["account_holder_name"] },
        { "path": ["account_type"] },
        { "path": ["currency"] }
      ]
    }
  ],
  "intendedUse": [
    {
      "intendedUseIdentifier": "iu-account-opening",
      "purpose": [
        { "lang": "en", "content": "Open a bank account remotely." },
        { "lang": "fr", "content": "Ouvrir un compte bancaire à distance." }
      ],
      "privacyPolicy": [
        {
          "type": "http://data.europa.eu/eudi/policy/privacy-statement",
          "policyURI": "https://examplebank.eu/privacy/wallet/account-opening"
        }
      ],
      "credential": [
        {
          "format": "dc+sd-jwt",
          "meta": { "vct_values": ["https://example.eu/schema/pid"] },
          "claim": [
            { "path": ["family_name"] },
            { "path": ["given_name"] },
            { "path": ["birth_date"] },
            { "path": ["nationalities"] }
          ]
        }
      ],
      "createdAt": "2026-01-01"
    },
    {
      "intendedUseIdentifier": "iu-bank-account-attestation-issuance",
      "purpose": [
        {
          "lang": "en",
          "content": "Verify wallet holder identity to issue a bank account attestation."
        }
      ],
      "privacyPolicy": [
        {
          "type": "http://data.europa.eu/eudi/policy/privacy-statement",
          "policyURI": "https://examplebank.eu/privacy/wallet/attestation-issuance"
        }
      ],
      "credential": [
        {
          "format": "dc+sd-jwt",
          "meta": { "vct_values": ["https://example.eu/schema/pid"] },
          "claim": [
            { "path": ["family_name"] },
            { "path": ["given_name"] },
            { "path": ["birth_date"] }
          ]
        }
      ],
      "createdAt": "2026-01-01"
    }
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
  "isIntermediary": false
}
````

### 4.2 Published API view (excludes `postalAddress`)

````json
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
  "country": "FR",
  "email": ["wallet-rp-registration@examplebank.eu"],
  "phone": ["+33100000000"],
  "infoURI": ["https://examplebank.eu"],
  "providerType": "WalletRelyingParty",
  "policy": [
    {
      "type": "http://data.europa.eu/eudi/policy/privacy-policy",
      "policyURI": "https://examplebank.eu/privacy"
    }
  ],
  "tradeName": "ExampleBank Mobile",
  "supportURI": ["https://examplebank.eu/support"],
  "srvDescription": [
    [
      { "lang": "en", "content": "Retail banking services for individuals." }
    ],
    [
      { "lang": "en", "content": "Issuance of qualified bank account attestations." }
    ]
  ],
  "isPSB": false,
  "entitlement": [
    "https://uri.etsi.org/19475/Entitlement/Service_Provider",
    "https://uri.etsi.org/19475/Entitlement/QEAA_Provider"
  ],
  "providesAttestations": [
    {
      "format": "dc+sd-jwt",
      "meta": {
        "vct_values": ["https://examplebank.eu/schema/bank-account"]
      },
      "claim": [
        { "path": ["iban"] },
        { "path": ["account_holder_name"] },
        { "path": ["account_type"] },
        { "path": ["currency"] }
      ]
    }
  ],
  "intendedUse": [
    {
      "intendedUseIdentifier": "iu-account-opening",
      "purpose": [
        { "lang": "en", "content": "Open a bank account remotely." }
      ],
      "privacyPolicy": [
        {
          "type": "http://data.europa.eu/eudi/policy/privacy-statement",
          "policyURI": "https://examplebank.eu/privacy/wallet/account-opening"
        }
      ],
      "credential": [
        {
          "format": "dc+sd-jwt",
          "meta": { "vct_values": ["https://example.eu/schema/pid"] },
          "claim": [
            { "path": ["family_name"] },
            { "path": ["given_name"] },
            { "path": ["birth_date"] },
            { "path": ["nationalities"] }
          ]
        }
      ],
      "createdAt": "2026-01-01"
    },
    {
      "intendedUseIdentifier": "iu-bank-account-attestation-issuance",
      "purpose": [
        {
          "lang": "en",
          "content": "Verify wallet holder identity to issue a bank account attestation."
        }
      ],
      "privacyPolicy": [
        {
          "type": "http://data.europa.eu/eudi/policy/privacy-statement",
          "policyURI": "https://examplebank.eu/privacy/wallet/attestation-issuance"
        }
      ],
      "credential": [
        {
          "format": "dc+sd-jwt",
          "meta": { "vct_values": ["https://example.eu/schema/pid"] },
          "claim": [
            { "path": ["family_name"] },
            { "path": ["given_name"] },
            { "path": ["birth_date"] }
          ]
        }
      ],
      "createdAt": "2026-01-01"
    }
  ],
  "supervisoryAuthority": {
    "legalPerson": {
      "legalName": ["Autorité de supervision Exemple"]
    },
    "country": "FR",
    "infoURI": ["https://supervisor.example.fr"]
  },
  "registryURI": "https://registry.example.fr/api",
  "isIntermediary": false
}
````
