# Registry
This document specifies requirements for the **Registrar of Wallet-Relying Parties (WRPs)** and the National Register of WRPs (the registry service) in the context of eIDAS2 and the EUDI Wallet ecosystem.
## 1. Scope and objective

Formally, a **Registrar** is the designated body that:
- manages the WRP registration lifecycle (onboarding, update, suspension, cancellation),
- ensures the integrity and publication of registration information,
- ensures interoperability by exposing WRP registration data via a national website and a single common REST API.

The **National Register of WRPs** is the publicly accessible system (dataset + API) that provides signed/sealed registration statements about WRPs and their authorisations/declared usage.

>The **National Register of Wallet-Relying Parties** is a single logical register. For scalability and resilience, a Member State MAY deploy multiple technical instances provided they expose a **single coherent common REST API** and return **signed statements** as required.<br>
>However, the usage of **sectorial register** MAY NOT have interest because the issuance of WRPAC is based on whether the Relying Party has been registered with an active status in the National Register.

## 2. Terms and Roles

- **Registrar of WRPs**: body designated by a Member State to establish and maintain the list of registered WRPs.
- **Register (National Register of WRPs)**: the service exposing information about registered WRPs through a national website and a common REST API.
- **WRP**: a relying party that intends to rely upon Wallet Units to provide services via digital interaction.
- **WRPAC**: Wallet-Relying Party Access Certificate, which is used for authentication towards wallets.
- **WRPRC**: Wallet-Relying Party Registration Certificate, which is optional, and is used to express intended use + registered data requests.
- **Intermediary**: an entity acting on behalf of a WRP in wallet interactions (where applicable).


## 3. References

- **Commission Implementing Regulation (EU) 2025/848** (Wallet-relying party registration / national registers / Annex I–V):  
  https://eur-lex.europa.eu/eli/reg_impl/2025/848/oj

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

### 4.1 WRP interacts directly with Wallet

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
  WAL->>WAL: Authenticate presenting entity via WRPAC
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
> NOTE on “excluded information”: Annex II requires that API statements exclude Annex I point 4 (the physical address where the WRP is established). Implementations therefore typically:
> - store the physical address for registrar/verification purposes, but 
> - do not publish it in API statement payloads.

## 6.1 WalletRelyingParty (WRP registration information object)


| Parameter              |                                                              Type | Description                                                                                                       | Reference                                             |
| ---------------------- |------------------------------------------------------------------:|-------------------------------------------------------------------------------------------------------------------| ----------------------------------------------------- |
| `legalName`            |                                   `string` or `MultiLangString[]` | Legal name as stated in an official record (for legal person).                                                    | CIR Annex I(1); ETSI TS 119 475 (RP attributes model) |
| `givenName`            |                                                          `string` | Given name (for natural person).                                                                                  | CIR Annex I(1); ETSI TS 119 475                       |
| `familyName`           |                                                          `string` | Family name (for natural person).                                                                                 | CIR Annex I(1); ETSI TS 119 475                       |
| `tradeName`            |                                                          `string` | User-friendly name (trade/service name), recognisable to the user.                                                | CIR Annex I(2)                                        |
| `identifier`           |                                                    `Identifier[]` | One or more identifiers (EORI, business register no., LEI, VAT, tax, EUID, etc.).                                 | CIR Annex I(3)                                        |
| `postalAddress`        |                                     `string` or structured object | Physical address where the WRP is established (**registration only; excluded from API statements**).              | CIR Annex I(4); CIR Annex II §2(1)(c)                 |
| `infoURI`              |                                                        `string[]` | URL(s) belonging to the WRP.                                                                                      | CIR Annex I(5)                                        |
| `country`              |                                                          `string` | ISO 3166-1 alpha-2 prefixing rule where applicable (EL for Greece).                                               | CIR Annex I(6)                                        |
| `supportURI`           |                                                          `string` | Website for helpdesk/support contact (one of the contact options).                                                | CIR Annex I(7)(a)                                     |
| `phone`                |                                                        `string[]` | Phone numbers for registration/intended-use contact (one of the contact options).                                 | CIR Annex I(7)(b)                                     |
| `email`                |                                                        `string[]` | Email addresses for registration/intended-use contact (one of the contact options).                               | CIR Annex I(7)(c)                                     |
| `srvDescription`       | `MultiLangString[]` (or array of per-service multilingual blocks) | Description of the type of services provided by the WRP.                                                          | CIR Annex I(8)                                        |
| `intendedUse`          |                                                   `IntendedUse[]` | Intended use(s) and requested data.                                                                               | CIR Annex I(9)–(10)                                   |
| `isPSB`                |                                                         `boolean` | Whether the WRP is a public sector body.                                                                          | CIR Annex I(11)                                       |
| `entitlement`          |                                                        `string[]` | Entitlement(s) (values defined in CIR Annex I(12); URIs in ETSI TS 119 475).                                      | CIR Annex I(12); ETSI TS 119 475 Annex A.2            |
| `providesAttestations` |                                                    `Credential[]` | Optional sub-entitlements (Member State specific) indicating which attestations a Non_Q_EAA_Provider shall issue. | CIR Annex I(13)                                       |
| `usesIntermediary`     |                     `WalletRelyingParty[]` or `IntermediaryRef[]` | Indicates reliance upon an intermediary acting on behalf of the relying party.                                    | CIR Annex I(14)–(15)                                  |
| `isIntermediary`       |                                                         `boolean` | Flag indicating the entity acts as an intermediary (national rules/implementation).                               | CIR Annex I(14)–(15) (association model)              |

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

