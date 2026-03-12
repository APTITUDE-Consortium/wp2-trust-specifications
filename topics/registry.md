# Registry
This document specifies requirements for the **Registrar of Wallet-Relying Parties (WRPs)** and the National Register of WRPs (the registry service) in the context of eIDAS2 and the EUDI Wallet ecosystem.
## 1. Scope and objective

Formally, a **Registrar** is the designated body that:
- manages the WRP registration lifecycle (onboarding, update, suspension, cancellation),
- ensures the integrity and publication of registration information,
- ensures interoperability by exposing WRP registration data via a national website and a single common REST API.

The **National Register of WRPs** is the publicly accessible system (dataset + API) that provides signed/sealed registration statements about WRPs and their authorisations/declared usage.

>The **National Register of Wallet-Relying Parties** is a single logical register. For scalability and resilience, a Member State MAY deploy multiple technical instances provided they expose a **single coherent common REST API** and return **signed statements** as required.<br>
>Additionally, sectorial registers may exist internally, but the decision regarding issuance of WRPAC is solely based on whether the Relying Party has been registered with an active status in the National Register.

## 2. Terms and Roles

- **Registrar of WRPs**: body designated by a Member State to establish and maintain the list of registered WRPs.
- **Register (National Register of WRPs)**: the service exposing information about registered WRPs through a national website and a common REST API. Responses from Register are sealed using Register's certificate. 
- **WRP**: a relying party that intends to rely upon Wallet Units to provide services via digital interaction.
- **WRPAC**: Wallet-Relying Party Access Certificate, which is used to authenticate the Relying Party during a transaction, and failure is treated as Relying Party authentication failure.
- **WRPRC**: Wallet-Relying Party Registration Certificate, which is optional, and is used to express intended use and registered data requests.
- **Intermediary**: an entity acting on behalf of a WRP in wallet interactions (where applicable).


## 3. References

- **Commission Implementing Regulation (EU) 2025/848** (Wallet-relying party registration / national registers / Annex I–V):  
  https://eur-lex.europa.eu/eli/reg_impl/2025/848/oj

- **Commission “Have your say” draft update to WRP registration rules (introduces Annex VI for common API / registry schema)**:  
  https://ec.europa.eu/info/law/better-regulation/have-your-say/initiatives/16113-European-Digital-Identity-Wallet-registration-of-wallet-relying-parties-update-_en

- **ETSI TS 119 475 v1.1.1** (WRP attributes, entitlement URIs, RP authorisation decision support):  
  https://www.etsi.org/deliver/etsi_ts/119400_119499/119475/01.01.01_60/ts_119475v010101p.pdf

- **ETSI TS 119 411-8 v1.1.1** (certificate profiles/policies referenced by ETSI ecosystem):  
  https://www.etsi.org/deliver/etsi_ts/119400_119499/11941108/01.01.01_60/ts_11941108v010101p.pdf

- **IETF RFC 7515** (JSON Web Signature, JWS):  
  https://www.rfc-editor.org/rfc/rfc7515

- **IETF RFC 7519** (JSON Web Token, JWT):  
  https://www.rfc-editor.org/rfc/rfc7519

- **EUDI Wallet ARF (TS5 + TS6)**:  
  https://eudi.dev/2.7.3/architecture-and-reference-framework-main/

- **WE BUILD – “Registry of Wallet Relying Parties” discussion** (informative):  
  https://github.com/JustBelieveEU/WE_BUILD/issues/20



## 4. Overall interaction schema 

## 4.1 WRP interacts directly with Wallet

The following diagram shows interactions between involved actors in case that WRP interacts directly with Wallet 

````mermaid
sequenceDiagram
  autonumber
  participant WRP as Wallet-Relying Party
  participant REG as Registrar
  participant NREG as National Register / Single Common API
  participant ACA as Access Certificate Authority
  participant RCA as Registration Certificate Authority
  participant WAL as Wallet Unit

  WRP->>REG: Onboarding application
  REG->>NREG: Publish registration status + Annex I information
  REG-->>WRP: Approval / lifecycle updates

  WRP->>ACA: Request certificate issuance
  ACA-->>WRP: Issue WRPAC

  WRP->>RCA: Request registration certificate (optional)
  RCA-->>WRP: Issue WRPRC (optional)

  WRP->>WAL: OID4VP / ISO 18013-5 interaction
  WAL->>WAL: Authenticate WRP using WRPAC
  WAL->>NREG: Retrieve RP registered info (optional)
  WAL-->>WRP: User consent + attribute release


````

## 4.2 WRP represented by an intermediary (where applicable)

In case that a relying party is represented by an intermediary, the interaction flow is shown as following: 

