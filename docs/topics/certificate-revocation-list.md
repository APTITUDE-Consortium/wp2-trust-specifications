A <artifacts:Certificate Revocation List (CRL)> is a time-stamped list identifying revoked certificates that is signed by a CA or CRL issuer and made freely available in a public repository. <artifacts:Certificate Revocation List (CRL)|CRLs> MAY be used in a wide range of applications and environments covering a broad spectrum of interoperability goals and an even broader spectrum of operational and assurance requirements.

CAs publish <artifacts:Certificate Revocation List (CRL)|CRLs> to provide status information about the certificates they issued. Each <artifacts:Certificate Revocation List (CRL)|CRL> has a particular scope. The <artifacts:Certificate Revocation List (CRL)|CRL> scope is the set of certificates that could appear on a given <artifacts:Certificate Revocation List (CRL)|CRL>. For example, the scope could be "all certificates issued by CA X". A complete <artifacts:Certificate Revocation List (CRL)|CRL> lists all unexpired certificates, within its scope, that have been revoked for one of the revocation reasons covered by the <artifacts:Certificate Revocation List (CRL)|CRL> scope.

The <artifacts:Certificate Revocation List (CRL)|CRL> issuer MAY also generate delta <artifacts:Certificate Revocation List (CRL)|CRLs>. A delta CRL only lists those certificates, within its scope, whose revocation status has changed since the issuance of a referenced complete <artifacts:Certificate Revocation List (CRL)|CRL>. The referenced complete CRL is referred to as a base <artifacts:Certificate Revocation List (CRL)|CRL>. The scope of a delta <artifacts:Certificate Revocation List (CRL)|CRL> SHALL be the same as the base <artifacts:Certificate Revocation List (CRL)|CRL> that it references.

If supported by the <roles:Certificate Authority (CA)|CA>, the <artifacts:Certificate Revocation List (CRL)|CRL> SHALL be available at the URI specified in the `cRLDistributionPoints.distributionPoint` *[0] CHOICE* structure within the [WRPAC](#wallet-relying-party-access-certificate).

In accordance with [RFC 5280, Section 5], the `CertificateList` ASN.1 structure consists of a `SEQUENCE` composed of the following fields:

| Field                       | Type            | Presence      | Description | Reference in [RFC 5280] |
| --------------------------- | :-------------: | :-----------: |------------ | ----------------------- |
| `tbsCertList`               | `SEQUENCE`      | REQUIRED      | Contains the core <artifacts:Certificate Revocation List (CRL)\|CRL> information, including the name of the issuer, issue date, next update date, the optional list of revoked certificates, and optional <artifacts:Certificate Revocation List (CRL)\|CRL> extensions. | Section 5.1.1.1 |
| `signatureAlgorithm`        | `SEQUENCE`      | REQUIRED      | Contains the identifier for the cryptographic algorithm used by the <artifacts:Certificate Revocation List (CRL)\|CRL> issuer to sign the CRL. | Section 5.1.1.2 |
| `signatureValue`            | `BIT STRING`    | REQUIRED      | Contains a digital signature computed upon the ASN.1 DER encoded `tbsCertList`. | Section 5.1.1.3 |

!!! note

    The rest of the section details the content of the `tbsCertList` field only. For additional information on the `signatureAlgorithm` and `signatureValue` fields, refer to [RFC 5280].

The `tbsCertList` field SHALL contain a `TBSCertList` structure conforming to [RFC 5280, Section 5.1.2]. The following table details the supported fields, including presence requirements, syntax types, descriptions, and corresponding references in [RFC 5280].

| Field                       | Type            | Presence      | Description | Reference in [RFC 5280] |
| --------------------------- | :-------------: | :-----------: |------------ | ----------------------- |
| `version`                   | `INTEGER`       | OPTIONAL      | Describes the version of the encoded <artifacts:Certificate Revocation List (CRL)\|CRL>. When extensions are used, this field SHALL be present and SHALL specify version 2 (value `1`). | Section 5.1.2.1 |
| `signature`                 | `SEQUENCE`      | REQUIRED      | Contains the algorithm identifier for the algorithm used to sign the <artifacts:Certificate Revocation List (CRL)\|CRL>. | Section 5.1.2.2 |
| `issuer`                    | `CHOICE`        | REQUIRED      | Identifies the entity that has signed and issued the <artifacts:Certificate Revocation List (CRL)\|CRL>. | Section 5.1.2.3 |
| `thisUpdate`                | `CHOICE`        | REQUIRED      | Represents the issue date of this <artifacts:Certificate Revocation List (CRL)\|CRL>. | Section 5.1.2.4 |
| `nextUpdate`                | `CHOICE`        | REQUIRED      | Represents the date by which the next <artifacts:Certificate Revocation List (CRL)\|CRL> will be issued. | Section 5.1.2.5 |
| `revokedCertificates`       | `SEQUENCE`      | OPTIONAL      | Contains a sequence of revoked certificates.  When there are no revoked certificates, this field SHALL be absent. | Section 5.1.2.6 |
| `crlExtensions`             | `SEQUENCE`      | OPTIONAL      | Contains a sequence of one or more <artifacts:Certificate Revocation List (CRL)\|CRL> extensions conforming to the structure defined in [RFC 5280, Section 5.2]. The applicable extensions are defined below. | Section 5.1.2.7 |

The following table specifies the X.509 CRL extensions supported by this specification, including their Object Identifiers (OIDs), type, criticality, presence requirement, description, and normative references.

The criticality values used in this specification have the following meaning:

- **C**: the extension SHALL be marked critical;
- **NC**: the extension SHALL be marked non-critical.

| Extension                         | OID                   | Type              | Criticality   | Presence      | Description  | Reference |
| --------------------------------- | :-------------------: | :---------------: | :-----------: | :-----------: |------------- | --------- |
| `authorityKeyIdentifier`          | `2.5.29.35`           | `SEQUENCE`        | NC            | REQUIRED      | Identifies the public key corresponding to the private key used to sign the <artifacts:Certificate Revocation List (CRL)\|CRL>. | [RFC 5280, Section 5.2.1] |
| `cRLNumber`                       | `2.5.29.20`           | `SEQUENCE`        | NC            | REQUIRED      | Conveys a monotonically increasing sequence number for a given <artifacts:Certificate Revocation List (CRL)\|CRL> scope and issuer. | [RFC 5280, Section 5.2.3] |

!!! choice "APTITUDE Implementation Choices"

    - <artifacts:Certificate Revocation List (CRL)|CRLs> SHALL be issued by the <artifacts:Trust Anchor>.
    - Delta <artifacts:Certificate Revocation List (CRL)|CRLs> SHALL NOT be used.
