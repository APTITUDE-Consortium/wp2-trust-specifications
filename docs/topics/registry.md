This section specifies requirements for the <roles:Registrar> of <roles:Wallet-Relying Party (WRP)|WRPs> and the national <components:Register> of <roles:Wallet-Relying Party (WRP)|WRPs> (the registry service) in the context of eIDAS2 and the <components:EUDI Wallet> ecosystem.

Formally, a <roles:Registrar> is the designated body that:

- Manages the <roles:Wallet-Relying Party (WRP)|WRP> registration lifecycle (onboarding, update, suspension, cancellation),
- Ensures the integrity and publication of registration information,
- Ensures interoperability by exposing <roles:Wallet-Relying Party (WRP)|WRP> registration data via a national website and a single common REST API.

The national <components:Register> of <roles:Wallet-Relying Party (WRP)|WRPs> is the publicly accessible system (dataset + API) that provides signed/sealed registration statements about <roles:Wallet-Relying Party (WRP)|WRPs> and their authorisations/declared usage.

!!! note

    The national <components:Register> of <roles:Wallet-Relying Party (WRP)|WRPs> is a single logical register. For scalability and resilience, a Member State MAY deploy multiple technical instances provided they expose a single coherent common REST API and return signed statements as required.
    
    Additionally, sectorial registers may exist internally, but the decision regarding issuance of <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> is solely based on whether the <roles:Wallet-Relying Party (WRP)|WRP> has been registered with an active status in the national <components:Register>.

??? references

    The list below enumerates all the applicable standards and specifications that have been used to populate the table below:

    - **CIR 2025/848** on <roles:Wallet-Relying Party (WRP)|WRP> registration and <components:Register|Registers>.
    - **CIR 2025/848-Amendment**. This draft slightly modifies Annexes I-V of [CIR 2025/848] and introduces Annex VI for common API and data schema for <components:Register> of <roles:Wallet-Relying Party (WRP)|WRPs>.
    - **ETSI TS 119 475** on <roles:Wallet-Relying Party (WRP)|WRP> attributes, entitlement URIs, <roles:Relying Party (RP)|RP> authorisation decision support.
    - **RFC 7515**
    - **RFC 7519**
    - **RFC 8392**
    - **TS05** on common formats and API for <roles:Wallet-Relying Party (WRP)|WRP> registration information.
    - **TS06** on common set of <roles:Wallet-Relying Party (WRP)|WRP> information to be registered.

#### Requirements

##### Register Requirements

| ID | Requirement | Reference |
| -- | ----------- | --------- |
| REGISTER-PUB-01 | Each Member State SHALL establish and maintain at least one national Register of WRPs. | [CIR 2025/848, Article 3(1)] |
| REGISTER-PUB-02 | The Register SHALL include at least the information set out in Annex I of [CIR 2025/848]. | [CIR 2025/848, Article 3(2)] |
| REGISTER-PUB-03 | Member States SHALL designate at least one Registrar to manage and operate at least one national Register. | [CIR 2025/848, Article 3(3)] |
| REGISTER-PUB-04 | Member States SHALL make Annex I information publicly available online in human-readable and machine-processable form. | [CIR 2025/848, Article 3(4)] |
| REGISTER-PUB-05 | Annex I information included in the Register (as for REGISTER-PUB-02) SHALL be available through a national website and a single common API, and SHALL be electronically signed/sealed by/on behalf of the Registrar. | [CIR 2025/848, Article 3(5)] |
| REGISTER-API-01 | The single common API SHALL be a REST API supporting JSON, and signed according to [RFC 7515]. | [CIR 2025/848, Annex II §2(1)(a)] |
| REGISTER-API-02 | The API SHALL allow any requestor, without prior authentication, to search and request complete lists, allowing partial matches on defined parameters. | [CIR 2025/848, Annex II §2(1)(b)] |
| REGISTER-API-03 | Replies to request that match at least one WRP SHALL include statements covering Annex I information [CIR 2025/848], current/historic WRPACs and WRPRCs, excluding Annex I point 4 information. | [CIR 2025/848, Annex II §2(1)(c)] |
| REGISTER-API-04 | The API SHALL be published as OpenAPI v3 with documentation enabling interoperability across the Union. | [CIR 2025/848, Annex II §2(1)(d)] |
| REGISTER-API-05 | The API SHALL provide security-by-default and by-design to ensure availability and integrity. | [CIR 2025/848, Annex II §2(1)(e)] |
| REGISTER-API-06 | Statements referred to in REGISTER-API-03 SHALL be electronically signed/sealed JSON files as for [RFC 7515]. | [CIR 2025/848, Annex II §2(2)] |

