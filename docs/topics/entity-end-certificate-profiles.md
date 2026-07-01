This section describes the purpose, format and content of End Entity Sign/Seal Certificates in the European Digital Identity Wallet (EUDIW) ecosystem that are used for signing and sealing purposes.

#### References

To guarantee the interoperability across all entities of the EUDIW ecosystem, End Entity Sign/Seal Certificates should adhere to common requirements, with respect to their content and format. The technical specifications describing such content are distributed between multiple documents and for a purpose of proper referencing are listed below:

- **RFC 3986**
- **RFC 5280**
- **ETSI TS 119 612**
- **ETSI EN 319 411-1**
- **ETSI EN 319 411-2** (applicable if the certificate is qualified)
- **ETSI EN 319 412-1**
- **ETSI EN 319 412-2** (applicable if the certificate is issued to natural persons)
- **ETSI EN 319 412-3** (applicable if the certificate is issued to legal persons)
- **ETSI EN 319 412-5** (applicable if the certificate is qualified)
- **ETSI TS 119 412-6** (profiles the Sign/Seal certificate for various entities in the EUDIW ecosystem)

#### End Entity Sign/Seal Certificate Content

In the following sections we are providing tables with parameters and extensions that are mandatory for the specific End Entity Sign/Seal Certificate as described in ETSI specifications. For simplicity, optional attributes are omitted from this document, unless their requirement is conditional, or it could be useful to mention them.

The column "Presence" in tables below contains the specification of the presence of the certificate parameter as follows:

- REQUIRED: The parameter SHALL be present.
- REQUIRED (C): The parameter SHALL be present if the condition specified in the "Description" column is fulfilled.
- OPTIONAL: The parameter is not required and can be skipped.

The `extensions` field of the Trust Anchor Certificates SHALL contain various extensions, each of which is an *ASN.1 SEQUENCE* containing the following fields:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `[extension_name].extnID` | [RFC 5280] clause 4.1.2.9 | REQUIRED | *OBJECT IDENTIFIER* | The OID identifying the specific extension type. |
| `[extension_name].critical` | [RFC 5280] clause 4.1.2.9 | OPTIONAL | *BOOLEAN* | Indicates whether the extension is critical. DEFAULT is `FALSE`. |
| `[extension_name].extnValue` | [RFC 5280] clause 4.1.2.9 | REQUIRED | *OCTET STRING* | Contains the DER encoding of the ASN.1 value corresponding to the extension type identified by `extnID`. |

The column "Criticality" of the certificate extensions has the semantics defined in [RFC 5280, clause 4.2] and uses the following acronyms:

- C: The extension SHALL be considered critical.
- NC: The extension SHALL be considered non-critical.

##### General Content

