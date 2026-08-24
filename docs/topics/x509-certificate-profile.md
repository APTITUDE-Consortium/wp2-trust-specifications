This section defines a general **X.509 Certificate Profile**, establishing the syntax, semantics and encoding requirements for X.509 certificates based on [RFC 5280] and [ETSI EN 319 412].

Each X.509 certificate defined in this specification SHALL conform to the requirements of this section unless explicitly stated otherwise.

As specified in [RFC 5280], X.509 Certificates SHALL be a `SEQUENCE` of the following fields:

| Field                       | Type            | Presence      | Description | Reference in [RFC 5280] |
| --------------------------- | :-------------: | :-----------: |------------ | ----------------------- |
| `tbsCertificate`            | `SEQUENCE`      | REQUIRED      | Contains the names of the subject and issuer, a public key associated with the subject, a validity period, and other associated information. | Section 4.1.1.1 |
| `signatureAlgorithm`        | `SEQUENCE`      | REQUIRED      | Contains the identifier for the cryptographic algorithm used by the CA to sign the certificate. | Section 4.1.1.2 |
| `signatureValue`            | `BIT STRING`    | REQUIRED      | Contains a digital signature computed upon the ASN.1 DER encoded `tbsCertificate`. | Section 4.1.1.3 |

!!! info

    The rest of the section details the content of the `tbsCertificate` field only. For additional information on the `signatureAlgorithm` and `signatureValue` fields, refer to [RFC5280].

The `tbsCertificate` field SHALL contain a `TBSCertificate` structure, whose fields SHALL conform to [RFC 5280, Section 4.1.2].

The following table defines the certificate fields applicable to the Certificate Profile specified in this document. For each field, the table defines its presence requirement, type, description, and corresponding reference in [RFC 5280]. Individual Certificate Profiles MAY provide additional contextual notes for these fields, but SHALL NOT alter the presence requirements specified herein.

| Field                       | Type            | Presence      | Description | Reference in [RFC 5280] |
| --------------------------- | :-------------: | :-----------: |------------ | ----------------------- |
| `version`                   | `INTEGER`       | REQUIRED      | Describes the version of the encoded certificate. For this profile, it SHALL be version 3 (value `2`). | Section 4.1.2.1 |
| `serialNumber`              | `INTEGER`       | REQUIRED      | Represents the serial number of the certificate. | Section 4.1.2.2 |
| `signature`                 | `SEQUENCE`      | REQUIRED      | Contains the algorithm identifier for the algorithm used by the <roles:Certificate Authority (CA)\|CA> to sign the certificate. The signature algorithm SHOULD be selected according to [ETSI TS 119 312], but MAY be superseded by national recommendations. | Section 4.1.2.3, Section 4.1.1.2 |
| `issuer`                    | `SEQUENCE`      | REQUIRED      | Identifies entity that has signed and issued the certificate. It SHALL comply with the applicable requirements of [ETSI EN 319 412-2, Clause 4.2.3.2], as specified by the corresponding certificate profile. | Section 4.1.2.4 |
| `validity`                  | `SEQUENCE`      | REQUIRED      | Represents the time interval during which the <roles:Certificate Authority (CA)\|CA> warrants that it will maintain information about the status of the certificate. | Section 4.1.2.5 |
| `subject`                   | `SEQUENCE`      | REQUIRED      | Identifies the entity associated with the public key stored in the subject public key field. It SHALL comply with the applicable requirements of [ETSI EN 319 412-3, Clause 4.2.1], as specified by the corresponding certificate profile. | Section 4.1.2.6 |
| `subjectPublicKeyInfo`      | `SEQUENCE`      | REQUIRED      | Carries the public key and identifies the algorithm with which the key is used. The subject public key SHOULD be selected according to [ETSI TS 119 312] but MAY be superseded by national recommendations. | Section 4.1.2.7 |
| `issuerUniqueID`            | `BIT STRING`    | PROHIBITED    | Represents the issuer unique identifiers, to handle the possibility of reuse of issuer names over time. | Section 4.1.2.8 |
| `subjectUniqueID`           | `BIT STRING`    | PROHIBITED    | Represents the subject unique identifiers, to handle the possibility of reuse of subject names over time. | Section 4.1.2.8 |
| `extensions`                | `SEQUENCE`      | REQUIRED      | Contains a sequence of one or more certificate extensions conforming to the structure defined in [RFC 5280, Section 4.2]. The applicable extensions and their profile-specific constraints are defined below and in the corresponding certificate profile. | Section 4.1.2.9 |

