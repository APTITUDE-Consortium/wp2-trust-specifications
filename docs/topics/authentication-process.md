The **Authentication Process** enables the <components:Wallet Unit> to authenticate a <roles:Wallet-Relying Party (WRP)|WRP> during an interaction. It establishes trust by validating the <roles:Wallet-Relying Party (WRP)|WRP>'s X.509 certificate chain, from a trusted <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC> to the presented <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>, and by verifying that the <roles:Wallet-Relying Party (WRP)|WRP> possesses the corresponding private key. The <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> is profiled in [Wallet-Relying Party Access Certificate](../sections/trust-artifacts.md#wallet-relying-party-access-certificate).

For <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> validation, the <components:Wallet Unit> SHALL accept only the <artifacts:Trust Anchor|Trust Anchors> published in the validated <artifacts:List of Trusted Entities (LoTE)|LoTE> of a <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC> (see [Trust Anchor Validation Process](../sections/trust-evaluation-process.md#trust-anchor-validation-process)).

**Input**

The Authentication outcome SHALL be based only on information derived from:

- the appropriate <artifacts:Trust Anchor> obtained from a valid instance of the <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC> <artifacts:List of Trusted Entities (LoTE)|LoTE>;
- the X.509 certificate path terminating in the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> end-entity certificate; and
- a <roles:Wallet-Relying Party (WRP)|WRP> signature over the interaction artifact, proving possession of the private key referenced in the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>.

**Outcome**

The <components:Wallet Unit> SHALL output either `AUTHENTICATED` or `NON_AUTHENTICATED`.

- If the result is `AUTHENTICATED`, the <components:Wallet Unit> proceeds with the interaction.
- If the result is `NON_AUTHENTICATED`, the <components:Wallet Unit> SHALL inform the user that the <roles:Wallet-Relying Party (WRP)|WRP> identity could not be verified and SHALL stop the interaction.

**Process**

The <components:Wallet Unit> SHALL verify the authenticity and integrity of the presented <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> as follows:

1. **Verify the signature.** Fetch the WRPAC `x5c` chain `[C, I_1, ..., I_n]`. The certificate chain and signed artifact depend on the flow:
    - **Remote Flow:** The chain is carried in the `x5c` header of the <roles:Wallet-Relying Party (WRP)|WRP>-signed <artifacts:Request Object>. The <roles:Wallet-Relying Party (WRP)|WRP> is authenticated through the `x509_hash` Client Identifier Prefix.
    - **Proximity Flow:** The chain is carried in the <roles:Wallet-Relying Party (WRP)|WRP>-signed `ReaderAuth` element, in the COSE `x5chain` header with label `33`, of the mdoc request message.
    - **Issuance Flow:** The chain is carried in the `x5c` header of the <roles:Wallet-Relying Party (WRP)|WRP>-signed <artifacts:Credential Issuer Metadata>.

    Use the public key of the WRPAC end-entity certificate `C` to verify the <roles:Wallet-Relying Party (WRP)|WRP> signature over the artifact signed in the specific interaction. If the signature is invalid, the Authentication outcome is `NON_AUTHENTICATED`.

2. **Select the <artifacts:Trust Anchor>.** Fetch the `Requested-LoTE-Type` of the <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC> <artifacts:List of Trusted Entities (LoTE)|LoTE>, its `Issuance` service type identifier as `Requested-Service-Type`, and use the runtime validation in [List of Trusted Entities Validation](../sections/trust-evaluation-process.md#list-of-trusted-entities-validation) process. This process identifies the entity and the service, and selects the WRPAC <artifacts:Trust Anchor>. If its `Status` is `PROCESS_FAILED`, the Authentication outcome is `NON_AUTHENTICATED`; otherwise, the <artifacts:Trust Anchor> is its `Trust-Anchor` output.
3. **Validate the certificate path.** Run the [X.509 Certificate Chain Validation](../sections/trust-evaluation-process.md#x509-certificate-chain-validation) with the path `I_n, ..., I_1, C` of the WRPAC chain (for n = 0, the path is `C`), the <artifacts:Trust Anchor> from step 2 as `trust_anchor` and the runtime validation time as `current_time`. If the path is `INVALID`, the Authentication outcome is `NON_AUTHENTICATED`.

The Authentication outcome SHALL be `AUTHENTICATED` only if all three steps succeed.

!!! warning "Mitigating Blind Signing Attacks"

    The <roles:Wallet-Relying Party (WRP)|WRP> SHALL distinguish transient authentication, such as access control, from content commitment, such as non-repudiation. To prevent an attacker from disguising a legal commitment as a protocol <data-elements:Nonce|nonce>, the <roles:Wallet-Relying Party (WRP)|WRP> SHALL NOT use the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> private key to sign arbitrary data controlled by an external party.
