This section describes the **Trust Evaluation Process**, which establish trust between two interacting entities by ensuring that their identities are verified against a recognized Root of Trust, and they are eligible to perform a particular operation (e.g., issuing or requesting an Attestation of a certain type). This process comprises three distinct sub-processes:

1. **Trust Anchor Validation Process**
2. **Authentication Process**, and
3. **Authorization Process**.

### Trust Anchor Validation Process

The **Trust Anchor Validation Process** establishes the cryptographic integrity and authenticity of Trusted Lists, which serve as the authoritative sources for Trust Anchors. A Trust Anchor is a self-signed X.509 certificate containing the names and public key used by a Wallet Unit or Wallet Relying Party (WRP) to validate an artifact or attestation.

Depending on the artifact or attestation being verified, the validating Entity SHALL fetch, download, and validate the appropriate Trusted List:

1. *List of Trusted Entities* (LoTE), used to retrieve Trust Anchors for validating the following:
   - **Infrastructure Certificates**: WRPAC or WRPRC.
   - **Wallet Artifacts**: Wallet Unit Attestation (WUA) or Wallet Instance Attestation (WIA).
   - **PID Signatures**: Person Identification Data (PID).
   - **Registrar-signed artifacts**: Register informations.
2. *EU Member State Trusted Lists* (EUMS TL); used to retrieve Trust Anchors for validating the following:
   - seal or signature on a Qualified Electronic Attestation of Attributes (QEAA); or 
   - seal or signature on a Public Electronic Attestation of Attributes (Pub-EAA).

To verify the authenticity of the retrieved Trusted Lists, the Entity SHALL perform the following validations:

- [LoTE Validation](#list-of-trusted-entities-validation-process): Validate the digital signature of the LoTE by verifying it against the LoTE Provider certificate. This certificate is authenticated via the *Official Journal of the European Union* (OJEU).
- [EUMS TL Validation](#european-union-member-state-trusted-lists-validation-process): Validate the digital signature of the EUMS TL by verifying it against the corresponding Member State public keys published in the *List of Trusted Lists* (LoTL). The LoTL itself is authenticated by validating its digital signature against the *Official Journal of the European Union* (OJEU).

To support continuous key rotation, both artifacts implement a pivoting mechanism. This ensures that an Entity possessing the last known valid version can reliably discover the location of the next version and validate it using the unbroken chain of trust rooted in the OJEU.

{% include-markdown "./trust-anchor-validation.md" %}

### Authentication Process

The **Authentication Process** enables the Wallet Unit to authenticate a Wallet Relying Party (WRP) during an interaction. It establishes trust by validating the WRP's X.509 certificate chain—from a trusted Provider of Wallet Relying Party Access Certificates (WRPAC) down to the presented WRPAC—and verifying the WRP's possession of the corresponding private key.

To authenticate the WRP, the Wallet Unit SHALL verify the authenticity and integrity of the presented WRPAC by performing the following steps:

1. **Retrieve the Trust Anchor:** Obtain the Provider of WRPAC's entry from the validated List of Trusted Entities (LoTE) (see [Trust Anchor Validation Process](#trust-anchor-validation-process)). The certificate(s) found in the `ServiceDigitalIdentity` field of the LoTE's `TrustedEntitiesList` constitute the Trust Anchor.
2. **Construct the Certification Path:** Build a path starting from the certificate issued by the Provider of WRPAC (C_1) and ending with the WRPAC presented by the WRP (C_n). *(Note: The simplest path consists of just one certificate, where n=1).*
3. **Execute Path Validation:** Run the algorithm defined in [Wallet Relying Party Access Certificate Path Validation](#wallet-relying-party-access-certificate-path-validation) using the retrieved Trust Anchor.
4. **Verify the Signature:** Use the public key from the validated WRPAC to verify the WRP's signature on the metadata presented during the specific interaction.

The method by which the WRP presents its WRPAC chain depends on the specific interaction flow:

- **OpenID4VP (Remote Flow):** The certificate chain is presented in the `x5c` field of the WRP-signed Request Object.
- **ISO 18013-5 (Proximity Flow):** The certificate chain is presented within the WRP-signed `ReaderAuth` element of the mdoc request message.
- **OpenID4VCI (Issuance Flow):** The certificate chain is presented in the `x5c` field of the WRP-signed Issuer Metadata.

!!! warning "Mitigating Blind Signing Attacks"

   Implementers SHALL distinguish between transient authentication (e.g., access control) and content commitment (non-repudiation). To prevent an attacker from disguising a legal commitment (like a debt acknowledgment) as a protocol nonce, the WRP SHALL NOT use the WRPAC private key to sign arbitrary data that could be controlled by an external party.

{% include-markdown "./authentication-process.md" %}

### Authorization Process

This section specifies the authorization process that a Wallet Instance (WI) SHALL execute to determine whether an interaction with a Wallet-Relying Party (WRP) is allowed within the EUDI Wallet ecosystem. A wallet Instance SHALL implement all the authorization-processing rules defined in this section [AUTHZ-GEN-03].

Authorization covers:

- **Issuance authorization**: whether a PID Provider or Attestation Provider (AP) is registered for the relevant role and for the specific attestation type(s) to be issued. This applies to PID Providers, QEAA Providers, PuB-EAA Providers, and non-qualified EAA Providers.
- **Presentation authorization**: whether a Relying Party (RP) request is within its registered scope, whether any Embedded Disclosure Policy permits disclosure, and whether the User approves. This applies to both direct RP and intermediated RP interactions, and both remote and proximity flows.

!!! note

    Authentication process is out of scope. This section does not define access certificate validation rules, LoTE validation procedures, certificate-path validation algorithms, revocation checking procedures for access certificates, the full trust-anchor validation model, nor the internal structure and encoding of the WRPRC (covered in section [Registration Certificate](registration-certificate.md)), nor Registrar online service API definition.

{% include-markdown "./authorization-process.md" %}
