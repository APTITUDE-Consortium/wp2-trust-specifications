# Registry
This document specifies requirements for the **Registrar of Wallet-Relying Parties (WRPs)** and the National Register of WRPs (the registry service) in the context of eIDAS2 and the EUDI Wallet ecosystem.
## Registrar & National Register of Wallet-Relying Parties (WRPs)
### Scope and objective

Formally, a **Registrar** is the designated body that:
- manages the WRP registration lifecycle (onboarding, update, suspension, cancellation),
- ensures the integrity and publication of registration information,
- ensures interoperability by exposing WRP registration data via a national website and a single common REST API.

The **National Register of WRPs** is the publicly accessible system (dataset + API) that provides signed/sealed registration statements about WRPs and their authorisations/declared usage.

>The **National Register of Wallet-Relying Parties** is a single logical register. For scalability and resilience, a Member State MAY deploy multiple technical instances provided they expose a **single coherent common REST API** and return **signed statements** as required.<br>
>However, the usage of **sectorial register** MAY NOT have interest because the issuance of WRPAC is based on whether the Relying Party has been registered with an active status in the National Register.

### Terms and Roles

- **Registrar of WRPs**: body designated by a Member State to establish and maintain the list of registered WRPs.
- **Register (National Register of WRPs)**: the service exposing information about registered WRPs through a national website and a common REST API.
- **WRP**: a relying party that intends to rely upon Wallet Units to provide services via digital interaction.
- **WRPAC**: Wallet-Relying Party Access Certificate, which is used for authentication towards wallets.
- **WRPRC**: Wallet-Relying Party Registration Certificate, which is optional, and is used to express intended use + registered data requests.
- **Intermediary**: an entity acting on behalf of a WRP in wallet interactions (where applicable).