The following table specifies the X.509 certificate extensions supported by this specification, including their Object Identifiers (OIDs), type, criticality, description, and normative references. Individual certificate profiles SHALL define the presence requirement (REQUIRED, OPTIONAL, or PROHIBITED) for each extension and MAY further constrain its syntax and contents.

The criticality values used in this specification have the following meaning:

- **C**: the extension SHALL be marked critical;
- **NC**: the extension SHALL be marked non-critical.

| Extension                         | OID                   | Type              | Criticality   | Description   | Reference |
| --------------------------------- | :-------------------: | :---------------: | :-----------: | ------------- | --------- |
| `authorityKeyIdentifier`          | `2.5.29.35`           | `SEQUENCE`        | NC            | Identifies the public key corresponding to the private key used by the issuing <roles:Certificate Authority (CA)\|CA> to sign the certificate. | [RFC 5280, Section 4.2.1.1], [ETSI EN 319 412-2, Clause 4.3.1] |
| `subjectKeyIdentifier`            | `2.5.29.14`           | `OCTET STRING`    | NC            | Identifies certificates that contain a particular public key. | [RFC 5280, Section 4.2.1.2] |
| `keyUsage`                        | `2.5.29.15`           | `BIT STRING`      | C             | Defines the purpose of the key contained in the certificate. | [RFC 5280, Section 4.2.1.3], [ETSI EN 319 412-2, Clause 4.3.2], [ETSI EN 319 412-3, Clause 4.3.1] |
| `certificatePolicies`             | `2.5.29.32`           | `SEQUENCE`        | NC            | Contains a sequence of one or more policy information terms. | [RFC 5280, Section 4.2.1.4], [ETSI EN 319 412-2, Clause 4.3.3] |
| `subjectAltName`                  | `2.5.29.17`           | `SEQUENCE`        | NC            | Represents a set of possible alternative names for the subject of the certificate. | [RFC 5280, Section 4.2.1.6], [ETSI EN 319 412-2, Clause 4.3.5], [ETSI TS 119 411-8, Clause 6.6.1, GEN-6.6.1-07] |
| `basicConstraints`                | `2.5.29.19`           | `SEQUENCE`        | C             | Identifies whether the subject of the certificate is a CA and the maximum depth of valid certification paths that include this certificate. | [RFC 5280, Section 4.2.1.9] |
| `cRLDistributionPoints`           | `2.5.29.31`           | `SEQUENCE`        | NC            | Contains references to publicly available <artifacts:Certificate Revocation List (CRL)\|Certificate Revocation Lists (CRLs)>. | [RFC 5280, Section 4.2.1.13], [ETSI EN 319 412-2, Clause 4.3.11] |
| `authorityInfoAccess`             | `1.3.6.1.5.5.7.1.1`   | `SEQUENCE`        | NC            | Indicates how to access information and services for the issuer of the certificate. | [RFC 5280, Section 4.2.2.1], [ETSI EN 319 412-2, Clause 4.4.1] |
| `ext-etsi-valassured-ST-certs`    | `0.4.0.194121.2.1`    | `NULL`            | NC            | Indicates that the certificate issuer ensures the validity of the certificate is assured at time of use of the corresponding private key. Upon presence of such statement, the WRP can decide not to check the certificate revocation status. | [ETSI EN 319 412-1, Clause 5.2.2] |
| `noRevAvail`                      | `2.5.29.56`           | `NULL`            | NC            | Allows a CA to indicate that no revocation information will be made available for this certificate. | [RFC 9608, Section 2] |
| `qcStatements`                    | `1.3.6.1.5.5.7.1.3`   | `SEQUENCE`        | NC            | Contains a sequence of one or more objects to define explicit properties of the certificate. | [RFC 3739, Section 3.2.6], [ETSI EN 319 412-5, Clause 4.2] |
