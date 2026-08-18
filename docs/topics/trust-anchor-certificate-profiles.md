This section extends the general [X.509 Certificate Profile](../sections/trust-artifacts.md#x509-certificate-profile) and specifies a Certificate Profile for entity <artifacts:Trust Anchor|Trust Anchors>.

A <artifacts:Trust Anchor> is a trusted public key (and associated data) used as an input to certification path validation. In this profile, the Trust Anchor SHALL be represented and distributed as an **X.509 certificate**, which MAY be self-signed. When published through <artifacts:Trusted List (TL)|TLs> or <artifacts:List of Trusted Entities (LoTE)|LoTE> infrastructure, that certificate is referenced from the corresponding service entry through the ``serviceDigitalIdentity`` component.

According to [OpenID4VC HAIP, Clause 6.1]:

- <roles:Attestation Provider (AP)|Attestation Provider>'s signing certificate SHALL be present in the <formats:Selective Disclosure JWT (SD-JWT)|SD-JWT> `x5c` header (the `x5c` header SHALL NOT be empty).
- <artifacts:Trust Anchor> certificate of the <roles:Attestation Provider (AP)|Attestation Provider> SHALL NOT be present in the <formats:Selective Disclosure JWT (SD-JWT)|SD-JWT> `x5c` header.

The implication of that is that the <roles:Attestation Provider (AP)|Attestation Provider>'s sign/seal certificate SHALL NOT be a <artifacts:Trust Anchor> certificate.

??? references

    - **CIR 2024/2980**
    - **ETSI TS 119 602**
    - **ETSI TS 119 612**
    - **RFC 5280**
    - **RFC 5914**

#### Definitions

##### Trust Anchor

A **trust anchor** is an authoritative entity represented by a public key and associated data. The public key is used to verify digital signatures, and the associated data is used to constrain the types of information or actions for which the trust anchor is authoritative.

##### Entity Trust Anchor Certificate (EUDIW context)

An **Entity Trust Anchor Certificate** is an **X.509 certificate** that is explicitly trusted by policy because it is published as a <artifacts:Trust Anchor> for a given entity/service in LoTE/Trusted List trust sources.

!!! warning

    A <artifacts:Trust Anchor> certificate may be **self-signed** or **non-self-signed**. In both cases it is treated as a <artifacts:Trust Anchor> if the relying party's trust policy (here: LoTE/Trusted List-based trust source) designates it as such.

##### Termination of certificate path validation

Relying parties validate a presented certificate by building a certification path that **terminates at a <artifacts:Trust Anchor>**. In this ecosystem, path construction and validation **SHALL terminate** at the first certificate that matches a LoTE-listed <artifacts:Trust Anchor>.

#### Trust model assumptions for entity trust anchors

##### What the trust anchor certificate is used for

The entity trust anchor certificate is **not** the certificate used to sign application payloads. Instead, it is used as the **trust termination point** for validating other certificates (typically end-entity certificates) that are used to sign/seal data.

##### CA capability requirement (issuer-style trust anchor)

If the entity trust anchor certificate is used to **issue/sign other certificates** (i.e., it appears as an issuer in the validated path), then it SHALL be a **CA certificate** for X.509 path validation purposes (i.e., it SHALL signal CA capability using X.509 v3 extensions).

##### Validity checking policy

Relying parties SHALL check the validity period of the trust anchor certificate and treat it as invalid if expired or not yet valid.

##### Self-signed and non-self-signed trust anchors

A LoTE/Trusted List-published trust anchor certificate MAY be:

- **Self-signed** (traditional root CA style); or
- **Non-self-signed** but treated as a trust anchor by policy (a "pinned" intermediate CA certificate).

Relying parties SHALL NOT require an additional issuer chain above a LoTE-designated trust anchor, even if it is not self-signed, because the trust anchor is a trust-store input designated by policy.

#### Format

The following table defines the profile-specific requirements for the certificate fields. Fields not listed in the table remain subject to the requirements defined in the common profile defined for [X.509 Certificates](../sections/trust-artifacts.md#x509-certificates).

| Field     | Additional Requirements   |
| --------- | ------------------------- |
| `issuer`  | If the certificate is self-signed, the issuer DN SHALL be identical to the subject DN. Otherwise, the issuer DN SHALL identify the entity that signed and issued the certificate and MAY differ from the subject DN. |

The following table defines the complete set of extensions applicable to the certificate profile. Extensions not listed in the table SHALL NOT be present.

| Extension                 | Presence      | Notes |
| ------------------------- | ------------- | ----- |
| `authorityKeyIdentifier`  | CONDITIONAL   | **REQUIRED IF:** the certificate is not self-signed. For self-signed certificates, it is RECOMMENDED. If present, the The `keyIdentifier` field SHOULD be derived from the public key using the methods defined in [RFC 5280, Section 4.2.1.1]. |
| `subjectKeyIdentifier`    | REQUIRED      | Provides a key identifier for the Trust Anchor public key. The `keyIdentifier` field SHOULD be derived from the subject public key using the methods defined in [RFC 5280, Section 4.2.1.2]. |
| `keyUsage`                | REQUIRED      | It SHALL assert the `keyCertSign` bit. It MAY assert the `cRLSign` bit if the Trust Anchor certificate is used by the CA to sign CRLs. It SHOULD be limited to usages consistent with the CA role of the Trust Anchor certificate. |
| `certificatePolicies`     | OPTIONAL      | It MAY include a `PolicyInformation` structure relevant to the issuing CA's practices. |
| `basicConstraints`        | REQUIRED      | The `cA` field SHALL be set to `TRUE`, signalling CA capability for X.509 path validation. The `pathLenConstraint` field MAY be present; in that case, it SHALL limit the number of non-self-issued intermediate CA certificates below this Trust Anchor. It is RECOMMENDED to set `pathLenConstraint` to `0` to prevent subordinate CA layers, unless a documented operational need exists to support additional intermediate CA tiers. |
| `cRLDistributionPoints`   | OPTIONAL      | It MAY include CRL distribution point URIs, when CRL-based revocation is used. |
| `authorityInfoAccess`     | CONDITIONAL   | **REQUIRED IF:** the certificate contains `basicConstraints` with `pathLenConstraint` > 0. If present, it SHALL include an `AccessDescription` structure with `accessMethod` set to `1.3.6.1.5.5.7.48.2` (`id-ad-caIssuers`) and an `accessLocation` that SHALL use the `http://` scheme and SHALL NOT use the `https://` scheme.<br />It MAY also include an `AccessDescription` structure with `accessMethod` set to `1.3.6.1.5.5.7.48.1` (`id-ad-ocsp`) and `accessLocation` specifying at least one OCSP responder authoritative to provide certificate status information for the certificate, when OCSP-based revocation is used. |
| `qcStatements`            | OPTIONAL      | It MAY contain `QCStatement` structures among those defined in [ETSI EN 319 412-5, Clause 4.2]. In any case, it SHALL NOT contain a `QCStatement` structure with `statementId` set to `0.4.0.1862.1.7` (`id-etsi-qcs-QcCClegislation`), referred to as `esi4-qcStatement-7`. |

!!! note

    The `pathLenConstraint` restricts the depth of certification paths below the Trust Anchor, as follows:

    - A value of `0` means that the Trust Anchor MAY issue end-entity certificates but SHALL NOT allow additional non-self-issued intermediate CA certificates in the path.
    - Absence of the `pathLenConstraint` implies that no explicit limit is imposed by the certificate itself.

    This profile allows the field to be OPTIONAL to support interoperability with different PKI deployment models. However, setting `pathLenConstraint` to `0` is RECOMMENDED to reduce trust hierarchy complexity, improve predictability of certificate chains, and limit the risk associated with unintended subordinate certification authorities.

??? example "Example: Self-signed entity trust anchor (root-style)"

    {% include-markdown "../examples/trust-anchor-self-signed.md" %}

??? example "Example: Non-self-signed entity trust anchor (pinned intermediate CA)"

    {% include-markdown "../examples/trust-anchor-intermediate.md" %}

##### Certificate content requirements derived from LoTE

Below are more in details defined requirements on the Trust Anchor certificate fields based on [ETSI TS 119 602] and [ETSI TS 119 612].

###### Subject Distinguished Name requirements

- The Trust Anchor certificate **SHALL** contain a non-empty subject distinguished name.
- The subject distinguished name **SHALL** identify the entity associated with the trust anchor public key in a clear and unambiguous manner.
- If the Trust Anchor represents a legal or organizational entity, the subject distinguished name **SHALL** contain an organizationName attribute identifying that entity.

###### Validity requirements

- The Trust Anchor certificate **SHALL** contain a validity field specifying the notBefore and notAfter time interval during which the certificate is valid.
- Relying parties **SHALL** check the validity period of the Trust Anchor certificate and **SHALL** treat the certificate as invalid if the current time is before notBefore or after notAfter.

###### Issuer Distinguished Name requirements

- The Trust Anchor certificate **SHALL** contain an issuer distinguished name.
- If the Trust Anchor certificate is self-signed, the issuer distinguished name **SHALL** be identical to the subject distinguished name.
- If the Trust Anchor certificate is non-self-signed, the issuer distinguished name **SHALL** identify the entity that signed and issued the certificate and **MAY** differ from the subject distinguished name.

###### Subject Key Identification requirements

- The Trust Anchor certificate **SHALL** contain a non-critical subjectKeyIdentifier extension identifying the trust anchor public key.
- The value of the subjectKeyIdentifier extension **SHOULD** be derived from the trust anchor public key in a stable and interoperable manner.
- The subjectKeyIdentifier extension **SHOULD** support reliable certificate path construction and certificate matching in LoTE / Trusted List based deployments.

###### Authority Key Identifier requirements

- For a non-self-signed Trust Anchor certificate, a non-critical authorityKeyIdentifier extension **SHALL** be present.
- For a self-signed Trust Anchor certificate, a non-critical authorityKeyIdentifier extension is **RECOMMENDED**.
- Where present, the authorityKeyIdentifier extension **SHOULD** identify the key of the certificate issuer.

###### Basic Constraints requirements

- The Trust Anchor certificate **SHALL** contain a critical basicConstraints extension with cA set to TRUE.
- The pathLenConstraint field in the basicConstraints extension **MAY** be present.
- If present, pathLenConstraint **SHALL** limit the number of non-self-issued intermediate CA certificates below the Trust Anchor certificate.
- Setting pathLenConstraint to 0 is **RECOMMENDED** unless a documented operational need exists to support additional subordinate CA tiers.

###### Key Usage requirements

- The Trust Anchor certificate **SHALL** contain a critical keyUsage extension that includes the keyCertSign bit.
- The keyUsage extension **MAY** include the cRLSign bit where the Trust Anchor certificate is used by a CA that signs certificate revocation lists.
- The keyUsage extension **SHOULD** be limited to usages consistent with the certification authority role of the Trust Anchor certificate.
