This section describes the **Core Trust Evaluation Processes**, which establish trust between two interacting entities by verifying their identities against a recognized <artifacts:Trust Anchor> and confirming their eligibility to perform a given operation (e.g., issuing or requesting an <credentials:Attestation> of a specific type). These processes are as follows:

- [**LOTL Authentication**](#lotl-authentication);
- [**Trusted List Authentication**](#trusted-list-authentication);
- [**Trust Anchor Validation Process**](#trust-anchor-validation-process);
- [**Sign/Seal Validation Process**](#signseal-validation-process);
- [**Authentication Process**](#authentication-process);
- [**Authorization Process**](#authorization-process).

The [**X.509 Certificate Chain Validation**](#x509-certificate-chain-validation) process is shared across the Sign/Seal Validation Process, the Authentication Process, and the Authorization Process. It validates a certificate path against the <artifacts:Trust Anchor> obtained from the [Trust Anchor Validation Process](#trust-anchor-validation-process), which draws on two trust-source routes: the seven retained <artifacts:List of Trusted Entities (LoTE)|LoTE> types, and, for QEAA, the pilot <artifacts:List Of Trusted Lists (LOTL)|LOTL> and <artifacts:Trusted List (TL)|Trusted List>, with no LoTE fallback. The pilot LOTL and TL are authenticated by the [LOTL Authentication](#lotl-authentication) and [Trusted List Authentication](#trusted-list-authentication) processes, and QEAA service matching and qualification are performed by the [Sign/Seal Validation Process](#signseal-validation-process).

### LOTL Authentication

{% include-markdown "../topics/lotl-authentication.md" %}

### Trusted List Authentication

{% include-markdown "../topics/trusted-list-authentication.md" %}

### Trust Anchor Validation Process

{% include-markdown "../topics/trust-anchor-validation.md" %}

### Sign/Seal Validation Process

{% include-markdown "../topics/attestation-signature-validation-process.md" %}

### Authentication Process

{% include-markdown "../topics/authentication-process.md" %}

### Authorization Process

{% include-markdown "../topics/authorization-process.md" %}

### X.509 Certificate Chain Validation

{% include-markdown "../topics/x509-certificate-validation.md" %}