The following table lists all the common parameters that are mandatory or conditional for end-certificates of all entities of EUDIW ecosystem described in this document. Details of those parameters are described in IETF RFC 5280 and further scoped in ETSI EN 319 412-2 (in case of Natural Persons) and ETSI EN 319 412-3 (in case of Legal Persons).

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `version` | [RFC 5280] clause 4.1.2.1 | REQUIRED | *[0] EXPLICIT INTEGER* | Indicates the version of the encoded certificate. For this profile, it SHALL be `v3` (`2`). |
| `serialNumber` | [RFC 5280] clause 4.1.2.2 | REQUIRED | *INTEGER* | The serial number of the certificate. |
| `signature` | [RFC 5280] clause 4.1.2.3 | REQUIRED | *SEQUENCE* | Identifies the signature algorithm used by the CA to sign the certificate. The signature algorithm SHOULD be selected according to [ETSI TS 119 312], but MAY be superseded by national recommendations. |
| `signature.algorithm` | [RFC 5280] clause 4.1.1.2 | REQUIRED | *OBJECT IDENTIFIER* | The OID of the signature algorithm. |
| `signature.parameters` | [RFC 5280] clause 4.1.1.2 | OPTIONAL | *ANY* | Algorithm-specific parameters, dependent on the algorithm used. |
| `subject` | [ETSI EN 319 412-2] clause 4.2.4 &<br>[ETSI EN 319 412-3] clause 4.2.1 | REQUIRED | *Name* | Identifies the entity associated with the public key stored in the subject public key field. If present, the size of `organizationName`, `organizationalUnitName` and `commonName` MAY be longer than the limit as stated in [RFC 5280].<br><br>If the subject is a natural person, the following attributes SHALL be present:<ul><li>`countryName` indicating the general context in which other attributes are to be understood;</li><li>choice of (`givenName` and/or `surname`) or `pseudonym`;</li><li>`commonName` indicating a name of the subject;</li><li>conditionally, `serialNumber` if the above attributes are not sufficient to ensure subject name uniqueness.</li></ul>When a natural person subject is associated with an organization, the attributes MAY also identify such organization using attributes like `organizationName` and `organizationIdentifier`.<br><br>If the subject is a legal person, the following attributes SHALL be present:<ul><li>`countryName` indicating the country in which the subject is established;</li><li>`organizationName` indicating the full registered name of the subject;</li><li>`organizationIdentifier` indicating an identification of the subject organization different from the organization name;</li><li>`commonName` indicating a name commonly used by the subject to represent itself.</li></ul> |
| `issuer` | [ETSI EN 319 412-2] clause 4.2.3 | REQUIRED | *Name* | Identifies the entity that has signed and issued the certificate.<br><br>If the issuer is a legal person, the following attributes SHALL be present:<ul><li>`countryName` indicating the country in which the issuer of the certificate is established;</li><li>`organizationName` indicating the full registered name of the certificate issuing organization;</li><li>`commonName` indicating a name commonly used by the subject to represent itself;</li><li>conditionally, an `organizationIdentifier` if an appropriate registration number is known to exist and it has a value different from the organization name.</li></ul><br>If the issuer is a natural person, the following attributes SHALL be present:<ul><li>`countryName` indicating a country that is consistent with the legal jurisdiction under which certificates are issued;</li><li>choice of (`givenName` and/or `surname`) or `pseudonym`; if the given name or surname of the issuer is known, the respective attribute SHALL be present;</li><li>`commonName`;</li><li>`serialNumber`.</li></ul> |
| `validity` | [RFC 5280] clause 4.1.2.5 | REQUIRED | *SEQUENCE* | Time interval during which the CA warrants that it will maintain information about the status of the certificate. |
| `validity.notBefore` | [RFC 5280] clause 4.1.2.5 | REQUIRED | *UTCTime* or *GeneralizedTime* | The date on which the certificate validity period begins. Dates through 2049 SHALL use `UTCTime`; dates in 2050 or later SHALL use `GeneralizedTime`. |
| `validity.notAfter` | [RFC 5280] clause 4.1.2.5 | REQUIRED | *UTCTime* or *GeneralizedTime* | The date on which the certificate validity period ends. Dates through 2049 SHALL use `UTCTime`; dates in 2050 or later SHALL use `GeneralizedTime`. |
| `subjectPublicKeyInfo` | [RFC 5280] clause 4.1.2.7 | REQUIRED | *SEQUENCE* | Carries the public key and identifies the algorithm with which the key is used. The subject public key SHOULD be selected according to ETSI TS 119 312 but MAY be superseded by national recommendations. |
| `subjectPublicKeyInfo.algorithm` | [RFC 5280] clause 4.1.2.7 | REQUIRED | *SEQUENCE* | The algorithm identifier for the public key. |
| `subjectPublicKeyInfo.subjectPublicKey` | [RFC 5280] clause 4.1.2.7 | REQUIRED | *BIT STRING* | The public key itself. |
| `extensions` | [RFC 5280] clause 4.1.2.9 | REQUIRED | *[3] EXPLICIT SEQUENCE* | A sequence of one or more certificate extensions. |

The following table lists all the common extensions that are mandatory or conditional for end-certificates of all entities of EUDIW ecosystem described in this document. Details of those extensions are described in IETF RFC 5280 and further scoped in ETSI EN 319 412-2 (in case of Natural Persons) and ETSI EN 319 412-3 (in case of Legal Persons).

