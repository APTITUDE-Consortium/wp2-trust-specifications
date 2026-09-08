# Implementation Profiles for the Trust Framework

Version 1.1

| Version   | Date          | Description       |
| --------- | ------------- | ----------------- |
| 0.1       | 2026-04-19    | First release     |
| 0.2       | 2026-06-08    | New section on Trust Management Process; editorial changes |
| 1.0       | 2026-07-27    | Added Onboarding Process and Trust Checks sections; expanded Trust Artifacts with Trust Anchor and Entity Sign/Seal Certificates subsections; integrated Register API OAS; structural and editorial changes |
| 1.1       |               |  |

**Authors**:

- Pasquale Cerqua, *Istituto Poligrafico e Zecca dello Stato S.p.A.*
- Gianmario Cortese, *Namirial S.p.A.*
- Henry Faure-Geors, *Keynectis*
- Francesco Antonio Marino, *Istituto Poligrafico e Zecca dello Stato S.p.A.*
- Andrea Moro, *Fondazione Bruno Kessler*
- Marco Pernpruner, *Fondazione Bruno Kessler*
- Nuno Ponte, *Multicert*
- Andreea Prian, *iDAKTO*
- Leone Riello, *Infocert S.p.A.*
- Giada Sciarretta, *Fondazione Bruno Kessler*
- Michal Šťava, *ARICOMA Digital S.R.O*
- Nikolaos Triantafyllou, *University of the Aegean*
- Hoang Van Hoan, *Keynectis*
- Maroš Zelenák, *ARICOMA Digital S.R.O*

**Reviewers**:

- Dominik František Bučík, *ARICOMA Digital S.R.O*
- Filippos Feizidis, *GRNET*
- George Fourtounis, *GRNET*
- Byron Georgantopoulos, *GRNET*
- Guillaume Hébert, *Keynectis*
- Angel Palomares Perez, *Bull*
- Leonardo Pio Palumbo, *Istituto Poligrafico e Zecca dello Stato S.p.A.*

**Feedback**:

- Issue tracking system: <https://github.com/APTITUDE-Consortium/wp2-trust-specifications/issues>

---

## Introduction

This document specifies implementation profiles for the Trust Framework's core conceptual and architectural components, as deployed within the APTITUDE Large Scale Pilot. It defines the trust architecture, the trust artifacts exchanged among entities, and the evaluation processes and trust checks to be performed during issuance and presentation flows. Except where explicitly noted, these profiles conform to the EUDI Wallet Architecture Reference Framework (ARF) and its associated Technical Specifications, the applicable ETSI standards, and the additional standards listed in the [References](sections/references.md) section, as adapted for the APTITUDE context.

---

## Scope and Structure

The *Implementation Profiles for the Trust Framework* is intended to enable Partners to prove their identity and authorization, and to verify the authenticity and integrity of Attestations exchanged within the APTITUDE ecosystem. Given the Large Scale Pilot status of the project, these profiles are derived from the requirements of the covered Use Cases, rather than prescribing an abstract, universally applicable trust architecture. Furthermore, the profiles account for the specific constraints of the piloting phase and reflect implementation choices made accordingly, as detailed in the following sections, in order to deliver a functional trust infrastructure capable of supporting the piloting Use Cases.

Given the considerations above, this specification covers the following topics:

- [**Trust Architecture**](sections/trust-architecture.md): Describes the roles and logical interaction flows within the APTITUDE ecosystem.

- [**Trust Artifacts**](sections/trust-artifacts.md): Defines the required trust objects and their conceptual roles within the APTITUDE ecosystem.

- [**Onboarding Process**](sections/onboarding-process.md): Defines the process by which entities become operational and recognizable within the APTITUDE ecosystem.

- [**Trust Evaluation**](sections/trust-evaluation-process.md): Outlines the stages of the trust-related processes and how they are applied during Issuance and Presentation.

- [**Trust Management and Lifecycle**](sections/trust-management-lifecycle.md): Defines the mechanisms for managing the status of <roles:Trusted Entity|Trusted Entities>.

- [**Trust Use Cases**](sections/use-cases.md): TBD.

### Out of Scope

This document does not prescribe internal implementation architectures or choices, deployment policies, operational policies (e.g., incident management, auditing, dispute resolution), or application-layer logic unrelated to trust. Detailed component and process specifications, service API definitions, and artifact profiles are provided in other APTITUDE tasks.

---

## Deviations from Architecture and Reference Framework

The APTITUDE ecosystem does not include actors representing Member States or the European Commission within its deployment activities. Consequently, the following operations, as regulated by [ARF], have no corresponding responsible actor within the APTITUDE ecosystem.

| #   | Operation                                                           | Responsible Actor(s) in EUDIW             |
| :-: | ------------------------------------------------------------------- | ----------------------------------------- |
| 1   | Publication of Lists of Trusted Entities and Lists of Trusted Lists | European Commission                       |
| 2   | Registration Process                                                | Member States                             |
| 3   | Notification Process                                                | European Commission and Member States     |
| 4   | Publication of Trusted Lists                                        | Member States                             |
| 5   | Management of Authentic Sources                                     | Specific Entities within Member States    |
| 6   | Publication and Management of Catalogues of Attestations            | European Commission                       |
| 7   | Management of Entity Lifecycle                                      | Supervisory Body                          |
| 8   | Certification Scheme                                                | Supervisory Body                          |
| 9   | Issuance of WRPACs, WRPRCs and Sign/Seal Certificates               | Member States                             |
| 10  | Publication of the Official Journal of the European Union (OJEU)    | European Commission                       |

To address this gap, the following implementation choices have been adopted:

| Implementation Choice in APTITUDE     | Operation(s) Addressed    |
| ------------------------------------- | :-----------------------: |
| The APTITUDE perimeter is limited to Partners officially enrolled in the Consortium. | — |
| APTITUDE WP2 exposes specific services to emulate the missing institutional roles, as specified in [Trust Architecture](sections/trust-architecture.md). | 1, 2, 3 |
| APTITUDE WP2 provides a single, simplified registration interface through which Partners self-declare their attributes and entitlements, without requiring dedicated administrative processes or certification scheme checks. | 2, 8 |
| APTITUDE WP2 aggregates registration information into a single Register used for all entities. | 2 |
| APTITUDE WP2 provides onboarding services to manage the associated operational processes (registration, notification, publication, certificate issuance). | 2, 3 |
| The PKI architecture will not include a LOTL with an associated TL; instead, it will feature a LoTE per entity type, including QEAA and EAA Providers. | 1, 4 |
| APTITUDE WP2 acts as the sole LoTE Provider; the certificate anchoring the various LoTE will be published via GitHub. | 1 |
| APTITUDE will not feature Authentic Sources. | 5 |
| APTITUDE will not feature Catalogues of Attestations. Instead, Attestation Rulebooks published on GitHub by the various WPs will be used. | 6 |
| APTITUDE will not feature active management of entity lifecycles, and will instead rely on dedicated Trust Use Cases for revocation. | 7 |

---

## Normative Language

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in BCP 14 [RFC 2119] [RFC 8174] when, and only when, they appear in all capitals, as shown here.

Additionally, the key words "CONDITIONAL" and "PROHIBITED" are used within data tables to describe field requirements. "CONDITIONAL" indicates that a field's presence is dependent on specific rules described in the text, while "PROHIBITED" is equivalent to "SHALL NOT".
