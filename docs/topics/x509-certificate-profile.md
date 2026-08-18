This section defines a general **X.509 Certificate Profile**, establishing the syntax, semantics and encoding requirements for X.509 certificates based on [RFC 5280] and [ETSI EN 319 412]. Each specific X.509 certificate defined in this specification SHALL conform to the requirements of this section unless explicitly stated otherwise.

The final certificate is obtained by combining the certificate body (`version` through `subjectPublicKeyInfo`) with the certificate extensions required by the selected certificate profile.
The resulting ASN.1 structure SHALL be encoded using the Distinguished Encoding Rules (DER) as specified in [RFC 5280].

#### Common Certificate Fields

The `TBSCertificate` structure and its fields SHALL conform to [RFC 5280, Section 4.1].

The following table defines the certificate fields applicable to the certificate profiles defined in this specification.
For each field, the table specifies the corresponding reference in [RFC 5280], its presence requirement, and any additional profile-specific constraints.

| Field                       | Presence      | Description | Reference in [RFC 5280] |
| --------------------------- | ------------- |------------ | ----------------------- |
| `version`                   | REQUIRED      | Describes the version of the encoded certificate. For this profile, it SHALL be version 3 (value `2`). | Section 4.1.2.1 |
| `serialNumber`              | REQUIRED      | Represents the serial number of the certificate. | Section 4.1.2.2 |
| `signature`                 | REQUIRED      | Contains the algorithm identifier for the algorithm used by the <roles:Certificate Authority (CA)\|CA> to sign the certificate. The signature algorithm SHOULD be selected according to [ETSI TS 119 312], but MAY be superseded by national recommendations. | Section 4.1.2.3, Section 4.1.1.2 |
| `issuer`                    | REQUIRED      | Identifies entity that has signed and issued the certificate. It SHALL comply with the applicable requirements of [ETSI EN 319 412-2, Clause 4.2.3.2], as specified by the corresponding certificate profile. | Section 4.1.2.4 |
| `validity`                  | REQUIRED      | Represents the time interval during which the <roles:Certificate Authority (CA)\|CA> warrants that it will maintain information about the status of the certificate. | Section 4.1.2.5 |
| `subject`                   | REQUIRED      | Identifies the entity associated with the public key stored in the subject public key field. It SHALL comply with the applicable requirements of [ETSI EN 319 412-3, Clause 4.2.1], as specified by the corresponding certificate profile. | Section 4.1.2.6 |
| `subjectPublicKeyInfo`      | REQUIRED      | Carries the public key and identifies the algorithm with which the key is used. The subject public key SHOULD be selected according to [ETSI TS 119 312] but MAY be superseded by national recommendations. | Section 4.1.2.7 |
| `issuerUniqueID`            | OPTIONAL      | Represents the issuer unique identifiers, to handle the possibility of reuse of issuer names over time. It SHOULD NOT be present. | Section 4.1.2.8 |
| `subjectUniqueID`           | OPTIONAL      | Represents the subject unique identifiers, to handle the possibility of reuse of subject names over time. It SHOULD NOT be present. | Section 4.1.2.8 |
| `extensions`                | REQUIRED      | Contains a sequence of one or more certificate extensions conforming to the structure defined in [RFC 5280, Section 4.2]. The applicable extensions and their profile-specific constraints are defined in [Supported Certificate Extensions](#supported-certificate-extensions) and in the corresponding certificate profile. | Section 4.1.2.9 |

#### Supported Certificate Extensions

The following table lists the certificate extensions supported by the X.509 certificate profiles defined in this specification, together with their object identifiers, default criticality, and normative references.
Specific certificate profiles define whether an extension is REQUIRED, OPTIONAL, or SHALL NOT be present, and MAY further constrain its contents.

The criticality values used in this specification have the following meaning:

- **C**: the extension SHALL be marked critical;
- **NC**: the extension SHALL be marked non-critical.

| Extension                         | OID                   | Criticality   | Description   | Reference |
| --------------------------------- | --------------------- | ------------- | ------------- | --------- |
| `authorityKeyIdentifier`          | `2.5.29.35`           | NC            | Identifies the public key corresponding to the private key used by the issuing <roles:Certificate Authority (CA)\|CA> to sign the certificate. | [RFC 5280, Section 4.2.1.1], [ETSI EN 319 412-2, Clause 4.3.1] |
| `subjectKeyIdentifier`            | `2.5.29.14`           | NC            | Identifies certificates that contain a particular public key. | [RFC 5280, Section 4.2.1.2] |
| `keyUsage`                        | `2.5.29.15`           | C             | Defines the purpose of the key contained in the certificate. | [RFC 5280, Section 4.2.1.3], [ETSI EN 319 412-2, Clause 4.3.2], [ETSI EN 319 412-3, Clause 4.3.1] |
| `certificatePolicies`             | `2.5.29.32`           | NC            | Contains a sequence of one or more policy information terms. | [RFC 5280, Section 4.2.1.4], [ETSI EN 319 412-2, Clause 4.3.3] |
| `subjectAltName`                  | `2.5.29.17`           | NC            | Represents a set of possible alternative names for the subject of the certificate. | [RFC 5280, Section 4.2.1.6], [ETSI EN 319 412-2, Clause 4.3.5], [ETSI TS 119 411-8, Clause 6.6.1, GEN-6.6.1-07] |
| `basicConstraints`                | `2.5.29.19`           | C             | Identifies whether the subject of the certificate is a CA and the maximum depth of valid certification paths that include this certificate. | [RFC 5280, Section 4.2.1.9] |
| `cRLDistributionPoints`           | `2.5.29.31`           | NC            | Contains references to publicly available <artifacts:Certificate Revocation List (CRL)\|Certificate Revocation Lists (CRLs)>. | [RFC 5280, Section 4.2.1.13], [ETSI EN 319 412-2, Clause 4.3.11] |
| `authorityInfoAccess`             | `1.3.6.1.5.5.7.1.1`   | NC            | Indicates how to access information and services for the issuer of the certificate. | [RFC 5280, Section 4.2.2.1], [ETSI EN 319 412-2, Clause 4.4.1] |
| `ext-etsi-valassured-ST-certs`    | `0.4.0.194121.2.1`    | NC            | Indicates that the certificate issuer ensures the validity of the certificate is assured at time of use of the corresponding private key. Upon presence of such statement, the WRP can decide not to check the certificate revocation status. | [ETSI EN 319 412-1, Clause 5.2.2] |
| `noRevAvail`                      | `2.5.29.56`           | NC            | Allows a CA to indicate that no revocation information will be made available for this certificate. | [RFC 9608, Section 2] |
| `qcStatements`                    | `1.3.6.1.5.5.7.1.3`   | NC            | Contains a sequence of one or more objects to define explicit properties of the certificate. | [RFC 3739, Section 3.2.6], [ETSI EN 319 412-5, Clause 4.2] |