````mermaid
sequenceDiagram
  autonumber
  participant INT as Intermediary (on behalf of WRP)
  participant REG as Registrar
  participant NREG as National Register / Single Common API
  participant ACA as Access Certificate Authority
  participant REGCA as Registration Certificate Authority
  participant WRP as Wallet-Relying Party
  participant WAL as Wallet Unit

%% Onboarding & registration (Intermediary)
  INT->>REG: Intermediary onboarding application
  REG->>NREG: Intermediary registration

%% Certificate issuance (Intermediary)
  INT->>ACA: Request certificate issuance
  ACA-->>INT: Issue WRPAC to Intermediary

%% Contractual agreement + WRP onboarding
  WRP->>INT: Agree on contract
  INT->>REG: RP onboarding application
  REG->>NREG: RP registration

%% Registration certificate (optional)
  INT->>REGCA: Request Registration Certificate
  REGCA-->>INT: Issue WRPRC for WRP 

%% Wallet interaction
  INT->>WAL: OID4VP / ISO 18013-5 interaction
  WAL->>WAL: Authenticate Intermediary via WRPAC  and RP <br/> with Registration Certificate (if present in protocols' extensions) 
  WAL->>NREG: Retrieve WRP entry + intermediary association (optional)
  WAL-->>INT: User consent + attribute release

````

## 5. Registry governance and publication requirements
## 5.1 Establishment and publication

| Requirement                                                                                                                                                         | Reference                       |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| Each Member State SHALL establish and maintain at least one national register of WRPs.                                                                              | CIR (EU) 2025/848, Article 3(1) |
| The register SHALL include at least the information set out in Annex I.                                                                                             | CIR (EU) 2025/848, Article 3(2) |
| Member States SHALL designate at least one registrar to manage and operate at least one national register.                                                          | CIR (EU) 2025/848, Article 3(3) |
| Member States SHALL make Annex I information publicly available online in human-readable and machine-processable form.                                              | CIR (EU) 2025/848, Article 3(4) |
| Annex I information SHALL be available through a national website and a single common API, and SHALL be electronically signed/sealed by/on behalf of the registrar. | CIR (EU) 2025/848, Article 3(5) |

## 5.2 Common API constraints (high level)
| Requirement                                                                                                                                            | Reference                            |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------ |
| The single common API SHALL be a REST API supporting JSON, and signed according to Annex II Section 1.                                                 | CIR (EU) 2025/848, Annex II §2(1)(a) |
| The API SHALL allow any requestor, without prior authentication, to search and request complete lists, allowing partial matches on defined parameters. | CIR (EU) 2025/848, Annex II §2(1)(b) |
| Matching replies SHALL include statements covering Annex I information, current/historic WRPACs and WRPRCs, **excluding Annex I point 4** information. | CIR (EU) 2025/848, Annex II §2(1)(c) |
| The API SHALL be published as OpenAPI v3 with documentation enabling interoperability across the Union.                                                | CIR (EU) 2025/848, Annex II §2(1)(d) |
| The API SHALL provide security-by-default/by-design to ensure availability and integrity.                                                              | CIR (EU) 2025/848, Annex II §2(1)(e) |
| Statements SHALL be electronically signed/sealed JSON files (structure according to Annex II Section 1).                                               | CIR (EU) 2025/848, Annex II §2(2)    |



## 6. Registry data model (format)
This section defines the format of the information exchanged via the Register API as JSON objects and JWS-signed statements.

> **Address field publication rule (important):** The draft Annex VI text says the published API payload excludes `WalletRelyingParty.physicalAddress`, while Table 1 uses the attribute name `postalAddress`.  
> This document uses **`postalAddress`** as the schema field name and applies the publication rule to that field (i.e., do not publish it in API statements).


## 6.1 WalletRelyingParty (WRP registration information object)


| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| `legalPerson` | `LegalPerson` (optional) | Specific attributes of a legal person. | Draft Annex VI Table 1 / Table 8 |
| `naturalPerson` | `NaturalPerson` (optional) | Specific attributes of a natural person. | Draft Annex VI Table 1 / Table 9 |
| `identifier` | `Identifier[]` | One or more identifiers from official records. | Draft Annex VI Table 1 / Table 10 |
| `postalAddress` | `string[]` (optional) | Postal address(es) of the legal entity (**registration view only; excluded from published API statements**). | Draft Annex VI Table 1; Draft Annex VI §3(a) |
| `country` | `string` | ISO 3166-1 alpha-2 country code, or `"EU"` for providers operating in the Union. | Draft Annex VI Table 1 |
| `email` | `string[]` (optional) | Contact email address(es) (RFC 5322 format). | Draft Annex VI Table 1 |
| `phone` | `string[]` (optional) | Contact phone number(s), international form with `+` prefix. | Draft Annex VI Table 1 |
| `infoURI` | `string[]` (optional) | Web page URI(s) for information about the entity. | Draft Annex VI Table 1 |
| `providerType` | `string` | Provider subtype. For WRP records, typically `WalletRelyingParty`. | Draft Annex VI Table 1 |
| `policy` | `Policy[]` | Policy/terms/privacy/registration policy URL(s) with policy type URI. | Draft Annex VI Table 1 / Table 7 |
| `x5c` | `string[]` (optional) | X.509 certificate chain(s) for provider services (JWS `x5c`-style chains; supports rollover). | Draft Annex VI Table 1 |
| `tradeName` | `string` (optional) | User-facing trade/service name recognisable to users. | CIR Annex I(2); Draft Annex VI Table 1 |
| `supportURI` | `string[]` | Support/helpdesk URI(s) for the service. | CIR Annex I(7)(a); Draft Annex VI Table 1 |
| `srvDescription` | `MultiLangString[]` | Localised description(s) of services provided. | CIR Annex I(8); Draft Annex VI Table 1 / Table 4 |
| `intendedUse` | `IntendedUse[]` (optional) | Intended-use definitions and requested attestation data. Not required if registering only as a designated intermediary. | CIR Annex I(9)–(10); Draft Annex VI Table 1 / Table 2 |
| `isPSB` | `boolean` | Whether the WRP is a public sector body (explicitly present; `false` if not PSB). | CIR Annex I(11); Draft Annex VI §10.1 |
| `entitlement` | `string[]` | Entitlement URI(s) (ETSI TS 119 475 Annex A.2 URIs). | CIR Annex I(12); ETSI TS 119 475; Draft Annex VI Table 1 |
| `providesAttestations` | `Credential[]` (optional / conditionally required) | Attestation types the WRP intends to issue to wallet units. **SHALL be present** if any entitlement is `QEAA_Provider`, `Non_Q_EAA_Provider`, `PUB_EAA_Provider`, or `PID_Provider`. | CIR Annex I(13); Draft Annex VI §10.2; Draft Annex VI Table 1 / Table 5 |
| `supervisoryAuthority` | `LegalEntity` | Competent supervisory authority (Art. 46a eIDAS) including contact information. | Draft Annex VI Table 1 / Table 6 |
| `registryURI` | `string` | URI of the API of the national register of WRPs. | Draft Annex VI Table 1 |
| `usesIntermediary` | `WalletRelyingParty[]` (optional, subset) | If present, indicates designated intermediary(ies). Only the subset `{identifier, tradeName, registryURI}` is needed for each intermediary reference. | CIR Annex I(14)–(15); Draft Annex VI Table 1 |
| `isIntermediary` | `boolean` | Whether the registered entity is a designated intermediary. SHALL be `false` if `usesIntermediary` is present. | CIR Annex I(14)–(15); Draft Annex VI Table 1 |


### 6.1.1 Identifier

| Parameter    |     Type | Description                                                                      | Reference      |
| ------------ | -------: | -------------------------------------------------------------------------------- | -------------- |
| `identifier` | `string` | Identifier value.                                                                | CIR Annex I(3) |
| `type`       | `string` | Identifier scheme/type (e.g., `EORI`, `BRN`, `LEI`, `VAT`, `TAX`, `EUID`, etc.). | CIR Annex I(3) |


### 6.1.2 MultiLangString

| Parameter |     Type | Description                      | Reference                  |
| --------- | -------: | -------------------------------- | -------------------------- |
| `lang`    | `string` | Language tag (e.g., `en`, `fr`). | ARF / common i18n practice |
| `content` | `string` | Language-specific content.       | ARF / common i18n practice |


### 6.1.3 IntendedUse

| Parameter               |                Type | Description                                                           | Reference                              |
| ----------------------- | ------------------: | --------------------------------------------------------------------- | -------------------------------------- |
| `intendedUseIdentifier` |            `string` | Registry-level unique identifier for the intended use.                | CIR Annex I(9)–(10) (per intended use) |
| `purpose`               | `MultiLangString[]` | Description of intended use of the data to request from wallet units. | CIR Annex I(10)                        |
| `privacyPolicy`         |          `Policy[]` | Privacy policy URL(s) for the intended use.                           | CIR Article 8(2)(g)–(3)                |
| `credential`            |      `Credential[]` | Machine-readable list of requested data (attestations/attributes).    | CIR Annex I(9)                         |
| `createdAt`             |            `string` | Creation timestamp (implementation).                                  | Implementation                         |
| `revokedAt`             | `string` (optional) | Revocation timestamp (implementation).                                | Implementation                         |


### 6.1.4 Policy


| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| `type` | `string` | Policy type URI (RFC 3986). See policy URIs below. | Draft Annex VI Table 7 |
| `policyURI` | `string` | URL where the policy is published. | Draft Annex VI Table 7 |

### 6.1.5 Credential
| Parameter |      Type | Description                                                   | Reference                         |
| --------- | --------: | ------------------------------------------------------------- | --------------------------------- |
| `format`  |  `string` | Credential format identifier (e.g., `dc+sd-jwt`, `mso_mdoc`). | CIR Annex I(9) (machine readable) |
| `meta`    |  `string` | Additional grouping/type metadata (profile).                  | Implementation / ARF profile      |
| `claim`   | `Claim[]` | Requested claim paths and allowed values (if constrained).    | CIR Annex I(9)                    |

### 6.1.6 Claim

| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| `path` | `array` | Non-empty path array of strings / `null` / non-negative integers (OpenID4VP-style path pointer segments). | CIR Annex I(9); Draft Annex VI Table 3 |
| `values` | `array` (optional) | Optional allowed values; elements may be `string`, `integer`, or `boolean`. | CIR Annex I(9); Draft Annex VI Table 3 |

### 6.1.7 LegalEntity (for `supervisoryAuthority`)

| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| `legalPerson` | `LegalPerson` (optional) | Present when the authority is a legal person. | Draft Annex VI Table 6 / Table 8 |
| `naturalPerson` | `NaturalPerson` (optional) | Present when the authority is a natural person. | Draft Annex VI Table 6 / Table 9 |
| `identifier` | `Identifier[]` (optional) | Identifier(s) of the authority. | Draft Annex VI Table 6 / Table 10 |
| `postalAddress` | `string[]` (optional) | Postal address(es) of the authority. | Draft Annex VI Table 6 |
| `country` | `string` | Country code (or `EU` where applicable). | Draft Annex VI Table 6 |
| `email` | `string[]` (optional) | Email address(es) of the authority. | Draft Annex VI Table 6 |
| `phone` | `string[]` (optional) | Phone number(s) of the authority. | Draft Annex VI Table 6 |
| `infoURI` | `string[]` (optional) | Information URI(s) of the authority. | Draft Annex VI Table 6 |

### 6.1.8 LegalPerson

| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| `legalName` | `string[]` | Legal name(s) as in official records. | Draft Annex VI Table 8 |
| `establishedBylaw` | `Law[]` (optional) | Legal basis for establishment. **SHALL be present** for PSBs responsible for authentic sources; present for other PSBs where applicable. | Draft Annex VI §10.3; Draft Annex VI Table 8 / Table 11 |

### 6.1.9 NaturalPerson

| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| `givenName` | `string` | Current first name(s), including middle names where applicable. | Draft Annex VI Table 9 |
| `familyName` | `string` | Current surname(s). | Draft Annex VI Table 9 |
| `dateOfBirth` | `string` (optional) | Date of birth (where present in official records). | Draft Annex VI Table 9 |
| `placeOfBirth` | `string` (optional) | Place of birth (where present in official records). | Draft Annex VI Table 9 |

### 6.1.10 Law

| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| `lang` | `string` | Two-letter language code (ISO 639-1 style). | Draft Annex VI Table 11 |
| `legalBasis` | `string` | Legal basis text establishing the legal person (or requiring/recommending access to a claim). | Draft Annex VI Table 11 |


## 6.2 Entitlements
| Parameter       |       Type | Description                                    | Reference                                  |
| --------------- | ---------: | ---------------------------------------------- | ------------------------------------------ |
| `entitlement[]` | `string[]` | Array of entitlement URIs (see mapping below). | CIR Annex I(12); ETSI TS 119 475 Annex A.2 |


Mapping between CIR entitlement label and ETSI TS 119 475 normative URI:

| CIR entitlement label          | Normative URI                                                     | Reference                    |
| ------------------------------ | ----------------------------------------------------------------- | ---------------------------- |
| `Service_Provider`             | `https://uri.etsi.org/19475/Entitlement/Service_Provider`         | ETSI TS 119 475, Annex A.2   |
| `QEAA_Provider`                | `https://uri.etsi.org/19475/Entitlement/QEAA_Provider`            | ETSI TS 119 475, Annex A.2   |
| `Non_Q_EAA_Provider`           | `https://uri.etsi.org/19475/Entitlement/Non_Q_EAA_Provider`       | ETSI TS 119 475, Annex A.2   |
| `PUB_EAA_Provider`             | `https://uri.etsi.org/19475/Entitlement/PUB_EAA_Provider`         | ETSI TS 119 475, Annex A.2   |
| `PID_Provider`                 | `https://uri.etsi.org/19475/Entitlement/PID_Provider`             | ETSI TS 119 475, Annex A.2   |
| `QCert_for_ESeal_Provider`     | `https://uri.etsi.org/19475/Entitlement/QCert_for_ESeal_Provider` | ETSI TS 119 475, Annex A.2   |
| `QCert_for_ESig_Provider`      | `https://uri.etsi.org/19475/Entitlement/QCert_for_ESig_Provider`  | ETSI TS 119 475, Annex A.2   |
| `rQSigCDs_Provider`            | `https://uri.etsi.org/19475/Entitlement/rQSigCDs_Provider`        | ETSI TS 119 475, Annex A.2   |
| `rQSealCDs_Provider`           | `https://uri.etsi.org/19475/Entitlement/rQSealCDs_Provider`       | ETSI TS 119 475, Annex A.2   |
| `ESig_ESeal_Creation_Provider` | `https://uri.etsi.org/19475/Entitlement/ESig_ESeal_Creation_Provider` | ETSI TS 119 475, Annex A.2 |



## 7. Registry statements

Registry statements exposed through the common API SHALL be provided as electronically signed or sealed JSON files, using JWS in accordance with Annex II Section 1 and RFC 7515.

## 7.1 JWS requirements
### 7.1.1 Serialization and header placement

This profile uses **JWS Compact Serialization** for API responses (e.g., `application/jwt`), unless a Member State profile explicitly defines another serialization.
In JWS Compact Serialization, there is **no unprotected header**; therefore, the JOSE Header is the **JWS Protected Header** and is integrity-protected by the signature.

| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| `statement` | `string` (JWS compact) | JWS compact serialisation containing the response payload. | CIR Annex II §1; RFC 7515 |
| `payload` | `JSON value` | Decoded payload. Depending on endpoint, this may be an object, an array, or a boolean. | Draft Annex VI §5; RFC 7515 |
| `integrityValidationInfo` | implementation-specific | Integrity-validation information as required by the applicable signature/seal profile. | Draft update; RFC 9162 / RFC 6962 |

### 7.1.2 JOSE Protected Header parameters (profile)
The following JOSE Protected Header requirements apply to registry statements:

| Header parameter | Requirement | Description | Reference |
| --- | --- | --- | --- |
| `alg` | **REQUIRED** | Signature/seal algorithm identifier. SHALL be supported by producer and verifier. The value `none` SHALL NOT be used for registry statements. | RFC 7515 §4.1.1; profile rule |
| `x5c` | **RECOMMENDED** (SHALL if no trust-list/key-resolution profile is defined) | X.509 certificate chain of the signer/sealer. The signing certificate SHALL be the first certificate in the array. | RFC 7515 §4.1.6 |
| `kid` | **RECOMMENDED** | Key identifier to support key rollover and efficient verifier key selection. | RFC 7515 §4.1.4 |
| `x5t#S256` | **RECOMMENDED** | SHA-256 thumbprint of the signing certificate (useful for pinning / key matching). | RFC 7515 §4.1.8 |
| `x5u` | OPTIONAL | URL to signer certificate chain. If used, it SHALL be retrieved over TLS with server identity validation. | RFC 7515 §4.1.5 |
| `typ` | OPTIONAL (RECOMMENDED) | Media type hint for the complete JWS object (e.g., `JWT` / `application/jwt` or a profile-specific media type). | RFC 7515 §4.1.9 |
| `crit` | OPTIONAL | If used, all listed parameters MUST be understood and processed by verifiers; otherwise the JWS is invalid. `crit` MUST appear only in the protected header. | RFC 7515 §4.1.11 |

> The JOSE header parameter `x5c` above is part of the JWS signature envelope. It is distinct from any `x5c` attribute defined in the registry payload/data schema (e.g., Annex VI data model fields).



## 7.2 Normative endpoint payloads (strict Annex VI-aligned)

### 7.2.1 `GET /wrp` payload
The decoded JWS payload for `GET /wrp` SHALL be:
- an array of `WalletRelyingParty` objects (matching the query),
- with address field excluded from published entries,
- and, where relevant, accompanied by WRPAC history information in the statement/profile used by the Member State.

### 7.2.2 `GET /wrp/check-intended-use` payload
The decoded JWS payload for `GET /wrp/check-intended-use` SHALL be:
- a boolean `true` or `false`.

## 7.3 Optional profile envelope (recommended for interoperability metadata)

To preserve issuer/timestamp metadata and pagination in a stable schema, a Member State MAY define an envelope profile as follows (while still satisfying the endpoint semantics above):

### 7.3.1 SignedWRPArrayEnvelope (profile)
| Parameter | Type | Description |
| --- | ---: | --- |
| `iss` | `string` | Identifier of the Registry/Registrar issuing the statement. |
| `iat` | `integer` | Issued-at timestamp (Unix epoch seconds). |
| `data` | `WalletRelyingParty[]` | Matching WRP entries (published view, address excluded). |
| `pagination` | `Pagination` (optional) | Cursor-based pagination metadata. |
| `wrpacHistory` | `CertificateHistoryEntry[]` (optional) | WRP access certificate history (including CT-related references where available). |
| `wrprcHistory` | `CertificateHistoryEntry[]` (optional) | WRP registration certificate history (if provided by national profile). |

### 7.3.2 SignedWRPEnvelope (profile, for non-common helper endpoints)
| Parameter | Type | Description |
| --- | ---: | --- |
| `iss` | `string` | Registry/Registrar identifier. |
| `iat` | `integer` | Issued-at timestamp. |
| `data` | `WalletRelyingParty` | Single WRP object (published view, address excluded). |
| `wrpacHistory` | `CertificateHistoryEntry[]` (optional) | WRPAC history. |
| `wrprcHistory` | `CertificateHistoryEntry[]` (optional) | WRPRC history (if supported). |

### 7.3.3 SignedIntendedUseCheckEnvelope (profile)
> **Note:** Annex VI strictly allows a JWS-signed boolean response. This object envelope is a non-normative profile convenience.

| Parameter | Type | Description |
| --- | ---: | --- |
| `iss` | `string` | Registry issuer. |
| `iat` | `integer` | Issued-at timestamp. |
| `data` | `boolean` | Result of intended-use check. |

## 7.4 CertificateHistoryEntry (profile helper for certificate histories)

| Parameter | Type | Description |
| --- | ---: | --- |
| `certificate` | `string` | Certificate (e.g., PEM/DER-encoded representation, profile-defined). |
| `x5c` | `string[]` (optional) | Certificate chain for the certificate entry. |
| `status` | `string` | Certificate status (e.g., `current`, `revoked`, `expired`, `historic`). |
| `validFrom` | `string` (optional) | Validity start timestamp/date (profile-defined format). |
| `validTo` | `string` (optional) | Validity end timestamp/date (profile-defined format). |
| `ctLogEntries` | `object[]` (optional) | CT log / transparency references (RFC 9162-aligned, profile-defined structure). |


## 8. Common Register API (TS5-aligned profile)

This section documents a TS5-aligned common Register API profile that satisfies Annex II constraints.
> The API is public (no prior authentication) and returns JWS-signed statements.

## 8.1 `GET /wrp` — search/list
### 8.1.1 Request (query parameters)

The common API SHALL support parameterised queries on `GET /wrp`. The following names align with the draft Annex VI query parameter naming.

| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| `identifier` | `string` | Filter by official/business registration number / identifier. | Draft Annex VI §2(a), §4(a) |
| `legalname` | `string` | Filter by official company name. | Draft Annex VI §2(b), §4(a) |
| `tradename` | `string` | Filter by trade name. | Draft Annex VI §2(b), §4(a) |
| `policy` | `string` | Filter by privacy policy URL (or policy URI as profiled). | Draft Annex VI §2(c), §4(a) |
| `entitlement` | `string` | Filter by entitlement type (URI). | Draft Annex VI §2(d), §4(a) |
| `providesattestation` | `string` | Filter by attestation types provided (e.g., attestation schema type in `providesAttestations`). | Draft Annex VI §2(e), §4(a) |
| `usesintermediary` | `string` or `boolean` | Filter by reliance on intermediary (presence of `usesIntermediary`). | Draft Annex VI §2(h), §4(a) |
| `isintermediary` | `boolean` | Filter by intermediary status. | Draft Annex VI §4(a) |
| `intendedUseIdentifier` | `string` | Filter by registrar-provided intended-use identifier. | Draft Annex VI §2(g), §4(a) |
| `intendedUseClaimPath` | `string` | Filter by intended-use requested claim path. | Draft Annex VI §4(a) |
| `intendedUseCredentialMeta` | `string` | Filter by intended-use credential metadata (format-specific). | Draft Annex VI §4(a) |
| `intendedUseCredentialFormat` | `string` | Filter by intended-use credential format. | Draft Annex VI §2(f), §4(a) |
| `cursor` | `string` (optional) | Cursor for pagination (profile-defined token format). | Draft Annex VI §4(c) |
| `limit` | `integer` (optional) | Page size (profile-defined). | Implementation profile |

### 8.1.2 Behaviour

| Requirement | Reference |
| --- | --- |
| If no query parameters are provided, `GET /wrp` SHALL return the full list of registered WRPs (subject to pagination profile). | Draft Annex VI §4(b) |
| The endpoint SHALL support cursor-based pagination. | Draft Annex VI §4(c) |
| The endpoint SHALL support combined filters in a single query. | Draft Annex VI §4(d) |
| A successful response (`200`) SHALL be JWS-signed. | Draft Annex VI §5; CIR Annex II §1 |

### 8.1.3 Response

| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| `200` body | `application/jwt` | JWS compact string. Decoded payload SHALL contain matching `WalletRelyingParty` entries (strict Annex VI form: array; profile envelope also allowed if documented). | Draft Annex VI §5; RFC 7515 |

---

## 8.2 `GET /wrp/check-intended-use` — intended use check (public, mandatory)

> **Important:** In the Annex VI draft this endpoint is part of the public API and is not optional.

### 8.2.1 Request

The draft requires a dedicated intended-use check endpoint with **four mandatory and one optional parameter**.  
This profile uses the following mapping (strictly aligned names for intended-use filters):

| Parameter | Type | M/O | Description | Reference |
| --- | ---: | :--: | --- | --- |
| `identifier` | `string` | M | Identifier of the WRP whose intended-use registration is being checked. | Draft Annex VI §5 (specific WRP check) |
| `intendedUseIdentifier` | `string` | M | Intended-use identifier registered by the registrar. | Draft Annex VI §2(g), §5 |
| `intendedUseClaimPath` | `string` | M | Requested claim path to check (serialised representation of path array; profile-defined encoding). | Draft Annex VI §4(c), §5 |
| `intendedUseCredentialFormat` | `string` | M | Credential format to check. | Draft Annex VI §2(f), §4(c), §5 |
| `intendedUseCredentialMeta` | `string` | O | Credential metadata filter (profile-defined serialisation). | Draft Annex VI §4(c), §5 |

### 8.2.2 Response

| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| `200` body | `application/jwt` | JWS compact string; decoded payload is boolean `true` or `false` (strict Annex VI). | Draft Annex VI §5; RFC 7515 |

---

## 8.3 `POST /wrp` — create (authorised write method)

This is a common API write method in the draft Annex VI.

### 8.3.1 Request
> This method is only accessible for entities which are authorized by Member State


| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| request body | `WalletRelyingParty` | Full WRP object compliant with Annex VI Table 1 schema (registration view). | Draft Annex VI §9(b); Table 1 |

### 8.3.2 Response

| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| `201` | - | Created. | Draft Annex VI §9(b) |

---

## 8.4 `PUT /wrp` — update (authorized write method)

### 8.4.1 Request
> This method is only accessible for entities which are authorized by Member State

| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| request body | `WalletRelyingParty` | Full WRP object compliant with Annex VI Table 1 schema (registration view). | Draft Annex VI §9(b); Table 1 |

### 8.4.2 Response

| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| `200` | - | Updated. | Draft Annex VI §9(b) |
| `404` | - | Not found. | Draft Annex VI §9(b) |

---

## 8.5 `DELETE /wrp` — delete
> This method is only accessible for entities which are authorized by Member State

### 8.5.1 Request

| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| request body | `object` | Identifier payload for the WRP to delete (profile-defined body shape, based on `WalletRelyingParty.identifier`). | Draft Annex VI §9(b) |

### 8.5.2 Response

| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| `204` | - | Deleted. | Draft Annex VI §9(b) |

---

## 8.6 `GET /wrp/{identifier}` — get by identifier (national/profile extension)

> This endpoint is useful, but it is **not explicitly defined** in the draft Annex VI common API method list.  
> If kept, mark it as a national/profile extension.

### 8.6.1 Request

| Parameter | Type | Description |
| --- | ---: | --- |
| `identifier` (path) | `string` | Identifier of the WRP to retrieve. |

### 8.6.2 Response

| Parameter | Type | Description |
| --- | ---: | --- |
| `200` body | `application/jwt` | JWS compact string; decoded payload contains one `WalletRelyingParty` entry (or profile envelope). |
| `404` | - | Not found. |


## 9. Registrar processes (requirements)
## 9.1 Registration policy and onboarding

| Requirement                                                                                                                                                                                       | Reference            |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------- |
| Registrars SHALL establish easy-to-use electronic, and where possible automated, registration processes.                                                                                          | CIR Article 6(1)     |
| Wallet-relying parties SHALL provide at least Annex I information to national registers.                                                                                                          | CIR Article 5(1)     |
| Wallet-relying parties SHALL ensure information is accurate and SHALL update without undue delay.                                                                                                 | CIR Article 5(2)–(3) |
| Where possible, registrars SHALL verify (automated) accuracy/validity, power of attorney (if applicable), entitlement type(s), and absence of existing registration in another national register. | CIR Article 6(3)     |
| Registrars SHALL verify against supporting documentation or appropriate authentic sources/official records.                                                                                       | CIR Article 6(4)     |
| Verification of entitlements SHALL be carried out according to Annex III.                                                                                                                         | CIR Article 6(5)     |
| If registrar cannot verify according to Article 6(3)–(5), registrar SHALL reject the registration.                                                                                                | CIR Article 6(6)     |
## 9.2 Suspension and cancellation

| Requirement                                                                                                                        | Reference        |
| ---------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| Registrars SHALL suspend/cancel where requested by a supervisory body (per eIDAS reference).                                       | CIR Article 9(1) |
| Registrars MAY suspend/cancel if info inaccurate/outdated/misleading, non-compliance, excessive attribute requests, breach of law. | CIR Article 9(2) |
| Registrars SHALL suspend/cancel if requested by the WRP itself.                                                                    | CIR Article 9(3) |
| Registrar SHALL conduct proportionality assessment before suspension/cancellation under Article 9(2).                              | CIR Article 9(4) |
| Registrar SHALL notify WRP + relevant certificate providers without undue delay and **not later than 24 hours**.                   | CIR Article 9(5) |
| Certificate providers SHALL revoke affected certificates without undue delay after notification (where applicable).                | CIR Article 9(6) |


## 9.3 Record keeping

| Requirement                                                                         | Reference      |
| ----------------------------------------------------------------------------------- | -------------- |
| Registrars SHALL keep records (Annex I + issuance data + changes) for **10 years**. | CIR Article 10 |

## 10. Certificate-provider interactions (requirements)
## 10.1 WRP access certificates (WRPAC)

| Requirement                                                                                                                                                                     | Reference          |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------ |
| Providers SHALL verify at issuance time that the WRP is included with valid registration status in the national register and certificate info is consistent with register info. | CIR Annex IV §3(c) |
| Providers SHALL continuously monitor changes in the national register and revoke when changes require (especially suspension/cancellation).                                     | CIR Annex IV §3(e) |
| Providers SHALL publish revocation status timely and in any event within 24 hours after receipt of revocation request.                                                          | CIR Annex IV §3(h) |

## 10.2 WRP registration certificates (WRPRC) (optional)


| Requirement                                                                                                                                                                   | Reference                                     |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------- |
| Where a Member State authorises WRPRCs, it SHALL ensure each intended use is expressed in the WRPRC and that WRPRCs include a privacy policy URL and a general access policy. | CIR Article 8(2)(b)–(c) and (g), Article 8(3) |
| Providers SHALL verify at issuance time register status, consistency with register info, and validity of the WRPAC (when relevant).                                           | CIR Annex V §3(c)                             |
| Providers SHALL monitor register changes, reissue/revoke when changes require.                                                                                                | CIR Annex V §3(d)                             |
| Data exchange format for WRPRC SHALL be signed JWTs (RFC 7519) and CWTs (RFC 8392).                                                                                           | CIR Annex V §4                                |

## 11. Non-normative JSON examples 

## 11.1 Example: WRP object (registration view – includes postalAddress)

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
    { "lang": "en", "content": "Retail banking services for individuals." },
    { "lang": "fr", "content": "Services bancaires pour particuliers." }
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

## 11.2 Example of a WRP object (published via API – excludes Annex I point 4 / physical address)

````json
{
  "legalPerson": {
    "legalName": ["ExampleBank S.A."]
  },
  "identifier": [
    {
      "type": "http://data.europa.eu/eudi/id/EUID",
      "identifier": "FR-EUID-123456789"
    }
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
      "type": "http://data.europa.eu/eudi/policy/privacy-policy",
      "policyURI": "https://examplebank.eu/privacy"
    }
  ],
  "tradeName": "ExampleBank Mobile",
  "supportURI": [
    "https://examplebank.eu/support"
  ],
  "srvDescription": [
    { "lang": "en", "content": "Retail banking services for individuals." }
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
            { "path": ["given_name"] }
          ]
        }
      ],
      "createdAt": "2026-01-01"
    }
  ]
}

````

## Attestation Verification Workflow

This section illustrates an example runtime verification flow performed by a Wallet Unit when a Wallet-Relying Party (WRP) (or an intermediary acting on its behalf) initiates an interaction (e.g., OID4VP or ISO 18013-5).

````mermaid
sequenceDiagram
  autonumber
  participant RP as Relying Party (WRP)
  participant W as Wallet
  participant REG as National Register API
  participant PKI as Trust/Validation data (cert path)

  RP->>W: Auth request (includes WRPAC or reference)
  W->>PKI: Validate WRPAC chain to expected trust anchor
  W->>REG: Query WRP entry (name/ID/entitlement/intermediary params)
  REG-->>W: JWS-signed JSON statement (Annex I info + current/historic WRPAC/WRPRC)
  W->>PKI: Validate Registrar seal/signature (JWS + validation data)
  W->>W: Check WRP status + match presented WRPAC with "current" certificate(s)
  W->>RP: Continue protocol only if checks succeed

````