| Parameter | Defined in | Presence | Criticality | Format | Description |
| :-------: | :--------: | :------: | :---------: | :----- | :---------- |
| `authorityKeyIdentifier` | [ETSI EN 319 412-2, clause 4.3.1] | REQUIRED | NC | *SEQUENCE* | Extension with the OID `2.5.29.35`.<br><br>Key identifier for the issuing CA's public key.<br><br>Contains: `keyIdentifier` (*OCTET STRING*), `authorityCertIssuer` (*GeneralNames*), and `authorityCertSerialNumber` (*INTEGER*). |
| `keyUsage` | [ETSI EN 319 412-2, clause 4.3.2] &<br>[ETSI EN 319 412-3, clause 4.3.1] | REQUIRED | C | *BIT STRING* | Extension with the OID `2.5.29.15`.<br><br>It SHALL be one of the following:<ol type="A"><li>non-repudiation</li><li>non-repudiation and digital signature</li><li>digital signature</li><li>digital signature and (key encipherment or key agreement)</li><li>key encipherment or key agreement</li><li>non-repudiation and digital signature and (key encipherment or key agreement)</li></ol>Type A, C, or E should be used to avoid mixed usage of keys.<br><br>Certificates issued to natural persons and used to validate commitment to signed content (e.g., documents/agreements) SHALL be limited to type A, B, or F (type A should be used).<br><br>Certificates issued to legal persons and used to validate digital signatures over content SHALL be limited to type A, B, or F (type A should be used).<br><br>Certificate issuers are invited to take into account the security implications, particularly **SC-1**, when this parameter is set up. |
| `cRLDistributionPoints` | [ETSI EN 319 412-2, clause 4.3.11] | REQUIRED (C) | NC | *SEQUENCE* | Extension with the OID `2.5.29.31`.<br><br>Sequence of `distributionPoint` represented by a CHOICE of `FullName` (*GeneralNames*) or `nameRelativeToCRLIssuer`, `reasons` (*BIT STRING*), and `cRLIssuer` (*GeneralNames*).<br><br>**Applicable condition:** If the certificate does not include any access location of an OCSP responder or the validity assured extension as defined in [ETSI EN 319 412-1].<br><br>It contains at least one reference to a publicly available CRL. |
| `authorityInfoAccess` | [ETSI EN 319 412-2, clause 4.4.1] | REQUIRED | NC | *SEQUENCE* | Extension with the OID `1.3.6.1.5.5.7.1.1`.<br><br>Sequence of `AccessDescription`, containing an `accessMethod` (OID) and an `accessLocation` (*GeneralName*).<br><br>It SHALL at least include the `id-ad-caIssuers` OID specifying at least one access location of a valid CA certificate of the issuing CA.<br><br>If OCSP is supported, it SHALL include the `id-ad-ocsp` OID specifying at least one access location of an OCSP responder providing status information for the present certificate.<br><br>If the certificate does not include any CRL distribution point and does not include the validity assured extension, a reference to at least one OCSP responder SHALL be present. |
| `certificatePolicies` | [RFC 3647, clause 3.3.1] &<br>[RFC 5280, clause 4.2.1.4] | REQUIRED | NC | *SEQUENCE* | Sequence of `PolicyInformation` elements, each being a SEQUENCE of `policyIdentifier` (OID) and `policyQualifiers`.<br><br>The extension is mandatory as stated in [ETSI EN 319 412-2], and it SHALL contain the identifier of at least one certificate policy which reflects the practices and procedures undertaken by the CA. |
| `subjectAltName` | [RFC 5280, clause 4.2.1.6] | REQUIRED | NC | *SEQUENCE* | Extension with the OID `2.5.29.17`.<br><br>Sequence of `GeneralName` elements, each representing a possible alternative name for the subject of the certificate.<br><br> Each `GeneralName` element contains contact information of the WRP and there SHALL be at least one element among the following:<ul><li>`uniformResourceIdentifier` indicating a website where the WRP can be contacted for helpdesk/support matters.</li><li>`otherName` with type-id `id-at-telephoneNumber` indicating a phone number for WRP registration/usage matters.</li><li>`rfc822Name` indicating an email address for WRP registration/usage matters.</li></ul>The extension is mandatory as stated in [ETSI TS 119 411-8] clause 6.6.1. |
| `qcStatements` (esi4-qcStatement-1) | [RFC 3739, clause 3.2.6] &<br>[ETSI EN 319 412-5, clause 4.2.1] | REQUIRED (C) | NC | *SEQUENCE* | `QCStatement` with the OID `0.4.0.1862.1.1`.<br><br>**Applicable condition:** For qualified certificates. It indicates that the certificate is qualified within the defined legal framework. For the eIDAS regulatory environment, the `QcCClegislation` SHALL be absent. |
| `qcStatements` (esi4-qcStatement-4) | [RFC 3739, clause 3.2.6] &<br>[ETSI EN 319 412-5, clause 4.2.2] | REQUIRED (C) | NC | *SEQUENCE* | `QCStatement` with the OID `0.4.0.1862.1.4`.<br><br>**Applicable condition:** For qualified certificates. It indicates that the private key related to the certified public key resides in a QSCD according to eIDAS regulation. The extension is mandatory as stated in ETSI EN 319 411-2, GEN-6.6.1-03. |
| `qcStatements` (esi4-qcStatement-6) | [RFC 3739, clause 3.2.6] &<br>[ETSI EN 319 412-5, clause 4.2.3] | REQUIRED (C) | NC | *SEQUENCE* | `QCStatement` with the OID `0.4.0.1862.1.6`.<br><br>**Applicable condition:** Mandatory for qualified certificates issued to legal persons for the purpose of electronic seal ([ETSI EN 319 412-5, clause 5]). MAY be present for certificates issued to natural persons for the purpose of electronic signatures.<br><br>Declares that a certificate is issued for one and only one of the purposes: electronic signature, electronic seal, or website authentication. |

!!! note

    In the APTITUDE profiles, Sign/Seal Certificates SHALL be long lived certificates. Thus the `noRevAvail` and `ext-etsi-valassured-ST-certs` SHALL NOT be used. 

##### PID Provider Sing/Seal Certificate Content

The following table lists all new or modified parameters that are mandatory or conditional for PID Providers as further scoped in ETSI TS 119 412-6, clause 4.

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `issuer` | [ETSI TS 119 412-6, clause 4.2] | REQUIRED | *Name* | The same as in General Content above, with an exception for a self-signed certificate. In that case, the content of issuer is the same as defined for the Subject parameter. |

The following table lists all new or modified extensions that are mandatory or conditional for PID Providers as further scoped in ETSI TS 119 412-6, clause 4.4.

