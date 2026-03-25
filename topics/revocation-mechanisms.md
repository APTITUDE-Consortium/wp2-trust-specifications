# Revocation Mechanisms

This section describes the artifacts, respective formats and parameters, that are employed in [Trust Management Process](trust-management-process.md) to manage the status of certificates and entities. The main distinction is the following:
  * To manage WRPAC, each Provider of WRPAC SHALL:
    - make available the necessary endpoints for at least one between [Certificate Revocation Lists](#certificate-revocation-lists) and [Online Certificate Status Protocol](#online-certificate-status-protocol);
    - issue Access Certificates with at least an extension corresponding to the provided revocation mechanism as illustrated in [Access Certificate](access-certificate.md).
  * To manage WRPRC, each Provider of WRPRC SHALL:
    - make available an endpoint to request Status [List Tokens](#status-list-token);
    - issue Registration Certificates with the appropriate parameter `status` as described in [Registration Certificates](registration-certificate.md).

## Token Status List

This section defines a Status List data structure, which is used to convey information regarding the individual statuses of multiple Wallet Relying Party Registration Certificates (WRPRC). A Status List describes the status of the WRPRCs by encoding their validity in a bit array. Each WRPRC is allocated an index during issuance; this index represents its position within the bit array. The value of the bit(s) at this index corresponds to the WRPRC's status. A Status List is provided within a cryptographically signed Status List Token in JWT format. 

In this specification, the roles of the Provider of WRPRC and Status Issuer (i.e., the entity that issues the Status List Token about the status information of the WRPRC) SHALL coincide. Moreover, the Status Provider (i.e., the entity that provides the Status List Token on a public endpoint) SHALL be the Provider of WRPRC itself.

The Provider of WRPRC MUST:
  * Define a number of bits, $k$, (either 1, 2, 4, or 8) that represents the amount of bits used to describe the status of each WRPRC within this Status List. The Provider of WRPRC MUST configure this number. Each WRPRC will therefore have $2^k$ possible states.
  * Create a byte array of size $\geq$ (expected number of WRPRCs) * $k$ / 8. Depending on $k$, each byte in the array corresponds to 8/$k$ statuses (8 if $k=1$, 4 if $k=2$, 2 if $k=4$, or 1 if $k=8$). Each time a WRPRC is issued, the Provider of WRPRC assigns it to a position in the array.
  * Set the status values for all issued WRPRCs within the byte array. The status of each WRPRC is identified using an index that maps to one or more specific bits within the byte array. The index starts counting at 0 and ends with (number of WRPRC) - 1. All bits of the byte array at a particular index are set to a status value.
  * Compress the byte array using DEFLATE [RFC 1951](https://datatracker.ietf.org/doc/html/rfc1951) with the ZLIB [RFC 1950](https://datatracker.ietf.org/doc/html/rfc1950) data format. Implementations are RECOMMENDED to use the highest compression level available.
  * Make an endpoint available to Wallet Units to request Status Lists Tokens.

The Provider of WRPRC MUST use the following values for the possible statuses of the issued WRPRCs:
  * `0x00` - `VALID` - The WRPRC is valid.
  * `0x01` - `INVALID` - The WRPRC is revoked.

For example, if two states for a certain WRPRC are possible, then $k=1$. If the Credential Issuer creates an array to store the statuses of 6 WRPRCs, whose validity statuses are 0, 0, 0, 1, 1, 0, respectively; then:
  * The bit array can be of the form `a=[0, 0, 0, 0, 0, 0, 0, 0; 0, 0, 1, 1, 0, 0, 0, 0; 0, 0, 1, 0, 0, 0, 0, 1]` which, in hexadecimal notation, corresponds to the byte array `[0x00, 0x30, 0x21]`.
  * The status values are encoded in specific bit positions based on their assigned index.
  * The array is then compressed using DEFLATE.

> _**Note:**_
> When the Provider of WRPRC chooses the number of bits for conveying statuses of the WRPRCs it issues, it MAY add other states besides those described above. The addition of many different states for the lifecycle of a WRPRC must, however, be carefully pondered, as it discloses information to Relying Parties.

Once the Wallet Unit receives a WRPRC, it can request the Status List to validate its status through the provided URI parameter and look up the corresponding index in the list.

### Status List Token

The **Status List Token** (SLT) is available at the Status List Endpoint. It is formatted as a JSON Web Token (JWT) signed by the Provider of WRPRC and contains the following parameters:

#### Status List Token Header

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----: | :---------- |
| `alg` | RFC 7515 | REQUIRED | *String* | A digital signature algorithm identifier per the IANA "JSON Web Signature and Encryption Algorithms" registry. It MUST NOT be set to `none` or to a symmetric algorithm (MAC) identifier. |
| `typ` | RFC 7515 | REQUIRED | *String* | Specifies the type of the Web Token. It MUST be set to `statuslist+jwt`. |
| `x5c` | RFC 7515 | REQUIRED | *Array of Strings* | Contains the Base64-encoded certificate chain required to verify the SLT's signature. |

#### Status List Token Payload

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----: | :---------- |
| `sub` | RFC 7519 | REQUIRED | *String* | The subject claim MUST specify the URI of the SLT. The value MUST be equal to that of the `uri` claim contained in the `status_list.uri` claim of the WRPRC. |
| `iat` | RFC 7519 | REQUIRED | *NumericDate* | A standard timestamp indicating when the SLT was issued. |
| `exp` | RFC 7519 | REQUIRED | *NumericDate* | A standard timestamp indicating when the SLT expires. |
| `status_list` | OAuth Status List Draft | REQUIRED | *JSON Object* | A JSON Object that contains the Status List configurations and payload. |
| `status_list.bits` | OAuth Status List Draft | REQUIRED | *Integer* | Specifies the number of bits per WRPRC in the compressed byte array. The allowed values are 1, 2, 4, and 8. |
| `status_list.lst` | OAuth Status List Draft | REQUIRED | *Base64url-encoded String* | Contains the status values for all the WRPRCs. The value MUST be the base64url-encoded compressed byte array. |

The following is an example of the Status List Token payload and header prior to signing and base64url encoding:

**Header:**
```json
{
  "alg": "ES256",
  "typ": "statuslist+jwt",
  "x5c": [
    "MIIDqjCCApKgAwIBAgIESLNEvDA...",
    "MIICwzCCAasCCQCKVy9eKjvi+jA...",
    "MIIDTDCCAjSgAwIBAgIJAPlnQYH..."
  ]
}
```
**Payload:**
```json
{
  "exp": 2291720170,
  "iat": 1686920170,
  "sub": "https://example-issuer.com/statuslists/",
  "status_list": {
    "bits": 1,
    "lst": "eNrbuRgAAhcBXQ"
  }
}
```

## Certificate Revocation Lists

Certificate Revocation Lists (CRLs) MAY be used in a wide range of applications and environments covering a broad spectrum of interoperability goals and an even broader spectrum of operational and assurance requirements. 

**CRL issuers** issue CRLs. The CRL issuer is either the Certificate Authority (CA) or an entity that has been authorized by the CA to issue CRLs. 

> _**Note:**_ 
> Within APTITUDE the CRL Issuer SHALL be the Trust Anchor. 

CAs publish CRLs to provide status information about the certificates they issued. Each CRL has a particular scope. The CRL scope is the set of certificates that could appear on a given CRL. For example, the scope could be "all certificates issued by CA X". A complete CRL lists all unexpired certificates, within its scope, that have been revoked for one of the revocation reasons covered by the CRL scope.

The CRL issuer MAY also generate delta CRLs. A delta CRL only lists those certificates, within its scope, whose revocation status has changed since the issuance of a referenced complete CRL. The referenced complete CRL is referred to as a base CRL. The scope of a delta CRL MUST be the same as the base CRL that it references.

An X.509 v2 CRL is represented as the ASN.1 DER encoding of the `CertificateList` SEQUENCE. The ASN.1 DER encoding is a strictly defined tag, length, and value encoding system for each element. The final bytes transmitted represent the DER encoding of the top-level SEQUENCE containing the fields in the following table:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `tbsCertList` | RFC 5280 clause 5.1.1.1 | REQUIRED | *SEQUENCE* | Contains the core CRL information including the name of the issuer, issue date, next update date, the optional list of revoked certificates, and optional CRL extensions. |
| `signatureAlgorithm` | RFC 5280 clause 5.1.1.2 | REQUIRED | *SEQUENCE* | Contains the algorithm identifier for the algorithm used by the CRL issuer to sign the `CertificateList`. Selection SHOULD align with relevant standards (e.g., ETSI TS 119 312). |
| `signatureAlgorithm.algorithm` | RFC 5280 clause 4.1.1.2 | REQUIRED | *OBJECT IDENTIFIER* | The OID of the signature algorithm. |
| `signatureAlgorithm.parameters` | RFC 5280 clause 4.1.1.2 | OPTIONAL | *ANY* | Algorithm-specific parameters, dependent on the signature algorithm used. |
| `signatureValue` | RFC 5280 clause 5.1.1.3 | REQUIRED | *BIT STRING* | Contains the digital signature computed upon the ASN.1 DER encoded `tbsCertList`. |

### Certificate List Content

The `TBSCertList` (To Be Signed Certificate List) is an ASN.1 SEQUENCE containing several fields and extensions. The following table lists all such fields and extensions that are required in a CRL or conditionally required.

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `version` | RFC 5280 clause 5.1.2.1 | OPTIONAL | *INTEGER* | Describes the version of the encoded CRL. When extensions are used (as is standard practice), this field MUST be present and MUST specify version 2 (the integer value is `1`). |
| `signature` | RFC 5280 clause 5.1.2.2 | REQUIRED | *SEQUENCE* | The algorithm identifier for the algorithm used to sign the CRL. |
| `signature.algorithm` | RFC 5280 clause 4.1.1.2 | REQUIRED | *OBJECT IDENTIFIER* | The OID of the signature algorithm. MUST match the `signatureAlgorithm` field in the parent `CertificateList` sequence. |
| `signature.parameters` | RFC 5280 clause 4.1.1.2 | OPTIONAL | *ANY* | Algorithm-specific parameters, dependent on the algorithm used. |
| `issuer` | RFC 5280 clause 5.1.2.3 | REQUIRED | *Name* | Identifies the entity that has signed and issued the CRL. It MUST contain a non-empty X.500 distinguished name (DN) composed of `AttributeType` (OID) and `AttributeValue` sequences. |
| `thisUpdate` | RFC 5280 clause 5.1.2.4 | REQUIRED | *UTCTime* or *GeneralizedTime* | Indicates the issue date of this CRL. Dates through 2049 MUST use `UTCTime`; dates in 2050 or later MUST use `GeneralizedTime`. |
| `nextUpdate` | RFC 5280 clause 5.1.2.5 | REQUIRED | *UTCTime* or *GeneralizedTime* | Indicates the date by which the next CRL will be issued. Dates through 2049 MUST use `UTCTime`; dates in 2050 or later MUST use `GeneralizedTime`. |
| `revokedCertificates` | RFC 5280 clause 5.1.2.6 | OPTIONAL | *SEQUENCE OF* | A sequence of revoked certificates. When there are no revoked certificates, this field MUST be absent. |
| `revokedCertificates.userCertificate` | RFC 5280 clause 5.1.2.6 | REQUIRED | *INTEGER* | The `CertificateSerialNumber` of the revoked certificate. |
| `revokedCertificates.revocationDate` | RFC 5280 clause 5.1.2.6 | REQUIRED | *UTCTime* or *GeneralizedTime* | The date on which the revocation occurred. |
| `revokedCertificates.crlEntryExtensions` | RFC 5280 clause 5.1.2.6 | OPTIONAL | *SEQUENCE OF* | Extensions specific to this revoked certificate entry. If present, the CRL `version` MUST be `v2`. |
| `crlExtensions` | RFC 5280 clause 5.1.2.7 | OPTIONAL | *[0] EXPLICIT SEQUENCE OF* | A sequence of one or more CRL extensions. If present, the CRL `version` MUST be `v2`. |

The `crlExtensions` field MAY contain various extensions. Notable standard extensions include:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `authorityKeyIdentifier` | RFC 5280 clause 5.2.1 | REQUIRED | *SEQUENCE* | Provides a means of identifying the public key corresponding to the private key used to sign the CRL. Contains `keyIdentifier` (OCTET STRING), `authorityCertIssuer`, or `authorityCertSerialNumber`. |
| `cRLNumber` | RFC 5280 clause 5.2.3 | REQUIRED | *INTEGER* | A non-critical extension conveying a monotonically increasing sequence number for a given CRL scope and issuer. |

> _**Note:***_
> Within the APTITUDE pilot we do not use Delta CRLs

## Online Certificate Status Protocol

In addition to checking CRLs for WRPACs, the Wallet Unit or WRP MAY also utilize the **Online Certificate Status Protocol (OCSP)**. OCSP enables applications to determine the exact revocation state of identified certificates. It provides more timely revocation information than is typically possible with CRLs and MAY also be used to obtain additional status information.

An OCSP client issues a status request to an OCSP responder and SHALL suspend the acceptance of the certificates in question until the responder provides a valid response. 

This protocol specifies the data that SHALL be exchanged between the OCSP client (which checks the status of one or more certificates) and the OCSP server (which provides the corresponding status). In this specific ecosystem, the OCSP client can be a WU checking the WRPAC of a WRP, and the OCSP server is the Provider of the WRPAC.

### Online Certificate Status Protocol Request Format

The OCSP request is the ASN.1 DER encoding of the `OCSPRequest` SEQUENCE, which contains the `tbsRequest` (To-Be-Signed Request) and an optional signature. The following table lists the parameters found within the `tbsRequest` structure.

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `version` | RFC 6960 clause 4.1.1 | OPTIONAL | *[0] EXPLICIT INTEGER* | Indicates the version of the protocol. If omitted, the default value is `v1` (0). |
| `requestList` | RFC 6960 clause 4.1.1 | REQUIRED | *SEQUENCE OF* | Contains one or more single certificate status requests. |
| `requestList.reqCert` | RFC 6960 clause 4.1.1 | REQUIRED | *SEQUENCE* | The `CertID` structure carrying the identifier of a target certificate. |
| `requestList.singleRequestExtensions` | RFC 6960 clause 4.1.1 | OPTIONAL | *[0] EXPLICIT SEQUENCE* | Includes extensions applicable to this single certificate status request. |
| `requestExtensions` | RFC 6960 clause 4.1.1 | OPTIONAL | *[2] EXPLICIT SEQUENCE* | Includes extensions applicable to the overall requests found within the `requestList`. |

The `reqCert` parameter utilizes the `CertID` structure, which is an ASN.1 *SEQUENCE* containing the following parameters:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `hashAlgorithm` | RFC 6960 clause 4.1.1 | REQUIRED | *SEQUENCE* | Identifies the hash algorithm used to generate the issuer name and key hashes. |
| `hashAlgorithm.algorithm` | RFC 6960 clause 4.1.1 | REQUIRED | *OBJECT IDENTIFIER* | The OID of the hash function (e.g.,SHA-256, depending on the profile). |
| `hashAlgorithm.parameters` | RFC 6960 clause 4.1.1 | OPTIONAL | *ANY* | Algorithm-specific parameters, dependent on the hash algorithm used. |
| `issuerNameHash` | RFC 6960 clause 4.1.1 | REQUIRED | *OCTET STRING* | The hash of the issuer's distinguished name (DN), calculated over the DER encoding of the issuer's name field. |
| `issuerKeyHash` | RFC 6960 clause 4.1.1 | REQUIRED | *OCTET STRING* | The hash of the issuer's public key, calculated over the value (excluding tag and length) of the subject public key field. |
| `serialNumber` | RFC 6960 clause 4.1.1 | REQUIRED | *INTEGER* | The serial number of the target certificate for which the status is being requested. |

The `requestExtensions` and `singleRequestExtensions` structures MAY contain various extensions. A common extension is the `nonce`:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `nonce` | RFC 6960 clause 4.4.1 | REQUIRED | *OCTET STRING* | Cryptographically fresh value used to bind a request and a response to prevent replay attacks. Identifier OID is `id-pkix-ocsp-nonce`. |

> _**Note:**_
> Within APTITUDE, OCSP requests SHALL use the `nonce` extension.

When sent over HTTP using POST, the body of this request is the raw DER encoding of this `OCSPRequest`, with the MIME type `application/ocsp-request`.

Below is a concrete example of an OCSP request:

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
      nonce = BIT STRING (nonce)
```

### Online Certificate Status Protocol Response Format

An OCSP response is the ASN.1 DER encoding of the `OCSPResponse` *SEQUENCE*. When transported over HTTP, the body of the HTTP response is the raw DER encoding of this `OCSPResponse`, with the MIME type `application/ocsp-response`. The `OCSPResponse` *SEQUENCE* contains the following parameters:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `responseStatus` | RFC 6960 clause 4.2.1 | REQUIRED | *ENUMERATED* | Indicates the processing status of the prior request. Supported values are: `successful` (0), `malformedRequest` (1), `internalError` (2), `tryLater` (3), `sigRequired` (5), and `unauthorized` (6). |
| `responseBytes` | RFC 6960 clause 4.2.1 | OPTIONAL | *[0] EXPLICIT SEQUENCE* | Present only when the `responseStatus` is `successful` (0). Contains the response type and the encoded response data. |
| `responseBytes.responseType` | RFC 6960 clause 4.2.1 | REQUIRED | *OBJECT IDENTIFIER* | Identifier for the response type. For a basic OCSP responder, this value SHALL be `id-pkix-ocsp-basic`. |
| `responseBytes.response` | RFC 6960 clause 4.2.1 | REQUIRED | *OCTET STRING* | Contains the DER encoding of the response syntax identified by `responseType` (e.g., the `BasicOCSPResponse` structure). |

> _**Note:**_ 
> Within APTITUDE, OCSP responders SHALL be capable of producing responses of the `id-pkix-ocsp-basic` response type. Correspondingly, OCSP clients SHALL be capable of receiving and processing responses of the `id-pkix-ocsp-basic` response type.

`BasicOCSPResponse` is an ASN.1 SEQUENCE containing the following parameters:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `tbsResponseData` | RFC 6960 clause 4.2.1 | REQUIRED | *SEQUENCE* | Contains the core response data to be signed by the responder. |
| `tbsResponseData.version` | RFC 6960 clause 4.2.1 | OPTIONAL | *[0] EXPLICIT INTEGER* | The version of the response syntax. If omitted, the default value is `v1` (0). |
| `tbsResponseData.responderID` | RFC 6960 clause 4.2.1 | REQUIRED | *CHOICE* | Identifies the OCSP responder. It MUST contain either `byName` or `byKey`. |
| `tbsResponseData.responderID.byName` | RFC 6960 clause 4.2.1 | OPTIONAL | *[1] EXPLICIT Name* | The `Name` from the responder’s certificate subject. |
| `tbsResponseData.responderID.byKey` | RFC 6960 clause 4.2.1 | OPTIONAL | *[2] EXPLICIT OCTET STRING* | The SHA-1 hash of the responder’s `subjectPublicKey` (excluding the tag and length fields). |
| `tbsResponseData.producedAt` | RFC 6960 clause 4.2.1 | REQUIRED | *GeneralizedTime* | The time at which the OCSP response was generated. |
| `tbsResponseData.responses` | RFC 6960 clause 4.2.1 | REQUIRED | *SEQUENCE OF* | A sequence of `SingleResponse` structures, providing the status of each requested certificate. |
| `tbsResponseData.responseExtensions` | RFC 6960 clause 4.2.1 | OPTIONAL | *[1] EXPLICIT SEQUENCE OF* | Contains extensions applicable to the overall OCSP response. |
| `signatureAlgorithm` | RFC 5280 clause 4.1.1.2 | REQUIRED | *SEQUENCE* | Identifies the cryptographic algorithm used to sign the response. |
| `signatureAlgorithm.algorithm` | RFC 5280 clause 4.1.1.2 | REQUIRED | *OBJECT IDENTIFIER* | The OID of the signature algorithm. Selection SHOULD align with relevant standards (e.g., ETSI TS 119 312). |
| `signatureAlgorithm.parameters` | RFC 5280 clause 4.1.1.2 | OPTIONAL | *ANY* | Algorithm-specific parameters, dependent on the OID defined in `algorithm`. |
| `signature` | RFC 6960 clause 4.2.1 | REQUIRED | *BIT STRING* | The digital signature computed over the hash of the DER-encoded `tbsResponseData`. |
| `certs` | RFC 6960 clause 4.2.1 | OPTIONAL | *[0] EXPLICIT SEQUENCE OF* | Certificate chain to help the client verify the responder's signature. If no certificates are included, this field SHOULD be absent. |

The `responseExtensions` structure MAY contain various extensions. A notable parameter often required by specific profiles (such as to prevent replay attacks) is the `nonce`:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `nonce` | RFC 6960 clause 4.4.1 | REQUIRED | *OCTET STRING* | Cryptographically fresh value used to bind a request and a response to prevent replay attacks. If included in the request, responders SHOULD include it in the response. Identifer OID is `id-pkix-ocsp-nonce`. |

> _**Note:**_
> Within APTITUDE, OCSP Responses SHALL use the `nonce` extension.

In the OCSP Response there SHALL be at least a `SingleResponse` for each `CertID` in the request. Each `SingleResponse` is an ASN.1 *SEQUENCE* that carries the following parameters:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `certID` | RFC 6960 clause 4.2.1 | REQUIRED | *SEQUENCE* | Identifier of the certificate whose status is determined in `certStatus`. |
| `certStatus` | RFC 6960 clause 4.2.1 | REQUIRED | *CHOICE* | The value of the certificate's status. It SHALL be exactly one of: `good`, `revoked`, or `unknown`. |
| `certStatus.good` | RFC 6960 clause 4.2.1 | OPTIONAL | *[0] IMPLICIT NULL* | Indicates the certificate is valid. |
| `certStatus.revoked` | RFC 6960 clause 4.2.1 | OPTIONAL | *[1] IMPLICIT SEQUENCE* | Indicates the certificate has been revoked. Contains the `RevokedInfo` structure. |
| `certStatus.revoked.revocationTime` | RFC 6960 clause 4.2.1 | REQUIRED | *GeneralizedTime* | The time at which the certificate was revoked. |
| `certStatus.revoked.revocationReason` | RFC 6960 clause 4.2.1 | OPTIONAL | *[0] EXPLICIT ENUMERATED* | Contains the `CRLReason` indicating why the certificate was revoked. |
| `certStatus.unknown` | RFC 6960 clause 4.2.1 | OPTIONAL | *[2] IMPLICIT NULL* | Indicates the responder does not know the status of the certificate. |
| `thisUpdate` | RFC 6960 clause 4.2.1 | REQUIRED | *GeneralizedTime* | Indicates the issue date and time of this OCSP Response. |
| `nextUpdate` | RFC 6960 clause 4.2.1 | OPTIONAL | *[0] EXPLICIT GeneralizedTime* | Indicates the date and time by which the next update to the OCSP Responder database will be in place. |
| `singleExtensions` | RFC 6960 clause 4.2.1 | OPTIONAL | *[1] EXPLICIT SEQUENCE* | Includes extensions applicable to this single certificate status response. |

Below is a concrete example of an OCSP response with a single `good` status.

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
            nonce = BIT STRING (nonce)
        signatureAlgorithm = sha256WithRSAEncryption
        signature          = BIT STRING (signature over hash(DER(tbsResponseData)))
        certs              = SEQUENCE OF
            Certificate (responder’s cert, possibly with its issuing CA cert)
```
