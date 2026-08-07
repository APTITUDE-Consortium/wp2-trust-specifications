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
2. Select and validate the applicable trust source:
    In this profile, for all credentials and attestation types, namely <credentials:Person Identification Data (PID)|PID>, <artifacts:Wallet Instance Attestation (WIA)>, <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA>, <credentials:Electronic Attestation of Attributes (EAA)|EAA> and <credentials:Public Electronic Attestation of Attributes (PuB-EAA)|PuB-EAA>, validate the applicable <artifacts:List of Trusted Entities (LoTE)|LoTE> as defined in [Trust Anchor Validation Process](../sections/trust-evaluation-process.md#trust-anchor-validation-process), and extract the appropriate <artifacts:Trust Anchor> from the relevant entity's `ServiceDigitalIdentity` field.
3. Extract the Sign/Seal Certificate chain from the <credentials:Attestation> and validate it against the obtained <artifacts:Trust Anchor> using the [X.509 Certificate Chain Validation](../sections/trust-evaluation-process.md#certificate-path-validation) algorithm.

!!! note

    In an mdoc <credentials:Attestation>, the Mobile Security Object carries the Document Signer certificate in the `x5chain` header. In an <formats:Selective Disclosure JWT (SD-JWT)|SD-JWT VC> <credentials:Attestation>, the issuer certificate chain is carried in the `x5c` header of the JOSE signature.