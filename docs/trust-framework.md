# Implementation Profiles for the Trust Framework

Version 0.1 (Draft)

| Version | Date       | Description   |
| ------- | ---------- | ------------- |
| 0.1     | 2026-04-19 | First release |

**Authors**:

- Gianmario Cortese, *Namirial S.p.A.*
- Henry Faure-Geors, *Keynectis*
- Francesco Antonio Marino, *Istituto Poligrafico e Zecca dello Stato S.p.A.*
- Andrea Moro, *Fondazione Bruno Kessler*
- Marco Pernpruner, *Fondazione Bruno Kessler*
- Nuno Ponte, *Multicert*
- Andreea Prian, *iDAKTO*
- Giada Sciarretta, *Fondazione Bruno Kessler*
- Hoang Van Hoan, *Keynectis*
- Maroš Zelenák, *ARICOMA Digital S.R.O*

**Reviewers**:

- Dominik František Bučík, *ARICOMA Digital S.R.O*
- Guillaume Hébert, *Keynectis*
- Angel Palomares Perez, *Atos IT Solutions*
- Leonardo Pio Palumbo, *Istituto Poligrafico e Zecca dello Stato S.p.A.*
- Leone Riello, *Infocert S.p.A.*
- Michal Šťava, *ARICOMA Digital S.R.O*
- Nikolaos Triantafyllou, *University of the Aegean*

**Feedback**:

- Issue tracking system: <https://github.com/APTITUDE-Consortium/wp2-trust-specifications/issues>

## 1. Introduction

This specification, *Implementation Profiles for the Trust Framework*, defines the conceptual and architectural requirements for ensuring trust in the APTITUDE piloted environments. At this stage, the specification focuses on articulating the necessary trust architecture, defining the essential trust artifacts, and outlining the high-level evaluation processes. By setting these principles, this document serves as a shared reference to guide subsequent development, ensuring that all implementation efforts remain aligned with the project's objectives for security, privacy, and interoperability.

---

## 2. Scope

This specification defines the trust framework profiles for the APTITUDE Large Scale Pilot. Its scope is limited to establishing the essential mechanisms for trust in interactions between <components:Wallet Unit|Wallet Units> and <roles:Wallet-Relying Party (WRP)|Wallet-Relying Parties>. The scope of this document is organized as follows:

- [**Trust Architecture**](#4-trust-architecture): Description of the roles and logical interaction flows within the APTITUDE pilot ecosystem.

- [**Trust Artifacts**](#5-trust-artifacts): Definition of the required trust objects and their conceptual roles in the ecosystem, including <components:Register|Registers>, <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|Wallet-Relying Party Access Certificates (WRPAC)> and <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|Wallet-Relying Party Registration Certificates (WRPRC)>, and the management of <artifacts:Trusted List (TL)|Trusted Lists (TLs)>, <artifacts:List of Trusted Entities (LoTE)|Lists of Trusted Entities (LoTE)> and <artifacts:Embedded Disclosure Policy (EDP)|Embedded Disclosure Policies (EDPs)>.

- [**Trust Evaluation Processes**](#6-trust-evaluation-process): Outlining the necessary stages for trust anchor validation, authentication and authorization processes.

- [**Trust Management and Lifecycle**](#7-trust-management-and-lifecycle): Defines the mechanisms for managing the status of <roles:Trusted Entity|Trusted Entities>, with a current focus on revocation procedures.

### Out of Scope

The current version of these specifications does not provide details on:

- **Low-level Implementation**: These will be covered in subsequent versions of the specifications.

- **Trust Management Process**: While this document defines revocation mechanisms, the broader Trust Management Process (covering full lifecycle management) is currently missing and will be addressed in future versions.

- **Registration, Notification, and Publication Processes**: The administrative and regulatory processes governing the registration, notification, and publication of <roles:Trusted Entity|Trust Entities> between Member States and the European Commission are excluded from this scope.

---

## 3. Normative Language

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in BCP 14 [RFC2119] [RFC8174] when, and only when, they appear in all capitals, as shown here.

---

## 4. Trust Architecture

{% include-markdown "./topics/trust-architecture.md" %}

---

## 5. Trust Artifacts

### Register

{% include-markdown "./topics/registry.md" %}

### Wallet-Relying Party Access Certificate

{% include-markdown "./topics/access-certificate.md" %}

### Wallet-Relying Party Registration Certificate

{% include-markdown "./topics/registration-certificate.md" %}

### List of Trusted Entities and List of Trusted Lists

{% include-markdown "./topics/trusted-list-and-list-of-trusted-lists.md" %}

### Embedded Disclosure Policy

{% include-markdown "./topics/embedded-disclosure-policy.md" %}

---

## 6. Trust Evaluation Process

{% include-markdown "./topics/trust-evaluation.md" %}

### Trust Anchor Validation Process

{% include-markdown "./topics/trust-anchor-validation.md" %}

### Authentication Process

{% include-markdown "./topics/authentication-process.md" %}

### Authorization Process

{% include-markdown "./topics/authorization-process.md" %}

---

## 7. Trust Management and Lifecycle

### Revocation Mechanisms

{% include-markdown "./topics/revocation-mechanisms.md" %}

---

## References

{% include-markdown "./references.md" %}