### References
[1]. [Commission Implementing Regulation (EU) 2025/848](https://eur-lex.europa.eu/legal-content/EN/TXT/PDF/?uri=OJ%3AL_202500848) <br>
[2]. [EUDI Wallet ARF (TS5 + TS6)](https://eudi.dev/2.7.3/architecture-and-reference-framework-main/) <br>
[3].  [ETSI TS 119 475 v1.1.1](https://www.etsi.org/deliver/etsi_ts/119400_119499/119475/01.01.01_60/ts_119475v010101p.pdf) and [TS 119 411-8 v1.1.1](https://www.etsi.org/deliver/etsi_ts/119400_119499/11941108/01.01.01_60/ts_11941108v010101p.pdf) <br>


### Overall schema
The following diagram shows interactions between involved actors in case that WRP interacts directly with Wallet 

````mermaid
flowchart LR
  WRP[Wallet-Relying Party] -->|1. Onboarding application| REG[Registrar]
  REG -->|2. Registration status + Annex I info| NREG[National Register / Single Common API]
  
  REG -->|3. Approval / lifecycle updates| WRP

  WRP -->|4. Request certificate issuance| ACA[Access Certificate <br> Authority]
  ACA -->|5. Issue WRPAC | WRP

  WRP -->|"6. Request registration certificate (optional)"| RCA[Registration Certificate <br> Authority]
  RCA -->|"7. Issue WRPRC (optional)" | WRP

  WRP -->|8. OID4VP / ISO 18013-5 interaction| WAL[Wallet Unit]
  WAL -->|9. Authenticate WRP using WRPAC| WAL
  WAL -->|"10. Retrieve RP registered info (optional)"| NREG
  WAL -->|11. User consent + attribute release| WRP

````

In case that a relying party is represented by an intermediary, the interaction flow is shown as followings: 

````mermaid
flowchart LR
  INT[Intermediary on behalf of WRP]
  REG[Registrar]
  NREG[National Register / Single Common API]
  ACA[Access Certificate <br> Authority]
  REGCA[Registration Certificate <br> Authority]
  WRP[Wallet-Relying Party]
  WAL[Wallet Unit]
  
  %% Onboarding & registration
  INT -->|1. Intermediary Onboarding application| REG
  REG -->|2. Intermediary registration| NREG
  
  %% Certificate issuance
  INT -->|3. Request certificate issuance| ACA
  ACA -->|4. Issue WRPAC to Intermediary| INT

  %% Contractual agreement
  WRP -->|5. Agree on contract| INT
  INT -->|6. RP onboarding application| REG
  REG -->|7. RP registration| NREG

  INT -->|"8. Request Registration Certificate (optional)"| REGCA
  REGCA -->|"9. Issue WRPRC for WRP (optional)"| INT
  
  %% Wallet interaction
  INT -->|10. OID4VP / ISO 18013-5 interaction| WAL
  WAL -->|11. Authenticate presenting entity via WRPAC| WAL
  WAL -->|"12. Retrieve WRP entry + intermediary association (optional)"| NREG
  WAL -->|13. User consent + attribute release| INT



````
## Registrar governance, deployment, and maintenance
### Deployment and operational responsibility
To ensure the reliability of register over time, policies and controls must exist and enforceable:

**REQ-RG-1** — Each Member State SHALL designate one or more Registrar(s) for WRPs established in its territory.

**REQ-RG-2** — The Registrar SHALL operate, maintain, and secure the National Register and ensure that registration information is:
accurate and up to date, maintained across the full WRP lifecycle (registration, changes, suspension, cancellation), 
retained for audit/monitoring needs.

**REQ-RG-3** — The Registrar SHALL define a registration policy (including verification rules for entitlements and intermediaries) and a suspension/cancellation policy.

### Publication and availability requirements
A set of requirements MUST be set out to ensure the publication and high availability of register.
**REQ-RG-4** — Registration information SHALL be made available through:

- a national website and
- a single common REST API.

**REQ-RG-5** — The common REST API SHALL: be a REST API supporting JSON, return information in signed/sealed JSON statements, be published as OpenAPI v3, with documentation ensuring EU-wide interoperability.

**REQ-RG-6** — The API SHALL allow access without prior authentication, to search and retrieve full lists with partial matches based on defined query parameters (see II.2).

**REQ-RG-7** — The API and register services SHALL implement security-by-design / security-by-default protections for integrity and availability (anti-tamper, DoS resilience, monitoring).

### Discoverability for cross-border interoperability

**REC-RG-8** — Member States SHOULD publish Registrar/Register endpoints as part of EU “trusted entity” discovery mechanisms (e.g., EU lists of trusted entities) to support cross-border wallets and verifiers.

## Relying Party Onboarding with Registrar
### WRP registration (onboarding process)

**REQ-ONB-1** — The Registrar SHALL define a formal WRP onboarding process:

**1. Electronic (and automated where possible) registration**

The Registrar SHALL establish easy-to-use electronic, and where possible automated, registration processes for Wallet-Relying Parties

| Phase               | Goal                                                     | Typical implementation artefacts                                     |
|---------------------|----------------------------------------------------------|-----------------------------------------------------------------------|
| Intake              | Receive application electronically                       | Web portal / eForm / API endpoint                                     |
| Automated checks    | Perform Article 6(3) automated verifications where possible | Registry lookups, automation rules                   |
| Evidence validation | Validate supporting documents / authentic sources        | Business register query, mandate/power-of-attorney verification       |
| Decision            | Approve or reject (Article 6(6))                          | Decision record, audit log                                            |
| Publication         | Update national website + single common API               | Signed/sealed JSON statements + OpenAPI v3 publication                |

**2. Legal entity information**

The Registrar SHALL collect and maintain at least the information listed in CIR 2025/848 Annex I in [1], including (non-exhaustive summary):

| #   | Annex I item                                                                  | Data element (suggested JSON key)       | Published via Register API?* |
|-----|-------------------------------------------------------------------------------|-----------------------------------------|------------------------------|
| 1   | Legal name + official record identification                                   | `legalName`, `officialRecord`           | YES                          |
| 2   | User-friendly name (trade/service name)                                       | `displayName`                           | YES                          |
| 3   | One or more identifiers (EORI, BRN, LEI, VAT, tax, EUID, etc.)                 | `identifiers[]`                         | YES                          |
| 4   | Establishment address                                                         | `establishmentAddress`                  | YES                          |
| 5   | URL belonging to WRP                                                          | `websiteUrl`                            | YES                          |
| 6   | Country prefix rule for some identifiers (ISO 3166-1 alpha-2, EL for Greece) | validation rule                         | YES (as semantics)           |
| 7   | Contact info (website / phone / email)                                        | `contact`                               | NO (excluded in API)         |
| 8   | Description of service type                                                   | `serviceDescription`                    | YES                          |
| 9   | For each intended use: requested data list (machine-readable)                 | `intendedUses[].requestedData[]`        | YES                          |
| 10  | For each intended use: purpose description                                    | `intendedUses[].purpose`                | YES                          |
| 11  | Public sector body indicator                                                  | `isPublicSectorBody`                    | YES                          |
| 12  | Entitlements (enumerated values)                                              | `entitlements[]`                        | YES                          |
| 13  | Optional sub-entitlements for Non_Q_EAA_Provider                               | `subEntitlements[]`                     | YES                          |
| 14  | Intermediary reliance indication                                              | `usesIntermediary`                      | YES                          |
| 15  | Association to intermediary                                                   | `intermediaryAssociation`               | YES                          |



### Entitlement verification sources

**REQ-ONB-2** — The Registrar SHALL verify entitlements using appropriate documentary evidence sources, including:
- national Trusted Lists (for QTSP-related entitlements), 
- EU-level lists published by the Commission for PID providers / Pub-EAA providers where relevant, 
- additional Member State procedures for non-qualified providers not listed.

### Privacy policy requirement

**REQ-ONB-3** — The Registrar SHALL require WRPs to provide a URL to the privacy policy for the intended use (and ensure it is represented where WRPRCs are used)

## National Register API requirements

**1. Query and search behavior**

**REQ-API-1** — The common API SHALL allow any requestor, without prior authentication, to:
- search the register, 
- request complete lists, 
- support partial matches based on parameters including (at least):
  - official/business registration number, 
  - WRP name, 
  - privacy policy URI and entitlement/intermediary fields (where applicable).
  
 
**2. Returned objects (“signed statements”)**

**REQ-API-2** — API responses returning one or more matches SHALL include one or more signed/sealed statements containing:
- Annex I in [1] registration information, 
- current and historic WRPACs and (if applicable) WRPRCs, 
- excluding the contact information as required by the CIR API constraints.

**3. Signature/seal format**

**REQ-API-3** — Register statements SHALL be:

- JSON files, 
- electronically signed or sealed by/on behalf of the Registrar, 
- using JWS (RFC 7515).


## Registrar interactions with ecosystem actors
### Access certificates (WRPAC)

**REQ-CERT-1** — Providers of WRPACs SHALL verify at issuance time that: the WRP is included with a valid status in the national register, certificate contents match register information.

**REQ-CERT-2** — Providers of WRPACs SHALL:

- continuously monitor changes in the register,
- revoke WRPACs when register changes require it (esp. suspension/cancellation), 
- publish revocation info within required time constraints.

**REQ-CERT-3** — WRPAC policies/practice statements should follow the harmonisation approach and ETSI policy guidance applicable to WRPACs.

### Registration certificates (WRPRC) – optional but strongly useful

**REQ-CERT-4** — If Member States implement WRPRCs, these certificates SHALL be:

- syntactically and semantically harmonised, 
- aligned with CIR requirements and corresponding ETSI data models for RP attributes / user authorization.


### Suspension and cancellation lifecycle

**REQ-LC-1** — The Registrar SHALL suspend or cancel a registration:
- if requested by a competent supervisory body, or 
- if requested by the WRP itself.

**REQ-LC-2** — The Registrar MAY suspend or cancel registration if it believes:
- registration info is inaccurate/outdated/misleading, 
- the WRP is not compliant with registration policy, 
- the WRP requests more attributes than registered, 
- the WRP breaches EU/national law in relation to its WRP role.

**REQ-LC-3** — The Registrar SHALL perform a proportionality assessment before suspension/cancellation (impact vs disruption/costs).

**REQ-LC-4** — Within 24h of suspension/cancellation, the Registrar SHALL notify:
- the WRP,
- the provider(s) of WRPACs, 
- the provider(s) of WRPRCs (if applicable), 
- including reason and redress/appeal mechanisms

**REQ-LC-5** — Certificate providers SHALL revoke affected certificates without undue delay after notification.

## Record keeping, auditability, and compliance

### Record keeping

**REQ-AUD-1** — The Registrar SHALL keep records for 10 years of:
- initial registration information (Annex I in [1]), 
- subsequent changes, 
- data used for issuance of WRPACs/WRPRCs.
  
### Data protection

**REQ-GDPR-1** — Personal data processing performed by the Registrar and register services SHALL comply with GDPR and related EU data protection rules.

## Attestation Verification Workflow

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