| Parameter   |     Type | Description                                 | Reference           |
| ----------- | -------: | ------------------------------------------- | ------------------- |
| `policyURI` | `string` | URL to the policy (e.g., privacy policy).   | CIR Article 8(2)(g) |
| `type`      | `string` | Policy type label (implementation/profile). | Implementation      |

### 6.1.5 Credential
| Parameter |      Type | Description                                                   | Reference                         |
| --------- | --------: | ------------------------------------------------------------- | --------------------------------- |
| `format`  |  `string` | Credential format identifier (e.g., `dc+sd-jwt`, `mso_mdoc`). | CIR Annex I(9) (machine readable) |
| `meta`    |  `string` | Additional grouping/type metadata (profile).                  | Implementation / ARF profile      |
| `claim`   | `Claim[]` | Requested claim paths and allowed values (if constrained).    | CIR Annex I(9)                    |

### 6.1.6 Claim
| Parameter |       Type | Description                         | Reference                                     |
| --------- | ---------: | ----------------------------------- | --------------------------------------------- |
| `path`    |   `string` | Claim path within the credential.   | CIR Annex I(9)                                |
| `values`  | `string[]` | Optional allowed values constraint. | CIR Annex I(9) (machine-readable constraints) |


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



## 7. Registry statements (signed/sealed format)
Annex II mandates that information exposed via the API is a signed/sealed JSON statement using JWS (RFC 7515).

## 7.1 JWS requirements

| Parameter   |                   Type | Description                                          | Reference                 |
| ----------- | ---------------------: | ---------------------------------------------------- | ------------------------- |
| `statement` | `string` (JWS compact) | JWS compact serialisation containing a JSON payload. | CIR Annex II §1; RFC 7515 |
| `payload`   |          `JSON object` | The decoded payload of the JWS (see schemas below).  | CIR Annex II §2(2)        |




## 7.2 SignedWRP (single object statement payload)
| Parameter |                 Type | Description                                                 | Reference                      |
| --------- | -------------------: | ----------------------------------------------------------- | ------------------------------ |
| `iss`     |             `string` | Identifier of the Registry/Registrar (issuer of statement). | Implementation profile         |
| `iat`     |            `integer` | Issued-at timestamp.                                        | RFC 7519 / common JWT practice |
| `data`    | `WalletRelyingParty` | The WRP data object (published view).                       | CIR Annex II §2(1)(c)          |