| Parameter | Defined in | Presence | Criticality | Format | Description |
| :-------: | :--------: | :------: | :---------: | :----- | :---------- |
| `keyUsage` | [ETSI TS 119 412-6, clause 4.4.1] | REQUIRED | C | *BIT STRING* | It SHOULD contain one (and only one) of the key-usage settings Type A, Type B, Type C, or Type F, as defined in ETSI EN 319 412-2. |
| `subjectKeyIdentifier` | [ETSI TS 119 412-6, clause 4.4.2] | REQUIRED | NC | *BIT STRING* | For end entity certificates, the subject key identifier extension provides a means of identifying certificates that contain the particular public key used in an application. The subject key identifier SHOULD be derived from the public key using the methods defined in RFC 5280, clause 4.2.1.2. |
| `authorityInfoAccess` | [ETSI TS 119 412-6, clause 4.4.3] | REQUIRED (C) | NC | *SEQUENCE* | Description is the same as in the General Content above. **Applicable condition:** Mandatory for non-self-signed certificates. |
| `qcStatements` (id-etsi-qct-pid) | [ETSI TS 119 412-6, clause 4.5] | REQUIRED | NC | *SEQUENCE* | `QCStatement` with the OID `0.4.0.194126.1.1` as defined in [ETSI TS 119 412-6, Annex A] |

###### PID Provider Sign/Seal Certificate Example

The following is an example of a PID Provider's non-self-signed end-certificate for legal persons.

```text
AccessCertificate cert = {

  tbsCertificate: {

    version: 2,                     // integer value 2 for v3
    serialNumber: "0x6F3A0B91D2...",
    signature: AlgorithmIdentifier {
      oid: "1.2.840.113549.1.1.11",  // sha256WithRSAEncryption
      params: NULL
    },

    issuer: DistinguishedName {      // issuer attributes for legal person
      countryName: "CZ",
      organizationName: "Example Trust Services CA",
      commonName: "Example CA",
      organizationIdentifier: "VATCZ-123456789"
    },

    validity: {
      notBefore: "2026-01-27T00:00:00Z",
      notAfter:  "2027-01-27T00:00:00Z"
    },

    subject: DistinguishedName {     // subject attributes for legal person
      countryName: "CZ",
      organizationName: "Example of PID Issuer",
      organizationIdentifier: "LEIXYZ-5493001KJTIIGC8Y1R12",
      commonName: "PID Issuer Example"
    },

    subjectPublicKeyInfo: {
      algorithm: AlgorithmIdentifier {
        oid: "1.2.840.113549.1.1.1",
        params: NULL
      },

      subjectPublicKey: "BASE64(SPKI_PUBLIC_KEY_BYTES)"
    },


    extensions: [

      Extension {
        oid: "2.5.29.35",            // authorityKeyIdentifier
        critical: false,
        value: AuthorityKeyIdentifier {
          keyIdentifier: "HEX(20B_KEYID_OF_ISSUING_CA_PUBLIC_KEY)"
        }
      },

      Extension {
        oid: "2.5.29.15",            // keyUsage
        critical: true,
        value: KeyUsage {
          nonRepudiation: true        // Type A
          // all others false
        }
      },

      Extension {
        oid: "2.5.29.14",    // subject key identifier
        critical: false,
        value: SubjectKeyIdentifier [
          keyIdentifier: "SHA-1(SUBJECT_PUBLIC_KEY_VALUE)"
        ]
      },

      Extension {
        oid: "1.3.6.1.5.5.7.1.1",    // authority information access
        critical: false,
        value: AuthorityInfoAccess [
          AccessDescription {
            accessMethod: "1.3.6.1.5.5.7.48.2",            // id-ad-caIssuers
            accessLocation: URI("https://ca.example.test/caIssuers/issuing-ca.cer")
          },

          AccessDescription {
            accessMethod: "1.3.6.1.5.5.7.48.1",            // id-ad-ocsp
            accessLocation: URI("https://ocsp.example.test")
          }
        ]
      },

      Extension {
        oid: "2.5.29.32",            // certificatePolicies
        critical: false,
        value: CertificatePolicies [
          PolicyInformation {
            policyIdentifier: "0.4.0.194112.1.3",          // qcp-legal-qcsd
            policyQualifiers: [
              CPSuri("https://rpca.example.test/cps")
            ]
          }
        ]
      },

      Extension {
        oid: "1.3.6.1.5.5.7.0.35",   // qcStatements-2 container
        critical: false,
        value: QCStatements [
          QCStatement {
            statementId: "0.4.0.194126.1.1",   // id-etsi-qct-pid
          }
        ]
      },

      Extension {
        oid: "2.5.29.17",            // subjectAltName
        critical: false,
        value: SubjectAltName [
          GeneralName.uniformResourceIdentifier("https://pid.example.test/support"),
          GeneralName.rfc822Name("support@pid.example.test"),
          GeneralName.otherName(
            typeId: "2.5.4.20",       // id-at-telephoneNumber
            value: "+420-111-222-333"
          )
        ]
      },

      Extension {
        oid: "2.5.29.31",            // cRLDistributionPoints
        critical: false,
        value: CRLDistributionPoints [
          DistributionPoint {
            distributionPoint: URI("https://crl.example.test/issuing-ca.crl")
          }
        ]
      }
    ]
  },

  signatureAlgorithm: AlgorithmIdentifier {
    oid: "1.2.840.113549.1.1.11",    // must match/align with tbsCertificate.signature
    params: NULL
  },
  signatureValue: "BASE64(SIGN(issuerPrivateKey, DER(tbsCertificate)))"
}
```

