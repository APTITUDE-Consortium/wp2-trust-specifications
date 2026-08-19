This section describes the artifacts that are employed in [Trust Management and Lifecycle](../sections/trust-management-lifecycle.md) to manage the status of certificates and entities by detailing respective formats and parameters. The main distinction is the following:

- To manage <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|Wallet-Relying Party Access Certificates (WRPACs)>, each <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC> SHALL:
    - make available at least one revocation mechanism among [Certificate Revocation Lists](#certificate-revocation-lists) and [Online Certificate Status Protocol](#online-certificate-status-protocol);
    - issue <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs> with at least an extension corresponding to the provided revocation mechanism as illustrated in [Wallet-Relying Party Access Certificate](../sections/trust-artifacts.md#wallet-relying-party-access-certificate).
- To manage <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|Wallet-Relying Party Registration Certificates (WRPRCs)>, each <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)|Provider of WRPRC> SHALL:
    - make available an endpoint to request [Status List Tokens](#status-list-token);
    - issue <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRCs> with the appropriate parameter `status` as described in [Wallet-Relying Party Registration Certificate](../sections/trust-artifacts.md#wallet-relying-party-registration-certificate).
- To manage <artifacts:Wallet Unit Attestation (WUA)|Wallet Unit Attestations (WUAs)>, each <roles:Wallet Provider (WP)|Wallet Provider> SHALL:
    - make available an endpoint to request [Status List Tokens](#status-list-token);
    - issue <artifacts:Wallet Instance Attestation (WIA)|WIAs> and <artifacts:Key Attestation (KA)|KAs> with the appropriate status-list references in `client_status.status.status_list` and `key_storage_status.status.status_list`, respectively, as described in [Token Status List (Wallet Unit Attestation Profile)](#token-status-list-wallet-unit-attestation-profile).

### Token Status List

This section profiles the Token Status List (TSL) mechanism of [draft-ietf-oauth-status-list](https://datatracker.ietf.org/doc/draft-ietf-oauth-status-list/) for artifacts whose status is managed using a Status List. A TSL conveys the current status of many artifacts in a compact, signed <artifacts:Status List Token>. The requirements in this profile apply unless refined by one of the artifact-specific profiles below.

The Status Issuer is the entity that issues the <artifacts:Status List Token> about the status information of the artifact. The Status Provider is the entity that makes the <artifacts:Status List Token> available at an accessible endpoint. The artifact-specific profile SHALL define these roles and whether they are fulfilled by the same entity.

#### Status List

A Status List contains a compressed byte array whose entries represent the statuses of many artifacts. The artifact-specific profile SHALL define the status-list reference member. Each status-list reference SHALL contain a distinct, non-negative `idx` value and a `uri` identifying the <artifacts:Status List Token> that contains the corresponding entry. For a JWT-encoded artifact, `idx` is a JSON integer and `uri` is a JSON string; for a CWT-encoded artifact, `idx` is a CBOR unsigned integer and `uri` is a CBOR text string. In both cases, `uri` SHALL be a URI conforming to [RFC 3986].

The Status Issuer SHALL:

- Configure the `bits` value as one of 1, 2, 4, or 8. This value determines the number of bits used to represent the status of each artifact and therefore the number of possible status values.
- Create a byte array of size >= (number of artifacts) * `bits` / 8. Depending on `bits`, each byte in the array corresponds to 8, 4, 2, or 1 status values.
- Assign each artifact to a distinct index starting at 0 and set the status value for every issued artifact at the corresponding position in the byte array. The status meanings and encoded values are defined by the artifact-specific profile.
- Pack entries starting with the least significant bit of each byte.
- Compress the byte array using DEFLATE [RFC 1951] with the ZLIB [RFC 1950] data format. Implementations SHOULD use the highest compression level available.

The status values and their meanings are defined by the artifact-specific profile.

#### Status List Token

The **<artifacts:Status List Token>** is available at the Status List Endpoint. The Status Provider SHALL make each <artifacts:Status List Token> available via HTTP GET at the URI specified by the status-list reference, using `application/statuslist+jwt` for a JWT <artifacts:Status List Token> or `application/statuslist+cwt` for a CWT <artifacts:Status List Token>. The format MAY be either a JWT or a CWT and SHALL be protected by a cryptographic signature.

!!! choice

    Within the APTITUDE profiles, the Status List Token SHALL be available in JWT format, and MAY be available in CWT format.

A JWT <artifacts:Status List Token> SHALL be formatted as described in Section 5.1, and a CWT <artifacts:Status List Token> as described in Section 5.2, of [draft-ietf-oauth-status-list](https://datatracker.ietf.org/doc/draft-ietf-oauth-status-list/). In addition, a JWT <artifacts:Status List Token> SHALL contain the following parameters:

##### Status List Token Header

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----: | :---------- |
| `alg` | [RFC 7515] | REQUIRED | *String* | A digital signature algorithm identifier per the IANA "JSON Web Signature and Encryption Algorithms" registry. It SHALL NOT be set to `none` or to a symmetric algorithm (MAC) identifier. |
| `typ` | [RFC 7515] | REQUIRED | *String* | Specifies the type of the Web Token. It SHALL be set to `statuslist+jwt`. |
| `x5c` | [RFC 7515] | REQUIRED | *Array of Strings* | Contains the Base64-encoded certificate chain required to verify the <artifacts:Status List Token>'s signature. |

##### Status List Token Payload

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----: | :---------- |
| `sub` | RFC 7519 | REQUIRED | *String* | The subject claim SHALL specify the URI of the <artifacts:Status List Token>. The value SHALL be equal to that of the `uri` claim contained in the status-list reference of the artifact. |
| `iat` | RFC 7519 | REQUIRED | *NumericDate* | A timestamp indicating when the <artifacts:Status List Token> was issued. |
| `exp` | RFC 7519 | REQUIRED | *NumericDate* | A timestamp indicating when the <artifacts:Status List Token> expires. |
| `status_list` | OAuth Status List Draft | REQUIRED | *JSON Object* | A JSON Object that contains the Status List configurations and payload. |
| `status_list.bits` | OAuth Status List Draft | REQUIRED | *Integer* | Specifies the number of bits per artifact in the compressed byte array. The allowed values are 1, 2, 4, and 8. |
| `status_list.lst` | OAuth Status List Draft | REQUIRED | *Base64url-encoded String* | Contains the status values for all artifacts. The value SHALL be the base64url-encoded compressed byte array. |
| `ttl` | OAuth Status List Draft | RECOMMENDED | *Integer* | Time to live claim expressed in seconds. It specifies the maximum amount of time, in seconds, that the <artifacts:Status List Token> can be cached by a consumer before a fresh copy SHOULD be retrieved. |

The following is an example of the <artifacts:Status List Token> payload and header prior to signing and base64url encoding:

??? example "Status List Token Header and Payload"

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
      "sub": "https://example-issuer.com/statuslists/1",
      "status_list": {
        "bits": 1,
        "lst": "eNrbuRgAAhcBXQ"
      }
    }
    ```

#### Status List Request

A consumer SHALL request a <artifacts:Status List Token> at the URI referenced by the status-list reference. The request SHALL use HTTP GET and the media type corresponding to the requested format: `application/statuslist+jwt` for a JWT or `application/statuslist+cwt` for a CWT.

Below is an example of such a request for a JWT <artifacts:Status List Token>.

```text
  GET /statuslists/1 HTTP/1.1
  Host: example.com
  Accept: application/statuslist+jwt
```

#### Status List Response

The successful response SHALL contain a <artifacts:Status List Token> and have HTTP status code 200. The content type of the successful response SHALL correspond to the format of the returned token: `application/statuslist+jwt` for a JWT or `application/statuslist+cwt` for a CWT.

```text
  HTTP/1.1 200 OK
  Content-Type: application/statuslist+jwt

  eyJhbGciOiJFUzI1NiIsImtpZCI6IjEyIiwidHlwIjoic3RhdHVzbGlzdCtqd3QifQ.e
  yJleHAiOjIyOTE3MjAxNzAsImlhdCI6MTY4NjkyMDE3MCwiaXNzIjoiaHR0cHM6Ly9le
  GFtcGxlLmNvbSIsInN0YXR1c19saXN0Ijp7ImJpdHMiOjEsImxzdCI6ImVOcmJ1UmdBQ
  WhjQlhRIn0sInN1YiI6Imh0dHBzOi8vZXhhbXBsZS5jb20vc3RhdHVzbGlzdHMvMSIsI
  nR0bCI6NDMyMDB9.2lKUUNG503R9htu4aHAYi7vjmr3sgApbfoDvPrl65N3URUO1EYqq
  Ql45Jfzd-Av4QzlKa3oVALpLwOEUOq-U*g
```

If caching-related HTTP headers are present in the HTTP response, consumers SHALL prioritize the `exp` and `ttl` claims within the <artifacts:Status List Token> over the HTTP headers for determining caching behavior.

#### Token Status List Profiles

##### Token Status List (WRPRC Profile)

This section profiles the Token Status List (TSL) mechanism of [draft-ietf-oauth-status-list](https://datatracker.ietf.org/doc/draft-ietf-oauth-status-list/) for <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|Wallet-Relying Party Registration Certificates (WRPRCs)>.

!!! choice

    Within the APTITUDE Profiles, the SLT Provider for WRPRC Status List Tokens SHALL be the <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)|Provider of WRPRC>.

**Status List**

According to the [ARF] and [ETSI TS 119 475], the WRPRC status is either `VALID` or `INVALID`; therefore, the <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)|Provider of WRPRC> SHALL set the `bits` parameter in the SLT's `status_list` object to `1`. The value `0x00` represents `VALID`, and the value `0x01` represents `INVALID`.

The SLT Provider SHALL pack entries starting with the least significant bit of each byte, compress the byte array using DEFLATE with the ZLIB data format, and publish the resulting Status List in the SLT.

**Status List Token**

!!! choice

    The SLT Provider SHALL act as both the Status Issuer and the Status Provider.
    
    It SHALL make each SLT available via HTTP GET at the URI specified by the WRPRC's `status.status_list.uri` member, using `application/statuslist+jwt` for a JWT SLT.
    
    The SLT format SHALL be either a JWT and SHALL be protected by a cryptographic signature.

A JWT SLT SHALL be formatted as described in [Status List Token](#status-list-token).

Regardless of the format, the SLT Provider for WRPRCs SHALL sign each SLT using a valid X.509 certificate whose trust chain terminates at the Trust Anchor published in the Providers of WRPRC LoTE.

For a JWT SLT, the signing certificate chain SHALL be carried in the `x5c` JOSE header.

##### Token Status List (Wallet Unit Attestation Profile)

This section profiles the Token Status List (TSL) mechanism of [draft-ietf-oauth-status-list](https://datatracker.ietf.org/doc/draft-ietf-oauth-status-list/) for Wallet Instance Attestations or Key Attestations as described in [TS03] and [CIR 2026/1731].

!!! choice

    Within the APTITUDE Profiles, the SLT Provider SHALL be the <roles:Wallet Provider (WP)|Wallet Provider>.

As specified in [TS03],

- A WIA SHALL include its Status List reference in `client_status.status.status_list`; and,
- A KA SHALL include its Status List reference in `key_storage_status.status.status_list`.

**Status List**

A Status List contains a compressed byte array whose entries represent the statuses of many Wallet Instance Attestations (WIAs) or Key Attestations (KAs).

Each Status List reference SHALL contain `idx` and `uri`. Both WIAs and KAs are JWTs; therefore, `idx` is a JSON integer and `uri` is a JSON string in each reference. In both cases, `uri` SHALL be a URI conforming to [RFC 3986].

According to this specification, a WIA or KA can have one of the following statuses:

- `VALID`. The WIA or KA is valid. This status is represented by `0x00` in the SLT.
- `INVALID`. The WIA or KA is revoked. This status is represented by `0x01` in the SLT.

As a result, the <roles:Wallet Provider (WP)|Wallet Provider> SHALL set the `bits` parameter in the SLT's `status_list` object to `1`.

The <roles:Wallet Provider (WP)|Wallet Provider> SHALL pack entries starting with the least significant bit of each byte, compress the byte array using DEFLATE with the ZLIB data format, and publish the resulting Status List in the SLT.

**KA Index Assignment**

According to `R_KA_1` of [CIR 2026/1731], a Wallet Provider SHALL choose one of the following index-assignment options for the `key_storage_status.status` claim in a KA.

- **Option 1: `type-shared index`**. All KAs attesting keys stored in the same type of WSCD or keystore SHALL contain the same index value in `key_storage_status.status`.
- **Option 2: `per-key-attestation index`**. A KA attesting keys stored in an individual WSCD or keystore SHALL contain a pairwise-unique index value in `key_storage_status.status`.

!!! choice

    Within the APTITUDE Profiles, the <roles:Wallet Provider (WP)|Wallet Provider> SHALL **Option 1: `type-shared index`**.

**Status List Token**

!!! choice

    The <roles:Wallet Provider (WP)|Wallet Provider> SHALL act as both the Status Issuer and the Status Provider.
    
    It SHALL make each SLT available via HTTP GET at the URI specified by either the WIA's `client_status.status.status_list.uri` member or the KA's `key_storage_status.status.status_list.uri` member, using `application/statuslist+jwt`.

    The SLT format SHALL be either a JWT and SHALL be protected by a cryptographic signature.
    
    Regardless of the chosen format, the SLT SHALL conform to [Status List Token](#status-list-token).

    Regardless of the format, the <roles:Wallet Provider (WP)|Wallet Provider> SHALL sign the SLT using a valid X.509 certificate whose trust chain terminates at the Trust Anchor published in the Wallet Providers LoTE.

**Operational and Runtime Checks**

!!! choice

    The following operational and runtime requirements are APTITUDE profiling choices derived from the possibilities in [CIR 2026/1731] and [TS03]. They do not replace the mandatory requirements applicable to PID Providers.

This profile distinguishes between:

- **Runtime status validation**, performed as part of the credential issuance transaction and described in RFC001.
- **Operational status monitoring**, performed by the PID or Attestaion Provider after issuance and during the technical validity period of the issued credential.

!!! choice

    For a device-bound credential, both the WIA and the KA are applicable, and the statuses of both SHALL be checked at issuance.
    
    For a non-device-bound credential, requirements concerning the KA do not apply, and only the status of the WIA SHALL be checked at issuance.

For PIDs, the current [TS03] requirements, as reflected in [CIR 2026/1731](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=OJ%3AL_202601731), require the PID Provider to monitor both the WIA and KA status at least once every 24 hours when the technical validity period of the PID exceeds 24 hours.

!!! choice

    For other Attestation types, within the APTITUDE profiles,
    
    - both WIA and KA operational checks SHALL be performed for device-bound credentials when operational monitoring is enabled;
    - while only the WIA operational check SHALL be performed for non-device-bound attestations when operational monitoring is enabled.

An Attestation Provider that supports WIA/KA operational status checks SHALL advertise the status-management policy applicable to each Credential Configuration in its Credential Issuer Metadata. This profile defines the following additional members of a Credential Configuration object:

- `wallet_attestation_status_management`;
- `key_attestation_status_management`.

Each value is an object with the following members:

| Member | Presence | Type | Description |
| :----- | :------- | :--- | :---------- |
| `wallet_attestation_status_management` | REQUIRED | *Object* | The status-management policy for the WIA. |
| `wallet_attestation_status_management.issuance_check` | REQUIRED | *String* | The issuance-time status check. The value SHALL be `wia`. |
| `wallet_attestation_status_management.operational_check` | REQUIRED | *String* | The post-issuance WIA status check. The value SHALL be `none` (no post-issuance WIA monitoring) or `wia` (the WIA status is monitored). |
| `wallet_attestation_status_management.maximum_check_interval` | OPTIONAL unless `operational_check` is not `none` | *Integer* | The maximum interval between two WIA status checks, expressed in seconds. |
| `wallet_attestation_status_management.revocation_action` | REQUIRED when `operational_check` is not `none` | *String* | The action taken when the WIA is invalid. The value defined by this profile is `revoke_credential`. |
| `wallet_attestation_status_management.policy_id` | RECOMMENDED | *String* | A stable identifier representing the WIA status-management policy applied by the Credential Issuer. |

| Member | Presence | Type | Description |
| :----- | :------- | :--- | :---------- |
| `key_attestation_status_management` | REQUIRED for device-bound credentials; not applicable to non-device-bound credentials | *Object* | The status-management policy for the KA. |
| `key_attestation_status_management.issuance_check` | REQUIRED for device-bound credentials | *String* | The issuance-time status check. The value SHALL be `ka` if the KA for device bound credential, and SHOULD be `none` for non device-bound credential. |
| `key_attestation_status_management.operational_check` | REQUIRED for device-bound credentials | *String* | The post-issuance KA status check. The value SHALL be `none` (no post-issuance KA monitoring) or `ka` (the KA status is monitored). |
| `key_attestation_status_management.maximum_check_interval` | OPTIONAL unless `operational_check` is not `none` | *Integer* | The maximum interval between two KA status checks, expressed in seconds. |
| `key_attestation_status_management.revocation_action` | REQUIRED when `operational_check` is not `none` | *String* | The action taken when the KA is invalid. The value defined by this profile is `revoke_credential`. |
| `key_attestation_status_management.policy_id` | RECOMMENDED | *String* | A stable identifier representing the KA status-management policy applied by the Credential Issuer. |

??? example "Credential Issuer Metadata of an Attestation Provider monitoring both WIA and KA"

    For example, an Attestation Provider may advertise monitoring of both WIA and KA status for a device-bound credential as follows:

    ```json
    {
      "credential_configurations_supported": {
        "example_device_bound_credential": {
          "format": "dc+sd-jwt",
          "cryptographic_binding_methods_supported": [
            "jwk"
          ],
          "wallet_attestation_status_management": {
            "issuance_check": "wia",
            "operational_check": "wia",
            "maximum_check_interval": 86400,
            "revocation_action": "revoke_credential",
            "policy_id": "urn:eu:eudi:wallet-wia-status-policy:continuous"
          },
          "key_attestation_status_management": {
            "issuance_check": "ka",
            "operational_check": "ka",
            "maximum_check_interval": 86400,
            "revocation_action": "revoke_credential",
            "policy_id": "urn:eu:eudi:wallet-ka-status-policy:continuous"
          }
        }
      }
    }
    ```

??? example "Credential Issuer Metadata of an Attestation Provider not monitoring KA"

    An Attestation Provider that does not perform operational monitoring would advertise:

    ```json
    {
      "credential_configurations_supported": {
        "example_device_bound_credential": {
          "format": "dc+sd-jwt",
          "cryptographic_binding_methods_supported": [
            "jwk"
          ],
          "wallet_attestation_status_management": {
            "issuance_check": "wia",
            "operational_check": "wia",
            "maximum_check_interval": 86400,
            "revocation_action": "revoke_credential",
            "policy_id": "urn:eu:eudi:wallet-wia-status-policy:continuous"
          },
          "key_attestation_status_management": {
            "issuance_check": "none",
            "operational_check": "none",
            "policy_id": "urn:eu:eudi:wallet-ka-status-policy:issuance-only"
          }
        }
      }
    }
    ```

**Privacy Considerations**

To prevent Wallet Providers from tracking or profiling users based on their use of Wallet Unit Attestations, Wallet Providers SHALL integrate the status information for many WIAs or KAs into the same list and SHALL publish the SLT at the same `uri` for all those attestations. This specification requires Wallet Providers to configure Status Lists with at least 100,000 status entries. If more attestations are issued, the Wallet Provider MAY create additional SLTs or increase the number of entries in the array, depending on practical considerations such as the total size of each SLT and the management of multiple endpoints.

### Certificate Revocation Lists

**<artifacts:Certificate Revocation List (CRL)|Certificate Revocation Lists (CRLs)>** [RFC 5280] MAY be used in a wide range of applications and environments covering a broad spectrum of interoperability goals and an even broader spectrum of operational and assurance requirements.

**CRL issuers** issue <artifacts:Certificate Revocation List (CRL)|CRLs>. The CRL issuer is either the <roles:Certificate Authority (CA)> or an entity that has been authorized by the <roles:Certificate Authority (CA)|CA> to issue <artifacts:Certificate Revocation List (CRL)|CRLs>.

!!! note

    Within APTITUDE the <artifacts:Certificate Revocation List (CRL)|CRL> Issuer SHALL be the <artifacts:Trust Anchor>.

CAs publish <artifacts:Certificate Revocation List (CRL)|CRLs> to provide status information about the certificates they issued. Each <artifacts:Certificate Revocation List (CRL)|CRL> has a particular scope. The <artifacts:Certificate Revocation List (CRL)|CRL> scope is the set of certificates that could appear on a given <artifacts:Certificate Revocation List (CRL)|CRL>. For example, the scope could be "all certificates issued by CA X". A complete <artifacts:Certificate Revocation List (CRL)|CRL> lists all unexpired certificates, within its scope, that have been revoked for one of the revocation reasons covered by the <artifacts:Certificate Revocation List (CRL)|CRL> scope.

The <artifacts:Certificate Revocation List (CRL)|CRL> issuer MAY also generate delta <artifacts:Certificate Revocation List (CRL)|CRLs>. A delta CRL only lists those certificates, within its scope, whose revocation status has changed since the issuance of a referenced complete <artifacts:Certificate Revocation List (CRL)|CRL>. The referenced complete CRL is referred to as a base <artifacts:Certificate Revocation List (CRL)|CRL>. The scope of a delta <artifacts:Certificate Revocation List (CRL)|CRL> SHALL be the same as the base <artifacts:Certificate Revocation List (CRL)|CRL> that it references.

If supported by the <roles:Certificate Authority (CA)|CA>, the <artifacts:Certificate Revocation List (CRL)|CRL> SHALL be available at the URI specified in the `cRLDistributionPoints.distributionPoint` *[0] CHOICE* structure within the [WRPAC](../sections/trust-artifacts.md#wallet-relying-party-access-certificate).

An X.509 v2 <artifacts:Certificate Revocation List (CRL)|CRL> is represented as the ASN.1 DER encoding of the `CertificateList` SEQUENCE. The ASN.1 DER encoding is a strictly defined tag, length, and value encoding system for each element. The final bytes transmitted represent the DER encoding of the top-level SEQUENCE containing the fields in the following table:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `tbsCertList` | [RFC 5280, clause 5.1.1.1] | REQUIRED | *SEQUENCE* | Contains the core <artifacts:Certificate Revocation List (CRL)\|CRL> information including the name of the issuer, issue date, next update date, the optional list of revoked certificates, and optional <artifacts:Certificate Revocation List (CRL)\|CRL> extensions. |
| `signatureAlgorithm` | [RFC 5280, clause 5.1.1.2] | REQUIRED | *SEQUENCE* | Contains the algorithm identifier for the algorithm used by the <artifacts:Certificate Revocation List (CRL)\|CRL> issuer to sign the `CertificateList`. Selection SHOULD align with relevant standards (e.g., [ETSI TS 119 312]). |
| `signatureAlgorithm.algorithm` | [RFC 5280, clause 4.1.1.2] | REQUIRED | *OBJECT IDENTIFIER* | The OID of the signature algorithm. |
| `signatureAlgorithm.parameters` | [RFC 5280, clause 4.1.1.2] | OPTIONAL | *ANY* | Algorithm-specific parameters, dependent on the signature algorithm used. |
| `signatureValue` | [RFC 5280, clause 5.1.1.3] | REQUIRED | *BIT STRING* | Contains the digital signature computed upon the ASN.1 DER encoded `tbsCertList`. |

#### Certificate List Content

The `TBSCertList` (To Be Signed Certificate List) is an ASN.1 SEQUENCE containing several fields and extensions. The following table lists all such fields and extensions that are required in a <artifacts:Certificate Revocation List (CRL)|CRL> or conditionally required.

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `version` | [RFC 5280, clause 5.1.2.1] | OPTIONAL | *INTEGER* | Describes the version of the encoded <artifacts:Certificate Revocation List (CRL)\|CRL>. When extensions are used (as is standard practice), this field SHALL be present and SHALL specify version 2 (the integer value is `1`). |
| `signature` | [RFC 5280, clause 5.1.2.2] | REQUIRED | *SEQUENCE* | The algorithm identifier for the algorithm used to sign the <artifacts:Certificate Revocation List (CRL)\|CRL>. |
| `signature.algorithm` | [RFC 5280, clause 4.1.1.2] | REQUIRED | *OBJECT IDENTIFIER* | The OID of the signature algorithm. SHALL match the `signatureAlgorithm` field in the parent `CertificateList` sequence. |
| `signature.parameters` | [RFC 5280, clause 4.1.1.2] | OPTIONAL | *ANY* | Algorithm-specific parameters, dependent on the algorithm used. |
| `issuer` | [RFC 5280, clause 5.1.2.3] | REQUIRED | *Name* | Identifies the entity that has signed and issued the <artifacts:Certificate Revocation List (CRL)\|CRL>. It SHALL contain a non-empty X.500 distinguished name (DN) composed of `AttributeType` (OID) and `AttributeValue` sequences. |
| `thisUpdate` | [RFC 5280, clause 5.1.2.4] | REQUIRED | *UTCTime* or *GeneralizedTime* | Indicates the issue date of this <artifacts:Certificate Revocation List (CRL)\|CRL>. Dates through 2049 SHALL use `UTCTime`; dates in 2050 or later SHALL use `GeneralizedTime`. |
| `nextUpdate` | [RFC 5280, clause 5.1.2.5] | REQUIRED | *UTCTime* or *GeneralizedTime* | Indicates the date by which the next <artifacts:Certificate Revocation List (CRL)\|CRL> will be issued. Dates through 2049 SHALL use `UTCTime`; dates in 2050 or later SHALL use `GeneralizedTime`. |
| `revokedCertificates` | [RFC 5280, clause 5.1.2.6] | OPTIONAL | *SEQUENCE OF* | A sequence of revoked certificates. When there are no revoked certificates, this field SHALL be absent. |
| `revokedCertificates.userCertificate` | [RFC 5280, clause 5.1.2.6] | REQUIRED | *INTEGER* | The `CertificateSerialNumber` of the revoked certificate. |
| `revokedCertificates.revocationDate` | [RFC 5280, clause 5.1.2.6] | REQUIRED | *UTCTime* or *GeneralizedTime* | The date on which the revocation occurred. |
| `revokedCertificates.crlEntryExtensions` | [RFC 5280, clause 5.1.2.6] | OPTIONAL | *SEQUENCE OF* | Extensions specific to this revoked certificate entry. If present, the <artifacts:Certificate Revocation List (CRL)\|CRL> `version` SHALL be `v2`. |
| `crlExtensions` | [RFC 5280, clause 5.1.2.7] | OPTIONAL | *[0] EXPLICIT SEQUENCE OF* | A sequence of one or more <artifacts:Certificate Revocation List (CRL)\|CRL> extensions. If present, the <artifacts:Certificate Revocation List (CRL)\|CRL> `version` SHALL be `v2`. |

The `crlExtensions` field MAY contain various extensions. Notable standard extensions include:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `authorityKeyIdentifier` | [RFC 5280, clause 5.2.1] | REQUIRED | *SEQUENCE* | Provides a means of identifying the public key corresponding to the private key used to sign the <artifacts:Certificate Revocation List (CRL)\|CRL>. Contains `keyIdentifier` (OCTET STRING), `authorityCertIssuer`, or `authorityCertSerialNumber`. |
| `cRLNumber` | [RFC 5280, clause 5.2.3] | REQUIRED | *INTEGER* | A non-critical extension conveying a monotonically increasing sequence number for a given <artifacts:Certificate Revocation List (CRL)\|CRL> scope and issuer. |

!!! note

    Within the APTITUDE pilot, Delta <artifacts:Certificate Revocation List (CRL)|CRLs> are not used.

### Online Certificate Status Protocol

**<protocols:Online Certificate Status Protocol (OCSP)>** [RFC 6960] enables applications to determine the exact revocation state of identified certificates. It provides more timely revocation information than is typically possible with CRLs and MAY also be used to obtain additional status information.

An <protocols:Online Certificate Status Protocol (OCSP)|OCSP> client issues a status request to an <protocols:Online Certificate Status Protocol (OCSP)|OCSP> responder and SHALL suspend the acceptance of the certificates in question until the responder provides a valid response.

If supported by the <roles:Certificate Authority (CA)|CA>, the URI to which the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> Responder can be invoked SHALL be present in the `authorityInfoAccess.accessLocation` extension of the [WRPAC](../sections/trust-artifacts.md#wallet-relying-party-access-certificate).

This protocol specifies the data that SHALL be exchanged between the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> client (which checks the status of one or more certificates) and the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> server (which provides the corresponding status). In this specific ecosystem, the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> client can be a WU checking the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> of a WRP, and the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> server is the Provider of the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>.

#### Online Certificate Status Protocol Request Format

The <protocols:Online Certificate Status Protocol (OCSP)|OCSP> request is the ASN.1 DER encoding of the `OCSPRequest` SEQUENCE, which contains the `tbsRequest` (To-Be-Signed Request) and an optional signature. The following table lists the parameters found within the `tbsRequest` structure.

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `version` | [RFC 6960, clause 4.1.1] | OPTIONAL | *[0] EXPLICIT INTEGER* | Indicates the version of the protocol. If omitted, the default value is `v1` (0). |
| `requestList` | [RFC 6960, clause 4.1.1] | REQUIRED | *SEQUENCE OF* | Contains one or more single certificate status requests. |
| `requestList.reqCert` | [RFC 6960, clause 4.1.1] | REQUIRED | *SEQUENCE* | The `CertID` structure carrying the identifier of a target certificate. |
| `requestList.singleRequestExtensions` | [RFC 6960, clause 4.1.1] | OPTIONAL | *[0] EXPLICIT SEQUENCE* | Includes extensions applicable to this single certificate status request. |
| `requestExtensions` | [RFC 6960, clause 4.1.1] | OPTIONAL | *[2] EXPLICIT SEQUENCE* | Includes extensions applicable to the overall requests found within the `requestList`. |

The `reqCert` parameter utilizes the `CertID` structure, which is an ASN.1 *SEQUENCE* containing the following parameters:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `hashAlgorithm` | [RFC 6960, clause 4.1.1] | REQUIRED | *SEQUENCE* | Identifies the hash algorithm used to generate the issuer name and key hashes. |
| `hashAlgorithm.algorithm` | [RFC 6960, clause 4.1.1] | REQUIRED | *OBJECT IDENTIFIER* | The OID of the hash function (e.g.,SHA-256, depending on the profile). |
| `hashAlgorithm.parameters` | [RFC 6960, clause 4.1.1] | OPTIONAL | *ANY* | Algorithm-specific parameters, dependent on the hash algorithm used. |
| `issuerNameHash` | [RFC 6960, clause 4.1.1] | REQUIRED | *OCTET STRING* | The hash of the issuer's distinguished name (DN), calculated over the DER encoding of the issuer's name field. |
| `issuerKeyHash` | [RFC 6960, clause 4.1.1] | REQUIRED | *OCTET STRING* | The hash of the issuer's public key, calculated over the value (excluding tag and length) of the subject public key field. |
| `serialNumber` | [RFC 6960, clause 4.1.1] | REQUIRED | *INTEGER* | The serial number of the target certificate for which the status is being requested. |

The `requestExtensions` and `singleRequestExtensions` structures MAY contain various extensions. A common extension is the `nonce`:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `nonce` | [RFC 6960, clause 4.4.1] | REQUIRED | *OCTET STRING* | Cryptographically fresh value used to bind a request and a response to prevent replay attacks. Identifier OID is `id-pkix-ocsp-nonce`. |

!!! note

    Within APTITUDE, <protocols:Online Certificate Status Protocol (OCSP)|OCSP> requests SHALL use the `nonce` extension.

When sent over HTTP using POST, the body of this request is the raw DER encoding of this `OCSPRequest`, with the MIME type `application/ocsp-request`.

Below is a concrete example of an <protocols:Online Certificate Status Protocol (OCSP)|OCSP> request:

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

#### Online Certificate Status Protocol Response Format

An <protocols:Online Certificate Status Protocol (OCSP)|OCSP> response is the ASN.1 DER encoding of the `OCSPResponse` *SEQUENCE*. When transported over HTTP, the body of the HTTP response is the raw DER encoding of this `OCSPResponse`, with the MIME type `application/ocsp-response`. The `OCSPResponse` *SEQUENCE* contains the following parameters:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `responseStatus` | [RFC 6960, clause 4.2.1] | REQUIRED | *ENUMERATED* | Indicates the processing status of the prior request. Supported values are: `successful` (0), `malformedRequest` (1), `internalError` (2), `tryLater` (3), `sigRequired` (5), and `unauthorized` (6). |
| `responseBytes` | [RFC 6960, clause 4.2.1] | OPTIONAL | *[0] EXPLICIT SEQUENCE* | Present only when the `responseStatus` is `successful` (0). Contains the response type and the encoded response data. |
| `responseBytes.responseType` | [RFC 6960, clause 4.2.1] | REQUIRED | *OBJECT IDENTIFIER* | Identifier for the response type. For a basic OCSP responder, this value SHALL be `id-pkix-ocsp-basic`. |
| `responseBytes.response` | [RFC 6960, clause 4.2.1] | REQUIRED | *OCTET STRING* | Contains the DER encoding of the response syntax identified by `responseType` (e.g., the `BasicOCSPResponse` structure). |

!!! note

    Within APTITUDE, <protocols:Online Certificate Status Protocol (OCSP)|OCSP> responders SHALL be capable of producing responses of the `id-pkix-ocsp-basic` response type. Correspondingly, <protocols:Online Certificate Status Protocol (OCSP)|OCSP> clients SHALL be capable of receiving and processing responses of the `id-pkix-ocsp-basic` response type.

`BasicOCSPResponse` is an ASN.1 SEQUENCE containing the following parameters:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `tbsResponseData` | [RFC 6960, clause 4.2.1] | REQUIRED | *SEQUENCE* | Contains the core response data to be signed by the responder. |
| `tbsResponseData.version` | [RFC 6960, clause 4.2.1] | OPTIONAL | *[0] EXPLICIT INTEGER* | The version of the response syntax. If omitted, the default value is `v1` (0). |
| `tbsResponseData.responderID` | [RFC 6960, clause 4.2.1] | REQUIRED | *CHOICE* | Identifies the <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> responder. It SHALL contain either `byName` or `byKey`. |
| `tbsResponseData.responderID.byName` | [RFC 6960, clause 4.2.1] | OPTIONAL | *[1] EXPLICIT Name* | The `Name` from the responder’s certificate subject. |
| `tbsResponseData.responderID.byKey` | [RFC 6960, clause 4.2.1] | OPTIONAL | *[2] EXPLICIT OCTET STRING* | The SHA-1 hash of the responder’s `subjectPublicKey` (excluding the tag and length fields). |
| `tbsResponseData.producedAt` | [RFC 6960, clause 4.2.1] | REQUIRED | *GeneralizedTime* | The time at which the <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> response was generated. |
| `tbsResponseData.responses` | [RFC 6960, clause 4.2.1] | REQUIRED | *SEQUENCE OF* | A sequence of `SingleResponse` structures, providing the status of each requested certificate. |
| `tbsResponseData.responseExtensions` | [RFC 6960, clause 4.2.1] | OPTIONAL | *[1] EXPLICIT SEQUENCE OF* | Contains extensions applicable to the overall <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> response. |
| `signatureAlgorithm` | [RFC 5280, clause 4.1.1.2] | REQUIRED | *SEQUENCE* | Identifies the cryptographic algorithm used to sign the response. |
| `signatureAlgorithm.algorithm` | [RFC 5280, clause 4.1.1.2] | REQUIRED | *OBJECT IDENTIFIER* | The OID of the signature algorithm. Selection SHOULD align with relevant standards (e.g., [ETSI TS 119 312]). |
| `signatureAlgorithm.parameters` | [RFC 5280, clause 4.1.1.2] | OPTIONAL | *ANY* | Algorithm-specific parameters, dependent on the OID defined in `algorithm`. |
| `signature` | [RFC 6960, clause 4.2.1] | REQUIRED | *BIT STRING* | The digital signature computed over the hash of the DER-encoded `tbsResponseData`. |
| `certs` | [RFC 6960, clause 4.2.1] | OPTIONAL | *[0] EXPLICIT SEQUENCE OF* | Certificate chain to help the client verify the responder's signature. If no certificates are included, this field SHOULD be absent. |

The `responseExtensions` structure MAY contain various extensions. A notable parameter often required by specific profiles (such as to prevent replay attacks) is the `nonce`:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `nonce` | [RFC 6960, clause 4.4.1] | REQUIRED | *OCTET STRING* | Cryptographically fresh value used to bind a request and a response to prevent replay attacks. If included in the request, responders SHOULD include it in the response. Identifer OID is `id-pkix-ocsp-nonce`. |

!!! note

    Within APTITUDE, <protocols:Online Certificate Status Protocol (OCSP)|OCSP> Responses SHALL use the `nonce` extension.

In the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> Response there SHALL be at least a `SingleResponse` for each `CertID` in the request. Each `SingleResponse` is an ASN.1 *SEQUENCE* that carries the following parameters:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----- | :---------- |
| `certID` | [RFC 6960, clause 4.2.1] | REQUIRED | *SEQUENCE* | Identifier of the certificate whose status is determined in `certStatus`. |
| `certStatus` | [RFC 6960, clause 4.2.1] | REQUIRED | *CHOICE* | The value of the certificate's status. It SHALL be exactly one of: `good`, `revoked`, or `unknown`. |
| `certStatus.good` | [RFC 6960, clause 4.2.1] | OPTIONAL | *[0] IMPLICIT NULL* | Indicates the certificate is valid. |
| `certStatus.revoked` | [RFC 6960, clause 4.2.1] | OPTIONAL | *[1] IMPLICIT SEQUENCE* | Indicates the certificate has been revoked. Contains the `RevokedInfo` structure. |
| `certStatus.revoked.revocationTime` | [RFC 6960, clause 4.2.1] | REQUIRED | *GeneralizedTime* | The time at which the certificate was revoked. |
| `certStatus.revoked.revocationReason` | [RFC 6960, clause 4.2.1] | OPTIONAL | *[0] EXPLICIT ENUMERATED* | Contains the `CRLReason` indicating why the certificate was revoked. |
| `certStatus.unknown` | [RFC 6960, clause 4.2.1] | OPTIONAL | *[2] IMPLICIT NULL* | Indicates the responder does not know the status of the certificate. |
| `thisUpdate` | [RFC 6960, clause 4.2.1] | REQUIRED | *GeneralizedTime* | Indicates the issue date and time of this <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> Response. |
| `nextUpdate` | [RFC 6960, clause 4.2.1] | OPTIONAL | *[0] EXPLICIT GeneralizedTime* | Indicates the date and time by which the next update to the <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> Responder database will be in place. |
| `singleExtensions` | [RFC 6960, clause 4.2.1] | OPTIONAL | *[1] EXPLICIT SEQUENCE* | Includes extensions applicable to this single certificate status response. |

Below is a concrete example of an <protocols:Online Certificate Status Protocol (OCSP)|OCSP> response with a single `good` status.

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
