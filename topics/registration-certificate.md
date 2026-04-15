# Wallet-Relying Party Registration Certificates (WRPRC)

## Overview

This document defines Wallet-Relying Party Registration Certificates (WRPRC), as described in [ARF](https://github.com/eu-digital-identity-wallet/eudi-doc-architecture-and-reference-framework/blob/main/docs/architecture-and-reference-framework-main.md#319-providers-of-registration-certificates). The WRPRC provides detailed information about the provider's entitlements, the attestations they issue, and their intended use.

## Normative References

| Reference | Document |
|----------|----------|
| [ETSI TS 119 475 V1.2.1](https://www.etsi.org/deliver/etsi_ts/119400_119499/119475/01.02.01_60/ts_119475v010201p.pdf) | Relying party attributes supporting EUDI Wallet user's authorization decisions |
| [ETSI TS 119 182-1](https://www.etsi.org/deliver/etsi_ts/119100_119199/11918201/01.02.01_60/ts_11918201v010201p.pdf) | JAdES digital signatures; Part 1: Building blocks and JAdES baseline signatures |
| [ETSI EN 319 411-1](https://www.etsi.org/deliver/etsi_en/319400_319499/31941101/01.03.01_60/en_31941101v010301p.pdf) | Policy and security requirements for Trust Service Providers issuing certificates; Part 1: General requirements |
| [CIR (EU) 2025/848](https://eur-lex.europa.eu/eli/reg_impl/2025/848/oj/eng) | Commission Implementing Regulation on the registration of wallet-relying parties |
| [IETF RFC 7519](https://www.rfc-editor.org/rfc/rfc7519) | JSON Web Token (JWT) |
| [IETF RFC 8392](https://datatracker.ietf.org/doc/html/rfc8392) | CBOR Web Token (CWT) |
| [IETF RFC 5646](https://datatracker.ietf.org/doc/rfc5646/) | Tags for Identifying Languages |
| [ISO 3166-1](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes) | Codes for the representation of names of countries |

## Format

1. The WRPRC shall be formatted as signed JSON Web Token (JWT) or CBOR Web Token (CWT).
2. The WRPRC shall comply with the syntactic and semantic requirements specified in Annex V paragraph 3 of CIR (EU) 2025/848 [i.2].
3. The WRPRC shall be signed with the digital signature of provider of the wallet-relying party registration certificates.
4. The JWT shall be signed with a JSON Advanced Electronic Signature with the B-B profile as defined in ETSI TS 119 182-1 [18].
5. The CWT shall be signed with an Advanced Electronic Signature following structure as defined in IETF RFC 9052 [19] and IETF RFC 9360 [20].

---

## Attribute overview

| Attribute group                                                       | Description                                                                               | Required |
|-----------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------|
| [Header Attributes](#header-attributes)                               | Required header fields used to identify, sign, and validate WRPRC.                        | Required |
| [Core Identity Attributes](#core-identity-attributes)                 | Identity attributes of the WRP subject (natural person or legal entity).                  | Required |
| [Service Description Attributes](#service-description-attributes)     | Multilingual service descriptions defining the WRP’s provided services.                   | Required |
| [Entitlements Attribute](#entitlements-attribute)                     | Entitlements defining what the WRP is authorised to do.                                   | Required |
| [Privacy and Policy Attributes](#privacy-and-policy-attributes)       | Privacy policy information.                                                               | Some of them |
| [Supervisory Authority Attributes](#supervisory-authority-attributes) | Supervisory authority contact details for reporting suspicious data-processing behaviour. | Required |
| [Service Provider Attributes](#service-provider-attributes)           | Credential queries, purposes, and intended-use identifiers for service providers.         | Required for Service Provider |
| [Attestation Provider Attributes](#attestation-provider-attributes)   | Attributes describing attestations issued by an EAA provider.                             | Required for EAA Provider |
| [Technical Attributes](#technical-attributes)                         | Technical metadata such as policies, timestamps, and status-list configuration.           | Some of them |
| [Uses Intermediary Attributes](#uses-intermediary-attributes)         | Attributes required when the WRP operates through an intermediary entity.                 | Required if Intermediary is used |


## Header Attributes

### JWT Header Attributes

> Listed header attributes are mandatory.

| Attribute | Type | Description | Reference |
|-----------|------|-------------|-----------|
| `typ` | *string* | Specifies the type of the Web Token. The value is set to `rc-wrp+jwt` for JWT | ETSI TS 119 475 Table 5 |
| `alg` | *string* | Indicates the algorithm used to sign the JWT as defined in clause 5.1.2 of ETSI TS 119 182-1 [18]. | ETSI TS 119 475 Table 5 |
| `x5c` | *array[string]* | Contains the whole certificate chain to verify the JWT or CWT as defined in clause 5.1.8 of ETSI TS 119 182-1 [18] | ETSI TS 119 475 Table 5 |

### CWT Header Attributes

> Listed header attributes are mandatory.

| Attribute | Type | Description | Reference |
|-----------|------|-------------|-----------|
| `typ` | *string* | Specifies the type of the Web Token. The value is set to `rc-wrp+cwt` for CWT | ETSI TS 119 475 Table 6 |
| `alg` | *string* | Indicates the algorithm used to sign the CWT as specified in IETF RFC 9052 [19], clause 3.1 | ETSI TS 119 475 Table 6 |
| `x5chain` | *array[string]* | Contains the whole certificate chain to verify the CWT as specified in IETF RFC 9360 [20], clause 2 | ETSI TS 119 475 Table 6 |

## Payload Attributes

### Core Identity Attributes

| Attribute | Type | Description | Required | Reference |
|-----------|------|-------------|-----------|-----------|
| `name` | *string* | The subject of the WRPRC trade name | Required | ETSI TS 119 475 Table 7 - `tradeName` |
| `sub_gn` | *string* | Given Name of Natural Person | Required for Natural Person | ETSI TS 119 475 Table 7 - `givenName` |
| `sub_fn` | *string* | Family Name of Natural Person | Required for Natural Person | ETSI TS 119 475 Table 7 - `familyName` |
| `sub_ln` | *string* | Official legal name | Required for Legal Entity | ETSI TS 119 475 Table 7 - `legalName` |
| `sub` | *string* | Organizational identifier per clause 5.1.3 | Required for Legal Entity | ETSI TS 119 475 Table 7 - `identifier` |
| `country` | *string* | ISO 3166-1 alpha-2 code | Required | ETSI TS 119 475 Table 7 - `country` |
| `registry_uri` | *string* | URL pointing to the national registry API endpoint of the registered WRP | Required | ETSI TS 119 475 Table 7 - `registryURI` |
| `info_uri` | *string* | URL general-purpose web address | Required | ETSI TS 119 475 Table 7 - `infoURI` |
| `support_uri` | *string* | URL or email address to use in data deletion or portability requests related to the WRP | Required | ETSI TS 119 475 Table 7 - `supportURI` |

### Service Description Attributes

| Attribute | Type | Description | Required | Reference |
|-----------|------|-------------|-----------|-----------|
| `srv_description` | *array[object]* | Multilingual service descriptions | Required | ETSI TS 119 475 Table 7 - `srvDescription` |
| `srv_description[].lang` | *string* | Language identifier, referring the BCP47 language tag format defined in RFC 5646 [9] | Required | ETSI TS 119 475 Table 7 - `lang` |
| `srv_description[].value` | *string* | Service description in specified language | Required | ETSI TS 119 475 Table 7 - `content` |

### Entitlements Attribute

| Attribute | Type | Description | Required | Reference |
|-----------|------|-------------|-----------|-----------|
| `entitlements` | *array[string]* | A list of entitlements assigned to the WRP as defined in ETSI TS 119 475 - Annex A.2 | Required | ETSI TS 119 475 Table 7 - `entitlement` |

### Privacy and Policy Attributes

| Attribute | Type | Description | Required | Reference |
|-----------|------|-------------|-----------|-----------|
| `privacy_policy` | *string* | URL to the WRP's privacy policy explaining data processing and storage practices | Required | ETSI TS 119 475 Table 7 - `policyURI` |
| `public_body` | *boolean* | Boolean indicating whether the WRP is a public sector body | Optional | ETSI TS 119 475 Table 10 - `isPSB` |

### Supervisory Authority Attributes

| Attribute | Type | Description | Required | Reference |
|-----------|------|-------------|-----------|-----------|
| `supervisory_authority` | *object* | DPA Info | Required | ETSI TS 119 475 Table 7 - `supervisoryAuthority` |
| `spervisory_authority.uri` | *string* | The URL of web form provided by the Data Protection Authority supervising the Relying Party, which Users can use to report suspicious attribute presentation requests | Required | ETSI TS 119 475 Table 7 - `infoURI` |
| `supervisory_authority.email` | *string* | An e-mail address of that DPA, on which the DPA is prepared to receive reports about suspicious attribute presentation requests from Users | Required | ETSI TS 119 475 Table 7 - `email` |
| `supervisory_authority.phone` | *string* | A telephone number of that DPA, on which the DPA is prepared to receive reports about suspicious attribute presentation requests from Users | Required | ETSI TS 119 475 Table 7 - `phone` |

### Service Provider Attributes

| Attribute | Type            | Description | Required | Reference |
|-----------|-----------------|-------------|-----------|-----------|
| `credentials` | *array[object]* | A set of credential queries, used to request credentials from the Wallet. The EUDIW will use this information to perform an over-asking validation | Required for Service Provider | ETSI TS 119 475 Table 9 - `credential` |
| `credentials[].format` | *string*         | Format of the attestation | Required for Service Provider | ETSI TS 119 475 Table 9 - `format` |
| `credentials[].meta` | *object*        | Object defining additional properties. | Required for Service Provider | ETSI TS 119 475 Table 9 - `meta` |
| `credentials[].claim` | *array[object]*  | Array of objects that specifies attributes in the requested attestation. If claim is absent, the WRPRC does not declare any specific attributes intended to be requested by the WRP | Required for Service Provide | ETSI TS 119 475 Table 9 - `claim` |
| `purpose` | *array[object]* | A list describing the data processing associated with the intended use | Required for Service Provider | ETSI TS 119 475 Table 9 - `purpose` |
| `purpose[].lang` | *string*        | Language identifier, referring the BCP 47 language tag format defined in IETF RFC 5646 [9] | Required for Service Provider | ETSI TS 119 475 Table 9 - `lang` |
| `purpose[].value` | *string*        | Purpose description provided in the language specified above | Required for Service Provider | ETSI TS 119 475 Table 9 - `value` |
| `intended_use_id` | *string*        | Unique identifier of the intended use if provided by the registry. Used to fetch the intented use directly from the registry | Required for Service Provider only if provided by registry | ETSI TS 119 475 Table 9 - `intendedUserIdentifier` |

### Attestation Provider Attributes

| Attribute | Type | Description | Required | Reference |
|-----------|------|-------------|-----------|-----------|
| `provides_attestations` | *array[object]* | A set of credentials issued by the WRP with EAA entitlements. | Required for EAA Provider | ETSI TS 119 475 Table 8 - `providesAttestations` |
| `provides_attestations[].format` | *string* | Format of the credential. | Required for EAA Provider | ETSI TS 119 475 Table 8 - `format` |
| `provides_attestations[].meta` | *object* | Metadata to identify the credential type. | Required for EAA Provider | ETSI TS 119 475 Table 8 - `meta` |
| `provides_attestations[].claim` | *array[object]* | Objects that specifies attributes in the requested attestation. | Required for EAA Provider only if provided by registry| ETSI TS 119 475 Table 8 - `claim` |

### Technical Attributes

| Attribute | Type | Description | Required | Reference |
|-----------|------|-------------|-----------|-----------|
| `policy_id` | *array[string]* | List of policy identifiers as defined in clause 6.1.3 | Required |  ETSI TS 119 475 Table 7 - `technical` |
| `certificate_policy` | *string* | URL to the certificate policy and certificate practice statement | Required | ETSI TS 119 475 Table 7 - `technical` |
| `iat` | *unix_timestamp* | Unix timestamp indicating when the WRP was issued | Required | ETSI TS 119 475 Table 7 - `technical` |
| `exp` | *unix_timestamp* | Expiration time of the JWT/CWT as a Unix timestamp | Optional | ETSI TS 119 475 Table 10 - `technical` |
| `status` | *object* | A URI to a status list presenting information about validity of the WRPRC  | Required | ETSI TS 119 475 Table 7 - `technical` |
| `status.status_list.idx` | *int* | Position in status bitstring | Required | ETSI TS 119 475 GEN-6.2.6.1-04, GEN-6.2.6.1-05 |
| `status.status_list.uri` | *string* | Status list credential URI | Required | ETSI TS 119 475 GEN-6.2.6.1-04 |

### Uses Intermediary Attributes

| Attribute | Type | Description | Required | Reference |
|-----------|------|-------------|-----------|-----------|
| `intermediary` | *object* | Used when the WRP operates via an intermediary | Required if Intermediary is used | ETSI TS 119 475 Table 10 - `usesIntermediary` |
| `intermediary.sub` | *string* | Identifier of the intermediary as specified by the intermediary WRPAC | Required if Intermediary is used | ETSI TS 119 475 Table 10 - `usesIntermediary` |
| `intermediary.sname` | *string* | commonName of the intermediary as specified by the intermediary WRPAC | Required if Intermediary is used | ETSI TS 119 475 Table 10 - `usesIntermediary` |


---

## Examples

### JWT Header

```json
{
  "typ": "rc-wrp+jwt",
  "alg": "ES256",
  "x5c": ["<base64-encoded-certificate-chain>"]
}
```

---

### CWT Header

```
{
  1: -7,    / alg: ES256 /,
  16: "rc-wrp+cwt", / typ /
  33: [     / x5chain /
    h'...', / binary end cert /
    h'...', / binary intermediate cert /
    h'...'  / binary root cert /
  ]
}
```

---

### JWT Payload Example - Service Provider

```json
{
  "name": "Online Shop AG",
  "sub_ln": "Online Shop AG",
  "sub": "LEIXG-529900T8BM49AURSDO55",
  "country": "DE",
  "registry_uri": "https://wrp-register.de/api/v1/relying-parties/DE-WRP-00789",
  "srv_description": [
    { "lang": "de-DE", "value": "Online-Einkaufsplattform mit Altersverifikation" },
    { "lang": "en-US", "value": "Online shopping platform with age verification" }
  ],
  "entitlements": ["https://uri.etsi.org/19475/Entitlement/Service_Provider"],
  "purpose": [
    { "lang": "de-DE", "value": "Altersverifikation für altersbeschränkte Produkte gemäß JuSchG" },
    { "lang": "en-US", "value": "Age verification for age-restricted products" }
  ],
  "credentials": [
    {
      "format": "dc+sd-jwt",
      "meta": { "vct_values": ["https://credentials.example.eu/pid"] },
      "claim": [{ "path": ["age_over_18"] }]
    }
  ],
  "privacy_policy": "https://shop.example.de/privacy",
  "info_uri": "https://shop.example.de",
  "support_uri": "https://shop.example.de/support",
  "supervisory_authority": {
    "uri": "https://www.bfdi.bund.de",
    "email": "poststelle@bfdi.bund.de",
    "phone": "+49 228 997799 0"
  },
  "public_body": false,
  "policy_id": ["0.4.0.19475.3.1"],
  "certificate_policy": "https://wrp-register.de/policies/service-provider",
  "iat": 1704067200,
  "exp": 1735689600,
  "status": { "status_list": { "idx": 156, "uri": "https://status.wrp-register.de/statuslist/1" } }
}
```

---

### JWT Payload Example - Qualified EAA Provider

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

---

### JWT Payload Example - Non-Qualified EAA Provider (University)

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

---

### JWT Payload Example - Banking KYC (Multiple Credentials)

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

---

### JWT Payload Example - With Intermediary

```json
{
  "name": "Small Business Verification",
  "sub_ln": "Small Business GmbH",
  "sub": "VATDE-DE123456789",
  "country": "DE",
  "entitlements": ["https://uri.etsi.org/19475/Entitlement/Service_Provider"],
  "credentials": [
    {
      "format": "dc+sd-jwt",
      "meta": { "vct_values": ["https://credentials.example.eu/pid"] },
      "claim": [{ "path": ["age_over_18"] }]
    }
  ],
  "intermediary": {
    "sub": {
      "id": "LEIXG-529900INTERMEDIARY01",
      "name": "Verification Services AG"
    }
  },
  "policy_id": ["0.4.0.19475.3.1"],
  "iat": 1704067200,
  "status": { "status_list": { "idx": 567, "uri": "https://status.wrp-register.de/statuslist/2" } }
}
```

---

### JWT Payload Example - Natural Person (Notary)

```json
{
  "name": "Notaio Marco Rossi",
  "sub_gn": "Marco",
  "sub_fn": "Rossi",
  "sub": "TINIT-RSSMRC80A01H501U",
  "country": "IT",
  "registry_uri": "https://wrp-register.gov.it/api/v1/relying-parties/IT-WRP-00890",
  "entitlements": ["https://uri.etsi.org/19475/Entitlement/Service_Provider"],
  "purpose": [
    { "lang": "it-IT", "value": "Identificazione delle parti per atti notarili" }
  ],
  "credentials": [
    {
      "format": "dc+sd-jwt",
      "meta": { "vct_values": ["https://credentials.example.eu/pid"] },
      "claim": [
        { "path": ["family_name"] }, { "path": ["given_name"] },
        { "path": ["birth_date"] }, { "path": ["personal_identifier"] }
      ]
    }
  ],
  "privacy_policy": "https://notaio-rossi.it/privacy",
  "supervisory_authority": { "uri": "https://www.garanteprivacy.it", "email": "protocollo@gpdp.it" },
  "public_body": false,
  "policy_id": ["0.4.0.19475.3.1"],
  "iat": 1704067200,
  "status": { "status_list": { "idx": 345, "uri": "https://status.wrp-register.gov.it/statuslist/1" } }
}
```

---

## Other information

### Algorithms

Algorithms used should be one of the algorithms for digital signatures recommended by in [ETSI TS 119 312](https://www.etsi.org/deliver/etsi_ts/119100_119199/11918201/01.02.01_60/ts_11918201v010201p.pdf).

[OpenID4VC High Assurance Interoperability Profile 1.0](https://openid.net/specs/openid4vc-high-assurance-interoperability-profile-1_0.html#section-7)
also defines its own requirements for digital signatures. However, those requirements are not directly related to
registration certificates.


### List of possible Entitlements

Per ETSI TS 119 475 Annex A.2:

| Entitlement | URI | OID | ETSI Reference | Description |
|-------------|-----|-----|----------------|-------------|
| `Service_Provider` | `https://uri.etsi.org/19475/Entitlement/Service_Provider` | `id-etsi-wrpa-entitlement 1` | Annex A.2.1 | General service provider |
| `QEAA_Provider` | `https://uri.etsi.org/19475/Entitlement/QEAA_Provider` | `id-etsi-wrpa-entitlement 2` | Annex A.2.2 | Qualified EAA provider |
| `Non_Q_EAA_Provider` | `https://uri.etsi.org/19475/Entitlement/Non_Q_EAA_Provider` | `id-etsi-wrpa-entitlement 3` | Annex A.2.3 | Non-qualified EAA provider |
| `PUB_EAA_Provider` | `https://uri.etsi.org/19475/Entitlement/PUB_EAA_Provider` | `id-etsi-wrpa-entitlement 4` | Annex A.2.4 | Public sector EAA provider |
| `PID_Provider` | `https://uri.etsi.org/19475/Entitlement/PID_Provider` | `id-etsi-wrpa-entitlement 5` | Annex A.2.5 | Provider of person identification data |
| `QCert_for_ESeal_Provider` | `https://uri.etsi.org/19475/Entitlement/QCert_for_ESeal_Provider` | `id-etsi-wrpa-entitlement 6` | Annex A.2.6 | QTSP issuing qualified certificates for electronic seals |
| `QCert_for_ESig_Provider` | `https://uri.etsi.org/19475/Entitlement/QCert_for_ESig_Provider` | `id-etsi-wrpa-entitlement 7` | Annex A.2.7 | QTSP issuing qualified certificates for electronic signatures |
| `rQSealCDs_Provider` | `https://uri.etsi.org/19475/Entitlement/rQSealCDs_Provider` | `id-etsi-wrpa-entitlement 8` | Annex A.2.8 | QTSP managing remote qualified electronic seal creation devices |
| `rQSigCDs_Provider` | `https://uri.etsi.org/19475/Entitlement/rQSigCDs_Provider` | `id-etsi-wrpa-entitlement 9` | Annex A.2.9 | QTSP managing remote qualified electronic signature creation devices  |
| `ESig_ESeal_Creation_Provider` | `https://uri.etsi.org/19475/Entitlement/ESig_ESeal_Creation_Provider` | `id-etsi-wrpa-entitlement 10` | Annex A.2.10 | Non-qualified provider for remote signature/seal creation |

### Organizational Identifier Formats

Per ETSI TS 119 475 clause 5.1.3 - Table 2 and 5.1.5 - Table 4:

| Type URI (B.2.5) | Semantic Prefix | ETSI Reference | EU Regulation |
|------------------|-----------------|----------------|---------------|
| `http://data.europa.eu/eudi/id/EUID` | `NTR` | GEN-5.1.3-02, Table 2 | CIR 2020/2244 |
| `http://data.europa.eu/eudi/id/LEI` | `LEI` | GEN-5.1.3-02, Table 2 | CIR 2022/1860 |
| `http://data.europa.eu/eudi/id/VATIN` | `VAT` | GEN-5.1.3-02, Table 2 | Directive 2006/112/EC |
| `http://data.europa.eu/eudi/id/TIN` | `TIN` | GEN-5.1.5-02, Table 4 | |

### CBOR Web Token (CWT) Claims

CWT token claims must be registered in a register created by IANA.

The register is available at - https://www.iana.org/assignments/cwt/cwt.xhtml