##### Wallet Provider Sign/Seal Certificate Content

The following table lists all new or modified parameters that are mandatory or conditional for Wallet Providers as further scoped in ETSI TS 119 412-6, clause 5.1.

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `issuer` | [ETSI TS 119 412-6, clause 5.1] | REQUIRED | *Name* | The same as in the General Content above, with an exception for self-signed certificate. In that case, the content of issuer is the same as defined for the Subject parameter. |

The following table lists all new or modified extensions that are mandatory or conditional for Wallet Providers as further scoped in ETSI TS 119 412-6, clause 5.1 and 5.2.

| Parameter | Defined in | Presence | Criticality | Format | Description |
| :-------: | :--------: | :------: | :---------: | :----- | :---------- |
| `keyUsage` | [ETSI TS 119 412-6, clause 5.1] | REQUIRED | C | *BIT STRING* | It SHOULD contain one (and only one) of the key-usage settings Type A, Type B, Type C, or Type F, as defined in ETSI EN 319 412-2. |
| `subjectKeyIdentifier` | [ETSI TS 119 412-6, clause 5.1] | REQUIRED | NC | *BIT STRING* | For end entity certificates, the subject key identifier extension provides a means of identifying certificates that contain the particular public key used in an application. The subject key identifier SHOULD be derived from the public key using the methods defined in RFC 5280, clause 4.2.1.2. |
| `authorityInfoAccess` | [ETSI TS 119 412-6, clause 5.1] | REQUIRED (C) | NC | *SEQUENCE* | Description is the same as in the General Content above. **Applicable condition:** Mandatory for non-self-signed certificates. |
| `qcStatements` (id-etsi-qct-wal) | [ETSI TS 119 412-6, clause 5.2] | REQUIRED | NC | *SEQUENCE* | `QCStatement` with the OID `0.4.0.194126.1.2` as defined in [ETSI TS 119 412-6, Annex A] |

###### Wallet Provider Sign/Seal Certificate Example

The following is an example of a Wallet Provider's non-self-signed end-certificate for legal persons.

```text
AccessCertificate cert = {

  tbsCertificate: {

    version: 2,                     // integer value 2 for v3
    serialNumber: "0x6F3A0B91D2...",
    signature: AlgorithmIdentifier {
      oid: "1.2.840.113549.1.1.11",  // sha256WithRSAEncryption
      params: NULL
    },

    issuer: DistinguishedName {      // issuer attributes for legal person
      countryName: "CZ",
      organizationName: "Example Trust Services CA",
      commonName: "Example CA",
      organizationIdentifier: "VATCZ-123456789"
    },

    validity: {
      notBefore: "2026-01-27T00:00:00Z",
      notAfter:  "2027-01-27T00:00:00Z"
    },

    subject: DistinguishedName {     // subject attributes for legal person
      countryName: "CZ",
      organizationName: "Example of Wallet Provider",
      organizationIdentifier: "LEIXYZ-5493001KJTIIGC8Y1R12",
      commonName: "Wallet Provider Example"
    },

    subjectPublicKeyInfo: {
      algorithm: AlgorithmIdentifier {
        oid: "1.2.840.113549.1.1.1",
        params: NULL
      },

      subjectPublicKey: "BASE64(SPKI_PUBLIC_KEY_BYTES)"
    },


    extensions: [

      Extension {
        oid: "2.5.29.35",            // authorityKeyIdentifier
        critical: false,
        value: AuthorityKeyIdentifier {
          keyIdentifier: "HEX(20B_KEYID_OF_ISSUING_CA_PUBLIC_KEY)"
        }
      },

      Extension {
        oid: "2.5.29.15",            // keyUsage
        critical: true,
        value: KeyUsage {
          nonRepudiation: true        // Type A
          // all others false
        }
      },

      Extension {
        oid: "2.5.29.14",    // subject key identifier
        critical: false,
        value: SubjectKeyIdentifier [
          keyIdentifier: "SHA-1(SUBJECT_PUBLIC_KEY_VALUE)"
        ]
      },

      Extension {
        oid: "1.3.6.1.5.5.7.1.1",    // authority information access
        critical: false,
        value: AuthorityInfoAccess [
          AccessDescription {
            accessMethod: "1.3.6.1.5.5.7.48.2",            // id-ad-caIssuers
            accessLocation: URI("https://ca.example.test/caIssuers/issuing-ca.cer")
          },

          AccessDescription {
            accessMethod: "1.3.6.1.5.5.7.48.1",            // id-ad-ocsp
            accessLocation: URI("https://ocsp.example.test")
          }
        ]
      },

      Extension {
        oid: "2.5.29.32",            // certificatePolicies
        critical: false,
        value: CertificatePolicies [
          PolicyInformation {
            policyIdentifier: "0.4.0.194112.1.3",          // qcp-legal-qcsd
            policyQualifiers: [
              CPSuri("https://rpca.example.test/cps")
            ]
          }
        ]
      },

      Extension {
        oid: "1.3.6.1.5.5.7.0.35",   // qcStatements-2 container
        critical: false,
        value: QCStatements [
          QCStatement {
            statementId: "0.4.0.194126.1.2",   // id-etsi-qct-wal
          }
        ]
      },

      Extension {
        oid: "2.5.29.17",            // subjectAltName
        critical: false,
        value: SubjectAltName [
          GeneralName.uniformResourceIdentifier("https://wp.example.test/support"),
          GeneralName.rfc822Name("support@wp.example.test"),
          GeneralName.otherName(
            typeId: "2.5.4.20",       // id-at-telephoneNumber
            value: "+420-111-222-333"
          )
        ]
      },

      Extension {
        oid: "2.5.29.31",            // cRLDistributionPoints
        critical: false,
        value: CRLDistributionPoints [
          DistributionPoint {
            distributionPoint: URI("https://crl.example.test/issuing-ca.crl")
          }
        ]
      }
    ]
  },

  signatureAlgorithm: AlgorithmIdentifier {
    oid: "1.2.840.113549.1.1.11",    // must match/align with tbsCertificate.signature
    params: NULL
  },
  signatureValue: "BASE64(SIGN(issuerPrivateKey, DER(tbsCertificate)))"
}
```

