This process validates the signature on an <credentials:Attestation> (including a <artifacts:Wallet Instance Attestation (WIA)>) using the appropriate <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> Certificate (Sign/Seal Certificate). It is invoked during issuance and presentation flows. Sign/Seal Certificate chains are validated with the [X.509 Certificate Chain Validation](../sections/trust-evaluation-process.md#certificate-path-validation) algorithm.

The process is structured as follows.

**Input**

- The received <credentials:Attestation> and the signer certificate chain carried within it.
- The type of <credentials:Attestation>, used to select the applicable trust source or scheme-specific validation rules.

**Outcome**

- The validated <credentials:Attestation>, or a validation failure.

**Process**

**Base Signature Validation**

The procedure depends on the type of <credentials:Attestation>:

1. Verify the <credentials:Attestation> signature with the Sign/Seal Certificate provided in the <credentials:Attestation>.
    For <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA> and <credentials:Public Electronic Attestation of Attributes (PuB-EAA)|PuB-EAA>, the <artifacts:Qualified Electronic Signature (QES)|qualified electronic signature> or <artifacts:Electronic Seal|seal> SHALL also be validated in accordance with the applicable qualified validation requirements, including Article 32 of Regulation (EU) No 910/2014 where applicable.
2. Select and validate the applicable trust source:
    - For <credentials:Person Identification Data (PID)|PID> and <artifacts:Wallet Instance Attestation (WIA)>, validate the applicable <artifacts:List of Trusted Entities (LoTE)|LoTE> as defined in [Trust Anchor Validation Process](../sections/trust-evaluation-process.md#trust-anchor-validation-process), and extract the appropriate <artifacts:Trust Anchor> from the relevant entity's `ServiceDigitalIdentity` field.
    - For <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA> and <credentials:Public Electronic Attestation of Attributes (PuB-EAA)|PuB-EAA>, validate the applicable <artifacts:Trusted List (TL)|Trusted List> as defined in [Trust Anchor Validation Process](../sections/trust-evaluation-process.md#trust-anchor-validation-process), and extract the appropriate <artifacts:Trust Anchor> from the relevant entity's `ServiceDigitalIdentity` field.
    - For a non-qualified <credentials:Electronic Attestation of Attributes (EAA)|EAA>, apply the applicable scheme rules governing signature validation.
3. For <credentials:Person Identification Data (PID)|PID>, <artifacts:Wallet Instance Attestation (WIA)>, <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA>, and <credentials:Public Electronic Attestation of Attributes (PuB-EAA)|PuB-EAA>, extract the Sign/Seal Certificate chain from the <credentials:Attestation> and validate it against the obtained <artifacts:Trust Anchor> using the [X.509 Certificate Chain Validation](../sections/trust-evaluation-process.md#certificate-path-validation) algorithm.

For <credentials:Public Electronic Attestation of Attributes (PuB-EAA)|PuB-EAA>, the validating Entity MAY additionally validate the corresponding <artifacts:List of Trusted Entities (LoTE)|LoTE> and match the provider's relevant trusted-entity parameters with the <artifacts:Trust Anchor> recovered from the <artifacts:Trusted List (TL)|Trusted List>.

!!! note

    In an mdoc <credentials:Attestation>, the Mobile Security Object carries the Document Signer certificate in the `x5chain` header. In an <formats:Selective Disclosure JWT (SD-JWT)|SD-JWT VC> <credentials:Attestation>, the issuer certificate chain is carried in the `x5c` header of the JOSE signature.

**Fallback Signature Validation**

If Base Signature Validation fails, the validating Entity SHALL execute Fallback Signature Validation only for <credentials:Person Identification Data (PID)|PID> and <artifacts:Wallet Instance Attestation (WIA)>:

1. Fetch and validate the applicable <artifacts:List of Trusted Entities (LoTE)|LoTE>, as defined in [Trust Anchor Validation Process](../sections/trust-evaluation-process.md#trust-anchor-validation-process), and extract the appropriate <artifacts:Trust Anchor> from the relevant entity's `ServiceDigitalIdentity` field.
2. Verify the <credentials:Attestation> signature directly using the validated <artifacts:Trust Anchor> as the signer certificate.

When a <artifacts:Trust Anchor> is used directly as the signer certificate, the <credentials:Attestation> SHALL NOT carry a different Sign/Seal Certificate or certificate chain.

For signatures or seals made with historical keys, the same process applies, but the <artifacts:Trust Anchor> is retrieved from the `ServiceHistory.ServiceDigitalIdentity` element instead of the current `ServiceInformation.ServiceDigitalIdentity` element.

If both Base Signature Validation and Fallback Signature Validation fail, the <credentials:Attestation> SHALL NOT be considered issued by a <roles:Trusted Entity|trusted Entity>.
