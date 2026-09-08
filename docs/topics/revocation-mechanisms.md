This section describes the artifacts that are employed in [Trust Management and Lifecycle](../sections/trust-management-lifecycle.md) to manage the status of certificates and entities by detailing respective formats and parameters. The main distinction is the following:

- To manage <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|Wallet-Relying Party Access Certificates (WRPACs)>, each <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC> SHALL:
    - make available at least one revocation mechanism among [Certificate Revocation Lists](#certificate-revocation-lists) and [Online Certificate Status Protocol](#online-certificate-status-protocol);
    - issue <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs> with at least an extension corresponding to the provided revocation mechanism as illustrated in [Wallet-Relying Party Access Certificate](../sections/trust-artifacts.md#wallet-relying-party-access-certificate).
- To manage <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|Wallet-Relying Party Registration Certificates (WRPRCs)>, each <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)|Provider of WRPRC> SHALL:
    - make available an endpoint to request [Status List Tokens](#status-list-token);
    - issue <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRCs> with the appropriate parameter `status` as described in [Wallet-Relying Party Registration Certificate](../sections/trust-artifacts.md#wallet-relying-party-registration-certificate).
- To manage <artifacts:Wallet Unit Attestation (WUA)|Wallet Unit Attestations (WUAs)>, each <roles:Wallet Provider (WP)|Wallet Provider> SHALL:
    - make available an endpoint to request [Status List Tokens](#status-list-token);
    - issue <artifacts:Wallet Instance Attestation (WIA)|WIAs> and <artifacts:Key Attestation (KA)|KAs> with the appropriate status-list references in `client_status.status.status_list` and `key_storage_status.status.status_list`, respectively, as described in [Token Status List (Wallet Unit Attestation Profile)](#token-status-list-wallet-unit-attestation-profile).

### Token Status List

This section profiles the Token Status List (TSL) mechanism of [draft-ietf-oauth-status-list] for artifacts whose status is managed using a Status List. A TSL conveys the current status of many artifacts in a compact, signed <artifacts:Status List Token>. The requirements in this profile apply unless refined by one of the artifact-specific profiles below.

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

The **<artifacts:Status List Token>** is available at the Status List Endpoint.
The format for the Status List Token is specified in [Status List Token](../sections/trust-artifacts.md#status-list-token).

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

This section profiles the Token Status List (TSL) mechanism of [draft-ietf-oauth-status-list] for <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|Wallet-Relying Party Registration Certificates (WRPRCs)>.

!!! choice

    Within the APTITUDE Profiles, the SLT Provider for WRPRC Status List Tokens SHALL be the <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)|Provider of WRPRC>.

**Status List**

According to the [ARF] and [ETSI TS 119 475], the WRPRC status is either `VALID` or `INVALID`; therefore, the <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)|Provider of WRPRC> SHALL set the `bits` parameter in the SLT's `status_list` object to `1`. The value `0x00` represents `VALID`, and the value `0x01` represents `INVALID`.

The SLT Provider SHALL pack entries starting with the least significant bit of each byte, compress the byte array using DEFLATE with the ZLIB data format, and publish the resulting Status List in the SLT.

**Status List Token**

!!! choice "APTITUDE Implementation Choices"

    - The SLT Provider SHALL act as both the Status Issuer and the Status Provider.
    - It SHALL make each SLT available via HTTP GET at the URI specified by the WRPRC's `status.status_list.uri` member, using `application/statuslist+jwt` for a JWT SLT.
    - The SLT format SHALL be either a JWT and SHALL be protected by a cryptographic signature.

A JWT SLT SHALL be formatted as described in [Status List Token](#status-list-token).

Regardless of the format, the SLT Provider for WRPRCs SHALL sign each SLT using a valid X.509 certificate whose trust chain terminates at the Trust Anchor published in the Providers of WRPRC LoTE.

For a JWT SLT, the signing certificate chain SHALL be carried in the `x5c` JOSE header.

##### Token Status List (Wallet Unit Attestation Profile)

This section profiles the Token Status List (TSL) mechanism of [draft-ietf-oauth-status-list] for Wallet Instance Attestations or Key Attestations as described in [TS03] and [CIR 2026/1731].

!!! choice "APTITUDE Implementation Choice"

    Within the APTITUDE Profiles, the SLT Provider SHALL be the <roles:Wallet Provider (WP)|Wallet Provider>.

!!! note "Signature Algorithms"

    The Signature Algorithms allowed for signing a Status List Token SHALL be these referenced in [TS03], i.e., ES256 (ECDSA with SHA-256 and P-256), ES384 (ECDSA with SHA-384 and P-384), and ES512 (ECDSA with SHA-512 and P-512).

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

    Within the APTITUDE Profiles, the <roles:Wallet Provider (WP)|Wallet Provider> SHALL **Option 1: `type-shared index`**. As a result, the `idx` within the Status List reference SHOULD NOT not be unique per Key Attestation token as multiple Key Attestation statuses may be referenced in the same index depending on the devices used.

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

For PIDs, the current [TS03] requirements, as reflected in [CIR 2026/1731], require the PID Provider to monitor both the WIA and KA status at least once every 24 hours when the technical validity period of the PID exceeds 24 hours.

!!! choice

    For other Attestation types, within the APTITUDE profiles,
    
    - both WIA and KA operational checks SHALL be performed for device-bound credentials when operational monitoring is enabled; while,
    - only the WIA operational check SHALL be performed for non-device-bound attestations when operational monitoring is enabled.

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

??? example "Example: Credential Issuer Metadata of an Attestation Provider monitoring both WIA and KA"

    {% include-markdown "../examples/credential-issuer-metadata-ka-wia.md" %}

??? example "Example: Credential Issuer Metadata of an Attestation Provider not monitoring KA"

    {% include-markdown "../examples/credential-issuer-metadata-wia.md" %}    

!!! warning "Privacy Considerations"

    To prevent Wallet Providers from tracking or profiling users based on their use of Wallet Unit Attestations, Wallet Providers SHALL integrate the status information for many WIAs (type-shared KAs are exempt from this requirement) into the same list and SHALL publish the SLT at the same `uri` for all those attestations. This specification requires Wallet Providers to configure Status Lists with at least 10000 status entries. If more attestations are issued, the Wallet Provider MAY create additional SLTs or increase the number of entries in the array, depending on practical considerations such as the total size of each SLT and the management of multiple endpoints.

### Certificate Revocation Lists

The format for Certificate Revocation Lists (CRLs) is specified in [Certificate Revocation List](../sections/trust-artifacts.md#certificate-revocation-list).

### Online Certificate Status Protocol

The <protocols:Online Certificate Status Protocol (OCSP)>, defined in [RFC 6960], enables applications to determine the exact revocation state of identified certificates. It provides more timely revocation information than is typically possible with CRLs and MAY also be used to obtain additional status information.

An <protocols:Online Certificate Status Protocol (OCSP)|OCSP> client issues a status request to an <protocols:Online Certificate Status Protocol (OCSP)|OCSP> responder and SHALL suspend the acceptance of the certificates in question until the responder provides a valid response.

If supported by the <roles:Certificate Authority (CA)|CA>, the URI to which the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> Responder can be invoked SHALL be present in the `authorityInfoAccess.accessLocation` extension of the [WRPAC](../sections/trust-artifacts.md#wallet-relying-party-access-certificate).

This protocol specifies the data that SHALL be exchanged between the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> client (which checks the status of one or more certificates) and the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> server (which provides the corresponding status). In this specific ecosystem, the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> client can be a Wallet Unit checking the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> of a WRP, and the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> server is the Provider of the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>.

The format for OCSP Requests and Responses is specified in [Online Certificate Status Protocol Artifacts](../sections/trust-artifacts.md#online-certificate-status-protocol-artifacts).
