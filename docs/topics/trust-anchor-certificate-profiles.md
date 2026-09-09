This section extends the general [X.509 Certificate Profile](../sections/trust-artifacts.md#x509-certificate-profile) and specifies a Certificate Profile for entity <artifacts:Trust Anchor|Trust Anchors>.

A <artifacts:Trust Anchor> is an authoritative entity represented by a public key and associated data. The public key is used to verify digital signatures, and the associated data is used to constrain the types of information or actions for which the <artifacts:Trust Anchor> is authoritative. Within the <artifacts:List of Trusted Entities (LoTE)|LoTE> infrastructure, the <artifacts:Trust Anchor> Certificate is referenced from the corresponding service entry through the ``serviceDigitalIdentity`` component.

<artifacts:Trust Anchor> certificates MAY be self-signed or non self-signed. In any case, <roles:Relying Party (RP)|Relying Parties> SHALL NOT require an additional issuer chain above a <artifacts:List of Trusted Entities (LoTE)|LoTE>-designated trust anchor, even if it is not self-signed, as the <artifacts:Trust Anchor> is a trust-store input designated by policy.

!!! note "Relationship Between Trust Anchors and Entity Sign/Seal Certificates"

    According to [OpenID4VC HAIP, Clause 6.1]:

    - <roles:Attestation Provider (AP)|Attestation Provider>'s signing certificate SHALL be present in the <formats:Selective Disclosure JWT (SD-JWT)|SD-JWT> `x5c` header (the `x5c` header SHALL NOT be empty).
    - <artifacts:Trust Anchor> certificate of the <roles:Attestation Provider (AP)|Attestation Provider> SHALL NOT be present in the <formats:Selective Disclosure JWT (SD-JWT)|SD-JWT> `x5c` header.

    Therefore, <roles:Attestation Provider (AP)|Attestation Providers>' Sign/Seal Certificates SHALL NOT be a <artifacts:Trust Anchor> certificate.

??? references

    - **CIR 2024/2980**
    - **ETSI TS 119 602**
    - **ETSI TS 119 612**
    - **RFC 5280**
    - **RFC 5914**

!!! choice "APTITUDE Implementation Choice"

    <artifacts:Trust Anchor> Certificates SHALL be issued only to legal persons.

The following table defines the profile-specific requirements for the certificate fields. Fields not listed in the table remain subject to the requirements defined in the [X.509 Certificate Profile](../sections/trust-artifacts.md#x509-certificates).

| Field     | Additional Requirements   |
| --------- | ------------------------- |
| `issuer`  | If the certificate is self-signed, the issuer's distinguished name SHALL be identical to the subject's distinguished name. Otherwise, the issuer's distinguished name SHALL identify the entity that signed and issued the certificate and MAY differ from the subject's distinguished name. |
| `subject` | The distinguished name SHALL contain an `organizationName` attribute identifying that entity. |

The following table defines the complete set of extensions applicable to the certificate profile.

| Extension                 | Presence      | Notes |
| ------------------------- | ------------- | ----- |
| `authorityKeyIdentifier`  | CONDITIONAL   | **REQUIRED IF:** the certificate is not self-signed. For self-signed certificates, it is RECOMMENDED. If the extension is present, the value of the `keyIdentifier` field SHOULD be derived from the public key using the methods defined in [RFC 5280, Section 4.2.1.1]. |
| `subjectKeyIdentifier`    | REQUIRED      | Provides a key identifier for the <artifacts:Trust Anchor> public key. Its value SHOULD be derived from the subject public key using the methods defined in [RFC 5280, Section 4.2.1.2]. This extension SHOULD support reliable Certificate Path construction and certificate matching in <artifacts:List of Trusted Entities (LoTE)\|LoTE>-based deployments. |
| `keyUsage`                | REQUIRED      | It SHALL assert the `keyCertSign` bit. It MAY assert the `cRLSign` bit if the <artifacts:Trust Anchor> certificate is used by the <roles:Certificate Authority (CA)\|CA> to sign <artifacts:Certificate Revocation List (CRL)\|CRLs>. It SHOULD be limited to usages consistent with the <roles:Certificate Authority (CA)\|CA> role of the <artifacts:Trust Anchor> certificate. |
| `certificatePolicies`     | OPTIONAL      | It MAY include a `PolicyInformation` structure relevant to the issuing <roles:Certificate Authority (CA)\|CA>'s practices. |
| `subjectAltName`          | OPTIONAL      | It MAY include a `GeneralName` structure with additional information on the subject. |
| `issuerAltName`           | OPTIONAL      | It MAY include a `GeneralName` structure with additional information on the issuer. |
| `basicConstraints`        | REQUIRED      | The `cA` field SHALL be set to `TRUE`, signalling <roles:Certificate Authority (CA)\|CA> capability for X.509 path validation. The `pathLenConstraint` field MAY be present; in that case, it SHALL limit the number of non-self-issued intermediate <roles:Certificate Authority (CA)\|CA> certificates below the <artifacts:Trust Anchor>. It is RECOMMENDED to set `pathLenConstraint` to `0` to prevent subordinate <roles:Certificate Authority (CA)\|CA> layers, unless a documented operational need exists to support additional intermediate <roles:Certificate Authority (CA)\|CA> tiers. |
| `cRLDistributionPoints`   | OPTIONAL      | It MAY include <artifacts:Certificate Revocation List (CRL)\|CRL> distribution point URIs, when <artifacts:Certificate Revocation List (CRL)\|CRL>-based revocation is used. |
| `authorityInfoAccess`     | OPTIONAL      | If applicable, it MAY include an `AccessDescription` structure with `accessMethod` set to `1.3.6.1.5.5.7.48.2` (`id-ad-caIssuers`) and an `accessLocation` specifying at least one access location of a valid <roles:Certificate Authority (CA)\|CA> certificate of the issuing <roles:Certificate Authority (CA)\|CA>.<br />It MAY also include an `AccessDescription` structure with `accessMethod` set to `1.3.6.1.5.5.7.48.1` (`id-ad-ocsp`) and `accessLocation` specifying at least one <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> responder authoritative to provide certificate status information for the certificate, when <protocols:Online Certificate Status Protocol (OCSP)\|OCSP>-based revocation is used. |
| `qcStatements`            | OPTIONAL      | It MAY contain `QCStatement` structures among those defined in [ETSI EN 319 412-5, Clause 4.2]. In any case, it SHALL NOT contain a `QCStatement` structure with `statementId` set to `0.4.0.1862.1.7` (`id-etsi-qcs-QcCClegislation`), referred to as `esi4-qcStatement-7`. |

!!! note

    The `pathLenConstraint` restricts the depth of certification paths below the <artifacts:Trust Anchor>, as follows:

    - A value of `0` means that the <artifacts:Trust Anchor> MAY issue end-entity certificates but SHALL NOT allow additional non-self-issued intermediate <roles:Certificate Authority (CA)|CA> certificates in the path.
    - Absence of the `pathLenConstraint` implies that no explicit limit is imposed by the certificate itself.

    This profile allows the field to be OPTIONAL to support interoperability with different <components:Public Key Infrastructure (PKI)|PKI> deployment models. However, setting `pathLenConstraint` to `0` is RECOMMENDED to reduce trust hierarchy complexity, improve predictability of certificate chains, and limit the risk associated with unintended subordinate certification authorities.

!!! warning "Use Case-Specific Requirements"

    Specific Use Cases could have custom <artifacts:Trust Anchor> Certificate requirements. Where strictly necessary, implementations MAY define and support additional extensions beyond the profile defined above.

??? example "Example: Self-signed Entity Trust Anchor (root-style)"

    {% include-markdown "../examples/trust-anchor-self-signed.md" %}

??? example "Example: Non-self-signed Entity Trust Anchor (pinned intermediate CA)"

    {% include-markdown "../examples/trust-anchor-intermediate.md" %}