##### EAA/QEAA Provider Sign/Seal Certificate Content

EAA and QEAA providers are from the perspective of Sign/Seal end-certificates almost the same and for simplicity we will cover them together.

There are no new or modified parameters or extensions specific for EAA or QEAA Provider as described in ETSI TS 119 412-6, clause 6 and 7.

For EAA Provider there are other requirements that focus on signing of certificates connected to either OCSP Responder or CRL depending on used revocation policy. More information can be found in ETSI TS 119 412-6, clause 6.2.

For QEAA Provider there are regulatory requirements from Regulation (EU) No 910/2014 that have to be met, but they are out of scope of this documentation. More information can be found in ETSI TS 119 412-6, clause 7.1.

###### EAA/QEAA Provider Sign/Seal Certificate Example

The following is an example of a QEAA Provider attribute not self-signed end-certificate for legal persons.

```text
AccessCertificate cert = {

  tbsCertificate: {

    version: 2,                     // integer value 2 for v3
    serialNumber: "0x6F3A0B91D2...",
    signature: AlgorithmIdentifier {
      oid: "1.2.840.113549.1.1.11",  // sha256WithRSAEncryption
      params: NULL
    },

    issuer: DistinguishedName {      // issuer attributes for legal person
      countryName: "CZ",
      organizationName: "Example Trust Services CA",
      commonName: "Example CA",
      organizationIdentifier: "VATCZ-123456789"
    },

    validity: {
      notBefore: "2026-01-27T00:00:00Z",
      notAfter:  "2027-01-27T00:00:00Z"
    },

    subject: DistinguishedName {     // subject attributes for legal person
      countryName: "CZ",
      organizationName: "Example of EAA/QEAA Provider",
      organizationIdentifier: "LEIXYZ-5493001KJTIIGC8Y1R12",
      commonName: "EAA/QEAA Provider Example"
    },

    subjectPublicKeyInfo: {
      algorithm: AlgorithmIdentifier {
        oid: "1.2.840.113549.1.1.1",
        params: NULL
      },

      subjectPublicKey: "BASE64(SPKI_PUBLIC_KEY_BYTES)"
    },


    extensions: [

      Extension {
        oid: "2.5.29.35",            // authorityKeyIdentifier
        critical: false,
        value: AuthorityKeyIdentifier {
          keyIdentifier: "HEX(20B_KEYID_OF_ISSUING_CA_PUBLIC_KEY)"
        }
      },

      Extension {
        oid: "2.5.29.15",            // keyUsage
        critical: true,
        value: KeyUsage {
          nonRepudiation: true        // Type A
          // all others false
        }
      },

      Extension {
        oid: "1.3.6.1.5.5.7.1.1",    // authority information access
        critical: false,
        value: AuthorityInfoAccess [
          AccessDescription {
            accessMethod: "1.3.6.1.5.5.7.48.2",            // id-ad-caIssuers
            accessLocation: URI("https://ca.example.test/caIssuers/issuing-ca.cer")
          },

          AccessDescription {
            accessMethod: "1.3.6.1.5.5.7.48.1",            // id-ad-ocsp
            accessLocation: URI("https://ocsp.example.test")
          }
        ]
      },

      Extension {
        oid: "2.5.29.32",            // certificatePolicies
        critical: false,
        value: CertificatePolicies [
          PolicyInformation {
            policyIdentifier: "0.4.0.194112.1.3",          // qcp-legal-qcsd
            policyQualifiers: [
              CPSuri("https://rpca.example.test/cps")
            ]
          }
        ]
      },

      Extension {
        oid: "2.5.29.17",            // subjectAltName
        critical: false,
        value: SubjectAltName [
          GeneralName.uniformResourceIdentifier("https://eaa.example.test/support"),
          GeneralName.rfc822Name("support@eaa.example.test"),
          GeneralName.otherName(
            typeId: "2.5.4.20",       // id-at-telephoneNumber
            value: "+420-111-222-333"
          )
        ]
      },

      Extension {
        oid: "2.5.29.31",            // cRLDistributionPoints
        critical: false,
        value: CRLDistributionPoints [
          DistributionPoint {
            distributionPoint: URI("https://crl.example.test/issuing-ca.crl")
          }
        ]
      }
    ]
  },

  signatureAlgorithm: AlgorithmIdentifier {
    oid: "1.2.840.113549.1.1.11",    // must match/align with tbsCertificate.signature
    params: NULL
  },
  signatureValue: "BASE64(SIGN(issuerPrivateKey, DER(tbsCertificate)))"
}
```

