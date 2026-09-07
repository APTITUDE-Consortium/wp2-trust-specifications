# Implementation Profiles for the Trust Framework

Version 1.0

| Version | Date       | Description   |
| ------- | ---------- | ------------- |
| 0.1     | 2026-04-19 | First release |
| 0.2     | 2026-06-08 | New section on Trust Management Process; editorial changes |
| 1.0     | 2026-07-27 | Added Onboarding Process and Trust Checks sections; expanded Trust Artifacts with Trust Anchor and Entity Sign/Seal Certificates subsections; integrated Register API OAS; structural and editorial changes |

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
- Michal Šťava, *ARICOMA Digital S.R.O*

**Feedback**:

- Issue tracking system: <https://github.com/APTITUDE-Consortium/wp2-trust-specifications/issues>

## Introduction

This specification, *Implementation Profiles for the Trust Framework*, defines the conceptual and architectural requirements for ensuring trust in the APTITUDE piloted environments. At this stage, the specification focuses on articulating the necessary trust architecture, defining the essential trust artifacts, and outlining the high-level evaluation processes. By setting these principles, this document serves as a shared reference to guide subsequent development, ensuring that all implementation efforts remain aligned with the project's objectives for security, privacy, and interoperability.

---

## Scope

This specification defines the trust framework profiles for the APTITUDE Large Scale Pilot. Its scope is limited to establishing the essential mechanisms for trust in interactions between <components:Wallet Unit|Wallet Units> and <roles:Wallet-Relying Party (WRP)|Wallet-Relying Parties>. The scope of this document is organized as follows:

- [**Trust Architecture**](sections/trust-architecture.md): Describes the roles and logical interaction flows within the APTITUDE pilot ecosystem.

- [**Trust Artifacts**](sections/trust-artifacts.md): Defines the required trust objects and their conceptual roles in the ecosystem, including <components:Register|Registers>, <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|Wallet-Relying Party Access Certificates (WRPAC)> and <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|Wallet-Relying Party Registration Certificates (WRPRC)>, and the management of <artifacts:Trusted List (TL)|Trusted Lists (TLs)>, <artifacts:List of Trusted Entities (LoTE)|Lists of Trusted Entities (LoTE)> and <artifacts:Embedded Disclosure Policy (EDP)|Embedded Disclosure Policies (EDPs)>.

- [**Onboarding Process**](sections/onboarding-process.md): Defines the process through which entities become operational and recognisable in the common trust infrastructure. Within the APTITUDE LSP, it is realised as a mocked-up version of the <roles:Wallet-Relying Party (WRP)|Wallet-Relying Party> Registration and <processes:Notification> processes.

- [**Trust Evaluation Processes**](sections/trust-evaluation-process.md): Outlines the necessary stages for the Authentication Process, the Authorization Process, and the Sign/Seal Validation Process, together with <artifacts:Trust Anchor> validation.

- [**Trust Checks**](sections/trust-checks.md): Describes the trust-related checks to be performed during Issuance and Presentation.

- [**Trust Management and Lifecycle**](sections/trust-management-lifecycle.md): Defines the mechanisms for managing the status of <roles:Trusted Entity|Trusted Entities>, with a current focus on revocation procedures.

### Out of Scope

These specifications does not provide details on:

- **Low-level Implementation**: These will be addressed in task T2.3.

- **Registration, Notification, and Publication Processes**: The administrative and regulatory processes governing the Registration, <processes:Notification>, and Publication of <roles:Trusted Entity|Trust Entities> between Member States and the European Commission are excluded from this scope. However, the corresponding processes to be implemented in APTITUDE for piloting purposes are described in [**Onboarding Process**](sections/onboarding-process.md).

---

## Normative Language

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in BCP 14 [RFC 2119] [RFC 8174] when, and only when, they appear in all capitals, as shown here.

Additionally, the key words "CONDITIONAL" and "PROHIBITED" are used within data tables to describe field requirements. "CONDITIONAL" indicates that a field's presence is dependent on specific rules described in the text, while "PROHIBITED" is equivalent to "SHALL NOT".
