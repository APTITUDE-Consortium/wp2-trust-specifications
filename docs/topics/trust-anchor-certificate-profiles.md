# Trust Anchor Certificate Profile for the EUDIW Ecosystem (X.509)

This document defines an interoperable **X.509 certificate profile** for **entity trust anchors** used in the European Digital Identity Wallet (EUDIW) ecosystem.

A **trust anchor** is a trusted public key (and associated data) used as an input to certification path validation. In this profile, the trust anchor is represented and distributed as an **X.509 certificate**, and it is expected to be published as a service digital identity through the **List of Trusted Entities (LoTE)** / **Trusted List** infrastructure.

According to OID4VC High Assurance Interoperability Profile 1.0 (HAIP), clause 6.1:

 - Issuer’s signing certificate MUST be present in the SD-JWT x5c header (The x5c header MUST NOT be empty)
 - Trust Anchor certificate of the Issuer MUST NOT be present in the SD-JWT x5c header.

The implication of that is:

- **The Issuer's sign/seal certificate SHALL NOT be a Trust Anchor certificate.**

> **Out of scope:** End-entity “provider sign/seal certificates” issued to PID Providers, Wallet Providers, EAA/QEAA Providers, and PSBEAA Providers. Those are profiled by ETSI TS 119 412-6 and referenced ETSI EN 319 412 parts.

---

## Definitions

### Trust Anchor

A **trust anchor** is an authoritative entity represented by a public key and associated data. The public key is used to verify digital signatures, and the associated data is used to constrain the types of information or actions for which the trust anchor is authoritative.

### Entity Trust Anchor Certificate (EUDIW context)

An **Entity Trust Anchor Certificate** is an **X.509 certificate** that is explicitly trusted by policy because it is published as a trust anchor for a given entity/service in LoTE/Trusted List trust sources.

**Important:** A trust anchor certificate may be **self-signed** or **non-self-signed**. In both cases it is treated as a trust anchor if the relying party’s trust policy (here: LoTE/Trusted List-based trust source) designates it as such.

### Termination of certificate path validation

Relying parties validate a presented certificate by building a certification path that **terminates at a trust anchor**. In this ecosystem, path construction and validation **SHALL terminate** at the first certificate that matches a LoTE-listed trust anchor.

---

## References

### Normative references

- **RFC 5280**: Internet X.509 Public Key Infrastructure Certificate and Certificate Revocation List (CRL) Profile.
- **RFC 5914**: Trust Anchor Format.
- **ETSI TS 119 602**: Lists of trusted entities; Data model.
- **ETSI TS 119 612**: Trusted Lists.

### Informative references

- **Commission Implementing Regulation (EU) 2024/2980**: Notifications concerning the European Digital Identity Wallet ecosystem.

---

## Trust model assumptions for entity trust anchors

### What the trust anchor certificate is used for

The entity trust anchor certificate is **not** the certificate used to sign application payloads. Instead, it is used as the **trust termination point** for validating other certificates (typically end-entity certificates) that are used to sign/seal data.

### CA capability requirement (issuer-style trust anchor)

If the entity trust anchor certificate is used to **issue/sign other certificates** (i.e., it appears as an issuer in the validated path), then it SHALL be a **CA certificate** for X.509 path validation purposes (i.e., it SHALL signal CA capability using X.509 v3 extensions).

### Validity checking policy

Relying parties SHALL check the validity period of the trust anchor certificate and treat it as invalid if expired or not yet valid.

### Self-signed and non-self-signed trust anchors

A LoTE/Trusted List-published trust anchor certificate MAY be:

- **Self-signed** (traditional root CA style); or
- **Non-self-signed** but treated as a trust anchor by policy (a “pinned” intermediate CA certificate).

Relying parties SHALL NOT require an additional issuer chain above a LoTE-designated trust anchor, even if it is not self-signed, because the trust anchor is a trust-store input designated by policy.

---

## Trust Anchor Certificate Profile (X.509)

### Presence semantics

The column "Presence" in tables below contains the specification of the presence of the certificate parameter as follows:

- **REQUIRED**: The parameter SHALL be present.
- **REQUIRED (C)**: The parameter SHALL be present if the condition specified in the "Description" column is fulfilled.
- **OPTIONAL**: The parameter is not required and can be omitted.

The column "Criticality" of the certificate extensions uses the semantics defined in RFC 5280.

---

### Basic certificate fields

