# Access Certificate

## Introduction
This section describes the purpose, format and content of wallet-relying party access certificates.

According to the Article 2 of CIR (EU) 2025/848, a wallet-relying party access certificate (access certificate), is a certificate for electronic seals or signatures authenticating and validating the wallet-relying party.
Issued by a designated provider under Member State supervision, the access certificate serves to authenticate and verify the trustworthiness of the wallet-relying parties when they interact with the EUDI wallet.
The suspension or cancellation of the relying party services, involves revocation of all valid access certificates by the relevant issuing authority, such that the relying party is no longer able to interact with wallet units.

The Annex IV of CIR (EU) 2025/848 also states that the access certificates are meant for performing electronic signatures or seals and that they shall comply with at least the normalised certificate policy (‘NCP’) requirements specified in the ETSI standards. Taking into account these minimal requirements, different scenarios are possible and specified in the following clauses: certificates issued to natural or legal persons, supporting advanced signatures/seals or even qualified signature/seals. Conditional requirements are defined according to the specific case the access certificates fall into.  

## References

To guarantee the interoperability across all the wallets provided within the Union, wallet-relying party access certificates should adhere to common requirements, with regards to their content and format. The technical standard specific to these certificates is ETSI TS 119 411-8. However, multiple other standards are referenced either directly or indirectly by the ETSI TS 119 411-8, containing requirements that are applicable to access certificates as well. The list below enumerates all the applicable standards and specifications that have been used to populate the table below:
-	[ETSI TS 119 411-8](https://www.etsi.org/deliver/etsi_ts/119400_119499/11941108/01.01.01_60/ts_11941108v010101p.pdf)
-	[ETSI EN 319 411-1](https://www.etsi.org/deliver/etsi_en/319400_319499/31941101/01.05.01_60/en_31941101v010501p.pdf)
-	[ETSI EN 319 411-2](https://www.etsi.org/deliver/etsi_en/319400_319499/31941102/02.06.01_60/en_31941102v020601p.pdf) applicable if the certificate is qualified
-	[ETSI EN 319 412-1](https://www.etsi.org/deliver/etsi_en/319400_319499/31941201/01.06.01_60/en_31941201v010601p.pdf)
-	[ETSI EN 319 412-2](https://www.etsi.org/deliver/etsi_en/319400_319499/31941202/02.04.01_60/en_31941202v020401p.pdf) applicable if the certificate is issued to natural persons
-	[ETSI EN 319 412-3](https://www.etsi.org/deliver/etsi_en/319400_319499/31941203/01.03.01_60/en_31941203v010301p.pdf) applicable if the certificate is issued to legal persons
-	[ETSI EN 319 412-5](https://www.etsi.org/deliver/etsi_en/319400_319499/31941205/02.05.01_60/en_31941205v020501p.pdf) applicable if the certificate is qualified
-	[RFC 5280](https://datatracker.ietf.org/doc/html/rfc5280)
-	[RFC 3647](https://datatracker.ietf.org/doc/html/rfc3647)
-	[RFC 3739](https://datatracker.ietf.org/doc/html/rfc3739)
-	[RFC 9608](https://datatracker.ietf.org/doc/html/rfc9608)
-	[CIR (EU) 2025/848](https://eur-lex.europa.eu/eli/reg_impl/2025/848/oj/eng)

## Dependency considerations
The wallet relying party access certificates attributes shall be derived from the information held in the register as specified in clause 5.1.2 of ETSI TS 119 475. This also implies that for some specific attributes in the access certificate the same value shall be encountered in the correponding registration certificate if any.

## Access certificate contents
The following table lists all the parameters and extensions that are mandatory in a certificate or mandatory with conditions. Optional parameters are not referenced and are  not recommended, since they could cause conflicts with the content specified.

The column "Presence" contains the specification of the presence of the certificate parameter as follows:
* M: Mandatory. The parameter shall be present.
* M(C): Conditionally mandatory. The parameter shall be present if the condition specified in the "Description" column is fulfilled.
* R(C): Conditionnaly recommended. The parameter should be present if the condition specified in the "Description" column is fulfilled.

The column "Criticality" of the certificate extensions takes the semantics defined in RFC 5280 clause 4.2 and uses the following accronyms:
* C: The extension shall be considered critical.
* NC: The extension shall be considered non-critical.

| Parameter | Defined in | Presence | Criticality | Format | Description |
| :-------: | :--------: | :------: | :---------: | :----- | :---------- |
| version | RFC 5280 clause 4.1.2.1 | M |  | INTEGER | Shall be v3. |
| signature | RFC 5280 clause 4.1.2.3 | M |  | ASN.1 SEQUENCE containing:<ul><li>*algorithm*: OID field</li><li>*parameters* field, OPTIONAL of type ANY, dependending on the algorithm used</li></ul> | Signature algorithm should be selected according to ETSI TS 119 312, but can be superseded by national recommendations. |
| issuer | ETSI EN 319 412-2 clause 4.2.3 | M |  | X.501 type *Name*;<br>The Name describes a hierarchical name composed of attributes, each attribute being a ASN.1 SEQUENCE containing an *AttributeType* (OID field) and *AttributeValue*. The type of the component *AttributeValue* is determined by the *AttributeType*; in general it will be a DirectoryString. | If the issuer is a legal person, the following attributes shall be present: <ul><li>*countryName* indicating the country in which the issuer of the certificate is established</li><li>*organizationName* indicating the full registered name of the certificate issuing organization</li><li>*commonName* indicating a name commonly used by the subject to represent itself</li><li>conditionally, an *organizationIdentifier* if an appropriate registration number is known to exist and it has a value different from the organization name</li></ul><br/>If the issuer is a natural person, the following attributes shall be present: <ul><li>*countryName* indicating a country that is consistent with the legal jurisdiction under which certificates are issued</li><li>choice of (*givenName* and/or *surname*) or *pseudonym*; in case of the (*givenName* and/or *surname*) alternative: if the given name of the issuer is known, then the *givenName* attribute shall be present and if the surname of the issuer is known, then the *surname* attribute shall be present</li><li>*commonName*</li><li>*serialNumber*</li></ul> |
| validity | RFC 5280 clause 4.1.2.5 | M |  | ASN.1 SEQUENCE composed of two dates: the date on which the certificate validity period begins (*notBefore*) and the date on which the certificate validity period ends (*notAfter*). Certificate validity dates through the year 2049 MUST be encoded as UTCTime; certificate validity dates in 2050 or later MUST be encoded as GeneralizedTime. | Time interval during which the CA warrants that it will maintain information about the status of the certificate. |
| subject | ETSI EN 319 412-2 clause 4.2.4 and <br/>ETSI EN 319 412-3 clause 4.2.1 | M |  | X.501 type *Name*;<br>The Name describes a hierarchical name composed of attributes, each attribute being a ASN.1 SEQUENCE containing an *AttributeType* (OID field) and *AttributeValue*. The type of the component *AttributeValue* is determined by the *AttributeType*; in general it will be a DirectoryString.</br></br>If present, the size of *organizationName*, *organizationalUnitName* and *commonName* may be longer than the limit as stated in IETF RFC 5280.| If the subject is a natural person, the following attributes shall be present: <ul><li>*countryName* indicating the general context in which other attributes are to be understood; the verifier may have to consult the certificate policy of the issuer to determine the exact semantics of this attribute</li><li>choice of (*givenName* and/or *surname*) or *pseudonym*; in case of the (*givenName* and/or *surname*) alternative: if the given name of the issuer is known, then the *givenName* attribute shall be present and if the surname of the issuer is known, then the *surname* attribute shall be present </li><li>*commonName* indicating a name of the subject</li><li>conditionally, *serialNumber* if the above attributes are not sufficient to ensure subject name uniqueness within the context of the issuer; it may contain a number or a code for the purpose of ensuring uniqueness</li></ul>If the subject is a natural person, the following attributes may be present:<ul><li>conditionally, when a natural person subject is associated with an organization, the subject attributes may also identify such organization using attributes such as *organizationName* and *organizationIdentifier*</li></ul>If the subject is a legal person, the following attributes shall be present: <ul><li>*countryName* indicating the country in which the subject is established</li><li>*organizationName* indicating the full registered name of the subject</li><li>*organizationIdentifier* indicating an identification of the subject organization different than the organization name, taking into account to use the ISO 3166-1 country code "EL" when referring to Greece where applicable.</li><li>*commonName* indicating a name commonly used by the subject to represent itself, that does not need to be an exact match of the fully registered organization name</li></ul> |
| subject public key info | RFC 5280 clause 4.1.2.7 | M |  | ASN.1 SEQUENCE containing two fields: the *algorithm* SEQUENCE and the *subjectPublicKey* BIT STRING. | The subject public key should be selected according to ETSI TS 119 312 but can be superseded by national recommendations. |
| **Extensions** |  | M |  | ASN.1 SEQUENCE of *Extension* fields.<br><br>An *Extension* is an ASN.1 SEQUENCE containing *extnID* as an OID field, *critical* field as a BOOLEAN and *extnValue*, OCTET STRING containing the DER encoding of the ASN.1 value corresponding to the extension type identified by *extnID*. |  |
| authority key identifier | ETSI EN 319 412-2 clause 4.3.1 | M | NC | Extension *AuthorityKeyIdentifier* is an ASN.1 SEQUENCE that contains: *keyIdentifier* as an OCTET STRING, *authorityCertIssuer* encoded as GeneralNames, *authorityCertSerialNumber* encoded as an INTEGER. | Key identifier for the issuing CA's public key. |
| key usage | ETSI EN 319 412-2 clause 4.3.2 and <br/>ETSI EN 319 412-3 clause 4.3.1 | M | C | Extension *KeyUsage* is encoded as a BIT STRING. | Shall be one of the following: <ol type="A"><li>non-repudiation</li><li>non-repudiation and digital signature</li><li>digital signature</li><li>digital signature and (key encipherment or key agreement)</li><li>key encipherment or key agreement</li><li>non-repudiation and digital signature and (key encipherment or key agreement)</li></ol>Type A, C or E should be used to avoid mixed usage of keys.<br/>Certificates issued to natural persons and that are used to validate commitment to signed content (e.g. documents, agreements and/or transactions) shall be limited to type A, B or F, in which case type A should be used.<br/>Certificates issued to legal persons and that are used to validate digital signatures over content (e.g. documents, agreements and/or transactions) that provide evidence of origin and integrity of the content shall be limited to type A, B or F, in which case type A should be used. |
| CRL distribution points | EN 319 412-2 clause 4.3.11 | M(C) | NC | Extension *CRLDistributionPoints* is an ASN.1 SEQUENCE of *distributionPoint* represented by a CHOICE of *FullName* encoded as GeneralNames or *nameRelativeToCRLIssuer* encoded as a set of attribute types and values , *reasons* encoded as a BIT STRING and *cRLIssuer* encoded as GeneralNames.  | Applicable condition: if the certificate does not include any access location of an OCSP responder or the validity assured extension as defined in ETSI EN 319 412-1.<br>It contains at least one reference to a publicly available CRL. |
| ext-etsi-valassured-ST-certs | ETSI EN 319 412-1 clause 5.2 | R(C) | NC | Extension with the OID 0.4.0.194121.2.1. | Applicable condition: for short-term certificates which cannot be revoked.<br/>The extension indicates that the certificate issuer ensures that the validity of the certificate is assured at time of use of the corresponding private key. Upon presence of such statement in the certificate, the relying party can decide not to check the certificate revocation status, for example, when validating a digital signature. |
| no revocation available | RFC 9608 clause 2 | M(C) | NC | Extension with the OID 2.5.29.56. | Applicable condition: if the certificate includes the validity assured extension, but neither include a CRL distribution point nor access location of an OCSP responder. |
| authority information access | ETSI EN 319 412-2 clause 4.4.1 | M | NC | Extension *AuthorityInfoAccess* that is an ASN.1 SEQUENCE of *AccessDescription*, containing an *accessMethod* as an OID and an *accessLocation* encoded as a GeneralName. | It shall at least include the *id-ad-caIssuers* OID with an *accessLocation* value specifying at least one access location of a valid CA certificate of the issuing CA.<br/>If OCSP is supported, it shall include the *id-ad-ocsp* OID, with an *accessLocation* value specifying at least one access location of an OCSP responder providing status information for the present certificate.<br/>If the certificate does not include any CRL distribution point and does not include the validity assured extension, a reference to at least one OCSP responder shall be present. |
| Certificate Policies | RFC 3647, clause 3.3.1 and RFC 5280, clause 4.2.1.4 | M | NC | Extension *CertificatePolicies* that is an ASN.1 SEQUENCE of *PolicyInformation*, that is also a SEQUENCE of *policy* OID and *policyQualifiers*. | <br/>Possible values for the policy identifier are: the applicable identifier defined in clause 5.3 of TS 119 411-8 and/or an identifier defined by the appropriate stakeholder or certificate issuer.<br/>The extension is mandatory as stated in ETSI TS 119 411-8, requirement GEN-6.6.1-03.<br/>TS 119 411-8 defines the following policy identifiers: <ul><li>0.4.0.194118.1.1 for NCP-n-eudiwrp (normalized certificate policy for wallet-relying party access certificates issued to natural persons)</li><li>0.4.0.194118.1.2 for NCP-l-eudiwrp (normalized certificate policy for wallet-relying party access certificates issued to legal persons)</li><li>0.4.0.194118.1.3 for QCP-n-eudiwrp (qualified certificate policy for wallet-relying party access certificates issued to natural persons)</li><li>0.4.0.194118.1.4 for QCP-l-eudiwrp (qualified certificate policy for wallet-relying party access certificates issued to legal persons)</li></ul></ul>The *cpsURI* under Certificate policies shall indicate a URL where the CPS of the provider of relying party access certificates is. |
| subject alternative name | RFC 5280 clause 4.2.1.6 | M | NC | Extension *SubjectAltName* encoded as GeneralNames. | This contains contact information of the relying party and shall be at least one of the following: <ul><li>GeneralName type *uniformResourceIdentifier* indicating a website where the relying party can be contacted for matters pertaining to provision of helpdesk and support</li><li>GeneralName type *otherName* with the type-id *id-attelephoneNumber* as defined in Recommendation ITU-T X.520, clause 6.7.1, indicating a phone number where the relying party can be contacted for matters pertaining to its registration and intended use of the wallet units</li><li>GeneralName type *rfc822Name* indicating an email address where the relying party can be contacted for matters pertaining to its registration and intended use of the wallet unit</li></ul>.<br/>The extension is mandatory as stated in ETSI S 119 411-8 clause 6.6.1. |
| qcStatements: esi4-qcStatement-1 | RFC 3739 clause 3.2.6 and <br/>ETSI EN 319 412-5, clause 4.2.1 | M(C) | NC | QCStatement with the OID 0.4.0.1862.1.1 | Applicable condition: for qualified certificates.<br/>It indicates that the certificate is qualified within the defined legal framework.<br/>For the eIDAS regulatory environment, the *QcCClegislation* shall be absent. |
| qcStatements: esi4-qcStatement-4 | RFC 3739 clause 3.2.6 and <br/>ETSI EN 319 412-5, clause 4.2.2 | M(C) | NC | QCStatement with the OID 0.4.0.1862.1.4 | Applicable condition: for qualified certificates.<br/>It indicates that the private key related to the certified public key resides in a QSCD according to eIDAS regulation.<br/>The extension is mandatory as stated in ETSI EN 319 411-2, GEN-6.6.1-03. |
| qcStatements: esi4-qcStatement-6 | RFC 3739 clause 3.2.6 and <br/>ETSI EN 319 412-5, clause 4.2.3 | M(C) | NC | QCStatement with the OID 0.4.0.1862.1.6 | Applicable condition: for qualified certificates issued to legal persons, for the purpose of electronic seal.<br/>For certificates issued to natural persons for the purpose of electronic signatures, this QCStatement may be present.<br/>This QCStatement declares that a certificate is issued as one and only one of the purposes of electronic signature, electronic seal or web site authentication.<br/>The extension is mandatory for qualified certificates issued for the purpose of electronic seal as stated in ETSI EN 319 412-5, clause 5. |

## Examples (Informative)

### Example of an access certificate for legal persons following the NCP policy

```

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

### Example of an access certificate for natural persons following the QCP policy that is short-term and therefore non-revocable

``` 
AccessCertificate cert = { 

  tbsCertificate: { 

    version: 2,                     // integer value 2 for v3  
    serialNumber: "0x02A94F10C3B7",
    signature: AlgorithmIdentifier { // M: per ETSI TS 119 312 (or national) 
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

      Extension {					            // authority key identifier
        oid: "2.5.29.35", 
        critical: false, 
        value: AuthorityKeyIdentifier { 
          keyIdentifier: "HEX(ISSUING_CA_KEYID)" 
        } 
      }, 

      Extension { 
        oid: "2.5.29.15",			        // key usage
        critical: true, 
        value: KeyUsage { 
          nonRepudiation: true        // Type A 
        } 
      }, 

      Extension {				            	// subject alternative name
        oid: "2.5.29.17", 
        critical: false, 
        value: SubjectAltName [ 
          GeneralName.rfc822Name("helpdesk@relyingparty.example.test"), 
          GeneralName.uniformResourceIdentifier("https://relyingparty.example.test/support") 
        ] 
      }, 

      Extension {	              			// authority information access 
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
        oid: "2.5.29.32", 	                    // certificate policies
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
        oid: "0.4.0.194121.2.1",	 	// ext-etsi-valassured-ST-certs
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
          QCStatement {				      // esi4-qcStatement-1
            statementId: "0.4.0.1862.1.1",
          }, 
          QCStatement { 
            statementId: "0.4.0.1862.1.4", // esi4-qcStatement-4
          }, 
          QCStatement { 
            statementId: "0.4.0.1862.1.6", 	// esi4-qcStatement-6
            value: 0.4.0.1862.1.6.1		// purpose : electronicSignature
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
