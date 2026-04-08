# Trust Evaluation Process (Authentication)

This section describes the **Trust Evaluation Process**, which establish trust between two interacting entities by ensuring that their identities are verified against a recognized Root of Trust, and they are eligible to perform a particular operation (e.g., issuing or requesting an Attestation of a certain type). This process comprises three distinct sub-processes: 
1. **Trust Anchor Validation Process**
2. **Authentication Process**, and 
3. **Authorization Process**.  

## Trust Anchor Validation Process

*See also: [Trust Anchor Validation Process](/topics/trust-anchor-validation.md)*

The [Trust Anchor Validation Process](/topics/trust-anchor-validation.md) establishes the integrity and authenticity of trusted lists which serve as the authoritative sources for Trust Anchors. The latter are self-signed X509 certificates containing the names and public key used to verify other signed data (e.g., PID, Attestations, WRP certificates). This process involves validating the authenticity and integrity of:
1. the *List of Trusted Entities* (LoTE) to retrieve the Trust Anchor of a Provider of WRPAC or Provider of WRPRC;
2. the *List of Trusted Entities* (LoTE) to retrieve the Trust Anchor of a PID, an Attestation, a Wallet Unit Attestation (WUA) or Wallet Unit Attestation (WIA) derived from the *List of Trusted Entities* (LoTE);
3. a *EU Member State Trusted Lists* (EUMS TL) to retrieve the QTSP root certificate needed to verify the seal of a Qualified Electronic Attestation of Attributes (QEAA) or a Public Electronic Attestation of Attributes (Pub-EAA).

During this process, the validating Entity SHALL retrieve the relevant trusted list and verify its authenticity by validating:
- (For the LoTE) the digital signature of the LoTE, verified against the LoTE Provider certificate. This certificate is authenticated via the *Official Journal of the European Union* (OJEU).
- (For the EUMS TL) the digital signature of the EUMS TL, verified against the corresponding Member State public keys published in the *List of Trusted Lists* (LoTL). The LoTL itself is authenticated via the *Official Journal of the European Union* (OJEU).

## Authentication Process

*See also: [Authentication Process](/topics/authentication-process.md)*

The [Authentication Process](/topics/authentication-process.md) establishes the identity of a Wallet Relying Party (WRP) during an interaction. When a Wallet Unit authenticates a WRP, it SHALL verify the authenticity and integrity of the presented Wallet Relying Party Access Certificate (WRPAC) and SHALL verify WRP's possession of the private key corresponding to the public key in the WRPAC. 

To accomplish this, the Wallet Unit SHALL perform the following steps:
1. Fetch the Provider of WRPAC Trust Anchor certificate from the corresponding validated LoTE (verified in [Trust Anchor Validation Process](/topics/trust-anchor-validation.md)). 
2. Validate the certificate path starting from the Provider of WRPAC issued certificate ($C_1$) and ending with the WRPAC presented by the WRP ($C_n$).
3. Use the public key from the WRPAC to verify the signature of the metadata presented by the WRP during the specific interaction.

These interactions are:
- the remote flow normed by [OpenID4VP](https://openid.net/specs/openid-4-verifiable-presentations-1_0.html), where the WRP presents a WRPAC chain to the Wallet Unit in the `x5c` field of the Request Object.
- the proximity flow normed by the ISO 18013-5, where the WRP presents a WRPAC chain to the Wallet Unit within the `ReaderAuth` element of the mdoc request message.
- the issuance flow normed by [OpenID4VCI](https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html), where the WRP presents a WRPAC chain to the Wallet Unit in the `x5c` field of the [Issuer Metadata](https://openid.net/specs/openid4vc-high-assurance-interoperability-profile-1_0-final.html#section-4.1).


> [!NOTE]
>
> The simplest certificate path consists of just one certificate ($n=1$), where the WRPAC is directly issued by the Provider of WRPAC. 

## Authorization Process

*See also: [Authorization Process](/topics/trust-evaluation-process-authorization.md) and [Entitlement and Policies](/topics/entitlement-policy.md)*

The Authorization Process determines whether an authenticated WRP is permitted to perform a specific action, such as issuing an Attestation or requesting specific attributes. This process involves:

1. Validating the WRPRC.
2. Comparing requested operations with registered capabilities.
3. Evaluating Embedded Disclosure Policies (rule set embedded in an electronic Attestation by its Attestation Providers to restrict which Relying Parties can access specific Attestations).

Based on these inputs, the Wallet Unit determines whether to grant or deny the requested access.


