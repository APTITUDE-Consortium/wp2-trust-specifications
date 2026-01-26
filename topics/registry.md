# Registry
This document specifies requirements for the **Registrar of Wallet-Relying Parties (WRPs)** and the National Register of WRPs (the registry service) in the context of eIDAS2 and the EUDI Wallet ecosystem.
## Registrar & National Register of Wallet-Relying Parties (WRPs)
**1. Scope and objective** 

Formally, a **Registrar** is the designated body that:
- manages the WRP registration lifecycle (onboarding, update, suspension, cancellation),
- ensures the integrity and publication of registration information,
- ensures interoperability by exposing WRP registration data via a national website and a single common REST API.

The **National Register of WRPs** is the publicly accessible system (dataset + API) that provides signed/sealed registration statements about WRPs and their authorisations/declared usage.

>Note (non-normative): The **National Register of Wallet-Relying Parties** is a single logical register. For scalability and resilience, a Member State MAY deploy multiple technical instances provided they expose a **single coherent common REST API** and return **signed statements** as required.<br>
>In addition, the issuance of WRPAC is based on whether the Relying Party has been registered with an active status in the National Register. This would prevent having **sectorial register** much less interest.

**2. Terms and Roles**

- **Registrar of WRPs**: body designated by a Member State to establish and maintain the list of registered WRPs.
- **Register (National Register of WRPs)**: the service exposing information about registered WRPs through a national website and a common REST API.
- **WRP**: a relying party that intends to rely upon Wallet Units to provide services via digital interaction.
- **WRPAC**: Wallet-Relying Party Access Certificate, which is used for authentication towards wallets.
- **WRPRC**: Wallet-Relying Party Registration Certificate, which is optional, and is used to express intended use + registered data requests.
- **Intermediary**: an entity acting on behalf of a WRP in wallet interactions (where applicable).

**Normative basis**: [Commission Implementing Regulation (EU) 2025/848](https://eur-lex.europa.eu/legal-content/EN/TXT/PDF/?uri=OJ%3AL_202500848) <br>
**Architecture basis**: [EUDI Wallet ARF (Relying Party registration + authentication mechanisms)](https://eudi.dev/2.7.3/architecture-and-reference-framework-main/) <br>
**Standardization basis**: [ETSI TS 119 475 v1.1.1](https://www.etsi.org/deliver/etsi_ts/119400_119499/119475/01.01.01_60/ts_119475v010101p.pdf) and [TS 119 411-8 v1.1.1](https://www.etsi.org/deliver/etsi_ts/119400_119499/11941108/01.01.01_60/ts_11941108v010101p.pdf) <br>


## Registrar governance, deployment, and maintenance
**1. Deployment and operational responsibility**

**REQ-RG-1** — Each Member State SHALL designate one or more Registrar(s) for WRPs established in its territory.

**REQ-RG-2** — The Registrar SHALL operate, maintain, and secure the National Register and ensure that registration information is:
accurate and up to date, maintained across the full WRP lifecycle (registration, changes, suspension, cancellation), 
retained for audit/monitoring needs.

**REQ-RG-3** — The Registrar SHALL define a registration policy (including verification rules for entitlements and intermediaries) and a suspension/cancellation policy.

**2. Publication and availability requirements**

**REQ-RG-4** — Registration information SHALL be made available through:

- a national website and
- a single common REST API.

**REQ-RG-5** — The common REST API SHALL: be a REST API supporting JSON, return information in signed/sealed JSON statements, be published as OpenAPI v3, with documentation ensuring EU-wide interoperability.

**REQ-RG-6** — The API SHALL allow access without prior authentication, to search and retrieve full lists with partial matches based on defined query parameters (see II.2).

**REQ-RG-7** — The API and register services SHALL implement security-by-design / security-by-default protections for integrity and availability (anti-tamper, DoS resilience, monitoring).

**3. Discoverability (recommended for cross-border interoperability)**

**REC-RG-8** — Member States SHOULD publish Registrar/Register endpoints as part of EU “trusted entity” discovery mechanisms (e.g., EU lists of trusted entities) to support cross-border wallets and verifiers.

## Relying Party Onboarding
**1. WRP registration (onboarding process)**

**REQ-ONB-1** — The Registrar SHALL define a formal WRP onboarding process, including: 
- intake (portal/API),
- legal entity identification,
- verification of declared entitlements, 
- validation of the “intended use” and requested data list,
- assignment of a registration identifier, 
- lifecycle management (update/suspension/cancellation)

**2. Legal entity information (minimum dataset)**

The Registrar SHALL collect and maintain at least the information listed in CIR 2025/848 Annex I, including (non-exhaustive summary):

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



**3. Entitlement verification sources**

**REQ-ONB-2** — The Registrar SHALL verify entitlements using appropriate documentary evidence sources, including:
- national Trusted Lists (for QTSP-related entitlements), 
- EU-level lists published by the Commission for PID providers / Pub-EAA providers where relevant, 
- additional Member State procedures for non-qualified providers not listed.

**4. Privacy policy requirement**

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
- Annex I registration information, 
- current and historic WRPACs and (if applicable) WRPRCs, 
- excluding the contact information as required by the CIR API constraints.

**3. Signature/seal format**

**REQ-API-3** — Register statements SHALL be:

- JSON files, 
- electronically signed or sealed by/on behalf of the Registrar, 
- using JWS (RFC 7515).


## Registrar interactions with ecosystem actors
**1. Access certificates (WRPAC)**

**REQ-CERT-1** — Providers of WRPACs SHALL verify at issuance time that: the WRP is included with a valid status in the national register, certificate contents match register information.

**REQ-CERT-2** — Providers of WRPACs SHALL:

- continuously monitor changes in the register,
- revoke WRPACs when register changes require it (esp. suspension/cancellation), 
- publish revocation info within required time constraints.

**REQ-CERT-3** — WRPAC policies/practice statements should follow the harmonisation approach and ETSI policy guidance applicable to WRPACs.

**2 Registration certificates (WRPRC) – optional but strongly useful**

**REQ-CERT-4** — If Member States implement WRPRCs, these certificates SHALL be:

- syntactically and semantically harmonised, 
- aligned with CIR requirements and corresponding ETSI data models for RP attributes / user authorization.


**4. Suspension and cancellation lifecycle**

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

**1. Record keeping**

**REQ-AUD-1** — The Registrar SHALL keep records for 10 years of:
- initial registration information (Annex I), 
- subsequent changes, 
- data used for issuance of WRPACs/WRPRCs.
  
**2. Data protection**

**REQ-GDPR-1** — Personal data processing performed by the Registrar and register services SHALL comply with GDPR and related EU data protection rules.




````mermaid
flowchart LR
  WRP[Wallet-Relying Party] -->|Onboarding application| REG[Registrar]
  REG -->|Registration status + Annex I info| NREG[National Register / Single Common API]
  REG -->|Approval / lifecycle updates| WRP

  WRP -->|Request certificate issuance| ACA[Access CA]
  ACA -->|Issue WRPAC | WRP

  WRP -->|OID4VP / ISO 18013-5 interaction| WAL[Wallet Unit]
  WAL -->|Authenticate WRP using WRPAC| WRP
  WAL -->|Optional: retrieve registered info| NREG
  WAL -->|User consent + attribute release| WRP

  REGCA[Registration CA ] -->|Issue WRPRC| WRP
  WRP -->|Provide WRPRC in request | WAL
````