The following table lists common parameters that are mandatory for an entity trust anchor certificate.

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `version` | [RFC 5280] §4.1.2.1 | REQUIRED | *[0] EXPLICIT INTEGER* | Indicates the version of the encoded certificate. For this profile, it SHALL be v3 (2). |
| `serialNumber` | [RFC 5280] §4.1.2.2 | REQUIRED | *INTEGER* | The serial number of the certificate. |
| `signature` | [RFC 5280] §4.1.2.3 | REQUIRED | *SEQUENCE* | Identifies the signature algorithm used by the issuer to sign the certificate. |
| `issuer` | [RFC 5280] §4.1.2.4 | REQUIRED | *Name* | Identifies the entity that signed and issued the certificate. For self-signed trust anchors, the issuer SHALL be identical to the subject. |
| `validity` | [RFC 5280] §4.1.2.5 | REQUIRED | *SEQUENCE* | Time interval during which the certificate is valid (notBefore, notAfter). |
| `subject` | [RFC 5280] §4.1.2.6 | REQUIRED | *Name* | Identifies the entity associated with the public key. |
| `subjectPublicKeyInfo` | [RFC 5280] §4.1.2.7 | REQUIRED | *SEQUENCE* | Carries the public key and identifies the algorithm with which the key is used. |
| `extensions` | [RFC 5280] §4.1.2.9 | REQUIRED | *[3] EXPLICIT SEQUENCE*| A sequence of one or more certificate extensions. |

---

### Required extensions

The following table lists the extensions that are mandatory or conditional for an entity trust anchor certificate.

| Parameter | Defined in | Presence | Criticality | Format | Description |
| :-------: | :--------: | :------: | :---------: | :----- | :---------- |
| `basicConstraints` | [RFC 5280] §4.2.1.9 | REQUIRED | C | *SEQUENCE* | SHALL indicate <code>cA = TRUE</code>. The <code>pathLenConstraint</code> field: <ul><li>is OPTIONAL;</li><li>if present, SHALL limit the number of non-self-issued intermediate CA certificates below this trust anchor;</li><li>it is RECOMMENDED to set <code>pathLenConstraint = 0</code> to prevent subordinate CA layers, unless a documented operational need exists to support additional intermediate CA tiers.</li></ul> |
| `keyUsage` | [RFC 5280] §4.2.1.3 | REQUIRED | C | *BIT STRING* | SHALL include <code>keyCertSign</code>. MAY include <code>cRLSign</code> if the CA signs CRLs. |
| `subjectKeyIdentifier` | [RFC 5280] §4.2.1.2 | REQUIRED | NC | *OCTET STRING* | Provides a key identifier for the trust anchor public key, enabling reliable chain building and LoTE matching. |
| `authorityKeyIdentifier` | [RFC 5280] §4.2.1.1 | REQUIRED (C) | NC | *SEQUENCE* | REQUIRED for non-self-signed trust anchors to facilitate chain building towards the LoTE trust anchor. For self-signed certificates it is RECOMMENDED. |

#### Note: Path length constraint policy

The <code>pathLenConstraint</code> restricts the depth of certification paths below the trust anchor.

- A value of <code>0</code> means that the trust anchor MAY issue end-entity certificates but SHALL NOT allow additional non-self-issued intermediate CA certificates in the path.
- Absence of the <code>pathLenConstraint</code> implies that no explicit limit is imposed by the certificate itself.

This profile allows the field to be OPTIONAL to support interoperability with different PKI deployment models. However, setting <code>pathLenConstraint = 0</code> is RECOMMENDED to reduce trust hierarchy complexity, improve predictability of certificate chains, and limit the risk associated with unintended subordinate certification authorities.

---

### Optional (deployment-driven) extensions

The following extensions are OPTIONAL because their necessity depends on the revocation/status model used in a given deployment.

| Parameter | Defined in | Presence | Criticality | Format | Description |
| :-------: | :--------: | :------: | :---------: | :----- | :---------- |
| `authorityInfoAccess (AIA)` | [RFC 5280] §4.2.2.1 | OPTIONAL | NC | *SEQUENCE* | MAY include <code>id-ad-caIssuers</code> and/or <code>id-ad-ocsp</code> access locations. |
| `cRLDistributionPoints` | [RFC 5280] §4.2.1.13 | OPTIONAL | NC | *SEQUENCE* | MAY include CRL distribution point URIs when CRL-based revocation is used. |
| `certificatePolicies` | [RFC 5280] §4.2.1.4 | OPTIONAL | NC | *SEQUENCE* | MAY be used to signal policy OIDs relevant to the issuing CA’s practices. |

