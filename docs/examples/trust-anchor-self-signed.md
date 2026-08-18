```text
AccessCertificate trustAnchor = {
  tbsCertificate: {
    version: 2,                                           // Integer value 2 for v3
    serialNumber: "0x9D846F726A8..",

    signature: AlgorithmIdentifier {
      oid: "1.2.840.113549.1.1.11",                       // sha256WithRSAEncryption
      params: NULL
    },

    issuer: DistinguishedName {
      countryName: "CZ",
      organizationName: "Example Entity Trust Anchor CA",
      commonName: "Example Entity Trust Anchor Root",
      organizationIdentifier: "VATCZ-123456789"
    },

    validity: {
      notBefore: "2026-01-01T00:00:00Z",
      notAfter:  "2031-01-01T00:00:00Z"
    },

    subject: DistinguishedName {                          // SHALL match the Issuer
      countryName: "CZ",
      organizationName: "Example Entity Trust Anchor CA",
      commonName: "Example Entity Trust Anchor Root",
      organizationIdentifier: "VATCZ-123456789"
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
        value: SubjectKeyIdentifier [
          keyIdentifier: "SHA-1(SUBJECT_PUBLIC_KEY_VALUE)"
        ]
      },

      Extension {
        oid: "2.5.29.15",                                 // keyUsage
        critical: true,
        value: KeyUsage {
          keyCertSign: true,
          cRLSign: true
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
      }      
    ]
  },

  signatureAlgorithm: AlgorithmIdentifier {
    oid: "1.2.840.113549.1.1.11",                         // Must match/align with tbsCertificate.signature
    params: NULL
  },

  signatureValue: "BASE64(SIGN(issuerPrivateKey, DER(tbsCertificate)))"
}
```