##### PuB-EAA Provider Sign/Seal Certificate Content

There are no new or modified parameters specific for PuB-EAA Provider as described in ETSI TS 119 412-6, clause 8.

The following table lists all new or modified extensions that are mandatory or conditional for PuB-EAA Provider as further scoped in ETSI TS 119 412-6, clause 8.2 and 8.3.

| Parameter | Defined in | Presence | Criticality | Format | Description |
| :-------: | :--------: | :------: | :---------: | :----- | :---------- |
| `authorityInfoAccess` | [ETSI TS 119 412-6, clause 8.1] | REQUIRED | NC | *SEQUENCE* | Description is the same as in the General Content above. It is mandatory for PuB-EAA Provider. |
| `qcStatements` (id-etsi-qcs-QcPSB) | [ETSI TS 119 412-6, clause 8.3] | REQUIRED | NC | *SEQUENCE* | `QCStatement` with the OID `0.4.0.194126.1.3` as defined in [ETSI TS 119 412-6, Annex A]. |
| `qcStatements` (esi4-qcStatement-10) | [ETSI TS 119 412-6, clause 8.3] | REQUIRED | NC | *SEQUENCE* | `QCStatement` with the OID `0.4.0.1862.1.10`. Requirements: <ul><li>The `QCStatement` SHALL contain the identification for the law under which the PuB-EAA Provider is established responsible for the authentic source.</li><li>**Aplicable condition:** If there is a well-defined Uniform Resource Identifier (URI) according to IETF RFC 3986 [8] for the unique identification of the legal basis upon which the PuB-EAA Provider is established as authentic source, it should be used here.</li><li>The `QCStatement` SHALL contain an unambiguous identification for the authentic source.</li><li>The `QCStatement` SHALL contain either the ISO 3166 [7] alpha-2 country codes for applicable law, or in the case of European Union law 'EU'.</li></ul> |

For PuB-EAA Provider there are other requirements that focus on signing of certificates connected to either OCSP Responder or CRL depending on used revocation policy. More information can be found in ETSI TS 119 412-6, clause 8.4.

###### Pub-EAA Provider Sign/Seal Certificate Example

The following is an example of a PuB-EAA Provider's not self-signed end-certificate for legal persons.