## 7.3 SignedWRPArray (list statement payload)
| Parameter    |                   Type | Description                           | Reference                      |
| ------------ | ---------------------: | ------------------------------------- | ------------------------------ |
| `iss`        |               `string` | Identifier of the Registry/Registrar. | Implementation profile         |
| `iat`        |              `integer` | Issued-at timestamp.                  | RFC 7519 / common JWT practice |
| `data`       | `WalletRelyingParty[]` | List of WRP objects.                  | CIR Annex II §2(1)(b)–(c)      |
| `pagination` |           `Pagination` | Pagination object (cursor-based).     | Implementation profile         |

## 7.4 SignedIntendedUseCheckResult (check response payload)
| Parameter           |                Type | Description                                                      | Reference                      |
| ------------------- | ------------------: | ---------------------------------------------------------------- | ------------------------------ |
| `iss`               |            `string` | Registry issuer.                                                 | Implementation profile         |
| `iat`               |           `integer` | Issued-at timestamp.                                             | RFC 7519 / common JWT practice |
| `data.isRegistered` |           `boolean` | True if the queried condition matches a registered intended use. | Implementation                 |
| `data.details`      | `string` (optional) | Additional details.                                              | Implementation                 |


## 8. Common Register API (TS5-aligned profile)

This section documents a TS5-aligned common Register API profile that satisfies Annex II constraints.
>> The API is public (no prior authentication) and returns JWS-signed statements.

## 8.1 `GET /wrp` — search/list
### 8.1.1 Request

The following Table shows the request parameters which can be used to search details about registered relying parties

| Parameter               |      Type | Description                                    | Reference             |
| ----------------------- | --------: | ---------------------------------------------- | --------------------- |
| `identifier`            |  `string` | Filter by WRP identifier.                      | CIR Annex II §2(1)(b) |
| `legalname`             |  `string` | Filter by legal name.                          | CIR Annex II §2(1)(b) |
| `tradename`             |  `string` | Filter by trade name.                          | CIR Annex II §2(1)(b) |
| `policy`                |  `string` | Filter by policy URI/type (privacy policy).    | CIR Annex II §2(1)(b) |
| `entitlement`           |  `string` | Filter by entitlement (URI).                   | CIR Annex II §2(1)(b) |
| `credentialmeta`        |  `string` | Filter by credential meta.                     | Implementation        |
| `credentialformat`      |  `string` | Narrow down meta matches by credential format. | Implementation        |
| `usesintermediary`      |  `string` | Filter by intermediary identifier.             | CIR Annex I(14)–(15)  |
| `isintermediary`        | `boolean` | Filter by intermediary status.                 | CIR Annex I(14)–(15)  |
| `intendeduseidentifier` |  `string` | Filter by intended use identifier.             | CIR Annex I(9)–(10)   |
| `limit`                 | `integer` | Page size.                                     | Implementation        |
| `cursor`                |  `string` | Cursor for pagination.                         | Implementation        |


### 8.1.2 Response
| Parameter  |              Type | Description                                                       | Reference                    |
| ---------- | ----------------: | ----------------------------------------------------------------- | ---------------------------- |
| `200` body | `application/jwt` | JWS compact string; decoded payload conforms to `SignedWRPArray`. | CIR Annex II §2(2); RFC 7515 |


## 8.2 `GET /wrp/{identifier}` — get by identifier

### 8.2.1 Request
| Parameter           |     Type | Description                            | Reference             |
| ------------------- | -------: | -------------------------------------- | --------------------- |
| `identifier` (path) | `string` | The identifier of the WRP to retrieve. | CIR Annex II §2(1)(b) |


### 8.2.2 Response

| Parameter  |              Type | Description                                                  | Reference                    |
| ---------- | ----------------: | ------------------------------------------------------------ | ---------------------------- |
| `200` body | `application/jwt` | JWS compact string; decoded payload conforms to `SignedWRP`. | CIR Annex II §2(2); RFC 7515 |
| `404`      |                 - | Not found.                                                   | Implementation               |

## 8.3 PUT /wrp — update (registrar-controlled)
This endpoint is registrar-specific and may be exposed only for registrar operations.

| Parameter    |                 Type | Description                          | Reference                  |
| ------------ | -------------------: | ------------------------------------ | -------------------------- |
| request body | `WalletRelyingParty` | Full WRP object (registration view). | CIR Article 5(3) (updates) |


