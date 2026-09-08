The <protocols:Online Certificate Status Protocol (OCSP)> [RFC 6960] enables applications to determine the revocation status of identified certificates. This section specifies the structure of OCSP [Requests](#ocsp-request) and [Responses](#ocsp-response). The operational use of OCSP within the APTITUDE ecosystem is detailed in [Online Certificate Status Protocol](../sections/trust-management-lifecycle.md#online-certificate-status-protocol).

### OCSP Request

In accordance with [RFC 6960, Section 4.1], the `OCSPRequest` ASN.1 structure consists of a `SEQUENCE` composed of the following fields:

| Field                       | Type            | Presence      | Description | Reference in [RFC 6960] |
| --------------------------- | :-------------: | :-----------: |------------ | ----------------------- |
| `tbsRequest`                | `SEQUENCE`      | REQUIRED      | Contains the optionally signed OCSP request. | Section 4.1.1 |
| `optionalSignature`         | `SEQUENCE`      | OPTIONAL      | Contains the identifier for the cryptographic algorithm used to sign the request (if applicable). | Section 4.1.1 |

!!! note

    The rest of the section details the content of the `tbsRequest` field only. For additional information on the `optionalSignature` field, refer to [RFC 6960].

The `tbsRequest` field SHALL contain a `TBSRequest` structure conforming to [RFC 6960, Section 4.1.1]. The following table details the supported fields, including presence requirements, syntax types, descriptions, and corresponding references in [RFC 6960].

| Field                       | Type            | Presence      | Description | Reference in [RFC 6960] |
| --------------------------- | :-------------: | :-----------: |------------ | ----------------------- |
| `version`                   | `INTEGER`       | OPTIONAL      | Describes the version of the protocol. If omitted, it defaults to version 1 (value `0`). | Section 4.1.1 |
| `requestList`               | `SEQUENCE`      | REQUIRED      | Contains a sequence of one or more certificate status requests. | Section 4.1.1 |
| `requestExtensions`         | `SEQUENCE`      | OPTIONAL      | Contains a sequence of one or more extensions applicable to the requests. The applicable extensions are defined below. | Section 4.1.1 |

The following table specifies the extensions supported by this specification, including their Object Identifiers (OIDs), type, presence requirement, description, and normative references.

| Extension                         | OID                       | Type              | Presence      | Description  | Reference |
| --------------------------------- | :-----------------------: | :---------------: | :-----------: |------------- | --------- |
| `nonce`                           | `1.3.6.1.5.5.7.48.1.2`    | `OCTET STRING`    | REQUIRED      | Represents a cryptographically fresh value used to bind a request and a response to prevent replay attacks. | [RFC 6960, Section 4.4.1] |

??? example "Example: OCSP Request"

    {% include-markdown "../examples/ocsp-request.md" %}

### OCSP Response

In accordance with [RFC 6960, Section 4.2], the `OCSPResponse` ASN.1 structure consists of a `SEQUENCE` composed of the following fields:

| Field                       | Type            | Presence      | Description | Reference in [RFC 6960] |
| --------------------------- | :-------------: | :-----------: |------------ | ----------------------- |
| `responseStatus`            | `ENUMERATED`    | REQUIRED      | Indicates the processing status of the prior request. The following values are supported: `successful` (`0`), `malformedRequest` (`1`), `internalError` (`2`), `tryLater` (`3`), `sigRequired` (`5`), `unauthorized` (`6`). | Section 4.2.1 |
| `responseBytes`             | `SEQUENCE`      | OPTIONAL      | Contains the response type and the encoded response data. It SHALL be specified only in case `responseStatus` indicates the `successful` status. | Section 4.2.1 |

!!! choice "APTITUDE Implementation Choices"

    - The response structure represented by the `responseBytes` field SHALL contain the `nonce` extension among the `responseExtensions`.
    - <protocols:Online Certificate Status Protocol (OCSP)|OCSP> responders SHALL be capable of producing responses of the `id-pkix-ocsp-basic` response type. Correspondingly, <protocols:Online Certificate Status Protocol (OCSP)|OCSP> clients SHALL be capable of receiving and processing responses of the `id-pkix-ocsp-basic` response type.

??? example "Example: OCSP Response"

    {% include-markdown "../examples/ocsp-response.md" %}
