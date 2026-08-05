This section describes the **Trust Evaluation Process**, which establishes trust between two interacting entities by ensuring that their identities are verified against a recognized Root of Trust and that they are eligible to perform a particular operation (e.g., issuing or requesting an <credentials:Attestation> of a certain type). This process comprises four distinct sub-processes:

1. [**Trust Anchor Validation Process**](../sections/trust-evaluation-process.md#trust-anchor-validation-process);
2. [**Authentication Process**](../sections/trust-evaluation-process.md#authentication-process);
3. [**Sign/Seal Validation Process**](../sections/trust-evaluation-process.md#sign-seal-validation-process);
4. [**Authorization Process**](../sections/trust-evaluation-process.md#authorization-process).

The [**X.509 Certificate Chain Validation**](../sections/trust-evaluation-process.md#certificate-path-validation) algorithm is shared by the Authentication Process, the Sign/Seal Validation Process, and the Authorization Process. It validates a certificate path against the <artifacts:Trust Anchor> obtained from a validated <artifacts:List of Trusted Entities (LoTE)|LoTE> or <artifacts:Trusted List (TL)|Trusted List>.
