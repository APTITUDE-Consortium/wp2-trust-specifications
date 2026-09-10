The Token Status List mechanism [draft-ietf-oauth-status-list] conveys the current status of multiple artifacts within a compact, signed object called a <artifacts:Status List Token>. This section specifies the structure of the Status List Token; the operational use of Token Status List within the APTITUDE ecosystem is detailed in [Token Status List](../sections/trust-management-lifecycle.md#token-status-list).

Status List Tokens SHALL be protected by a cryptographic signature and SHALL be encoded in either JWT or CWT format. Depending on the format used, they SHALL comply with:

- For JWT format: [draft-ietf-oauth-status-list, Section 5.1], [RFC 7515], [RFC 7519].
- For CWT format: [draft-ietf-oauth-status-list, Section 5.2], [RFC 8392].

!!! choice "APTITUDE Implementation Choice"

    The <artifacts:Status List Token> SHALL be available in JWT format and MAY additionally be available in CWT format.

The following table details the header parameters for Status List Tokens in JWT format, including presence requirements, syntax types, descriptions, and corresponding references in [draft-ietf-oauth-status-list].

| Parameter                   | Type            | Presence      | Description | Reference in [draft-ietf-oauth-status-list] |
| --------------------------- | :-------------: | :-----------: |------------ | ------------------------------------------- |
| `alg`                       | `String`        | REQUIRED      | Contains the algorithm identifier for the algorithm used to sign the JWT, among those contained in the IANA "JSON Web Signature and Encryption Algorithms" registry. It SHALL NOT be set to `none` or to a symmetric algorithm (MAC) identifier. | Section 5.1 |
| `typ`                       | `String`        | REQUIRED      | Specifies the JWT type. It SHALL be set to `statuslist+jwt`. | Section 5.1 |
| `x5c`                       | `String[]`      | REQUIRED      | Contains the base64-encoded certificate chain required to verify the <artifacts:Status List Token>'s signature. | Section 5.1 |

The following table details the payload parameters for Status List Tokens in JWT format.

| Parameter                   | Type            | Presence      | Description | Reference in [draft-ietf-oauth-status-list] |
| --------------------------- | :-------------: | :-----------: |------------ | ------------------------------------------- |
| `sub`                       | `String`        | REQUIRED      | Specifies the URI of the <artifacts:Status List Token>. The value SHALL be equal to that of the `uri` claim contained in the `status_list` claim of the referenced token. | Section 5.1 |
| `iat`                       | `NumericDate`   | REQUIRED      | Represents the time at which the <artifacts:Status List Token> was issued. | Section 5.1 |
| `exp`                       | `NumericDate`   | REQUIRED      | Represents the time at which the <artifacts:Status List Token> is considered expired. | Section 5.1 |
| `status_list`               | `JSONObject`    | REQUIRED      | Contains the Status List configurations and payload. | Section 5.1 |
| `ttl`                       | `Integer`       | RECOMMENDED   | Specifies the maximum amount of time, in seconds, that the <artifacts:Status List Token> can be cached by a consumer before a fresh copy SHOULD be retrieved. | Section 5.1 |

??? example "Example: Status List Token in JWT Format"

    {% include-markdown "../examples/status-list-token.md" %}
