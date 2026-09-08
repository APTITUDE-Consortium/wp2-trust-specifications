```text
OCSPRequest:
  tbsRequest:
    version = v1
    requestList = SEQUENCE OF
      Request:
        reqCert:
          hashAlgorithm:
            algorithm  = sha256
            parameters = null
          issuerNameHash = SHA256( DER-encode(Issuer Name) )
          issuerKeyHash  = SHA256( Issuer SubjectPublicKey BIT STRING )
          serialNumber   = 0x01A2B3C4D5
    requestExtensions:
      nonce = OCTET STRING (nonce)
```