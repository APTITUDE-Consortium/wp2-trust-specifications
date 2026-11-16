This process validates the signature on an <credentials:Attestation> (including a <artifacts:Wallet Instance Attestation (WIA)|WIA>) using the appropriate <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> Certificate. It is invoked during issuance and presentation flows. Sign/Seal Certificate chains are validated with the [X.509 Certificate Chain Validation](../sections/trust-evaluation-process.md#certificate-path-validation) algorithm.

The process is structured as follows.

**Input**

- The received <credentials:Attestation> and the signer certificate chain carried within it.
- The type of <credentials:Attestation>, used to select the applicable trust source or scheme-specific validation rules.
- For <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA>, the electronic attestation (`QEAA`), the X.509 certificate supporting its signature validation (`CERT`), and the current runtime validation time (`Date-time`).

**Outcome**

- The validated <credentials:Attestation>, or a validation failure.

**Process**

**Base Signature Validation**

The procedure depends on the type of <credentials:Attestation>:

1. Verify the <credentials:Attestation> signature with the Sign/Seal Certificate provided in the <credentials:Attestation>.
2. Select and validate the applicable trust source through [Trust Anchor Validation Process](../sections/trust-evaluation-process.md#trust-anchor-validation-process).

    - For <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA>, use the authenticated, runtime-accepted pilot <artifacts:Trusted List (TL)|TL> service information and perform **<credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA> Service Qualification** below.
    - For <credentials:Person Identification Data (PID)|PID>, <artifacts:Wallet Instance Attestation (WIA)|WIA>, <credentials:Electronic Attestation of Attributes (EAA)|EAA> and <credentials:Public Electronic Attestation of Attributes (PuB-EAA)|PuB-EAA>.

    Pass the signer certificate chain carried within the <credentials:Attestation>, `[C, I_1, ..., I_n]`, the <artifacts:List of Trusted Entities (LoTE)|LoTE> type or <artifacts:Trusted List (TL)|TL> that applies to that <credentials:Attestation> type and run the [List of Trusted Entities Validation](../sections/trust-evaluation-process.md#list-of-trusted-entities-validation) or [Trusted List Validation](../sections/trust-evaluation-process.md#trusted-list-validation) process to identify the applicable <artifacts:Trust Anchor>. If its `Status` is `PROCESS_FAILED`, the validation fails; otherwise, the <artifacts:Trust Anchor> is its `Trust-Anchor` output.
3. Validate the Sign/Seal Certificate chain `[C, I_1, ..., I_n]` against the obtained <artifacts:Trust Anchor>, where path-based validation applies, using [X.509 Certificate Chain Validation](../sections/trust-evaluation-process.md#certificate-path-validation) with the path `I_n, ..., I_1, C`, the <artifacts:Trust Anchor> as `trust_anchor` and the runtime validation time as `current_time`. The obtained <artifacts:Trust Anchor> is the `Trust-Anchor` output of step 2 for <credentials:Person Identification Data (PID)|PID>, <artifacts:Wallet Instance Attestation (WIA)|WIA>, <credentials:Electronic Attestation of Attributes (EAA)|EAA> and <credentials:Public Electronic Attestation of Attributes (PuB-EAA)|PuB-EAA>, and the applicable CA <artifacts:Trust Anchor> obtained from the TL route for <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA>. If the path is `INVALID`, the validation fails. For <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA> direct service-identity matching, use the matching result governed below. An attestation-supplied certificate alone SHALL NOT establish trust. Failure of signature validation, applicable path validation or trust-source validation SHALL result in validation failure.

**<credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA> Service Qualification**

The validator SHALL invoke [ETSI TS 119 615 V1.4.1 (2026-05), Clause 4.12], including its content check for `urn:etsi:esi:eaa:eu:qualified` and its invocation of issuer qualification under Clause 4.6 and certificate/service matching under Clause 4.3.

<credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA> validation SHALL succeed only when the source procedure returns `QEAA-Status = PROCESS_PASSED` and `QEAA-Results = Qualified` under pilot trust, and the signature and applicable path validation succeed. A failed procedure, `Not_Qualified`, `Indeterminate`, or runtime-unusable evidence SHALL result in validation failure.

!!! note

    In an mdoc <credentials:Attestation>, the Mobile Security Object carries the Document Signer certificate in the `x5chain` header. In an <formats:Selective Disclosure JWT (SD-JWT)|SD-JWT VC> <credentials:Attestation>, the issuer certificate chain is carried in the `x5c` header of the JOSE signature.
