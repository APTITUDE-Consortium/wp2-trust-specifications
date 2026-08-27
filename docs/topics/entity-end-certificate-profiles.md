This section extends the [X.509 Certificate Profile](../sections/trust-artifacts.md#x509-certificate-profile) and specifies Certificate Profiles for Entity Sign/Seal Certificates, which are used for signing and sealing various Attestations.

??? references

    To guarantee the interoperability across all entities of the EUDIW ecosystem, Entity Sign/Seal Certificates should adhere to common requirements, with respect to their content and format. The technical specifications describing such content are distributed between multiple documents and for a purpose of proper referencing are listed below:

    - **ETSI EN 319 411-1**
    - **ETSI EN 319 411-2** (applicable if the certificate is qualified)
    - **ETSI EN 319 412-1**
    - **ETSI EN 319 412-2** (applicable if the certificate is issued to natural persons)
    - **ETSI EN 319 412-3** (applicable if the certificate is issued to legal persons)
    - **ETSI EN 319 412-5** (applicable if the certificate is qualified)
    - **ETSI TS 119 412-6** (profiles the Sign/Seal certificate for various entities in the EUDIW ecosystem)
    - **ETSI TS 119 612**
    - **RFC 3986**
    - **RFC 5280**

!!! choice "APTITUDE Implementation Choices"

    - Entity Sign/Seal Certificates SHALL be issued by a CA and SHALL NOT be self-signed.
    - Entity Sign/Seal Certificates SHALL be issued only to legal persons.
    - Entity Sign/Seal Certificates SHALL be long-lived. Therefore, the extensions `ext-etsi-valassured-ST-certs` and `noRevAvail` SHALL NOT be specified.

#### PID Provider Sign/Seal Certificate

The specific requirements for PID Provider Sign/Seal Certificates are specified in [ETSI TS 119 412-6, Clause 4].

The following table defines the complete set of extensions applicable to the certificate profile. Extensions not listed in the table SHALL NOT be present.

| Extension                 | Presence      | Notes |
| ------------------------- | :-----------: | ----- |
| `authorityKeyIdentifier`  | REQUIRED      | The value of the `keyIdentifier` field SHOULD be derived from the public key using the methods defined in [RFC 5280, Section 4.2.1.1] |
| `subjectKeyIdentifier`    | REQUIRED      | Its value SHOULD be derived from the subject public key using the methods defined in [RFC 5280, Section 4.2.1.2]. |
| `keyUsage`                | REQUIRED      | It SHALL contain one (and only one) of the key-usage settings *Type A*, *Type B*, *Type C*, or *Type F*. |
| `certificatePolicies`     | REQUIRED      | It SHALL include a `PolicyInformation` structure with `policyIdentifier` set to the OID of a certificate policy including at least the requirements for *NCP+*, defined in [ETSI EN 319 411-1], to comply with [ARF] requirement `AS-AP-10-098`. |
| `subjectAltName`          | REQUIRED      |  |
| `cRLDistributionPoints`   | CONDITIONAL   | **REQUIRED IF:** the certificate does not include any access location of an OCSP responder or the validity assured extension as defined in [ETSI EN 319 412-1]. If present, it SHALL contain at least one reference to a publicly available <artifacts:Certificate Revocation List (CRL)\|Certificate Revocation List>. |
| `authorityInfoAccess`     | REQUIRED      | It SHALL include an `AccessDescription` structure with `accessMethod` set to `1.3.6.1.5.5.7.48.2` (`id-ad-caIssuers`) and `accessLocation` specifying at least one access location of a valid CA certificate of the issuing CA. If OCSP is supported by the issuing CA, the extension SHALL include an `AccessDescription` structure with `accessMethod` set to `1.3.6.1.5.5.7.48.1` (`id-ad-ocsp`) and `accessLocation` specifying at least one OCSP responder authoritative to provide certificate status information for the certificate, as described in [Online Certificate Status Protocol](../sections/trust-management-lifecycle.md#online-certificate-status-protocol). |
| `qcStatements`            | REQUIRED      | It SHALL contain a `QCStatement` structure with `statementId` set to `0.4.0.1862.1.6` (`id-etsi-qcs-QcType`); the corresponding `statementInfo` SHALL contain a `QcType` structure including exactly one object identifier, namely `0.4.0.194126.1.1` (`id-etsi-qct-pid`), as defined in [ETSI TS 119 412-6, Clause 4.5]. It MAY contain additional `QCStatement` structures among those defined in [ETSI EN 319 412-5, Clause 4.2]. It MAY contain additional `QCStatement` structures among those defined in [ETSI EN 319 412-5, Clause 4.2]. In any case, it SHALL NOT contain:<ul><li>A `QCStatement` structure with `statementId` set to `0.4.0.1862.1.1` (`id-etsi-qcs-QcCompliance`), referred to as `esi4-qcStatement-1`.</li><li>A `QCStatement` structure with `statementId` set to `0.4.0.1862.1.4` (`id-etsi-qcs-QcSSCD`), referred to as `esi4-qcStatement-4`.</li><li>A `QCStatement` structure with `statementId` set to `0.4.0.1862.1.7` (`id-etsi-qcs-QcCClegislation`), referred to as `esi4-qcStatement-7`.</li></ul> |

!!! choice "APTITUDE Implementation Choice"

    PID Provider Sign/Seal Certificates are not Qualified Certificates. Therefore, the `qcStatements` extension SHALL NOT contain `QCStatement` structures with `statementId` set to `0.4.0.1862.1.1` (`id-etsi-qcs-QcCompliance`) or `0.4.0.1862.1.4` (`id-etsi-qcs-QcSSCD`).

??? example "Example: PID Provider Sign/Seal Certificate"

    {% include-markdown "../examples/pid-provider-sign-seal.md" %}

#### Wallet Provider Sign/Seal Certificate

The specific requirements for Wallet Provider Sign/Seal Certificates are specified in [ETSI TS 119 412-6, Clause 5].

The following table defines the complete set of extensions applicable to the certificate profile. Extensions not listed in the table SHALL NOT be present.

| Extension                 | Presence      | Notes |
| ------------------------- | ------------- | ----- |
| `authorityKeyIdentifier`  | REQUIRED      | The value of the `keyIdentifier` field SHOULD be derived from the public key using the methods defined in [RFC 5280, Section 4.2.1.1] |
| `subjectKeyIdentifier`    | REQUIRED      | Its value SHOULD be derived from the subject public key using the methods defined in [RFC 5280, Section 4.2.1.2]. |
| `keyUsage`                | REQUIRED      | It SHALL contain one (and only one) of the key-usage settings *Type A*, *Type B*, *Type C*, or *Type F*. |
| `certificatePolicies`     | REQUIRED      | It SHALL include a `PolicyInformation` structure with `policyIdentifier` set to the OID of a certificate policy including at least (as per [ARF] requirement `EW-DM-38-001`):<ul><li>The requirements for *NCP*, defined in [ETSI EN 319 411-1], for KAs describing a keystore.</li><li>The requirements for *NCP+*, defined in [ETSI EN 319 411-1], for KAs describing a WSCA/WSCD.</li></ul> |
| `subjectAltName`          | REQUIRED      |  |
| `cRLDistributionPoints`   | CONDITIONAL   | **REQUIRED IF:** the certificate does not include any access location of an OCSP responder or the validity assured extension as defined in [ETSI EN 319 412-1]. If present, it SHALL contain at least one reference to a publicly available <artifacts:Certificate Revocation List (CRL)\|Certificate Revocation List>. |
| `authorityInfoAccess`     | REQUIRED      | It SHALL include an `AccessDescription` structure with `accessMethod` set to `1.3.6.1.5.5.7.48.2` (`id-ad-caIssuers`) and `accessLocation` specifying at least one access location of a valid CA certificate of the issuing CA. If OCSP is supported by the issuing CA, the extension SHALL include an `AccessDescription` structure with `accessMethod` set to `1.3.6.1.5.5.7.48.1` (`id-ad-ocsp`) and `accessLocation` specifying at least one OCSP responder authoritative to provide certificate status information for the certificate, as described in [Online Certificate Status Protocol](../sections/trust-management-lifecycle.md#online-certificate-status-protocol). |
| `qcStatements`            | REQUIRED  | It SHALL contain a `QCStatement` structure with `statementId` set to `0.4.0.1862.1.6` (`id-etsi-qcs-QcType`); the corresponding `statementInfo` SHALL contain a `QcType` structure including exactly one object identifier, namely `0.4.0.194126.1.2` (`id-etsi-qct-wal`), as defined in [ETSI TS 119 412-6, Clause 5.2]. It MAY contain additional `QCStatement` structures among those defined in [ETSI EN 319 412-5, Clause 4.2]. In any case, it SHALL NOT contain:<ul><li>A `QCStatement` structure with `statementId` set to `0.4.0.1862.1.1` (`id-etsi-qcs-QcCompliance`), referred to as `esi4-qcStatement-1`.</li><li>A `QCStatement` structure with `statementId` set to `0.4.0.1862.1.4` (`id-etsi-qcs-QcSSCD`), referred to as `esi4-qcStatement-4`.</li><li>A `QCStatement` structure with `statementId` set to `0.4.0.1862.1.7` (`id-etsi-qcs-QcCClegislation`), referred to as `esi4-qcStatement-7`.</li></ul> |

!!! choice "APTITUDE Implementation Choice"

    Wallet Provider Sign/Seal Certificates are not Qualified Certificates. Therefore, the `qcStatements` extension SHALL NOT contain `QCStatement` structures with `statementId` set to `0.4.0.1862.1.1` (`id-etsi-qcs-QcCompliance`) or `0.4.0.1862.1.4` (`id-etsi-qcs-QcSSCD`).

??? example "Example: Wallet Provider Sign/Seal Certificate"

    {% include-markdown "../examples/wallet-provider-sign-seal.md" %}

#### (Q)EAA Provider Sign/Seal Certificate

The specific requirements for EAA Provider and QEAA Provider Sign/Seal Certificates are specified in Clauses 6 and 7 of [ETSI TS 119 412-6], respectively.

The following table defines the complete set of extensions applicable to the certificate profile. Extensions not listed in the table SHALL NOT be present.

| Extension                 | Presence                          | Notes |
| ------------------------- | --------------------------------- | ----- |
| `authorityKeyIdentifier`  | REQUIRED                          | The value of the `keyIdentifier` field SHOULD be derived from the public key using the methods defined in [RFC 5280, Section 4.2.1.1] |
| `subjectKeyIdentifier`    | OPTIONAL                          | If present, its value SHOULD be derived from the subject public key using the methods defined in [RFC 5280, Section 4.2.1.2]. |
| `keyUsage`                | REQUIRED                          | It SHALL contain one (and only one) of the key-usage settings *Type A*, *Type B*, *Type C*, or *Type F*. |
| `certificatePolicies`     | REQUIRED (only for QEAA)          | As described in [ETSI EN 319 411-2, Clause 6.6.1]. |
| `subjectAltName`          | REQUIRED                          |  |
| `cRLDistributionPoints`   | CONDITIONAL                       | **REQUIRED IF:** the certificate does not include any access location of an OCSP responder or the validity assured extension as defined in [ETSI EN 319 412-1]. If present, it SHALL contain at least one reference to a publicly available <artifacts:Certificate Revocation List (CRL)\|Certificate Revocation List>. |
| `authorityInfoAccess`     | REQUIRED (only for QEAA)          | It SHALL include an `AccessDescription` structure with `accessMethod` set to `1.3.6.1.5.5.7.48.2` (`id-ad-caIssuers`) and `accessLocation` specifying at least one access location of a valid CA certificate of the issuing CA. If OCSP is supported by the issuing CA, the extension SHALL include an `AccessDescription` structure with `accessMethod` set to `1.3.6.1.5.5.7.48.1` (`id-ad-ocsp`) and `accessLocation` specifying at least one OCSP responder authoritative to provide certificate status information for the certificate, as described in [Online Certificate Status Protocol](../sections/trust-management-lifecycle.md#online-certificate-status-protocol). |
| `qcStatements`            | REQUIRED (QEAA), OPTIONAL (EAA)   | For **QEAA**: It SHALL contain a `QCStatement` structure with `statementId` set to `0.4.0.1862.1.1` (`id-etsi-qcs-QcCompliance`), referred to as `esi4-qcStatement-1`.<br />For **EAA**:<ul><li>It SHALL NOT contain a `QCStatement` structure with `statementId` set to `0.4.0.1862.1.1` (`id-etsi-qcs-QcCompliance`), referred to as `esi4-qcStatement-1`.</li><li>It SHALL NOT contain a `QCStatement` structure with `statementId` set to `0.4.0.1862.1.4` (`id-etsi-qcs-QcSSCD`), referred to as `esi4-qcStatement-4`.</li></ul>For **both**:<ul><li>It MAY contain additional `QCStatement` structures among those defined in [ETSI EN 319 412-5, Clause 4.2].</li><li>In any case, it SHALL NOT contain a `QCStatement` structure with `statementId` set to `0.4.0.1862.1.7` (`id-etsi-qcs-QcCClegislation`), referred to as `esi4-qcStatement-7`.</li></ul> |

!!! choice "APTITUDE Implementation Choices"

    - QEAA Provider Sign/Seal Certificates SHALL be Qualified Certificates. Therefore, the `qcStatements` extension SHALL contain at least a `QCStatement` structure with `statementId` set to `0.4.0.1862.1.1` (`id-etsi-qcs-QcCompliance`).
    
    - EAA Provider Sign/Seal Certificates SHALL NOT be Qualified Certificates. Therefore, the `qcStatements` extension SHALL NOT contain `QCStatement` structures with `statementId` set to `0.4.0.1862.1.1` (`id-etsi-qcs-QcCompliance`) or `0.4.0.1862.1.4` (`id-etsi-qcs-QcSSCD`).

??? example "Example: QEAA Provider Sign/Seal Certificate"

    {% include-markdown "../examples/qeaa-provider-sign-seal.md" %}

#### PuB-EAA Provider Sign/Seal Certificate

The following table defines the complete set of extensions applicable to the certificate profile. Extensions not listed in the table SHALL NOT be present.

| Extension                 | Presence      | Notes |
| ------------------------- | ----------------------------- | ----- |
| `authorityKeyIdentifier`  | REQUIRED      | The value of the `keyIdentifier` field SHOULD be derived from the public key using the methods defined in [RFC 5280, Section 4.2.1.1] |
| `subjectKeyIdentifier`    | OPTIONAL      | If present, its value be derived from the subject public key using the methods defined in [RFC 5280, Section 4.2.1.2]. |
| `keyUsage`                | REQUIRED      |  |
| `certificatePolicies`     | REQUIRED      | As described in [ETSI EN 319 411-2, Clause 6.6.1]. |
| `subjectAltName`          | REQUIRED      |  |
| `cRLDistributionPoints`   | CONDITIONAL   | **REQUIRED IF:** the certificate does not include any access location of an OCSP responder or the validity assured extension as defined in [ETSI EN 319 412-1]. If present, it SHALL contain at least one reference to a publicly available <artifacts:Certificate Revocation List (CRL)\|Certificate Revocation List>. |
| `authorityInfoAccess`     | REQUIRED      | It SHALL include an `AccessDescription` structure with `accessMethod` set to `1.3.6.1.5.5.7.48.2` (`id-ad-caIssuers`) and `accessLocation` specifying at least one access location of a valid CA certificate of the issuing CA. If OCSP is supported by the issuing CA, the extension SHALL include an `AccessDescription` structure with `accessMethod` set to `1.3.6.1.5.5.7.48.1` (`id-ad-ocsp`) and `accessLocation` specifying at least one OCSP responder authoritative to provide certificate status information for the certificate, as described in [Online Certificate Status Protocol](../sections/trust-management-lifecycle.md#online-certificate-status-protocol). |
| `qcStatements`            | REQUIRED      | It SHALL contain:<ul><li>A `QCStatement` structure with `statementId` set to `0.4.0.1862.1.1` (`id-etsi-qcs-QcCompliance`), referred to as `esi4-qcStatement-1`.</li><li>A `QCStatement` structure with `statementId` set to the OID corresponding to `id-etsi-qcs-QcPSB`; the corresponding `statementInfo` SHALL contain a `QcPSB` structure including the fields defined in [ETSI TS 119 412-6, Clause 8.3].</li></ul>It MAY contain additional `QCStatement` structures among those defined in [ETSI EN 319 412-5, Clause 4.2]. In any case, it SHALL NOT contain a `QCStatement` structure with `statementId` set to `0.4.0.1862.1.7` (`id-etsi-qcs-QcCClegislation`), referred to as `esi4-qcStatement-7`. |

!!! warning

    While the specific requirements for PuB-EAA Provider Sign/Seal Certificates specified in [ETSI TS 119 412-6, Clause 8] do not require these certificates to be qualified, [EU REG 2024/1183, Art. 45f(1)(b)] requires PuB-EAA Attestations to be signed with a qualified certificate.

!!! choice "APTITUDE Implementation Choice"

    To comply with [EU REG 2024/1183, Art. 45f(1)(b)], although not explicitly required by [ARF] or [ETSI TS 119 412-6], PuB-EAA Provider Sign/Seal Certificates are Qualified Certificates. Therefore, the `qcStatements` extension SHALL contain at least a `QCStatement` structure with `statementId` set to `0.4.0.1862.1.1` (`id-etsi-qcs-QcCompliance`).

!!! warning

    [ETSI TS 119 412-6, Annex A] does not define the specific OID of the `id-etsi-qcs-QcPSB` statement identifier.

??? example "Example: Pub-EAA Provider Sign/Seal Certificate"

    {% include-markdown "../examples/pubeaa-provider-sign-seal.md" %}
