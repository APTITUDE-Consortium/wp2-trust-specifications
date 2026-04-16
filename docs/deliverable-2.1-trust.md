# Implementation Profiles for the Trust Framework

Version 0.1 (Draft)

| Version | Date       | Description |
| ------- | ---------- | ----------- |
| 0.1     | 2026-04-XX | First release |

## Authors

- Gianmario Cortese, Namirial S.p.A.
- Henry Faure-Geors, Keynectis
- Francesco Antonio Marino, Istituto Poligrafico e Zecca dello Stato S.p.A.
- Andrea Moro, Fondazione Bruno Kessler
- Marco Pernpruner, Fondazione Bruno Kessler
- Nuno Ponte, Multicert
- Andreea Prian, IDAKTO
- Giada Sciarretta, Fondazione Bruno Kessler
- Hoang Van Hoan, Keynectis
- Maroš Zelenák, ARICOMA Digital S.R.O

## Reviewers

- Dominik František Bučík, ARICOMA Digital S.R.O
- Guillaume Hébert, Keynectis
- Angel Palomares Perez, Atos IT Solutions
- Leonardo Pio Palumbo, Istituto Poligrafico e Zecca dello Stato S.p.A.
- Leone Riello, Infocert S.p.A.
- Michal Šťava, ARICOMA Digital S.R.O
- Nikolaos Triantafyllou, University of the Aegean

## Table of Contents

- [1. Introduction](#1-introduction)
- [2. Scope](#2-scope)
  - [Out of Scope](#out-of-scope)
- [3. Normative Language](#3-normative-language)
- [4. Trust Architecture](#4-trust-architecture)
- [5. Trust Artifacts](#5-trust-artifacts)
  - [Register](#register)
  - [Wallet-Relying Party Access Certificate](#wallet-relying-party-access-certificate)
  - [Wallet-Relying Party Registration Certificate](#wallet-relying-party-registration-certificate)
  - [List of Trusted Entities and List of Trusted Lists](#list-of-trusted-entities-and-list-of-trusted-lists)
  - [Embedded Disclosure Policy](#embedded-disclosure-policy)
- [6. Trust Evaluation Process](#6-trust-evaluation-process)
  - [Trust Anchor Validation Process](#trust-anchor-validation-process)
  - [Authentication Process](#authentication-process)
  - [Authorization Process](#authorization-process)
- [7. Trust Management and Lifecycle](#7-trust-management-and-lifecycle)
  - [Revocation Mechanisms](#revocation-mechanisms)
- [8. References](#8-references)

## 1. Introduction

*TBD*

---

## 2. Scope

*TBD*

### Out of Scope

*TBD*

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

---

## 7. Trust Management and Lifecycle

### Revocation Mechanisms

{% include-markdown "./topics/revocation-mechanisms.md" %}

---

## 8. References
