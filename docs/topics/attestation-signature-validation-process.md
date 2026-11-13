This process validates the signature on an <credentials:Attestation> (including a <artifacts:Wallet Instance Attestation (WIA)|WIA>) using the appropriate <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> Certificate. It is invoked during issuance and presentation flows. Sign/Seal Certificate chains are validated with the [X.509 Certificate Chain Validation](../sections/trust-evaluation-process.md#certificate-path-validation) algorithm.

The process is structured as follows.

**Input**

- The received <credentials:Attestation> and the signer certificate chain carried within it.
- The type of <credentials:Attestation>, used to select the applicable trust source or scheme-specific validation rules.
- For QEAA, the electronic attestation (`EAA`), the X.509 certificate supporting its signature validation (`CERT`), and the current runtime validation time (`Date-time`).

**Outcome**

- The validated <credentials:Attestation>, or a validation failure.

**Process**

**Base Signature Validation**

The procedure depends on the type of <credentials:Attestation>:

1. Verify the <credentials:Attestation> signature with the Sign/Seal Certificate provided in the <credentials:Attestation>.
2. Select and validate the applicable trust source through [Trust Anchor Validation Process](../sections/trust-evaluation-process.md#trust-anchor-validation-process). For QEAA, use the authenticated, runtime-accepted pilot TL service information and perform **QEAA Service Qualification** below. For <credentials:Person Identification Data (PID)|PID>, <artifacts:Wallet Instance Attestation (WIA)|WIA>, <credentials:Electronic Attestation of Attributes (EAA)|EAA> and <credentials:Public Electronic Attestation of Attributes (PuB-EAA)|PuB-EAA>, retain the applicable LoTE route and extract the appropriate <artifacts:Trust Anchor> from the relevant entity's `ServiceDigitalIdentity` field.
3. Validate the Sign/Seal Certificate chain against the obtained CA <artifacts:Trust Anchor>, where path-based validation applies, using [X.509 Certificate Chain Validation](../sections/trust-evaluation-process.md#certificate-path-validation). For QEAA direct service-identity matching, use the matching result governed below. An attestation-supplied certificate alone SHALL NOT establish trust. Failure of signature validation, applicable path validation or trust-source validation SHALL result in validation failure.

**QEAA Service Qualification**

The validator SHALL invoke [ETSI TS 119 615 V1.4.1 (2026-05), Clause 4.12], including its content check for `urn:etsi:esi:eaa:eu:qualified` and its invocation of issuer qualification under Clause 4.6 and certificate/service matching under Clause 4.3. Bind `EAA` and `CERT` to the received QEAA and its supporting signing certificate, `Date-time` to the current runtime validation time, and `TLS-Sti` to `http://uri.etsi.org/TrstSvc/Svctype/EAA/Q` as defined in [ETSI TS 119 612 V2.4.1 (2025-08), Clause 5.5.1.1(k)]. The pilot TL and LOTL profiles and the common authentication and runtime acceptance procedure cited above supply the pilot trust context for these source procedures.

The validator SHALL retain the matching service information, listed provider identity, certificate and any validated path context returned by the cited matching and qualification procedures. Direct public-key and subject-name matching and path-based matching SHALL follow Clause 4.3.4; service identities SHALL NOT all be treated as CA certificates. Any applicable path validation SHALL invoke the shared X.509 algorithm cited above. Service identity, current status and effective time are governed by [ETSI TS 119 612 V2.4.1 (2025-08), Clauses 5.5.3–5.5.5]. The matched QEAA service SHALL be currently `http://uri.etsi.org/TrstSvc/TrustedList/Svcstatus/granted`, with its status effective at `Date-time`, and bound to the signing provider by the cited procedures.

QEAA validation SHALL succeed only when the source procedure returns `QEAA-Status = PROCESS_PASSED` and `QEAA-Results = Qualified` under pilot trust, and the signature and applicable path validation succeed. A failed procedure, `Not_Qualified`, `Indeterminate`, or runtime-unusable evidence SHALL result in validation failure. Preserve the source qualification status and sub-status alongside this local result. QEAA service qualification is distinct from `CA/QC` qualified-certificate determination; a qualified signing certificate SHALL NOT substitute for qualification of the matched `EAA/Q` service. This binding supports issuance and presentation verification under [ARF Trust Model, Sections 6.6.2.6 and 6.6.3.6].

!!! note

    In an mdoc <credentials:Attestation>, the Mobile Security Object carries the Document Signer certificate in the `x5chain` header. In an <formats:Selective Disclosure JWT (SD-JWT)|SD-JWT VC> <credentials:Attestation>, the issuer certificate chain is carried in the `x5c` header of the JOSE signature.