---

## Examples (pseudo-structure)

> The following examples are illustrative. They focus on the profile-relevant fields and extensions.

### Example A — Self-signed entity trust anchor (root-style)

```text
AccessCertificate trustAnchor = {
  tbsCertificate: {
    version: 2,  // v3
    serialNumber: "0x01A2B3C4...",
    signature: AlgorithmIdentifier { oid: "1.2.840.113549.1.1.11", params: NULL },

    issuer:  DistinguishedName {
      countryName: "CZ",
      organizationName: "Example Entity Trust Anchor CA",
      commonName: "Example Entity Trust Anchor Root"
    },

    validity: {
      notBefore: "2026-01-01T00:00:00Z",
      notAfter:  "2031-01-01T00:00:00Z"
    },

    subject: DistinguishedName {
      countryName: "CZ",
      organizationName: "Example Entity Trust Anchor CA",
      commonName: "Example Entity Trust Anchor Root"
    },

    subjectPublicKeyInfo: {
      algorithm: AlgorithmIdentifier { oid: "1.2.840.113549.1.1.1", params: NULL },
      subjectPublicKey: "BASE64(SPKI_PUBLIC_KEY_BYTES)"
    },

    extensions: [
      Extension {
        oid: "2.5.29.19", // basicConstraints
        critical: true,
        value: BasicConstraints { cA: true, pathLenConstraint: 0 }
      },
      Extension {
        oid: "2.5.29.15", // keyUsage
        critical: true,
        value: KeyUsage { keyCertSign: true, cRLSign: true }
      },
      Extension {
        oid: "2.5.29.14", // subjectKeyIdentifier
        critical: false,
        value: SubjectKeyIdentifier { keyIdentifier: "SHA-1(SUBJECT_PUBLIC_KEY_VALUE)" }
      },
      Extension {
        oid: "2.5.29.35", // authorityKeyIdentifier
        critical: false,
        value: AuthorityKeyIdentifier { keyIdentifier: "SHA-1(SUBJECT_PUBLIC_KEY_VALUE)" }
      }
    ]
  }
}
```

### Example B — Non-self-signed entity trust anchor (pinned intermediate CA)

```text
AccessCertificate trustAnchor = {
  tbsCertificate: {
    version: 2,  // v3
    serialNumber: "0x0F0E0D0C...",
    signature: AlgorithmIdentifier { oid: "1.2.840.113549.1.1.11", params: NULL },

    issuer: DistinguishedName {
      countryName: "CZ",
      organizationName: "Example Superior CA",
      commonName: "Example Superior CA"
    },

    validity: {
      notBefore: "2026-01-01T00:00:00Z",
      notAfter:  "2029-01-01T00:00:00Z"
    },

    subject: DistinguishedName {
      countryName: "CZ",
      organizationName: "Example Entity Trust Anchor CA",
      commonName: "Example Entity Trust Anchor (Pinned Intermediate)"
    },

    subjectPublicKeyInfo: {
      algorithm: AlgorithmIdentifier { oid: "1.2.840.113549.1.1.1", params: NULL },
      subjectPublicKey: "BASE64(SPKI_PUBLIC_KEY_BYTES)"
    },

    extensions: [
      Extension {
        oid: "2.5.29.19", // basicConstraints
        critical: true,
        value: BasicConstraints { cA: true, pathLenConstraint: 0 }
      },
      Extension {
        oid: "2.5.29.15", // keyUsage
        critical: true,
        value: KeyUsage { keyCertSign: true }
      },
      Extension {
        oid: "2.5.29.14", // subjectKeyIdentifier
        critical: false,
        value: SubjectKeyIdentifier { keyIdentifier: "SHA-1(SUBJECT_PUBLIC_KEY_VALUE)" }
      },
      Extension {
        oid: "2.5.29.35", // authorityKeyIdentifier
        critical: false,
        value: AuthorityKeyIdentifier { keyIdentifier: "HEX(KEYID_OF_SUPERIOR_CA_PUBLIC_KEY)" }
      },
      Extension {
        oid: "1.3.6.1.5.5.7.1.1", // authorityInfoAccess
        critical: false,
        value: AuthorityInfoAccess [
          AccessDescription {
            accessMethod: "1.3.6.1.5.5.7.48.2", // id-ad-caIssuers
            accessLocation: URI("https://ca.example.test/caIssuers/superior-ca.cer")
          }
        ]
      }
    ]
  }
}
```
