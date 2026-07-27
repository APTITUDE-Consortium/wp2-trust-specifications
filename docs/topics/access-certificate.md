This section describes the purpose, format and content of <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|Wallet-Relying Party Access Certificates (WRPACs)>.

According to the Article 2 of CIR (EU) 2025/848, a <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>, is a certificate for electronic seals or signatures authenticating and validating the <roles:Wallet-Relying Party (WRP)>.
Issued by one or more designated providers under Member State supervision, the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> serves to authenticate and verify the trustworthiness of the <roles:Wallet-Relying Party (WRP)|WRP> when they interact with the <components:EUDI Wallet>. For more details on the authentication process, see [Authentication Process](../sections/trust-evaluation-process.md#authentication-process).
The suspension or cancellation of the <roles:Wallet-Relying Party (WRP)|WRP> services, involves revocation of all valid <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs> by the relevant issuing authority, such that the <roles:Wallet-Relying Party (WRP)|WRP> is no longer able to interact with <components:Wallet Unit|Wallet Units>. For more detail on the Trust Management processes, see [Trust Management and Lifecycle](../sections/trust-management-lifecycle.md).

The Annex IV of [CIR 2025/848] also states that the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs> are meant for performing electronic signatures or seals and that they shall comply with at least the <artifacts:Normalised Certificate Policy (NCP)> requirements specified in the ETSI standards. Taking into account these minimal requirements, different scenarios are possible and specified in the following clauses: certificates issued to natural or legal persons, supporting advanced signatures/seals or even qualified signature/seals. Conditional requirements are defined according to the specific case the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs> fall into.

??? references

    To guarantee the interoperability across all the wallets provided within the Union, <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs> should adhere to common requirements, with respect to their content and format. The technical standard specific to these certificates is [ETSI TS 119 411-8]. However, multiple other standards are referenced either directly or indirectly by [ETSI TS 119 411-8], containing requirements that are applicable to <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs> as well. The list below enumerates all the applicable standards and specifications that have been used to populate the table below:

    - **CIR 2025/848**
    - **ETSI EN 319 411-1**
    - **ETSI EN 319 411-2** (applicable if the certificate is qualified)
    - **ETSI EN 319 412-1**
    - **ETSI EN 319 412-2** (applicable if the certificate is issued to natural persons)
    - **ETSI EN 319 412-3** (applicable if the certificate is issued to legal persons)
    - **ETSI EN 319 412-5** (applicable if the certificate is qualified)
    - **ETSI TS 119 411-8**
    - **RFC 3647**
    - **RFC 3739**
    - **RFC 5280**
    - **RFC 9608**

#### Dependency Considerations

The <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> attributes SHALL be derived from the information held in the <components:Register> as specified in clause 5.1.2 of [ETSI TS 119 475]. This also implies that for some specific attributes in the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> the same value SHALL be encountered in the corresponding <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|Wallet-Relying Party Registration Certificate> if any.

#### Wallet Relying Party Access Certificate Content

The following table lists all the parameters and extensions that are mandatory in a <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> or mandatory with conditions. Optional parameters are not referenced and are not recommended, since they could cause conflicts with the content specified.

The column "Presence" contains the specification of the presence of the certificate parameter as follows:

- REQUIRED: The parameter SHALL be present.
- REQUIRED (C): The parameter SHALL be present if the condition specified in the "Description" column is fulfilled.

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `version` | [RFC 5280, clause 4.1.2.1] | REQUIRED | *[0] EXPLICIT INTEGER* | Indicates the version of the encoded certificate. For this profile, it SHALL be `v3` (`2`). |
| `serialNumber` | [RFC 5280, clause 4.1.2.2] | REQUIRED | *INTEGER* | The serial number of the certificate. |
| `signature` | [RFC 5280, clause 4.1.2.3] | REQUIRED | *SEQUENCE* | Identifies the signature algorithm used by the <roles:Certificate Authority (CA)\|CA> to sign the certificate. The signature algorithm SHOULD be selected according to [ETSI TS 119 312], but MAY be superseded by national recommendations. |
| `signature.algorithm` | [RFC 5280, clause 4.1.1.2] | REQUIRED | *OBJECT IDENTIFIER* | The OID of the signature algorithm. |
| `signature.parameters` | [RFC 5280, clause 4.1.1.2] | OPTIONAL | *ANY* | Algorithm-specific parameters, dependent on the algorithm used. |
| `issuer` | [ETSI EN 319 412-2, clause 4.2.3] | REQUIRED | *Name* | Identifies the entity that has signed and issued the certificate.<br><br>If the issuer is a legal person, the following attributes SHALL be present:<ul><li>`countryName` indicating the country in which the issuer of the certificate is established;</li><li>`organizationName` indicating the full registered name of the certificate issuing organization;</li><li>`commonName` indicating a name commonly used by the subject to represent itself;</li><li>conditionally, an `organizationIdentifier` if an appropriate registration number is known to exist and it has a value different from the organization name.</li></ul><br>If the issuer is a natural person, the following attributes SHALL be present:<ul><li>`countryName` indicating a country that is consistent with the legal jurisdiction under which certificates are issued;</li><li>choice of (`givenName` and/or `surname`) or `pseudonym`; if the given name or surname of the issuer is known, the respective attribute SHALL be present;</li><li>`commonName`;</li><li>`serialNumber`.</li></ul> |
| `validity` | [RFC 5280, clause 4.1.2.5] | REQUIRED | *SEQUENCE* | Time interval during which the <roles:Certificate Authority (CA)\|CA> warrants that it will maintain information about the status of the certificate. |
| `validity.notBefore` | [RFC 5280, clause 4.1.2.5] | REQUIRED | *UTCTime* or *GeneralizedTime* | The date on which the certificate validity period begins. Dates through 2049 SHALL use `UTCTime`; dates in 2050 or later SHALL use `GeneralizedTime`. |
| `validity.notAfter` | [RFC 5280, clause 4.1.2.5] | REQUIRED | *UTCTime* or *GeneralizedTime* | The date on which the certificate validity period ends. Dates through 2049 SHALL use `UTCTime`; dates in 2050 or later SHALL use `GeneralizedTime`. |
| `subject` | [ETSI EN 319 412-2, clause 4.2.4],<br>[ETSI EN 319 412-3, clause 4.2.1] | REQUIRED | *Name* | Identifies the entity associated with the public key stored in the subject public key field. If present, the size of `organizationName`, `organizationalUnitName` and `commonName` MAY be longer than the limit as stated in [RFC 5280].<br><br>If the subject is a natural person, the following attributes SHALL be present:<ul><li>`countryName` indicating the general context in which other attributes are to be understood;</li><li>choice of (`givenName` and/or `surname`) or `pseudonym`;</li><li>`commonName` indicating a name of the subject;</li><li>conditionally, `serialNumber` if the above attributes are not sufficient to ensure subject name uniqueness.</li></ul>When a natural person subject is associated with an organization, the attributes MAY also identify such organization using attributes like `organizationName` and `organizationIdentifier`.<br><br>If the subject is a legal person, the following attributes SHALL be present:<ul><li>`countryName` indicating the country in which the subject is established;</li><li>`organizationName` indicating the full registered name of the subject;</li><li>`organizationIdentifier` indicating an identification of the subject organization different from the organization name;</li><li>`commonName` indicating a name commonly used by the subject to represent itself.</li></ul> |
| `subjectPublicKeyInfo` | [RFC 5280, clause 4.1.2.7] | REQUIRED | *SEQUENCE* | Carries the public key and identifies the algorithm with which the key is used. The subject public key SHOULD be selected according to [ETSI TS 119 312] but MAY be superseded by national recommendations. |
| `subjectPublicKeyInfo.algorithm` | [RFC 5280, clause 4.1.2.7] | REQUIRED | *SEQUENCE* | The algorithm identifier for the public key. |
| `subjectPublicKeyInfo.subjectPublicKey` | [RFC 5280, clause 4.1.2.7] | REQUIRED | *BIT STRING* | The public key itself. |
| `extensions` | [RFC 5280, clause 4.1.2.9] | REQUIRED | *[3] EXPLICIT SEQUENCE* | A sequence of one or more certificate extensions. |

The `extensions` field of the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> SHALL contain various extensions, each of which is an *ASN.1 SEQUENCE* containing the following fields:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `[extension_name].extnID` | [RFC 5280, clause 4.1.2.9] | REQUIRED | *OBJECT IDENTIFIER* | The OID identifying the specific extension type. |
| `[extension_name].critical` | [RFC 5280, clause 4.1.2.9] | OPTIONAL | *BOOLEAN* | Indicates whether the extension is critical. DEFAULT is `FALSE`. |
| `[extension_name].extnValue` | [RFC 5280, clause 4.1.2.9] | REQUIRED | *OCTET STRING* | Contains the DER encoding of the ASN.1 value corresponding to the extension type identified by `extnID`. |

Below there is a list of the mandatory extensions and their content, if applicable. The column "Criticality" of the certificate extensions takes the semantics defined in [RFC 5280, clause 4.2] and uses the following acronyms:

- C: The extension SHALL be considered critical.
- NC: The extension SHALL be considered non-critical.

| Parameter | Defined in | Presence | Criticality | Format | Description |
| :-------: | :--------: | :------: | :---------: | :----- | :---------- |
| `authorityKeyIdentifier` | [ETSI EN 319 412-2, clause 4.3.1] | REQUIRED | Non-critical | *SEQUENCE* | Extension with the OID `2.5.29.35`.<br><br>Key identifier for the issuing <roles:Certificate Authority (CA)\|CA>'s public key.<br><br>Contains: `keyIdentifier` (*OCTET STRING*), `authorityCertIssuer` (*GeneralNames*), and `authorityCertSerialNumber` (*INTEGER*). |
| `keyUsage` | [ETSI EN 319 412-2, clause 4.3.2],<br>[ETSI EN 319 412-3, clause 4.3.1] | REQUIRED | Critical | *BIT STRING* | Extension with the OID `2.5.29.15`.<br><br>It SHALL be one of the following:<ol type="A"><li>non-repudiation</li><li>non-repudiation and digital signature</li><li>digital signature</li><li>digital signature and (key encipherment or key agreement)</li><li>key encipherment or key agreement</li><li>non-repudiation and digital signature and (key encipherment or key agreement)</li></ol>Type A, C, or E should be used to avoid mixed usage of keys.<br><br>Certificates issued to natural persons and used to validate commitment to signed content (e.g., documents/agreements) SHALL be limited to type A, B, or F (type A should be used).<br><br>Certificates issued to legal persons and used to validate digital signatures over content SHALL be limited to type A, B, or F (type A should be used).<br><br>Certificate issuers are invited to take into account the security implications, particularly **SC-1**, when this parameter is set up. |
| `cRLDistributionPoints` | [ETSI EN 319 412-2, clause 4.3.11] | REQUIRED (C) | Non-critical | *SEQUENCE* | Extension with the OID `2.5.29.31`.<br><br>Sequence of `distributionPoint` represented by a CHOICE of `FullName` (*GeneralNames*) or `nameRelativeToCRLIssuer`, `reasons` (*BIT STRING*), and `cRLIssuer` (*GeneralNames*).<br><br>**Applicable condition:** If the certificate does not include any access location of an <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> responder or the validity assured extension as defined in [ETSI EN 319 412-1].<br><br>It contains at least one reference to a publicly available <artifacts:Certificate Revocation List (CRL)\|Certificate Revocation List>. |
| `ext-etsi-valassured-ST-certs` | [ETSI EN 319 412-1, clause 5.2] | REQUIRED (C) | NC | *EXTENSION* | Extension with the OID `0.4.0.194121.2.1`.<br><br>**Applicable condition:** For short-term certificates which cannot be revoked.<br><br>Indicates that the certificate issuer ensures the validity of the certificate is assured at time of use of the corresponding private key. Upon presence of such statement, the WRP can decide not to check the certificate revocation status (e.g., when validating a digital signature). |
| `noRevAvail` | [RFC 9608] clause 2 | REQUIRED (C) | NC | *EXTENSION* | Extension with the OID `2.5.29.56`.<br><br>**Applicable condition:** If the certificate includes the validity assured extension, but neither includes a <artifacts:Certificate Revocation List (CRL)\|CRL> distribution point nor access location of an <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> responder. |
| `authorityInfoAccess` | [ETSI EN 319 412-2, clause 4.4.1] | REQUIRED | Non-critical | *SEQUENCE* | Extension with the OID `1.3.6.1.5.5.7.1.1`.<br><br>Sequence of `AccessDescription`, containing an `accessMethod` (OID) and an `accessLocation` (*GeneralName*).<br><br>It SHALL at least include the `id-ad-caIssuers` OID specifying at least one access location of a valid <roles:Certificate Authority (CA)\|CA> certificate of the issuing <roles:Certificate Authority (CA)\|CA>.<br><br>If <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> is supported, it SHALL include the `id-ad-ocsp` OID specifying at least one access location of an <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> responder providing status information for the present certificate.<br><br>If the certificate does not include any <artifacts:Certificate Revocation List (CRL)\|CRL> distribution point and does not include the validity assured extension, a reference to at least one <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> responder SHALL be present. |
| `certificatePolicies` | [RFC 3647, clause 3.3.1],<br>[RFC 5280, clause 4.2.1.4] | REQUIRED | NC | *SEQUENCE* | Sequence of `PolicyInformation` elements, each being a SEQUENCE of `policyIdentifier` (OID) and `policyQualifiers`.<br><br>The extension is mandatory as stated in [ETSI TS 119 411-8], requirement GEN-6.6.1-03. [ETSI TS 119 411-8] defines the following policy identifiers:<ul><li>`0.4.0.194118.1.1` for `NCP-n-eudiwrp`</li><li>`0.4.0.194118.1.2` for `NCP-l-eudiwrp`</li><li>`0.4.0.194118.1.3` for `QCP-n-eudiwrp`</li><li>`0.4.0.194118.1.4` for `QCP-l-eudiwrp`</li></ul>The `cpsURI` under Certificate policies SHALL indicate a URL where the CPS of the <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPACs> is located. |
| `subjectAltName` | [RFC 5280, clause 4.2.1.6] | REQUIRED | NC | *SEQUENCE* | Extension with the OID `2.5.29.17`.<br><br>Sequence of `GeneralName` elements, each representing a possible alternative name for the subject of the certificate.<br><br> Each `GeneralName` element contains contact information of the WRP and there SHALL be at least one element among the following:<ul><li>`uniformResourceIdentifier` indicating a website where the WRP can be contacted for helpdesk/support matters.</li><li>`otherName` with type-id `id-at-telephoneNumber` indicating a phone number for WRP registration/usage matters.</li><li>`rfc822Name` indicating an email address for WRP registration/usage matters.</li></ul>The extension is mandatory as stated in [ETSI TS 119 411-8, clause 6.6.1]. |
| `qcStatements` (esi4-qcStatement-1) | [RFC 3739, clause 3.2.6],<br>[ETSI EN 319 412-5, clause 4.2.1] | REQUIRED (C) | NC | *SEQUENCE* | `QCStatement` with the OID `0.4.0.1862.1.1`.<br><br>**Applicable condition:** For qualified certificates. It indicates that the certificate is qualified within the defined legal framework. For the eIDAS regulatory environment, the `QcCClegislation` SHALL be absent. |
| `qcStatements` (esi4-qcStatement-4) | [RFC 3739, clause 3.2.6],<br>[ETSI EN 319 412-5, clause 4.2.2] | REQUIRED (C) | NC | *SEQUENCE* | `QCStatement` with the OID `0.4.0.1862.1.4`.<br><br>**Applicable condition:** For qualified certificates. It indicates that the private key related to the certified public key resides in a QSCD according to eIDAS regulation. The extension is mandatory as stated in [ETSI EN 319 411-2, GEN-6.6.1-03]. |
| `qcStatements` (esi4-qcStatement-6) | [RFC 3739, clause 3.2.6],<br>[ETSI EN 319 412-5, clause 4.2.3] | REQUIRED (C) | NC | *SEQUENCE* | `QCStatement` with the OID `0.4.0.1862.1.6`.<br><br>**Applicable condition:** Mandatory for qualified certificates issued to legal persons for the purpose of electronic seal ([ETSI EN 319 412-5, clause 5]). MAY be present for certificates issued to natural persons for the purpose of electronic signatures.<br><br>Declares that a certificate is issued for one and only one of the purposes: electronic signature, electronic seal, or web site authentication. |

#### Examples

The following is an example of a <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> for legal persons following the <artifacts:Normalised Certificate Policy (NCP)|NCP>.

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
      countryName: "FR", 
      organizationName: "Example Trust Services CA S.A.", 
      commonName: "Example TS CA - Issuing", 
      organizationIdentifier: "VATFR-123456789" 
    }, 

    validity: { 
      notBefore: "2026-01-27T00:00:00Z", 
      notAfter:  "2027-01-27T00:00:00Z" 
    }, 

    subject: DistinguishedName {     // subject attributes for legal person 
      countryName: "FR", 
      organizationName: "Relying Party Example S.A.", 
      organizationIdentifier: "LEIXYZ-5493001KJTIIGC8Y1R12", 
      commonName: "RP Example" 
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
            policyIdentifier: "0.4.0.194118.1.2",          // NCP-l-eudiwrp (legal person) 
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
          GeneralName.uniformResourceIdentifier("https://rp.example.test/support"), 
          GeneralName.rfc822Name("wallet-support@rp.example.test"), 
          GeneralName.otherName( 
            typeId: "2.5.4.20",       // id-at-telephoneNumber 
            value: "+33-1-23-45-67-89" 
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

Below there is an example of a <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> for natural persons following the QCP policy that is short-term and therefore non-revocable.

```text
WRPAC cert = { 

  tbsCertificate: { 

    version: 2,                     // integer value 2 for v3  
    serialNumber: "0x02A94F10C3B7",
    signature: AlgorithmIdentifier { // M: per [ETSI TS 119 312] (or national) 
      oid: "1.2.840.113549.1.1.11",  // example: sha256WithRSAEncryption 
      params: NULL 
    }, 

    issuer: DistinguishedName {      // issuer attributes for legal person 
      countryName: "FR", 
      organizationName: "Qualified Trust Service Provider CA S.A.", 
      commonName: "QTSP CA - Qualified Issuing", 
      organizationIdentifier: "VATFR-987654321" 
    }, 

      validity: {                    // short-term validity 
      notBefore: "2026-01-27T10:00:00Z", 
      notAfter:  "2026-01-27T22:00:00Z" 
    }, 

    subject: DistinguishedName { 
      countryName: "FR", 
      givenName: "Alice", 
      surname: "Martin", 
      commonName: "Alice Martin", 
      serialNumber: "PNO-FR-ALICEMARTIN-839201"
    }, 

    subjectPublicKeyInfo: {
      algorithm: AlgorithmIdentifier { 
        oid: "1.2.840.10045.2.1",     // ecPublicKey 
        params: "1.2.840.10045.3.1.7" // prime256v1 
      }, 

      subjectPublicKey: "BASE64(SPKI_PUBLIC_KEY_BYTES)" 
    }, 

    extensions: [ 

      Extension {                 // authority key identifier
        oid: "2.5.29.35", 
        critical: false, 
        value: AuthorityKeyIdentifier { 
          keyIdentifier: "HEX(ISSUING_CA_KEYID)" 
        } 
      }, 

      Extension { 
        oid: "2.5.29.15",           // key usage
        critical: true, 
        value: KeyUsage { 
          nonRepudiation: true        // Type A 
        } 
      }, 

      Extension {                 // subject alternative name
        oid: "2.5.29.17", 
        critical: false, 
        value: SubjectAltName [ 
          GeneralName.rfc822Name("helpdesk@relyingparty.example.test"), 
          GeneralName.uniformResourceIdentifier("https://relyingparty.example.test/support") 
        ] 
      }, 

      Extension {                  // authority information access 
        oid: "1.3.6.1.5.5.7.1.1", 
        critical: false, 
        value: AuthorityInfoAccess [ 
          AccessDescription { 
            accessMethod: "1.3.6.1.5.5.7.48.2",  // id-ad-caIssuers 
            accessLocation: URI("https://qtsp.example.test/caIssuers/qualified-issuing-ca.cer") 
          } 
        ] 
      }, 

      Extension { 
        oid: "2.5.29.32",                      // certificate policies
        critical: false, 
        value: CertificatePolicies [ 
          PolicyInformation { 
            policyIdentifier: "0.4.0.194118.1.3",  // QCP-n-eudiwrp 
            policyQualifiers: [ 
              CPSuri("https://qtsp.example.test/cps") 
            ] 
          } 
        ] 
      }, 

      Extension { 
        oid: "0.4.0.194121.2.1",   // ext-etsi-valassured-ST-certs
        critical: false, 
        value:DER(NULL)             // (DER encoding: 0500)
      }, 

      Extension { 
        oid: "2.5.29.56",           // id-ce-noRevAvail
        critical: false, 
        value:DER(NULL)             // (DER encoding: 0500)
      }, 

      Extension { 
        oid: "1.3.6.1.5.5.7.1.3",   // qcStatements container 
        critical: false, 
        value: QCStatements [ 
          QCStatement {          // esi4-qcStatement-1
            statementId: "0.4.0.1862.1.1",
          }, 
          QCStatement { 
            statementId: "0.4.0.1862.1.4", // esi4-qcStatement-4
          }, 
          QCStatement { 
            statementId: "0.4.0.1862.1.6",  // esi4-qcStatement-6
            value: 0.4.0.1862.1.6.1  // purpose : electronicSignature
            } 
          } 
        ] 
      } 
    ] 
  }, 

  signatureAlgorithm: AlgorithmIdentifier { 
    oid: "1.2.840.113549.1.1.11", 
    params: NULL 
  }, 

  signatureValue: "BASE64(SIGN(issuerPrivateKey, DER(tbsCertificate)))" 
} 
```

#### Security Considerations

A <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> is a certificate for electronic seals or signatures that is used to authenticate and validate a WRP when interacting with <components:Wallet Unit|Wallet Units>. Because the corresponding private key is a signature/seal key, implementations SHALL prevent the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> key from becoming a general-purpose signing oracle.

**SC-1 — No blind signing of attacker-controlled inputs.**
The WRP (and any remote signing component used on its behalf, e.g., HSM/QSCD/remote seal) should only sign well-defined, locally constructed protocol artefacts and should not sign arbitrary bytes received from outside (e.g., *random* <data-elements:Nonce|nonces>, hashes, or opaque challenges supplied by an attacker).
For instance, when the interaction with the <components:Wallet Unit> takes plase as described in the protocol [OpenID4VP], the WRP signs a self-constructed <artifacts:Request Object>. Before signing, the WRP SHOULD validate that the <artifacts:Request Object> is fully context-bound (e.g., correct `aud`, `client_id`/`iss`, `exp`, `nonce`, and correct endpoint binding such as `response_uri`/`redirect_uri`, and the intended presentation definition). Any signing API should enforce a strict schema/allowlist and reject unexpected fields. This is particularly important when the key usage is set to non-repudiation, since this protects against the signing entity falsely denying some action and allows a reliable third party to determine the authenticity of signed data in case of later conflict.

**SC-2 — Bind signatures to the intended protocol context.**
Signed protocol objects should be clearly typed and scoped to the protocol to reduce *cross-context* misuse. In particular:

- Use an explicit JOSE `typ` value appropriate for secured authorization requests / OpenID4VP <artifacts:Request Object|Request Objects>.
- Constrain accepted JOSE algorithms and key types, and reject insecure or unexpected values (e.g., `alg=none`).

**SC-3 — Key protection, access control, and monitoring.**
Private keys corresponding to <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs> SHOULD be protected and operated under strong controls (access control for key use, audit logging, incident response, and operational monitoring). For remote signing, apply rate limiting and anomaly detection to reduce abuse.