## 8.4 GET /wrp/check-intended-use — intended use check (optional helper)
### 8.4.1 Request
| Parameter               |           Type | Description                   | Reference             |
| ----------------------- | -------------: | ----------------------------- | --------------------- |
| `rpidentifier`          |       `string` | Unique identifier of the WRP. | CIR Annex II §2(1)(b) |
| `intendeduseidentifier` |       `string` | Intended use identifier.      | CIR Annex I(9)–(10)   |
| `credentialformat`      |       `string` | Credential format.            | CIR Annex I(9)        |
| `claimpath`             |       `string` | Claim path.                   | CIR Annex I(9)        |
| `credentialmeta`        |       `string` | Optional credential meta.     | Implementation        |
| `policyurl`             | `string` (uri) | Privacy policy URL.           | CIR Article 8(2)(g)   |

### 8.4.2 Response
| Parameter  |              Type | Description                                                                     | Reference |
| ---------- | ----------------: | ------------------------------------------------------------------------------- | --------- |
| `200` body | `application/jwt` | JWS compact string; decoded payload conforms to `SignedIntendedUseCheckResult`. | RFC 7515  |


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

## 11.1 Example: WRP object (registration view – includes physical address)

````json
{
  "tradeName": "ExampleBank Mobile",
  "legalName": "ExampleBank S.A.",
  "country": "FR",
  "identifier": [
    { "type": "EUID", "identifier": "FR-EUID-123456789" },
    { "type": "VAT", "identifier": "FR12345678901" }
  ],
  "postalAddress": "10 Rue Exemple, 75000 Paris, FR",
  "infoURI": ["https://examplebank.eu"],
  "supportURI": "https://examplebank.eu/support",
  "email": "wallet-rp-registration@examplebank.eu",
  "phone": "+33-1-00-00-00-00",
  "srvDescription": [
    { "lang": "en", "content": "Retail banking services for individuals." },
    { "lang": "fr", "content": "Services bancaires pour particuliers." }
  ],
  "isPSB": false,
  "entitlement": [
    "urn:etsi:esi:wp:attributes:entitlements:Service_Provider"
  ],
  "intendedUse": [
    {
      "intendedUseIdentifier": "iu-001",
      "purpose": [
        { "lang": "en", "content": "Open a bank account remotely." }
      ],
      "privacyPolicy": [
        { "type": "privacy", "policyURI": "https://examplebank.eu/privacy/wallet" }
      ],
      "credential": [
        {
          "format": "dc+sd-jwt",
          "meta": "PID",
          "claim": [
            { "path": "family_name", "values": [] },
            { "path": "given_name", "values": [] },
            { "path": "birth_date", "values": [] }
          ]
        }
      ],
      "createdAt": "2026-01-01T10:00:00Z"
    }
  ]
}

````



## 11.2 Example of a WRP object (published via API – excludes Annex I point 4 / physical address)

````json
{
  "tradeName": "ExampleBank Mobile",
  "legalName": "ExampleBank S.A.",
  "country": "FR",
  "identifier": [
    { "type": "EUID", "identifier": "FR-EUID-123456789" }
  ],
  "infoURI": ["https://examplebank.eu"],
  "supportURI": "https://examplebank.eu/support",
  "email": "wallet-rp-registration@examplebank.eu",
  "phone": "+33-1-00-00-00-00",
  "srvDescription": [
    { "lang": "en", "content": "Retail banking services for individuals." }
  ],
  "isPSB": false,
  "entitlement": [
    "urn:etsi:esi:wp:attributes:entitlements:Service_Provider"
  ],
  "intendedUse": [
    {
      "intendedUseIdentifier": "iu-001",
      "purpose": [
        { "lang": "en", "content": "Open a bank account remotely." }
      ],
      "privacyPolicy": [
        { "type": "privacy", "policyURI": "https://examplebank.eu/privacy/wallet" }
      ],
      "credential": [
        {
          "format": "dc+sd-jwt",
          "meta": "PID",
          "claim": [
            { "path": "family_name", "values": [] },
            { "path": "given_name", "values": [] }
          ]
        }
      ],
      "createdAt": "2026-01-01T10:00:00Z"
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
