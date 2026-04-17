This section specifies requirements for the Registrar of Wallet-Relying Parties (WRPs) and the national Register of WRPs (the registry service) in the context of eIDAS2 and the EUDI Wallet ecosystem.

Formally, a Registrar is the designated body that:

- manages the WRP registration lifecycle (onboarding, update, suspension, cancellation),
- ensures the integrity and publication of registration information,
- ensures interoperability by exposing WRP registration data via a national website and a single common REST API.

The national Register of WRPs is the publicly accessible system (dataset + API) that provides signed/sealed registration statements about WRPs and their authorisations/declared usage.

!!! note

    The national Register of WRPs is a single logical register. For scalability and resilience, a Member State MAY deploy multiple technical instances provided they expose a single coherent common REST API and return signed statements as required.<br>
    
    Additionally, sectorial registers may exist internally, but the decision regarding issuance of WRPAC is solely based on whether the WRP has been registered with an active status in the national Register.


#### References
The list below enumerates all the applicable standards and specifications that have been used to populate the table below:

- **CIR 2025/848** on WRP registration and Registers 
- **CIR 2025/848-Amendment**. This draft slightly modifies Annexes I-V of [CIR 2025/848] and introduces Annex VI for common API and data schema for Register of WRPs.
- **ETSI TS 119 475 v1.2.1**  on WRP attributes, entitlement URIs, RP authorisation decision support.
- **TS05 V1.3** on common formats and API for WRP registration information
- **TS06 V1.0.1** on common set of WRP information to be registered
- **RFC 7515**
- **RFC 7519**
- **RFC 8392**

#### Requirements 

##### Register Requirements 

| ID | Requirement | Reference |
| -- | ----------- | --------- |
| REGISTER-PUB-01 | Each Member State SHALL establish and maintain at least one national Register of WRPs. | [CIR 2025/848], Article 3(1) |
| REGISTER-PUB-02 | The Register SHALL include at least the information set out in Annex I of [CIR 2025/848]. | [CIR 2025/848], Article 3(2) |
| REGISTER-PUB-03 | Member States SHALL designate at least one Registrar to manage and operate at least one national Register. | [CIR 2025/848], Article 3(3) |
| REGISTER-PUB-04 | Member States SHALL make Annex I information publicly available online in human-readable and machine-processable form. | [CIR 2025/848], Article 3(4) |
| REGISTER-PUB-05 | Annex I information included in the Register (as for REGISTER-PUB-02) SHALL be available through a national website and a single common API, and SHALL be electronically signed/sealed by/on behalf of the Registrar. | [CIR 2025/848], Article 3(5) |
| REGISTER-API-01 | The single common API SHALL be a REST API supporting JSON, and signed according to IETF RFC 7515. | [CIR 2025/848], Annex II §2(1)(a) |
| REGISTER-API-02 | The API SHALL allow any requestor, without prior authentication, to search and request complete lists, allowing partial matches on defined parameters. | [CIR 2025/848], Annex II §2(1)(b) |
| REGISTER-API-03 | Replies to request that match at least one WRP SHALL include statements covering Annex I information [CIR 2025/848], current/historic WRPACs and WRPRCs, excluding Annex I point 4 information. | [CIR 2025/848], Annex II §2(1)(c) |
| REGISTER-API-04 | The API SHALL be published as OpenAPI v3 with documentation enabling interoperability across the Union. | [CIR 2025/848], Annex II §2(1)(d) |
| REGISTER-API-05 | The API SHALL provide security-by-default and by-design to ensure availability and integrity. | [CIR 2025/848], Annex II §2(1)(e) |
| REGISTER-API-06 | Statements referred to in REGISTER-API-03 SHALL be electronically signed/sealed JSON files as for IETF RFC 7515. | [CIR 2025/848], Annex II §2(2) |