```text
AccessCertificate cert = {

  tbsCertificate: {

    version: 2,                     // integer value 2 for v3
    serialNumber: "0x6F3A0B91D2...",
    signature: AlgorithmIdentifier {
      oid: "1.2.840.113549.1.1.11",  // sha256WithRSAEncryption
      params: NULL
    },

    issuer: DistinguishedName {      // issuer attributes for legal person
      countryName: "CZ",
      organizationName: "Example Trust Services CA",
      commonName: "Example CA",
      organizationIdentifier: "VATCZ-123456789"
    },

    validity: {
      notBefore: "2026-01-27T00:00:00Z",
      notAfter:  "2027-01-27T00:00:00Z"
    },

    subject: DistinguishedName {     // subject attributes for legal person
      countryName: "CZ",
      organizationName: "Example of PuB-EAA Provider",
      organizationIdentifier: "LEIXYZ-5493001KJTIIGC8Y1R12",
      commonName: "PuB-EAA Provider Example"
    },

    subjectPublicKeyInfo: {
      algorithm: AlgorithmIdentifier {
        oid: "1.2.840.113549.1.1.1",
        params: NULL
      },

      subjectPublicKey: "BASE64(SPKI_PUBLIC_KEY_BYTES)"
    },


    extensions: [

      Extension {
        oid: "2.5.29.35",            // authorityKeyIdentifier
        critical: false,
        value: AuthorityKeyIdentifier {
          keyIdentifier: "HEX(20B_KEYID_OF_ISSUING_CA_PUBLIC_KEY)"
        }
      },

      Extension {
        oid: "2.5.29.15",            // keyUsage
        critical: true,
        value: KeyUsage {
          nonRepudiation: true        // Type A
          // all others false
        }
      },

      Extension {
        oid: "2.5.29.14",    // subject key identifier
        critical: false,
        value: SubjectKeyIdentifier [
          keyIdentifier: "SHA-1(SUBJECT_PUBLIC_KEY_VALUE)"
        ]
      },

      Extension {
        oid: "1.3.6.1.5.5.7.1.1",    // authority information access
        critical: false,
        value: AuthorityInfoAccess [
          AccessDescription {
            accessMethod: "1.3.6.1.5.5.7.48.2",            // id-ad-caIssuers
            accessLocation: URI("https://ca.example.test/caIssuers/issuing-ca.cer")
          },

          AccessDescription {
            accessMethod: "1.3.6.1.5.5.7.48.1",            // id-ad-ocsp
            accessLocation: URI("https://ocsp.example.test")
          }
        ]
      },

      Extension {
        oid: "2.5.29.32",            // certificatePolicies
        critical: false,
        value: CertificatePolicies [
          PolicyInformation {
            policyIdentifier: "0.4.0.194112.1.3",          // qcp-legal-qcsd
            policyQualifiers: [
              CPSuri("https://rpca.example.test/cps")
            ]
          }
        ]
      },

      Extension {
        oid: "1.3.6.1.5.5.7.0.35",   // qcStatements-2 container
        critical: false,
        value: QCStatements [
          QCStatement {
            statementId: "0.4.0.194126.1.3",   // id-etsi-qcs-QcPSB
            statementInfo: {
              countryOfLegislation: "CZ",
              authSourceIdentification: "https://authsource.gov.cz/cz/registry/rob",
              legislationIdentification: "https://legislation.gov.cz/eli/cz/sb/2000/365"
            }
          }
        ]
      },

      Extension {
        oid: "2.5.29.17",            // subjectAltName
        critical: false,
        value: SubjectAltName [
          GeneralName.uniformResourceIdentifier("https://pubeaa.example.test/support"),
          GeneralName.rfc822Name("support@pubeaa.example.test"),
          GeneralName.otherName(
            typeId: "2.5.4.20",       // id-at-telephoneNumber
            value: "+420-111-222-333"
          )
        ]
      },

      Extension {
        oid: "2.5.29.31",            // cRLDistributionPoints
        critical: false,
        value: CRLDistributionPoints [
          DistributionPoint {
            distributionPoint: URI("https://crl.example.test/issuing-ca.crl")
          }
        ]
      }
    ]
  },

  signatureAlgorithm: AlgorithmIdentifier {
    oid: "1.2.840.113549.1.1.11",    // must match/align with tbsCertificate.signature
    params: NULL
  },
  signatureValue: "BASE64(SIGN(issuerPrivateKey, DER(tbsCertificate)))"
}
```

#### Sign/Seal Certificate Path Validation

When instantiating the [Certificate Path Validation](#authentication-process.md) algorithm for Sign/Seal Certificate chains, the initialization parameters are defined as follows:

- The <artifacts:Trust Anchor> is the *trusted certificate* obtained from the `ServiceDigitalIdentity` component in relevant <artifacts:List of Trusted Entities (LoTE)|LoTE> (See the table below).
- The Certification Path is the sequence of $n$ certificates ($C_1 \dots C_n$) provided by the WRP, where:
    - $C_1$ is the certificate issued by the root Certificate Authority.
    - $C_n$ is the Sign/Seal Certificate (the target certificate).
    - For any $i$ in $1 \dots n-1$, $C_i$ is the issuer of $C_{i+1}$.

!!! note

    Regarding Sign/Seal Certificates within APTITUDE, $n=1$. The Sign/Seal Certificate SHALL be referenced in the `x5c` claim of the Attestation, while the Trust Anchor referenced in the LoTE SHALL be a self-signed certificate of the entity issuing Sign/Seal Certificates as described in [Trust Anchor Certificates Profiles](#trust-anchor-certificate-profiles.md).

The following table maps the Sign/Seal Certificate subject to the location of the respective Trust Anchor.

| Sign/Seal Certificate subject | Attestation signed | Trust Anchor location |
| :---------------------------: | :----------------: | :-------------------: |
| PID Provider | signing PID | PID Providers LoTE |
| Wallet Provider | WIA, KA | Wallet Providers LoTE  |
| EAA Provider | signing EAA | MS decision |
| QEAA Provider | signing QEAA | TL |
| Pub-EAA Provider | signing  PuB-EAA | Pub-EAA Providers LoTE |
