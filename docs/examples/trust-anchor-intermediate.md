```text
AccessCertificate trustAnchor = {
  tbsCertificate: {
    version: 2,                                           // Integer value 2 for v3
    serialNumber: "0x736A63D6352..",

    signature: AlgorithmIdentifier {
      oid: "1.2.840.113549.1.1.11",                       // sha256WithRSAEncryption
      params: NULL
    },

    issuer: DistinguishedName {
      countryName: "CZ",
      organizationName: "Example Root CA",
      commonName: "Example Root",
      organizationIdentifier: "VATCZ-987654321"
    },

    validity: {
      notBefore: Time.utcTime("260127000000Z"),
      notAfter: Time.utcTime("270127000000Z")
    },

    subject: DistinguishedName {
      countryName: "CZ",
      organizationName: "Example Entity Trust Anchor CA",
      commonName: "Example Entity Trust Anchor (Pinned Intermediate)",
      organizationIdentifier: "VATCZ-123481789"
    },

    subjectPublicKeyInfo: {
      algorithm: AlgorithmIdentifier {
        oid: "1.2.840.113549.1.1.1",                      // rsaEncryption
        params: NULL
      },

      subjectPublicKey: "BASE64(SPKI_PUBLIC_KEY_BYTES)"
    },

    extensions: [
      Extension {
        oid: "2.5.29.35",                                 // authorityKeyIdentifier
        critical: false,
        value: AuthorityKeyIdentifier {
          keyIdentifier: "SHA-1(ISSUER_PUBLIC_KEY_VALUE)"
        }
      },

      Extension {
        oid: "2.5.29.14",                                 // subjectKeyIdentifier
        critical: false,
        value: SubjectKeyIdentifier("SHA-1(SUBJECT_PUBLIC_KEY_VALUE)")
      },

      Extension {
        oid: "2.5.29.15",                                 // keyUsage
        critical: true,
        value: KeyUsage {
          keyCertSign: true
          // All other bits set to false
        }
      },

      Extension {
        oid: "2.5.29.19",                                 // basicConstraints
        critical: true,
        value: BasicConstraints {
          cA: true,
          pathLenConstraint: 0
        }
      },

      Extension {
        oid: "1.3.6.1.5.5.7.1.1",                         // authorityInfoAccess
        critical: false,
        value: AuthorityInfoAccess [
          AccessDescription {
            accessMethod: "1.3.6.1.5.5.7.48.2",           // id-ad-caIssuers
            accessLocation: GeneralName.uniformResourceIdentifier("http://ca.example.test/caIssuers/issuing-ca.cer")
          }
        ]
      }
    ]
  },

  signatureAlgorithm: AlgorithmIdentifier {
    oid: "1.2.840.113549.1.1.11",                         // SHALL match/align with tbsCertificate.signature
    params: NULL
  },

  signatureValue: "BASE64(SIGN(issuerPrivateKey, DER(tbsCertificate)))"
}
```
