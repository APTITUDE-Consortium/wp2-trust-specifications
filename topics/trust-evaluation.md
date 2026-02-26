# Trust Evaluation Process (Authentication)

This section describes the **Trust Evaluation Process**, which ensures that all actors and credentials within the ecosystem are verified against a recognized Root of Trust. This process comprises three distinct sub-processes: 
1. **Trust Anchor Validation Process**
2. **Authentication Process**, and 
3. **Authorization Process**.  

## Trust Anchor Validation Process

*See also: [Trust Anchor Validation Process](/topics/trust-anchor-validation.md)*

The [Trust Anchor Validation Process](/topics/trust-anchor-validation.md) establishes the integrity and authenticity of the trusted lists required to verify service providers. This process is a prerequisite for obtaining trusted certificates, including:
1. the certificate of a WRPAC provider or WRPRC provider derived from the *List of Trusted Entities* (LoTE);
2. the certificate of an Attestation, a Wallet Unit Attestation (WUA) or Wallet Instance Attestation (WIA) derived from the *List of Trusted Entities* (LoTE);
3. QTSP certificates needed to verify the seal of a Qualified Electronic Attestation of Attributes (QEAA) or a Public Electronic Attestation of Attributes (Pub-EAA) derived from the *EU Member State Trusted Lists* (EUMS TL).

During this process, the validating Entity MUST retrieve the relevant trusted list and verify its authenticity by validating:
- (For the LoTE) the digital signature of the LoTE, verified against the LoTE Provider certificate. This certificate is authenticated via the *Official Journal of the European Union* (OJEU).
- (For the EUMS TL) the digital signature of the EUMS TL, verified against the corresponding Member State public keys published in the *List of Trusted Lists* (LoTL). The LoTL itself is authenticated via the *Official Journal of the European Union* (OJEU).

## Authentication Process

*See also: [Authentication Process](/topics/authentication-process.md)*

The [Authentication Process](/topics/authentication-process.md) establishes the identity of a Wallet Relying Party (WRP) during an interaction. When a Wallet Instance authenticates a WRP, it MUST verify the authenticity and integrity of the presented Wallet Relying Party Access Certificate (WRPAC). The Wallet Instance validates the certification path:
1. starting from the WRPAC Provider certificate found in the valid LoTE (verified in the previous step).
2. ending with the WRPAC presented by the WRP.

## Authorization Process

*See also: [Authorization Process](/topics/trust-evaluation-process-authorization.md) and [Entitlement and Policies](/topics/entitlement-policy.md)*

The Authorization Process determines whether an authenticated WRP is permitted to perform a specific action, such as issuing an Attestation or requesting specific attributes. This process involves evaluating:

1. Authorization Policies: Associated with the WRP's identity.
2. Entitlements: Explicit rights granted to the WRP.
3. Disclosure Policies: Embedded rules regarding data minimization and user consent.

Based on these inputs, the Wallet Instance determines whether to grant or deny the requested access.


