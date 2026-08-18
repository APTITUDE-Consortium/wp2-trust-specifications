This section extends the general [X.509 Certificate Profile](../sections/trust-artifacts.md#x509-certificate-profile) and specifies a Certificate Profile for <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|Wallet-Relying Party Access Certificates (WRPACs)>.

According to [CIR 2025/848, Article 2], a <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> is a certificate for electronic seals or signatures authenticating and validating the <roles:Wallet-Relying Party (WRP)> when they interact with the EUDI Wallet. For more details on the authentication process, see [Authentication Process](../sections/trust-evaluation-process.md#authentication-process).

The suspension or cancellation of the <roles:Wallet-Relying Party (WRP)|WRP> services involves revocation of all valid <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs> by the relevant issuing authority, such that the <roles:Wallet-Relying Party (WRP)|WRP> is no longer able to interact with <components:Wallet Unit|Wallet Units>. For more detail on the Trust Management processes, see [Trust Management and Lifecycle](../sections/trust-management-lifecycle.md).

??? references

    The technical standard specific to <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs> is [ETSI TS 119 411-8]. However, multiple other standards are referenced either directly or indirectly by [ETSI TS 119 411-8], containing requirements that are applicable to <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs> as well. The list below enumerates all the applicable standards and specifications that have been used to populate the table below:

    - **CIR 2025/848**
    - **ETSI EN 319 411-1**
    - **ETSI EN 319 411-2** (applicable if the certificate is qualified)
    - **ETSI EN 319 412-1**
    - **ETSI EN 319 412-3** (applicable if the certificate is issued to legal persons)
    - **ETSI EN 319 412-5** (applicable if the certificate is qualified)
    - **ETSI TS 119 411-8**
    - **RFC 3647**
    - **RFC 3739**
    - **RFC 5280**
    - **RFC 9608**

!!! note "Dependency Considerations"

    The <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> attributes SHALL be derived from the information held in the <components:Register> as specified in clause 5.1.2 of [ETSI TS 119 475]. This also implies that for some specific attributes in the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> the same value SHALL be encountered in the corresponding <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|Wallet-Relying Party Registration Certificate> if any.

#### Format

The following table defines the complete set of extensions applicable to the certificate profile. Extensions not listed in the table SHALL NOT be present.

| Extension                 | Presence      | Notes |
| ------------------------- | ------------- | ----- |
| `authorityKeyIdentifier`  | REQUIRED      | The The `keyIdentifier` field SHOULD be derived from the public key using the methods defined in [RFC 5280, Section 4.2.1.1]. |
| `subjectKeyIdentifier`    | OPTIONAL      | If present, the `keyIdentifier` field SHOULD be derived from the subject public key using the methods defined in [RFC 5280, Section 4.2.1.2]. |
| `keyUsage`                | REQUIRED      | It SHALL contain one (and only one) of the key-usage settings *Type A*, *Type B*, or *Type F*. *Type A* SHOULD be used as per [ETSI EN 319 412-3, LEG-4.3.1-4]. |
| `certificatePolicies`     | REQUIRED      | It SHALL include a `PolicyInformation` structure with `policyIdentifier` set to one of the following values (defined in [ETSI TS 119 411-8]): `0.4.0.194118.1.1` (NCP-n-eudiwrp); `0.4.0.194118.1.2` (NCP-l-eudiwrp); `0.4.0.194118.1.3` (QCP-n-eudiwrp); `0.4.0.194118.1.4` (QCP-l-eudiwrp). Moreover, `policyQualifiers` SHALL contain a `cpsURI` that references an URL where the CPS of the <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC> is located. |
| `subjectAltName`          | REQUIRED      | It SHALL include a `GeneralName` structure with one of the following parameters defined to provide valid contact information of the WRP: `uniformResourceIdentifier` (website for helpdesk/support matters), `otherName` with `type-id` set to `2.5.4.20` (`id-at-telephoneNumber`, phone number for WRP registration/usage matters), `rfc822Name` (email address for WRP registration/usage matters). |
| `cRLDistributionPoints`   | CONDITIONAL   | **REQUIRED IF:** the certificate does not include any access location of an <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> responder or the validity assured extension as defined in [ETSI EN 319 412-1]. If present, it SHALL contain at least one reference to a publicly available <artifacts:Certificate Revocation List (CRL)\|Certificate Revocation List>. |
| `authorityInfoAccess`     | REQUIRED      | It SHALL include an `AccessDescription` structure with `accessMethod` set to `1.3.6.1.5.5.7.48.2` (`id-ad-caIssuers`) and `accessLocation` specifying at least one access location of a valid CA certificate of the issuing <roles:Certificate Authority (CA)\|CA>. If <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> is supported by the issuing CA, the extension SHALL include an `AccessDescription` structure with `accessMethod` set to `1.3.6.1.5.5.7.48.1` (`id-ad-ocsp`) and `accessLocation` specifying at least one <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> responder authoritative to provide certificate status information for the certificate. |
| `qcStatements`            | OPTIONAL      | It MAY contain `QCStatement` structures among those defined in [ETSI EN 319 412-5, Clause 4.2]. In any case, it SHALL NOT contain:<ul><li>A `QCStatement` structure with `statementId` set to `0.4.0.1862.1.1` (`id-etsi-qcs-QcCompliance`), referred to as `esi4-qcStatement-1`.</li><li>A `QCStatement` structure with `statementId` set to `0.4.0.1862.1.4` (`id-etsi-qcs-QcSSCD`), referred to as `esi4-qcStatement-4`.</li><li>A `QCStatement` structure with `statementId` set to `0.4.0.1862.1.7` (`id-etsi-qcs-QcCClegislation`), referred to as `esi4-qcStatement-7`.</li></ul>

!!! choice "APTITUDE Implementation Choices"

    - WRPACs SHALL be issued only to legal persons.
    - WRPACs SHALL be long-lived. Therefore, the extensions `ext-etsi-valassured-ST-certs` and `noRevAvail` SHALL NOT be specified.
    - WRPACs SHALL NOT be Qualified Certificates. Therefore, the `qcStatements` extension SHALL NOT contain `QCStatement` structures with `statementId` set to `0.4.0.1862.1.1` (`id-etsi-qcs-QcCompliance`) or `0.4.0.1862.1.4` (`id-etsi-qcs-QcSSCD`).

??? example "Example: WRPAC for legal persons"

    {% include-markdown "../examples/access-certificate.md" %}

#### Security Considerations

A <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> is a certificate for electronic seals or signatures that is used to authenticate and validate a WRP when interacting with <components:Wallet Unit|Wallet Units>. Because the corresponding private key is a signature/seal key, implementations SHALL prevent the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> key from becoming a general-purpose signing oracle.

**SC-1 — No blind signing of attacker-controlled inputs.**
The WRP (and any remote signing component used on its behalf, e.g., HSM/QSCD/remote seal) should only sign well-defined, locally constructed protocol artefacts and should not sign arbitrary bytes received from outside (e.g., *random* <data-elements:Nonce|nonces>, hashes, or opaque challenges supplied by an attacker).
For instance, when the interaction with the <components:Wallet Unit> takes plase as described in the protocol [OpenID4VP], the WRP signs a self-constructed <artifacts:Request Object>. Before signing, the WRP SHOULD validate that the <artifacts:Request Object> is fully context-bound (e.g., correct `aud`, `client_id`/`iss`, `exp`, `nonce`, and correct endpoint binding such as `response_uri`/`redirect_uri`, and the intended presentation definition). Any signing API should enforce a strict schema/allowlist and reject unexpected fields. This is particularly important when the key usage is set to non-repudiation, since this protects against the signing entity falsely denying some action and allows a reliable third party to determine the authenticity of signed data in case of later conflict.

**SC-2 — Bind signatures to the intended protocol context.**
Signed protocol objects should be clearly typed and scoped to the protocol to reduce *cross-context* misuse. In particular:

- Use an explicit JOSE `typ` value appropriate for secured authorization requests / OpenID4VP <artifacts:Request Object|Request Objects>.
- Constrain accepted JOSE algorithms and key types, and reject insecure or unexpected values (e.g., `alg=none`).

**SC-3 — Key protection, access control, and monitoring.**
Private keys corresponding to <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs> SHOULD be protected and operated under strong controls (access control for key use, audit logging, incident response, and operational monitoring). For remote signing, apply rate limiting and anomaly detection to reduce abuse.
