# Trust Evaluation Process (Authentication)

This section describes the **Trust Evaluation Process**, which establish trust between two interacting entities by ensuring that their identities are verified against a recognized Root of Trust and they are eligible to perform a particular operations (e.g., issuing or requesting an Attestation of a certain type). This process comprises three distinct sub-processes: 
1. **Trust Anchor Validation Process**
2. **Authentication Process**, and 
3. **Authorization Process**.  

## Trust Anchor Validation Process

*See also: [Trust Anchor Validation Process](/topics/trust-anchor-validation.md)*

The [Trust Anchor Validation Process](/topics/trust-anchor-validation.md) establishes the integrity and authenticity of the trusted lists required to verify service providers. This process is a prerequisite for obtaining trusted certificates, including:
1. the self-signed certificate (Trust Anchor) of a Provider of WRPAC or Provider of WRPRC derived from the *List of Trusted Entities* (LoTE);
2. the self-signed certificate (Trust Anchor) of an Attestation, a Wallet Unit Attestation (WUA) or Wallet Unit Attestation (WIA) derived from the *List of Trusted Entities* (LoTE);
3. QTSP self-signed certificates needed to verify the seal of a Qualified Electronic Attestation of Attributes (QEAA) or a Public Electronic Attestation of Attributes (Pub-EAA) derived from the *EU Member State Trusted Lists* (EUMS TL).

During this process, the validating Entity MUST retrieve the relevant trusted list and verify its authenticity by validating:
- (For the LoTE) the digital signature of the LoTE, verified against the LoTE Provider certificate. This certificate is authenticated via the *Official Journal of the European Union* (OJEU).
- (For the EUMS TL) the digital signature of the EUMS TL, verified against the corresponding Member State public keys published in the *List of Trusted Lists* (LoTL). The LoTL itself is authenticated via the *Official Journal of the European Union* (OJEU).

## Authentication Process

*See also: [Authentication Process](/topics/authentication-process.md)*

The [Authentication Process](/topics/authentication-process.md) establishes the identity of a Wallet Relying Party (WRP) during an interaction. When a Wallet Unit authenticates a WRP, it MUST verify the authenticity and integrity of the presented Wallet Relying Party Access Certificate (WRPAC) and MUST verify WRP's possession of the private key corresponding to the public key in the WRPAC. To accomplish this, the Wallet Unit MUST perform the following steps:
1. Fetch the Provider of WRPAC Trust Anchor certificate from the corresponding validated LoTE (verified in [Trust Anchor Validation Process](/topics/trust-anchor-validation.md)). 
2. Validate the certificate path starting from the Provider of WRPAC issued certificate ($C_1$) and ending with the WRPAC presented by the WRP ($C_n$).
3. Use the public key from the WRPAC to verify the signature of the metadata presented by the WRP.

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


