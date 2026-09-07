The **Authentication Process** enables the <components:Wallet Unit> to authenticate a <roles:Wallet-Relying Party (WRP)> during an interaction. It establishes trust by validating the <roles:Wallet-Relying Party (WRP)|WRP>'s X.509 certificate chain, from a trusted <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC> to the presented <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>, and by verifying that the WRP possesses the corresponding private key. The <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> is profiled in [Wallet-Relying Party Access Certificate](../sections/trust-artifacts.md#wallet-relying-party-access-certificate).

For WRPAC validation, the <components:Wallet Unit> SHALL accept only the <artifacts:Trust Anchor|Trust Anchors> published in the validated <artifacts:List of Trusted Entities (LoTE)|LoTE> of a Provider of WRPAC (see [Trust Anchor Validation Process](../sections/trust-evaluation-process.md#trust-anchor-validation-process)).

**Input**

The Authentication outcome SHALL be based only on information derived from:

- the appropriate <artifacts:Trust Anchor> obtained from a valid instance of the Provider of WRPAC <artifacts:List of Trusted Entities (LoTE)|LoTE>;
- the X.509 certificate path terminating in the WRPAC end-entity certificate; and
- a WRP signature over the interaction artifact, proving possession of the private key referenced in the WRPAC.

**Outcome**

The <components:Wallet Unit> SHALL output either `AUTHENTICATED` or `NON_AUTHENTICATED`.

- If the result is `AUTHENTICATED`, the <components:Wallet Unit> proceeds with the interaction.
- If the result is `NON_AUTHENTICATED`, the <components:Wallet Unit> SHALL inform the User that the WRP identity could not be verified and SHALL stop the interaction.

**Process**

The <components:Wallet Unit> SHALL verify the authenticity and integrity of the presented <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> as follows:

1. **Retrieve the <artifacts:Trust Anchor>:** Obtain the Provider of WRPAC entry from the validated <artifacts:List of Trusted Entities (LoTE)|LoTE>. To select the correct entry, match the `issuer.organizationIdentifier` of the first certificate in the presented chain with the `TrustedEntitiesList[].TrustedEntity.TETradeName` value. The certificates in `TrustedEntityServices[].ServiceInformation.ServiceDigitalIdentity` constitute the <artifacts:Trust Anchor|Trust Anchors>.
2. **Construct the certification path:** Build a path starting with the certificate issued by the Provider of WRPAC (`C_1`) and ending with the WRPAC presented by the WRP (`C_n`). The simplest path consists of a single certificate, where `n = 1`. If the received chain is in end-entity-first order, it SHALL be normalized to the path order consumed by the shared validation algorithm.
3. **Execute path validation:** Validate the certification path with the retrieved <artifacts:Trust Anchor> using the [X.509 Certificate Chain Validation](../sections/trust-evaluation-process.md#certificate-path-validation) algorithm.
4. **Verify the signature:** Use the public key of the validated WRPAC to verify the WRP signature over the artifact signed in the specific interaction. The certificate chain and signed artifact depend on the flow:
    - **Remote Flow:** The chain is carried in the `x5c` header of the WRP-signed <artifacts:Request Object>. The WRP is authenticated through the `x509_hash` Client Identifier Prefix.
    - **Proximity Flow:** The chain is carried in the WRP-signed `ReaderAuth` element, in the COSE `x5chain` header with label `33`, of the mdoc request message.
    - **Issuance Flow:** The chain is carried in the `x5c` header of the WRP-signed Credential Issuer Metadata.

!!! warning "Mitigating Blind Signing Attacks"

    The WRP SHALL distinguish transient authentication, such as access control, from content commitment, such as non-repudiation. To prevent an attacker from disguising a legal commitment as a protocol <data-elements:Nonce|nonce>, the WRP SHALL NOT use the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> private key to sign arbitrary data controlled by an external party.