!!! note

    The set of WRP information listed in Annex I of [CIR 2025/848] and mentioned in REGISTER-PUB-05 and REGISTER-API-03 will be described in the [Register Data Schema](#register-data-schema) section.

##### Registrar Requirements 

| ID | Requirement | Reference |
| -- | ----------- | --------- |
| REGISTRAR-REG-01 | Registrars SHALL establish easy-to-use electronic, and where possible automated, registration processes. | [CIR 2025/848], Article 6(1) |
| REGISTRAR-REG-02 | WRPs SHALL provide at least Annex I information to national registers. | [CIR 2025/848], Article 5(1) |
| REGISTRAR-REG-03 | WRPs SHALL ensure information is accurate and SHALL update without undue delay. | [CIR 2025/848], Article 5(2)–(3) |
| REGISTRAR-REG-04 | Where possible, Registrars SHALL verify (automated) accuracy/validity, power of attorney (if applicable), entitlement type(s), and absence of existing registration in another national Register. | [CIR 2025/848], Article 6(3) |
| REGISTRAR-REG-05 | Registrars SHALL verify against supporting documentation or appropriate authentic sources/official records. | [CIR 2025/848], Article 6(4) |
| REGISTRAR-REG-06 | Verification of entitlements SHALL be carried out according to Annex III of [CIR 2025/848]. | [CIR 2025/848], Article 6(5) |
| REGISTRAR-REG-07 | If Registrar cannot verify according to Article 6(3)–(5) of [CIR 2025/848], Registrar SHALL reject the registration. | [CIR 2025/848], Article 6(6) |
| REGISTRAR-GOV-01 | Registrars SHALL suspend/cancel a registration of a WRP where requested by a supervisory body (per eIDAS reference). | [CIR 2025/848], Article 9(1) |
| REGISTRAR-GOV-02 | Registrars MAY suspend/cancel a registration of a WRP if info inaccurate/outdated/misleading, non-compliance, excessive attribute requests, breach of law. | [CIR 2025/848], Article 9(2) |
| REGISTRAR-GOV-03 | Registrars SHALL suspend/cancel a registration of a WRP if requested by the WRP itself. | [CIR 2025/848], Article 9(3) |
| REGISTRAR-GOV-04 | Registrar SHALL conduct proportionality assessment before suspension/cancellation under Article 9(2). | [CIR 2025/848], Article 9(4) |
| REGISTRAR-GOV-05 | Registrar SHALL notify WRP and relevant Providers of WRPAC and WRPRC without undue delay and not later than 24 hours. | [CIR 2025/848], Article 9(5) |
| REGISTRAR-GOV-06 | Providers of WRPAC and WRPRC SHALL revoke affected certificates without undue delay after notification (where applicable). | [CIR 2025/848], Article 9(6) |
| REGISTRAR-GOV-07 |  Registrars SHALL keep records (Annex I + issuance data + changes) for 10 years. | [CIR 2025/848], Article 10 |

##### Provider of WRPAC and WRPRC and Register Interactions Requirements 

| ID | Requirement | Reference |
| -- | ----------- | --------- |
| PROVIDER-WRPAC-01 | Providers of WRPAC SHALL verify at issuance time that the WRP is included with valid registration status in the national Register and certificate info is consistent with Register info. | [CIR 2025/848], Annex IV §3(c) |
| PROVIDER-WRPAC-02 | Providers of WRPAC SHALL continuously monitor changes in the national Register and revoke when changes require (especially suspension/cancellation). | [CIR 2025/848], Annex IV §3(e) |
| PROVIDER-WRPAC-03 | Providers of WRPAC SHALL publish revocation status timely and in any event within 24 hours after receipt of revocation request. | [CIR 2025/848], Annex IV §3(h) |
| PROVIDER-WRPRC-01 | Where a Member State authorises WRPRCs, it SHALL ensure each intended use is expressed in the WRPRC and that WRPRCs include a privacy policy URL and a general access policy. | [CIR 2025/848], Article 8(2)(b)–(c) and (g), Article 8(3) |
| PROVIDER-WRPRC-02 | Providers of WRPRC SHALL verify at issuance time Register status, consistency with Register info, and validity of the WRPAC (when relevant). | [CIR 2025/848], Annex V §3(c) |
| PROVIDER-WRPRC-03 | Providers of WRPRC SHALL monitor Register changes, reissue/revoke when changes require. | [CIR 2025/848], Annex V §3(d) |
| PROVIDER-WRPRC-04 | Data exchange format for WRPRC SHALL be signed JWTs (RFC 7519) and CWTs (RFC 8392), using an Advanced Electronic Signature (AdES) with the B-B profile (JAdES per [ETSI TS 119 182-1] for JWT, COSE for CWT). | [CIR 2025/848], Annex V §4; [ETSI TS 119 475] §4.4 |


#### Register Data Schema

This section defines the data schema for each WRP registered in the national Register of WRPs. The values are extracted from the Annex VI of the [CIR 2025/848-Amendment].

<!--format of the information exchanged via the Register API as JSON objects and JWS-signed statements. -->

!!! note "Address field publication rule (important)"

    The draft Annex VI text says the published API payload excludes `WalletRelyingParty.physicalAddress`, while Table 1 uses the attribute name `postalAddress`. This document uses **`postalAddress`** as the schema field name and applies the publication rule to that field (i.e., do not publish it in API statements).

| Parameter | Type | Presence | Description | 
| --------- | ---- | -------- | ----------- |
| `legalPerson` | `LegalPerson` | REQUIRED if legal person | Specific attributes of a legal person. It SHALL be present if the legal entity is a legal person. | 
| `naturalPerson` | `NaturalPerson`| REQUIRED if natural person| Specific attributes of a natural person. It SHALL be present if the legal entity is a natural person.|
| `identifier` | `Identifier[]` | REQUIRED | One or more identifiers from official records. | 
| `postalAddress` | `string[]` | OPTIONAL | Postal address(es) of the legal entity (**registration view only; excluded from published API statements**). Note: [ETSI TS 119 475] B.2.2 defines this as `[1..1] string`; Draft Annex VI Table 1 uses an array. This document follows Draft Annex VI. |
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
| `intendedUse` | `IntendedUse[]` | OPTIONAL | Intended-use definitions and requested attestation data. Not required if registering only as a designated intermediary. | 
| `isPSB` | `boolean` | REQUIRED | Whether the WRP is a public sector body (explicitly present; `false` if not PSB). | 
| `entitlement` |  `string[]` | REQUIRED | Entitlement URI(s) (see note below). |
| `providesAttestations` | `Credential[]` | REQUIRED if PID/Attestation Provider| Attestation types the WRP intends to issue to wallet units. It SHALL be present if any entitlement is `QEAA_Provider`, `Non_Q_EAA_Provider`, `PUB_EAA_Provider`, or `PID_Provider`. | 
| `supervisoryAuthority` | `LegalEntity` | REQUIRED | Competent supervisory authority (Art. 46a eIDAS) including contact information. | 
| `registryURI` | `string` | REQUIRED | URI of the API of the national register of WRPs. | 
| `usesIntermediary` | `WalletRelyingParty[]` | OPTIONAL | If present, indicates designated intermediary(ies). Only the subset `{identifier, tradeName, registryURI}` is needed for each intermediary reference. | 
| `isIntermediary` | `boolean` | REQUIRED | Whether the registered entity is a designated intermediary. SHALL be `false` if `usesIntermediary` is present. | 

!!! note

    Mapping between CIR entitlement label and [ETSI TS 119 475] (Annex A.2) normative URI:

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

    [ETSI TS 119 475] v1.2.1 Annex A.3 defines additional sub-entitlement URIs for specific service provider roles. For example, Payment Service Provider sub-entitlements include:

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
| Privacy policy | `http://data.europa.eu/eudi/policy/privacy-policy` | [ETSI TS 119 475] B.2.8; [CIR 2025/848] Article 8(2)(g) |
| Terms and conditions | `http://data.europa.eu/eudi/policy/terms-and-conditions` | [CIR 2025/848-Amendment], Annex VI Table 7 |
| Privacy statement (intended use) | `http://data.europa.eu/eudi/policy/privacy-statement` | [CIR 2025/848-Amendment], Annex VI Table 7 |

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
| `establishedBylaw` | `Law[]` | REQUIRED if PSBs responsible for authentic sources| Legal basis for establishment. It SHALL be present for PSBs responsible for authentic sources; present for other PSBs where applicable. | 

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


#### Registry statements

Registry statements exposed through the common API SHALL be provided as electronically signed or sealed JSON files, using JWS in accordance with Annex II Section 1 and [RFC 7515].

#### JWS requirements

##### Serialization and header placement

This profile uses **JWS Compact Serialization** for API responses (e.g., `application/jwt`), unless a Member State profile explicitly defines another serialization.
In JWS Compact Serialization, there is **no unprotected header**; therefore, the JOSE Header is the **JWS Protected Header** and is integrity-protected by the signature.

| Parameter | Type | Description | Reference |
| --- | ---: | --- | --- |
| `statement` | `string` (JWS compact) | JWS compact serialisation containing the response payload. | CIR Annex II §1; [RFC 7515] |
| `payload` | `JSON value` | Decoded payload. Depending on endpoint, this may be an object, an array, or a boolean. | [CIR 2025/848-Amendment] Annex VI §5; [RFC 7515] |
| `integrityValidationInfo` | implementation-specific | Integrity-validation information as required by the applicable signature/seal profile. | Draft update; [RFC 9162] / [RFC 6962] |

##### JOSE Protected Header parameters (profile)

The following JOSE Protected Header requirements apply to registry statements:

| Header parameter | Requirement | Description | Reference |
| --- | --- | --- | --- |
| `alg` | **REQUIRED** | Signature/seal algorithm identifier. SHALL be supported by producer and verifier. The value `none` SHALL NOT be used for registry statements. | [RFC 7515] §4.1.1; profile rule |
| `x5c` | **RECOMMENDED** (SHALL if no trust-list/key-resolution profile is defined) | X.509 certificate chain of the signer/sealer. The signing certificate SHALL be the first certificate in the array. | [RFC 7515] §4.1.6 |
| `kid` | **RECOMMENDED** | Key identifier to support key rollover and efficient verifier key selection. | [RFC 7515] §4.1.4 |
| `x5t#S256` | **RECOMMENDED** | SHA-256 thumbprint of the signing certificate (useful for pinning / key matching). | [RFC 7515] §4.1.8 |
| `x5u` | OPTIONAL | URL to signer certificate chain. If used, it SHALL be retrieved over TLS with server identity validation. | [RFC 7515] §4.1.5 |
| `typ` | OPTIONAL (RECOMMENDED) | Media type hint for the complete JWS object (e.g., `JWT` / `application/jwt` or a profile-specific media type). | [RFC 7515] §4.1.9 |
| `crit` | OPTIONAL | If used, all listed parameters MUST be understood and processed by verifiers; otherwise the JWS is invalid. `crit` MUST appear only in the protected header. | [RFC 7515] §4.1.11 |

!!! note

    The JOSE header parameter `x5c` above is part of the JWS signature envelope. It is distinct from any `x5c` attribute defined in the registry payload/data schema (e.g., Annex VI data schema fields).

#### Normative endpoint payloads

##### `GET /wrp` payload

The decoded JWS payload for `GET /wrp` SHALL be:

- an array of `WalletRelyingParty` objects (matching the query),
- with address field excluded from published entries,
- and, where relevant, accompanied by WRPAC history information in the statement/profile used by the Member State.

##### `GET /wrp/check-intended-use` payload

The decoded JWS payload for `GET /wrp/check-intended-use` SHALL be:

- a boolean `true` or `false`.

#### Optional profile envelope (recommended for interoperability metadata)

To preserve issuer/timestamp metadata and pagination in a stable schema, a Member State MAY define an envelope profile as follows (while still satisfying the endpoint semantics above):

##### SignedWRPArrayEnvelope (profile)

| Parameter | Type | Description |
| --- | ---: | --- |
| `iss` | `string` | Identifier of the Registry/Registrar issuing the statement. |
| `iat` | `integer` | Issued-at timestamp (Unix epoch seconds). |
| `data` | `WRPEntry[]` | Matching WRP entries (published view, address excluded), each bundled with its certificate history. |
| `pagination` | `Pagination` (optional) | Cursor-based pagination metadata. |

###### WRPEntry (per-WRP bundle)

| Parameter | Type | Description |
| --- | ---: | --- |
| `wrp` | `WalletRelyingParty` | WRP registration information (published view, address excluded). |
| `wrpacHistory` | `CertificateHistoryEntry[]` (optional) | WRP access certificate history for this WRP (including CT-related references where available). |
| `wrprcHistory` | `CertificateHistoryEntry[]` (optional) | WRP registration certificate history for this WRP (if provided by national profile). |

##### SignedWRPEnvelope (profile, for non-common helper endpoints)

| Parameter | Type | Description |
| --- | ---: | --- |
| `iss` | `string` | Registry/Registrar identifier. |
| `iat` | `integer` | Issued-at timestamp. |
| `data` | `WalletRelyingParty` | Single WRP object (published view, address excluded). |
| `wrpacHistory` | `CertificateHistoryEntry[]` (optional) | WRPAC history. |
| `wrprcHistory` | `CertificateHistoryEntry[]` (optional) | WRPRC history (if supported). |

##### SignedIntendedUseCheckEnvelope (profile)

!!! note

    Annex VI strictly allows a JWS-signed boolean response. This object envelope is a non-normative profile convenience.

| Parameter | Type | Description |
| --- | ---: | --- |
| `iss` | `string` | Registry issuer. |
| `iat` | `integer` | Issued-at timestamp. |
| `data` | `boolean` | Result of intended-use check. |

#### CertificateHistoryEntry (profile helper for certificate histories)

| Parameter | Type | Description |
| --- | ---: | --- |
| `certificate` | `string` | Certificate (e.g., PEM/DER-encoded representation, profile-defined). |
| `x5c` | `string[]` (optional) | Certificate chain for the certificate entry. |
| `status` | `string` | Certificate status (e.g., `current`, `revoked`, `expired`, `historic`). |
| `validFrom` | `string` (optional) | Validity start timestamp/date (profile-defined format). |
| `validTo` | `string` (optional) | Validity end timestamp/date (profile-defined format). |
| `ctLogEntries` | `object[]` (optional) | CT log / transparency references ([RFC 9162]-aligned, profile-defined structure). |

#### Common Register API (TS5-aligned profile)

This section documents a TS5-aligned common Register API profile that satisfies Annex II constraints.
> The API is public (no prior authentication) and returns JWS-signed statements.

#### `GET /wrp` — search/list

##### Request (query parameters)

The common API SHALL support parameterised queries on `GET /wrp`. The following names align with the [CIR 2025/848-Amendment] Annex VI query parameter naming.

| Parameter | Type | R/O | Description | Reference |
| --- | ---: | --- | --- | --- |
| `identifier` | `string` | O | Filter by official/business registration number / identifier. | [CIR 2025/848-Amendment], Annex VI §2(a), §4(a) |
| `legalname` | `string` | O | Filter by official company name. | [CIR 2025/848-Amendment], Annex VI §2(b), §4(a) |
| `tradename` | `string` | O | Filter by trade name. | [CIR 2025/848-Amendment], Annex VI §2(b), §4(a) |
| `policy` | `string` | O | Filter by privacy policy URL (or policy URI as profiled). | [CIR 2025/848-Amendment], Annex VI §2(c), §4(a) |
| `entitlement` | `string` | O | Filter by entitlement type (URI). | [CIR 2025/848-Amendment], Annex VI §2(d), §4(a) |
| `providesattestation` | `string` | O | Filter by attestation types provided (e.g., attestation schema type in `providesAttestations`). | [CIR 2025/848-Amendment], Annex VI §2(e), §4(a) |
| `usesintermediary` | `string` or `boolean` | O | Filter by reliance on intermediary (presence of `usesIntermediary`). | [CIR 2025/848-Amendment], Annex VI §2(h), §4(a) |
| `isintermediary` | `boolean` | O | Filter by intermediary status. | [CIR 2025/848-Amendment], Annex VI §4(a) |
| `intendedUseIdentifier` | `string` | O | Filter by registrar-provided intended-use identifier. | [CIR 2025/848-Amendment], Annex VI §2(g), §4(a) |
| `intendedUseClaimPath` | `string` | O | Filter by intended-use requested claim path. | [CIR 2025/848-Amendment], Annex VI §4(a) |
| `intendedUseCredentialMeta` | `string` | O | Filter by intended-use credential metadata (format-specific). | [CIR 2025/848-Amendment], Annex VI §4(a) |
| `intendedUseCredentialFormat` | `string` | O | Filter by intended-use credential format. | [CIR 2025/848-Amendment], Annex VI §2(f), §4(a) |
| `cursor` | `string`  | O | Cursor for pagination (profile-defined token format). | [CIR 2025/848-Amendment], Annex VI §4(c) |
| `limit` | `integer`  | O | Page size (profile-defined). | Implementation profile |

##### Behaviour

| Requirement | Reference |
| --- | --- |
| If no query parameters are provided, `GET /wrp` SHALL return the full list of registered WRPs (subject to pagination profile). | [CIR 2025/848-Amendment], Annex VI §4(b) |
| The endpoint SHALL support cursor-based pagination. | [CIR 2025/848-Amendment], Annex VI §4(c) |
| The endpoint SHALL support combined filters in a single query. | [CIR 2025/848-Amendment], Annex VI §4(d) |
| A successful response (`200`) SHALL be JWS-signed. | [CIR 2025/848-Amendment], Annex VI §5; CIR Annex II §1 |

##### Response

| HTTP Code | Type | Description | Reference |
| --- | ---: | --- | --- |
| `200` | `application/jwt` | JWS compact string. Decoded payload SHALL contain matching `WalletRelyingParty` entries (strict Annex VI form: array; profile envelope also allowed if documented). | [CIR 2025/848-Amendment], Annex VI §5; [RFC 7515] |

---

#### `GET /wrp/check-intended-use` — intended use check (public, required)

!!! warning

    In the Annex VI [CIR 2025/848-Amendment], this endpoint is part of the public API and is not optional.

##### Request

The draft requires a dedicated intended-use check endpoint with **four required and one optional parameter**.  
This profile uses the following mapping (strictly aligned names for intended-use filters):

| Parameter | Type | R/O | Description | Reference |
| --- | ---: | :--: | --- | --- |
| `identifier` | `string` | R | Identifier of the WRP whose intended-use registration is being checked. | [CIR 2025/848-Amendment], Annex VI §5 (specific WRP check) |
| `intendedUseIdentifier` | `string` | R | Intended-use identifier registered by the registrar. | [CIR 2025/848-Amendment], Annex VI §2(g), §5 |
| `intendedUseClaimPath` | `string` | R | Requested claim path to check (serialised representation of path array; profile-defined encoding). | [CIR 2025/848-Amendment], Annex VI §4(c), §5 |
| `intendedUseCredentialFormat` | `string` | R | Credential format to check. | [CIR 2025/848-Amendment], Annex VI §2(f), §4(c), §5 |
| `intendedUseCredentialMeta` | `string` | O | Credential metadata filter (profile-defined serialisation). | [CIR 2025/848-Amendment], Annex VI §4(c), §5 |

##### Response

| HTTP Code | Type | Description | Reference |
| --- | ---: | --- | --- |
| `200`  | `application/jwt` | JWS compact string; decoded payload is boolean `true` or `false` (strict Annex VI). | [CIR 2025/848-Amendment], Annex VI §5; [RFC 7515] |
| `400` | - | Bad request (invalid or incomplete request parameter). | Implementation |

---

#### `POST /wrp` — create (authorised write method)

This is a common API write method in the [CIR 2025/848-Amendment], Annex VI.

##### Request

!!! note

    This method is only accessible for entities which are authorized by Member State

| Parameter | Type | R/O | Description | Reference |
| --- | ---: | --- | --- | --- |
| request body | `WalletRelyingParty` | R | Full WRP object compliant with Annex VI Table 1 schema (registration view). | [CIR 2025/848-Amendment], Annex VI §9(b); Table 1 |

##### Response

| HTTP Code | Type | Description | Reference |
| --- | ---: | --- | --- |
| `201` | - | Created. | [CIR 2025/848-Amendment], Annex VI §9(b) |
| `400` | - | Bad request (invalid or incomplete payload). | Implementation |
| `401` | - | Unauthorized (missing or invalid authentication). | Implementation |
| `403` | - | Forbidden (caller not authorised by Member State). | Implementation |

---

#### `PUT /wrp` — update (authorized write method)

##### Request

!!! note

    This method is only accessible for entities which are authorized by Member State

| Parameter | Type | R/O | Description | Reference |
| --- | ---: | --- | --- | --- |
| request body | `WalletRelyingParty` | R | Full WRP object compliant with Annex VI Table 1 schema (registration view). | [CIR 2025/848-Amendment], Annex VI §9(b); Table 1 |

##### Response

| HTTP Code | Type | Description | Reference |
| --- | ---: | --- | --- |
| `200` | - | Updated. | [CIR 2025/848-Amendment], Annex VI §9(b) |
| `400` | - | Bad request (invalid or incomplete payload). | Implementation |
| `401` | - | Unauthorized (missing or invalid authentication). | Implementation |
| `403` | - | Forbidden (caller not authorised by Member State). | Implementation |
| `404` | - | Not found. | [CIR 2025/848-Amendment], Annex VI §9(b) |

---

#### `DELETE /wrp` — delete

!!! note

    This method is only accessible for entities which are authorized by Member State

##### Request

| Parameter | Type | R/O | Description | Reference |
| --- | ---: | --- | --- | --- |
| request body | `object` | R | Identifier payload for the WRP to delete (profile-defined body shape, based on `WalletRelyingParty.identifier`). | [CIR 2025/848-Amendment], Annex VI §9(b) |

##### Response

| HTTP Code | Type | Description | Reference |
| --- | ---: | --- | --- |
| `204` | - | Deleted. | [CIR 2025/848-Amendment], Annex VI §9(b) |
| `400` | - | Bad request (invalid identifier payload). | Implementation |
| `401` | - | Unauthorized (missing or invalid authentication). | Implementation |
| `403` | - | Forbidden (caller not authorised by Member State). | Implementation |
| `404` | - | Not found. | Implementation |

---

#### `GET /wrp/{identifier}` — get by identifier (national/profile extension)

!!! note

    This endpoint is useful, but it is **not explicitly defined** in the [CIR 2025/848-Amendment], Annex VI common API method list. If kept, mark it as a national/profile extension.

##### Request

| Parameter | Type | R/O | Description |
| --- | ---: | --- | --- |
| `identifier` (path) | `string` | R | Identifier of the WRP to retrieve. |

##### Response

| HTTP Code | Type | Description |
| --- | ---: | --- |
| `200` | `application/jwt` | JWS compact string; decoded payload contains one `WalletRelyingParty` entry (or profile envelope). |
| `404` | - | Not found. |


#### Non-normative JSON examples

#### Example: WRP object (registration view – includes postalAddress)

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

#### Example of a WRP object (published via API – excludes Annex I point 4 / physical address)

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
    [
      { "lang": "en", "content": "Retail banking services for individuals." }
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

!!! note

    The published API view excludes only `postalAddress` (Annex I point 4). All other fields, including intended-use credential claims, are published as registered.
