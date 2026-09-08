```text
OCSPResponse:
  responseStatus = successful (0)
  responseBytes:
    responseType = id-pkix-ocsp-basic
    response = DER(BasicOCSPResponse)
      BasicOCSPResponse: 
        tbsResponseData:
          version = v1
          responderID"
            byName: 
             CN = Example OCSP Responder
             O  = Example CA
             C  = CZ
          producedAt = 20250101000000Z
          responses = SEQUENCE OF
            SingleResponse:
              certID:
                hashAlgorithm  = sha1
                issuerNameHash = SHA1( DER-encode(issuer Name) )
                issuerKeyHash  = SHA1( issuer SubjectPublicKey BIT STRING )
                serialNumber   = 0x01A2B3C4D5
              certStatus  = good
              thisUpdate  = 20250101000000Z
              nextUpdate  = 20250102000000Z
              singleExtensions = absent
          responseExtensions:
            nonce = OCTET STRING (nonce)
        signatureAlgorithm = sha256WithRSAEncryption
        signature          = BIT STRING (signature over hash(DER(tbsResponseData)))
        certs              = SEQUENCE OF
            Certificate (responder’s cert, possibly with its issuing CA cert)
```