!!! note

    The set of <roles:Wallet-Relying Party (WRP)|WRP> information listed in Annex I of [CIR 2025/848] and mentioned in REGISTER-PUB-05 and REGISTER-API-03 will be described in the [Register Data Schema](#register-data-schema) section.

##### Registrar Requirements

| ID | Requirement | Reference |
| -- | ----------- | --------- |
| REGISTRAR-REG-01 | <roles:Registrar\|Registrars> SHALL establish easy-to-use electronic, and where possible automated, registration processes. | [CIR 2025/848, Article 6(1)] |
| REGISTRAR-REG-02 | WRPs SHALL provide at least Annex I information to national registers. | [CIR 2025/848, Article 5(1)] |
| REGISTRAR-REG-03 | WRPs SHALL ensure information is accurate and SHALL update without undue delay. | [CIR 2025/848, Article 5(2)–(3)] |
| REGISTRAR-REG-04 | Where possible, <roles:Registrar\|Registrars> SHALL verify (automated) accuracy/validity, power of attorney (if applicable), entitlement type(s), and absence of existing registration in another national Register. | [CIR 2025/848, Article 6(3)] |
| REGISTRAR-REG-05 | <roles:Registrar\|Registrars> SHALL verify against supporting documentation or appropriate <components:Authentic Source\|Authentic Sources>/official records. | [CIR 2025/848, Article 6(4)] |
| REGISTRAR-REG-06 | Verification of entitlements SHALL be carried out according to Annex III of [CIR 2025/848]. | [CIR 2025/848, Article 6(5)] |
| REGISTRAR-REG-07 | If Registrar cannot verify according to Article 6(3)–(5) of [CIR 2025/848], Registrar SHALL reject the registration. | [CIR 2025/848, Article 6(6)] |
| REGISTRAR-GOV-01 | <roles:Registrar\|Registrars> SHALL suspend/cancel a registration of a WRP where requested by a <roles:Supervisory Body\|supervisory body> (per eIDAS reference). | [CIR 2025/848, Article 9(1)] |
| REGISTRAR-GOV-02 | <roles:Registrar\|Registrars> MAY suspend/cancel a registration of a WRP if info inaccurate/outdated/misleading, non-compliance, excessive attribute requests, breach of law. | [CIR 2025/848, Article 9(2)] |
| REGISTRAR-GOV-03 | <roles:Registrar\|Registrars> SHALL suspend/cancel a registration of a WRP if requested by the WRP itself. | [CIR 2025/848, Article 9(3)] |
| REGISTRAR-GOV-04 | Registrar SHALL conduct proportionality assessment before suspension/cancellation under Article 9(2). | [CIR 2025/848, Article 9(4)] |
| REGISTRAR-GOV-05 | Registrar SHALL notify WRP and relevant Providers of WRPAC and WRPRC without undue delay and not later than 24 hours. | [CIR 2025/848, Article 9(5)] |
| REGISTRAR-GOV-06 | Providers of WRPAC and WRPRC SHALL revoke affected certificates without undue delay after notification (where applicable). | [CIR 2025/848, Article 9(6)] |
| REGISTRAR-GOV-07 | <roles:Registrar\|Registrars> SHALL keep records (Annex I + issuance data + changes) for 10 years. | [CIR 2025/848, Article 10] |

##### Provider of WRPAC and WRPRC and Register Interactions Requirements

| ID | Requirement | Reference |
| -- | ----------- | --------- |
| PROVIDER-WRPAC-01 | Providers of <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC> SHALL verify at issuance time that the WRP is included with valid registration status in the national Register and certificate info is consistent with Register info. | [CIR 2025/848, Annex IV §3(c)] |
| PROVIDER-WRPAC-02 | Providers of <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC> SHALL continuously monitor changes in the national Register and revoke when changes require (especially suspension/cancellation). | [CIR 2025/848, Annex IV §3(e)] |
| PROVIDER-WRPAC-03 | Providers of WRPAC SHALL publish revocation status timely and in any event within 24 hours after receipt of revocation request. | [CIR 2025/848, Annex IV §3(h)] |
| PROVIDER-WRPRC-01 | Where a Member State authorises WRPRCs, it SHALL ensure each intended use is expressed in the WRPRC and that WRPRCs include a privacy policy URL and a general access policy. | [CIR 2025/848, Article 8(2)(b)–(c) and (g), Article 8(3)] |
| PROVIDER-WRPRC-02 | Providers of WRPRC SHALL verify at issuance time Register status, consistency with Register info, and validity of the WRPAC (when relevant). | [CIR 2025/848, Annex V §3(c)] |
| PROVIDER-WRPRC-03 | Providers of WRPRC SHALL monitor Register changes, reissue/revoke when changes require. | [CIR 2025/848, Annex V §3(d)] |
| PROVIDER-WRPRC-04 | Data exchange format for WRPRC SHALL be signed JWTs (RFC 7519) and CWTs (RFC 8392), using an Advanced Electronic Signature (AdES) with the B-B profile (JAdES per [ETSI TS 119 182-1] for JWT, COSE for CWT). | [CIR 2025/848, Annex V §4]; [ETSI TS 119 475, Section 4.4] |

#### Register Data Schema

This section defines the data schema for each <roles:Wallet-Relying Party (WRP)\|WRP> registered in the national <components:Register> of <roles:Wallet-Relying Party (WRP)|WRPs>. The values are extracted from Annex VI of the [CIR 2025/848-Amendment].

<!--format of the information exchanged via the Register API as JSON objects and JWS-signed statements. -->

!!! warning "Address field publication rule"

    The draft Annex VI text says the published API payload excludes `WalletRelyingParty.physicalAddress`, while Table 1 uses the attribute name `postalAddress`. This document uses **`postalAddress`** as the schema field name and applies the publication rule to that field (i.e., do not publish it in API statements).

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `legalPerson` | `LegalPerson` | REQUIRED if legal person | Specific attributes of a legal person. It SHALL be present if the legal entity is a legal person. |
| `naturalPerson` | `NaturalPerson`| REQUIRED if natural person| Specific attributes of a natural person. It SHALL be present if the legal entity is a natural person.|
| `identifier` | `Identifier[]` | REQUIRED | One or more identifiers from official records. |
| `postalAddress` | `string[]` | OPTIONAL | Postal address(es) of the legal entity (**registration view only; excluded from published API statements**). Note: [ETSI TS 119 475, B.2.2] defines this as `[1..1] string`; Draft Annex VI Table 1 uses an array. This document follows Draft Annex VI. |
| `country` |  `string` | REQUIRED | ISO 3166-1 alpha-2 country code, or `"EU"` for providers operating in the Union. |
| `email` | `string[]` | OPTIONAL | Contact email address(es) (RFC 5322 format). |
| `phone` | `string[]` | OPTIONAL | Contact phone number(s), international form with `+` prefix. |
| `infoURI` | `string[]` | OPTIONAL | Web page URI(s) for information about the entity. |
| `providerType` | `string` | REQUIRED | Provider subtype. For WRP records, typically `WalletRelyingParty`. |
| `policy` | `Policy[]` | REQUIRED | Policy/terms/privacy/registration policy URL(s) with policy type URI. |
| `x5c` |  `string[]` | OPTIONAL | X.509 certificate chain(s) for provider services (JWS `x5c`-style chains; supports rollover). |
| `tradeName` | `string` | OPTIONAL | User-facing trade/service name recognisable to users. |
| `supportURI` | `string[]` | REQUIRED | Support/helpdesk URI(s) for the service. |
| `srvDescription` |  `MultiLangString[][]` | REQUIRED | Array of service descriptions, each being an array of localised strings (one inner array per service). |
| `intendedUse` | `IntendedUse[]` | REQUIRED if the entity is not an intermediary | Intended-use definitions and requested attestation data. Not required if registering only as a designated intermediary. |
| `isPSB` | `boolean` | REQUIRED | Whether the WRP is a <roles:Public Sector Body> (explicitly present; `false` if not PSB). |
| `entitlement` |  `string[]` | REQUIRED | Entitlement URI(s) (see note below). |
| `providesAttestations` | `Credential[]` | REQUIRED if PID/Attestation Provider| Attestation types the WRP intends to issue to wallet units. It SHALL be present if any entitlement is `QEAA_Provider`, `Non_Q_EAA_Provider`, `PUB_EAA_Provider`, or `PID_Provider`. |
| `supervisoryAuthority` | `LegalEntity` | REQUIRED | Competent supervisory authority (Art. 46a eIDAS) including contact information. |
| `registryURI` | `string` | REQUIRED | URI of the API of the national register of WRPs. |
| `usesIntermediary` | `WalletRelyingParty[]` | OPTIONAL | If present, indicates designated intermediary(ies). Only the subset `{identifier, tradeName, registryURI}` is needed for each intermediary reference. |
| `isIntermediary` | `boolean` | REQUIRED | Whether the registered entity is a designated intermediary. SHALL be `false` if `usesIntermediary` is present. |

!!! note

    Mapping between CIR entitlement label and [ETSI TS 119 475, Annex A.2] normative URI:

    | CIR entitlement label | Normative URI | 
    | --------------------- | ------------- |
    | `Service_Provider` | `https://uri.etsi.org/19475/Entitlement/Service_Provider`| 
    | `QEAA_Provider` | `https://uri.etsi.org/19475/Entitlement/QEAA_Provider` |
    | `Non_Q_EAA_Provider` | `https://uri.etsi.org/19475/Entitlement/Non_Q_EAA_Provider` | 
    | `PUB_EAA_Provider` | `https://uri.etsi.org/19475/Entitlement/PUB_EAA_Provider` |
    | `PID_Provider` | `https://uri.etsi.org/19475/Entitlement/PID_Provider`| 
    | `QCert_for_ESeal_Provider` | `https://uri.etsi.org/19475/Entitlement/QCert_for_ESeal_Provider` | 
    | `QCert_for_ESig_Provider` | `https://uri.etsi.org/19475/Entitlement/QCert_for_ESig_Provider` |
    | `rQSigCDs_Provider` | `https://uri.etsi.org/19475/Entitlement/rQSigCDs_Provider`  | 
    | `rQSealCDs_Provider` | `https://uri.etsi.org/19475/Entitlement/rQSealCDs_Provider` | 
    | `ESig_ESeal_Creation_Provider` | `https://uri.etsi.org/19475/Entitlement/ESig_ESeal_Creation_Provider` | 

    [ETSI TS 119 475, Annex A.3] defines additional sub-entitlement URIs for specific service provider roles. For example, Payment Service Provider sub-entitlements include:

    | Sub-entitlement | URI |
    | --------------- | --- |
    | Account Servicing PSP | `https://uri.etsi.org/19475/SubEntitlement/psp/psp-as` |
    | Payment Initiation Service Provider | `https://uri.etsi.org/19475/SubEntitlement/psp/psp-pi` |
    | Account Information Service Provider | `https://uri.etsi.org/19475/SubEntitlement/psp/psp-ai` |
    | PSP issuing card-based payment instruments | `https://uri.etsi.org/19475/SubEntitlement/psp/psp-ic` |
    | Unspecified PSP | `https://uri.etsi.org/19475/SubEntitlement/psp/unspecified` |

    Future editions may define additional sub-entitlements at national or EU level.

##### Identifier

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `identifier` | `string` | REQUIRED | Identifier value of the LegalEntity. |
| `type`       | `string` | REQUIRED | Identifier scheme/type URI (see normative URIs below). |

Normative identifier type URIs defined in [ETSI TS 119 475]:

| Label | Normative URI | Description |
| ----- |-------------- | ----------- |
| EORI-No | `http://data.europa.eu/eudi/id/EORI-No` | Economic Operator Registration and Identification Number according to (EU) No 1352/2013. |
| LEI | `http://data.europa.eu/eudi/id/LEI` | Legal Entity Identifier according to (EU) 2022/1860; [ISO 17442-1]. |
| EUID | `http://data.europa.eu/eudi/id/EUID` | European Unique Identifier according to (EU) 2020/2244; (EU) 2021/1042. |
| VATIN | `http://data.europa.eu/eudi/id/VATIN` | Value Added Tax Identification Number according to Council Directive 2006/112/EC. |
| TIN | `http://data.europa.eu/eudi/id/TIN` | Taxpayer Identification Number. |
| Excise | `http://data.europa.eu/eudi/id/Excise` | Excise Number according to Art. 2 (12) of the Council Regulation (EC) No 389/2012. |

!!! note

    Additional type identifiers may be defined at national or EU level.

##### MultiLangString

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `lang`    | `string` | REQUIRED | Language tag (e.g., `en`, `fr`). |
| `content` | `string` | REQUIRED | Language-specific content. |

##### IntendedUse

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `intendedUseIdentifier` | `string` |  REQUIRED | Registry-level unique identifier for the intended use. |
| `purpose` | `MultiLangString[]` |  REQUIRED | Description of intended use of the data to request from wallet units. |
| `privacyPolicy` | `Policy[]`|  REQUIRED | Privacy policy URL(s) for the intended use. |
| `credential`| `Credential[]` |  REQUIRED | Machine-readable list of requested data (attestations/attributes). |
| `createdAt` | `string` | REQUIRED | Validity start date of the intended use in accordance with ISO86011  YYYY-MM-DD format. |
| `revokedAt` | `string` | OPTIONAL | End date for the validity of the intended use in accordance with ISO86011  YYYY-MM-DD format. |

##### Policy

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `type` | `string` | REQUIRED | Policy type URI (RFC 3986). See defined policy type URIs below. |
| `policyURI` | `string` | REQUIRED | URL where the policy is published. |

Defined policy type URIs:

| Policy type | URI | Reference |
| ----------- | --- | --------- |
| Privacy policy | `http://data.europa.eu/eudi/policy/privacy-policy` | [ETSI TS 119 475, B.2.8]; [CIR 2025/848, Article 8(2)(g)] |
| Terms and conditions | `http://data.europa.eu/eudi/policy/terms-and-conditions` | [CIR 2025/848-Amendment, Annex VI, Table 7] |
| Privacy statement (intended use) | `http://data.europa.eu/eudi/policy/privacy-statement` | [CIR 2025/848-Amendment, Annex VI, Table 7] |

!!! note

    Additional policy type URIs may be defined at national or EU level.

##### Credential

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `format`  |  `string` | REQUIRED | Credential format identifier (e.g., `dc+sd-jwt`, `mso_mdoc`). |
| `meta`    |  `object` | REQUIRED | Additional grouping/type metadata defined per credential format (e.g., `{"vct": "..."}` for `dc+sd-jwt`, `{"doctype_value": "..."}` for `mso_mdoc`). See OpenID4VP §6.1. |
| `claim`   | `Claim[]` |  OPTIONAL | Requested claim paths and allowed values (if constrained). |

##### Claim

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `path` | `array` | REQUIRED | Non-empty path array of strings / `null` / non-negative integers (OpenID4VP-style path pointer segments). |
| `values` | `array` | OPTIONAL | Optional allowed values; elements may be `string`, `integer`, or `boolean`. |

##### LegalEntity (for `supervisoryAuthority`)

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `legalPerson` | `LegalPerson` | OPTIONAL | Present when the authority is a legal person. |
| `naturalPerson` | `NaturalPerson` | OPTIONAL | Present when the authority is a natural person. |
| `identifier` | `Identifier[]` | OPTIONAL | Identifier(s) of the authority. |
| `postalAddress` | `string[]` | OPTIONAL | Postal address(es) of the authority. |
| `country` | `string` | REQUIRED | Country code (or `EU` where applicable). |
| `email` | `string[]` | OPTIONAL | Email address(es) of the authority. |
| `phone` | `string[]` | OPTIONAL | Phone number(s) of the authority. |
| `infoURI` | `string[]` | OPTIONAL | Information URI(s) of the authority. |

##### LegalPerson

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `legalName` | `string[]` | REQUIRED | Legal name(s) as in official records. |
| `establishedBylaw` | `Law[]` | REQUIRED if PSBs responsible for <components:Authentic Source\|Authentic Sources> | Legal basis for establishment. It SHALL be present for PSBs responsible for <components:Authentic Source\|Authentic Sources>; present for other PSBs where applicable. |

##### NaturalPerson

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `givenName` | `string` | REQUIRED | Current first name(s), including middle names where applicable. |
| `familyName` | `string` | REQUIRED | Current surname(s). |
| `dateOfBirth` | `string` | OPTIONAL | Date of birth (where present in official records). |
| `placeOfBirth` | `string`| OPTIONAL | Place of birth (where present in official records). |

##### Law

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `lang` | `string` | REQUIRED | Two-letter language code (ISO 639-1 style). |
| `legalBasis` | `string` | REQUIRED | Legal basis text establishing the legal person (or requiring/recommending access to a claim). |

##### Non-normative example: WRP object for a Relying Party

A bank registered as a service provider (requesting PID for KYC).

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
````

##### Non-normative example: WRP object for a Relying Party that is also an Attestation Provider

A bank registered as both a service provider (requesting <credentials:Person Identification Data (PID)|PID> for KYC) and a `QEAA_Provider` (issuing bank account attestations to wallet units). It has both `intendedUse` and `providesAttestations`.

````json
{
  "legalPerson": {
    "legalName": ["ExampleBank S.A."]
  },
  [...as previous example...] 
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

##### Non-normative example: WRP object for a designated Intermediary

An entity registered as a designated Intermediary that acts on behalf of <roles:Wallet-Relying Party (WRP)|WRPs> during Wallet interactions. It has `isIntermediary: true` and does not declare `intendedUse` (not required when registering solely as an intermediary).

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

##### Non-normative example: WRP object for a WRP using a designated Intermediary

A small e-commerce business that relies on TrustBridge (see example above) to conduct Wallet interactions on its behalf. It has `usesIntermediary` pointing to the Intermediary's registry entry, and `isIntermediary: false`.

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

#### Common Register API

This section documents a [TS05] aligned common <components:Register> API profile that satisfies [CIR 2025/848, Annex II] and [CIR 2025/848-Amendment] constraints.

!!! note

    The OpenAPI Specification (OAS) of the API described in this section is available in [this page](../api/register-api.md).

##### API Methods on Registration and Updating of WRP Data

The common API write methods (POST, PUT and DELETE) are defined for purposes of managing the <components:Register> information of MS <roles:Registrar|Registrars>.

!!! note

    These methods SHALL be accessible by authorised users only.

###### `POST /wrp` — create (REQUIRED)

POST is for creating a new <roles:Wallet-Relying Party (WRP)|WRP> entry in the <components:Register>. Method expects a request body with the `WalletRelyingParty` schema, and returns a `201` on success.

**Request (body)**

| Type | Presence | Description |
| ---- | -------- | ----------- |
| `WalletRelyingParty` | REQUIRED | Full WRP object compliant with [CIR 2025/848-Amendment, Annex VI, Table 1] schema. |

**Response**

| HTTP Code | Description |
| ----------| ----------- |
| `201` | Created. |
| `400` | Bad request (invalid or incomplete payload). |
| `401` | Unauthorized (missing or invalid authentication). |
| `403` | Forbidden (caller not authorised by Member State). |

---

###### `PUT /wrp` — update (REQUIRED)

PUT is for updating an existing <roles:Wallet-Relying Party (WRP)|WRP> entry in the <components:Register>. Method expects a request body with the `WalletRelyingParty` schema, and can return `200` on success or `404` if not found.

**Request (body)**

| Type | Presence | Description |
| ---- | -------- | ----------- |
| `WalletRelyingParty` | REQUIRED | Full WRP object compliant with [CIR 2025/848-Amendment, Annex VI, Table 1] schema. |

**Response**

| HTTP Code | Description |
| ----------| ----------- |
| `200` | Successfully updated. |
| `400` | Bad request (invalid or incomplete payload). |
| `401` | Unauthorized (missing or invalid authentication). |
| `403` | Forbidden (caller not authorised by Member State). |
| `404` | Not found. |

---

###### `DELETE /wrp` — delete (REQUIRED)

DELETE is for deleting an existing <roles:Wallet-Relying Party (WRP)|WRP> entry in the <components:Register>. Method expects a request body with the `WalletRelyingParty` identifier, and returns a `204` on success.

**Request (body)**

| Parameter | Presence | Description |
| --------- | -------- | ----------- |
| `identifier` | REQUIRED | Identifier payload for the WRP to delete (profile-defined body shape, based on `WalletRelyingParty.identifier`). |

!!! warning

    For [TS05] and [CIR 2025/848-Amendment], this method expects a request body with the `WalletRelyingParty` identifier, while in the corresponding YAML file [ts5-openapi31-registrar-api.yml](https://github.com/eu-digital-identity-wallet/eudi-doc-standards-and-technical-specifications/blob/main/docs/technical-specifications/api/ts5-openapi31-registrar-api.yml) the identifier is sent as a query parameter. This profile follows the [CIR 2025/848-Amendment].

**Response**

| HTTP Code | Description |
| ----------| ----------- |
| `204` | Successfully deleted. |
| `400` | Bad request (invalid or incomplete payload). |
| `401` | Unauthorized (missing or invalid authentication). |
| `403` | Forbidden (caller not authorised by Member State). |
| `404` | Not found. |

##### API Methods for Register Queries (Open API)

The common API read methods (GET) SHALL be open for public access (no prior authentication) and returns JWS-signed statements.

The public API SHALL provide methods for searching and querying complete data sets of registered <roles:Wallet-Relying Party (WRP)|WRPs> matching with provided query parameters

###### `GET /wrp` — search/list (REQUIRED)

Get a list of <roles:Wallet-Relying Party (WRP)|WRPs> (with optional filtering and pagination, list of all registered WRPs returned when no query parameters are provided).

**Request (query parameters)**

The common API SHALL support parameterised queries on `GET /wrp`. The following names align with the [CIR 2025/848-Amendment, Annex VI] query parameter naming.

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `identifier` | `string` | OPTIONAL | Filter by official/business registration number / identifier. |
| `legalname` | `string` | OPTIONAL | Filter by official company name. |
| `tradename` | `string` | OPTIONAL | Filter by trade name. |
| `policy` | `string` | OPTIONAL | Filter by privacy policy URL (or policy URI as profiled). |
| `entitlement` | `string` | OPTIONAL | Filter by entitlement type (URI). |
| `usesintermediary` | `string` | OPTIONAL | Filter by intermediary identifier. |
| `isintermediary` | `boolean` | OPTIONAL | Filter by intermediary status. |
| `intendeduseidentifier` | `string` | OPTIONAL | Filter by registrar-provided intended-use identifier. |
| `claimpath` | `string` | OPTIONAL | Filter by intended-use requested claim path. |
| `credentialmeta` | `string` | OPTIONAL | Filter by intended-use credential metadata (format-specific). |
| `credentialformat` | `string` | OPTIONAL | Filter by intended-use credential format. |
| `cursor` | `string`  | OPTIONAL | Cursor for pagination (profile-defined token format). |
| `limit` | `integer`  | OPTIONAL | The number of items to return per page (profile-defined). |
| `providesattestation` | `Credential` | OPTIONAL | Filter by attestation types provided. |

!!! warning

    The name of some query parameters differ from [TS05] and the corresponding YAML file [ts5-openapi31-registrar-api.yml](https://github.com/eu-digital-identity-wallet/eudi-doc-standards-and-technical-specifications/blob/main/docs/technical-specifications/api/ts5-openapi31-registrar-api.yml) containing the OpenAPI specification of the JSON and REST based application programming interfaces (e.g., `intendedusecredentialmeta` vs `credentialmeta`). This profile follows the OpenAPI specification.

    In addition, this specification adds `providesattestation` to cover the [CIR 2025/848-Amendment] requirement for filtering parameter: type of attestations provided, returning the complete data set of each of the registered wallet-relying parties matching the value provided for this parameter.

| Requirement |
| ----------- |
| If no query parameters are provided, `GET /wrp` SHALL return the full list of registered WRPs (subject to pagination profile). |
| The endpoint SHALL support cursor-based pagination. |
| The endpoint SHALL support combined filters in a single query. |

**Response**
A successful response (`200`) SHALL be JWS-signed response body.

| HTTP Code | Media Type | Description |
| --------- | ---------- | ----------- |
| `200` | `application/jwt` | JWS compact string. Decoded payload SHALL contain an array of `WalletRelyingParty` objects (matching the query), with address field excluded from published entries, and, where relevant, accompanied by <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC> history information in the statement/profile used by the Member State. (strict Annex VI form: array; profile envelope also allowed if documented). |

!!! note

    The published API view excludes only `postalAddress` ([CIR 2025/848-Amendment, Annex I, point 4]). All other fields, including intended-use credential claims, are published as registered.

<!--
!!! note

    This implementation profile uses *JWS Compact Serialization* for API responses (e.g., `application/jwt`). In JWS Compact Serialization, there is *no unprotected header*; therefore, the JOSE Header is the *JWS Protected Header* and is integrity-protected by the signature.

    The following JOSE Protected Header requirements apply to Registry statements:

    | Header parameter | Presence | Description | Reference |
    | --- | --- | --- | --- |
    | `alg` | REQUIRED | Signature/seal algorithm identifier. The value `none` SHALL NOT be used for Registry statements. | [RFC 7515, §4.1.1]; profile rule |
    | `x5c` | RECOMMENDED (REQUIRED if no trust-list/key-resolution profile is defined) | X.509 certificate chain of the signer/sealer. The signing certificate SHALL be the first certificate in the array. | [RFC 7515, §4.1.6] |
    | `kid` | RECOMMENDED | Key identifier to support key rollover and efficient verifier key selection. | [RFC 7515, §4.1.4] |
    | `x5t#S256` | RECOMMENDED | SHA-256 thumbprint of the signing certificate (useful for pinning / key matching). | [RFC 7515, §4.1.8] |
    | `x5u` | OPTIONAL | URL to signer certificate chain. If used, it SHALL be retrieved over TLS with server identity validation. | [RFC 7515, §4.1.5] |
    | `typ` | RECOMMENDED | Media type hint for the complete JWS object (e.g., `JWT` / `application/jwt` or a profile-specific media type). | [RFC 7515, §4.1.9] |
    | `crit` | OPTIONAL | If used, all listed parameters MUST be understood and processed by verifiers; otherwise the JWS is invalid. `crit` MUST appear only in the protected header. | [RFC 7515, §4.1.11] |

    !!! note

        The JOSE header parameter `x5c` above is part of the JWS signature envelope. It is distinct from any `x5c` attribute defined in the registry payload/data schema (e.g., Annex VI data schema fields).
-->

---

###### `GET /wrp/check-intended-use` — intended use check (REQUIRED)

A dedicated intended-use check endpoint for making narrowed-down intended use related queries from the <components:Register>.

**Request**

This profile uses the following mapping (strictly aligned names for intended-use filters):

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `rpidentifier` | `string` | REQUIRED | Identifier of the WRP whose intended-use registration is being checked. |
| `intendeduseidentifier` | `string` | OPTIONAL | Intended-use identifier registered by the registrar. |
| `claimpath` | `string` | OPTIONAL | Requested claim path to check (serialised representation of path array; profile-defined encoding). |
| `credentialformat` | `string` | OPTIONAL | Credential format to check. |
| `credentialmeta` | `string` | OPTIONAL | Credential metadata filter (profile-defined serialisation). |
| `policyurl` | `string` | OPTIONAL | Used when checking if the privacy policy URL is registered for the identified WRP. |

**Response**

| HTTP Code | Media Type | Description |
| --------- | ---------- | ----------- |
| `200`  | `application/jwt` | JWS compact string; decoded payload is boolean `true` or `false`. |
| `400` | - | Bad request (invalid or incomplete request parameter). |
| `404` | - | WRP with the given `rpidentifier` not found. |

---

###### `GET /wrp/{identifier}` — get by identifier (OPTIONAL)

Get <roles:Wallet-Relying Party (WRP)|WRP> by identifier.

!!! note

    This endpoint is useful, but it is **not explicitly defined** in the [CIR 2025/848-Amendment, Annex VI] common API method list. If kept, mark it as a national/profile extension.

**Request (query)**

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `identifier` | `string` | REQUIRED | Identifier of the WRP to retrieve. |

**Response**

| HTTP Code | Media Type | Description |
| --------- | ---------- | ----------- |
| `200` | `application/jwt` | JWS compact string; decoded payload contains one `WalletRelyingParty` entry (or profile envelope). |
| `404` | - | Not found. |

##### Optional Profile Envelope (recommended for interoperability metadata)

To preserve issuer/timestamp metadata and pagination in a stable schema, a Member State MAY define an envelope profile as follows (while still satisfying the endpoint semantics above):

###### SignedWRPArrayEnvelope (profile)

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `iss` | `string` | REQUIRED | Identifier of the Registry/<roles:Registrar> issuing the statement. |
| `iat` | `integer` | REQUIRED | Issued-at timestamp (Unix epoch seconds). |
| `data` | `WRPEntry[]` | REQUIRED | Matching WRP entries (published view, address excluded), each bundled with its certificate history. |
| `pagination` | `Pagination` | OPTIONAL | Cursor-based pagination metadata. |

###### WRPEntry (per-WRP bundle)

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `wrp` | `WalletRelyingParty` | REQUIRED | WRP registration information (published view, address excluded). |
| `wrpacHistory` | `CertificateHistoryEntry[]` | OPTIONAL | WRP access certificate history for this WRP (including CT-related references where available). |
| `wrprcHistory` | `CertificateHistoryEntry[]` | OPTIONAL | WRP registration certificate history for this WRP (if provided by national profile). |

###### SignedWRPEnvelope (profile, for non-common helper endpoints)

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `iss` | `string` | REQUIRED | Registry/<roles:Registrar> identifier. |
| `iat` | `integer` | REQUIRED | Issued-at timestamp. |
| `data` | `WalletRelyingParty` | REQUIRED | Single WRP object (published view, address excluded). |
| `wrpacHistory` | `CertificateHistoryEntry[]` | OPTIONAL | <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC> history. |
| `wrprcHistory` | `CertificateHistoryEntry[]` | OPTIONAL | <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC> history (if supported). |

###### SignedIntendedUseCheckEnvelope (profile)

!!! note

    Annex VI strictly allows a JWS-signed boolean response. This object envelope is a non-normative profile convenience.

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `iss` | `string` | REQUIRED | Registry issuer. |
| `iat` | `integer` | REQUIRED | Issued-at timestamp. |
| `data` | `boolean` | REQUIRED | Result of intended-use check. |

###### CertificateHistoryEntry (profile helper for certificate histories)

| Parameter | Type | Presence | Description |
| --------- | ---- | -------- | ----------- |
| `certificate` | `string` | REQUIRED | Certificate (e.g., PEM/DER-encoded representation, profile-defined). |
| `x5c` | `string[]`  | OPTIONAL | Certificate chain for the certificate entry. |
| `status` | `string` | REQUIRED | Certificate status (e.g., `current`, `revoked`, `expired`, `historic`). |
| `validFrom` | `string`  | OPTIONAL | Validity start timestamp/date (profile-defined format). |
| `validTo` | `string`  | OPTIONAL | Validity end timestamp/date (profile-defined format). |
| `ctLogEntries` | `object[]`  | OPTIONAL | CT log / transparency references ([RFC 9162]-aligned, profile-defined structure). |
