This section details the trust checks that SHALL be performed during the Issuance process.

```mermaid
sequenceDiagram
    participant User
    participant Wallet as Wallet Instance
    participant EAAProvider as Attestation Provider
    participant WRPACLoTE as Provider of WRPAC LoTE
    participant WRPCLoTE as Provider of WRRPC LoTE
    participant WProvider as Wallet Providers LoTE
    participant LoTL as LoTE Provider
    participant TL as TL Provider

    User->>Wallet: 1. Request EAA issuance
    Wallet->>EAAProvider: 2. Fetch Credential Issuer Metadata (OpenID4VCI)
    EAAProvider-->>Wallet: Signed Credential Issuer Metadata
 
    rect rgb(230, 230, 230)
    Note over Wallet: Verify metadata signature
    Wallet->>WRPACLoTE: 3a. Fetch Provider of WRPAC LoTE
    WRPACLoTE-->>Wallet: Provider of WRPAC LoTE
    Note over Wallet: 3b. Validate LoTE
    Note over Wallet: 3c. Identify the corresponding trusted entity
    Note over Wallet: 3d. Validate the WRPAC
    Note over Wallet: 3e. Validate the metadata signature using the WRPAC
    end

    rect rgb(230, 230, 230)
    Note over Wallet: Verify WRPRC
    Wallet->>WRPCLoTE: 4a. Fetch Provider of WRPRC LoTE
    WRPCLoTE-->>Wallet: Provider of  WRPRC LoTE
    Note over Wallet: 4b. Validate LoTE
    Note over Wallet: 4c. Identify the corresponding trusted entity
    Note over Wallet: 4d. Validate the WRPRC
    Note over Wallet: 4e. Check Provider entitlements
    end
   
    Note over Wallet: 5. Match WRPAC with WRPRC
    opt applicable to Authorization Code Flow only
        Wallet->>EAAProvider: 6. Send WIA to PAR endpoint (OpenID4VCI)

        rect rgb(230, 230, 230)
        Note over EAAProvider: Verify WIA
        EAAProvider->>WProvider: 7a. Fetch Wallet Providers LoTE
        WProvider-->>EAAProvider: Wallet Providers LoTE
        Note over EAAProvider: 7b. Validate LoTE
        Note over EAAProvider: 7c. Identify the corresponding trusted entity
        Note over EAAProvider: 7d. Validate the WIA signature
        Note over EAAProvider: 7e. Validate the WIA contents
        EAAProvider-->>Wallet: Authorization response (code)
        end
    end

    Wallet->>EAAProvider: 8. Send WIA to Token endpoint (OpenID4VCI)

    rect rgb(230, 230, 230)
    Note over EAAProvider: Verify WIA
    EAAProvider->>WProvider: 7a. Fetch Wallet Providers LoTE
    WProvider-->>EAAProvider: Wallet Providers LoTE
    Note over EAAProvider: 7b. Validate LoTE
    Note over EAAProvider: 7c. Identify the corresponding trusted entity
    Note over EAAProvider: 7d. Validate the WIA signature
    Note over EAAProvider: 7e. Validate the WIA contents
    end
    EAAProvider-->>Wallet: Token response (access token)

    Wallet->>EAAProvider: 9. Send KA to Credential endpoint (OpenID4VCI)

    rect rgb(230, 230, 230)
    Note over EAAProvider: Verify KA
    EAAProvider->>WProvider: 7a. Fetch Wallet Providers LoTE
    WProvider-->>EAAProvider: Wallet Providers LoTE
    Note over EAAProvider: 7b. Validate LoTE
    Note over EAAProvider: 7c. Identify the corresponding trusted entity
    Note over EAAProvider: 10a. Validate the KA signature
    Note over EAAProvider: 10b. Validate the KA contents
    end
    EAAProvider-->>Wallet: Credential response

    rect rgb(230, 230, 230)
    Note over Wallet: Verify Attestation
    Wallet->>LoTL: 11a. Fetch Attestation Provider LoTE
    LoTL-->>Wallet: Attestation Provider LoTE
    Note over Wallet: 11b. Validate LoTE
    Note over Wallet: 11c. Validate Attestation signature
    end
```

!!! note

    <roles:Attestation Provider (AP)|Attestation Providers> can have a dedicated <components:Authorization Server> that makes authorization-related endpoints available. That kind of implementation details are hidden in this schema, since the <roles:Attestation Provider (AP)|Attestation Provider> bears the overall responsibility for responding to the <components:Wallet Instance>'s requests.

!!! note

    A <data-elements:Nonce|nonce> endpoint might be necessary as well however that feature does not have an impact on the trust-related checks.

#### Step-by-step Operations

**Step 1: Request EAA Issuance.** Various flows are possible for this step and this can depend on the wallet implementation. The <components:Wallet Instance> can be populated with a pre-defined set of credentials offered by different <roles:Attestation Provider (AP)|Attestation Providers> or can fetch other offers via different means.

**Step 2: Fetch <artifacts:Credential Issuer Metadata> (<protocols:OpenID for Verifiable Credentials Issuance (OID4VCI)|OID4VCI>).** The <components:Wallet Instance> retrieves information about the <roles:Attestation Provider (AP)|Attestation Provider>'s technical capabilities, supported attestations, and display information from the <roles:Attestation Provider (AP)|Attestation Provider> endpoint. This information includes the <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)|Provider of WRPRC>. In this context it is expected that the metadata is a signed JSON Web Signature (JWS). The JWS also contains the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> in its Protected Header [`AUTHZ-ISS-04`].

**Step 3a: Fetch <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC> <artifacts:List of Trusted Entities (LoTE)|LoTE>.** The <components:Wallet Instance> retrieves the <artifacts:List of Trusted Entities (LoTE)|LoTE> listing all the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> issuers from a publicly-known URL.

**Step 3b: Validate LoTE.** The <components:Wallet Instance> validates the <artifacts:List of Trusted Entities (LoTE)|LoTE> signature is order to make sure the <artifacts:List of Trusted Entities (LoTE)|LoTE> is authentic. Extra checks are performed in order to make sure the <artifacts:List of Trusted Entities (LoTE)|LoTE> is not outdated.

**Step 3c: Identify the corresponding <roles:Trusted Entity>.** The <components:Wallet Instance> identifies the <artifacts:List of Trusted Entities (LoTE)|LoTE> <roles:Trusted Entity> corresponding to the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> presented in the metadata JWS [`AUTHZ-ISS-02`].

**Step 3d: Validate the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>.** The <components:Wallet Instance> validates the authenticity and integrity of the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> using the trust anchor of the <roles:Trusted Entity> identitied in the <artifacts:List of Trusted Entities (LoTE)|LoTE>.

**Step 3e: Validate the metadata signature using the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>.** The <components:Wallet Instance> validates the metadata JWS signature using the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> [`AUTHZ-ISS-05`].

**Step 4a: Fetch <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)|Provider of WRPRC> <artifacts:List of Trusted Entities (LoTE)|LoTE>.** The <components:Wallet Instance> retrieves the <artifacts:List of Trusted Entities (LoTE)|LoTE> listing all the <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> issuers from a publicly-known URL [`AUTHZ-ISS-07`].

**Step 4b: Validate <artifacts:List of Trusted Entities (LoTE)|LoTE>.** The <components:Wallet Instance> validates the <artifacts:List of Trusted Entities (LoTE)|LoTE> signature is order to make sure the <artifacts:List of Trusted Entities (LoTE)|LoTE> is authentic. Extra checks are performed in order to make sure the <artifacts:List of Trusted Entities (LoTE)|LoTE> is not outdated.

**Step 4c: Identify the corresponding <roles:Trusted Entity>.** The <components:Wallet Instance> identifies the <artifacts:List of Trusted Entities (LoTE)|LoTE> <roles:Trusted Entity> corresponding to the <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> presented in the <roles:Attestation Provider (AP)|Attestation Provider> metadata.

**Step 4d: Validate the <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC>.** The <components:Wallet Instance> validates the authenticity and integrity of the <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> using the <artifacts:Trust Anchor> of the <roles:Trusted Entity> identitied in the <artifacts:List of Trusted Entities (LoTE)|LoTE> [`AUTHZ-GEN-08`].

**Step 4e: Check Provider entitlements.** The <components:Wallet Instance> verifies that the entitlement of issuing <credentials:Attestation|Attestations> is present in the <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> [`AUTHZ-GEN-11`, `AUTHZ-GEN-13`].

**Step 5: Match <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> with <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC>.** The <components:Wallet Instance> verifies that both the certificates are related to the same entity [`AUTHZ-GEN-09`, `AUTHZ-GEN-12`].

**Step 6: Send <artifacts:Wallet Instance Attestation (WIA)|WIA> to PAR endpoint (<protocols:OpenID for Verifiable Credentials Issuance (OID4VCI)|OID4VCI>).** The <components:Wallet Instance> sends the <artifacts:Wallet Instance Attestation (WIA)|WIA> signed by the <roles:Wallet Provider (WP)|WP>, attesting that the <components:Wallet Instance> is a valid one.

**Step 7a: Fetch <roles:Wallet Provider (WP)|WP> <artifacts:List of Trusted Entities (LoTE)|LoTE>.** The <roles:Attestation Provider (AP)|Attestation Providers> retrieves the <artifacts:List of Trusted Entities (LoTE)|LoTE> listing all the <roles:Wallet Provider (WP)|WPs> from a publicly-known URL. This list is necessary to validate different signed artifacts received from the <components:Wallet Instance> in the different requests. <roles:Attestation Provider (AP)|Attestation Providers> can implement a caching mechanism of the <artifacts:List of Trusted Entities (LoTE)|LoTE> so that they would not need to retrieve it multiple times in the course of the <credentials:Electronic Attestation of Attributes (EAA)|EAA> issuance process. It is up to <roles:Attestation Provider (AP)|Attestation Providers> to implement this mechanism or not and to decide for how long they would want to cache the list. This implies that in some cases, this step could be skipped.

**Step 7b: Validate <artifacts:List of Trusted Entities (LoTE)|LoTE>.** The <roles:Attestation Provider (AP)|Attestation Provider> validates the <artifacts:List of Trusted Entities (LoTE)|LoTE> signature in order to make sure the <artifacts:List of Trusted Entities (LoTE)|LoTE> is authentic. Extra checks are performed in order to make sure the <artifacts:List of Trusted Entities (LoTE)|LoTE> is not outdated.

**Step 7c: Identify the corresponding <roles:Trusted Entity>.** The <roles:Attestation Provider (AP)|Attestation Provider> identifies the <artifacts:List of Trusted Entities (LoTE)|LoTE> <roles:Trusted Entity> corresponding to the <artifacts:Wallet Instance Attestation (WIA)|WIA> presented in the request.

**Step 7d: Validate the <artifacts:Wallet Instance Attestation (WIA)|WIA> signature.** The <roles:Attestation Provider (AP)|Attestation Provider> checks the <artifacts:Wallet Instance Attestation (WIA)|WIA> integrity and authenticity by validating the JWT signature using the trust anchor of the <roles:Trusted Entity> identitied in the <artifacts:List of Trusted Entities (LoTE)|LoTE>.

**Step 7e: Validate the <artifacts:Wallet Instance Attestation (WIA)|WIA> contents.** The <roles:Attestation Provider (AP)|Attestation Provider> checks that the <components:Wallet Instance> is valid by verifying the status list referenced in the <artifacts:Wallet Instance Attestation (WIA)|WIA>. Extra cheks are performed like <artifacts:Wallet Instance Attestation (WIA)|WIA> validity checks and associated Proof-of-Possession checks.

**Step 8: Send <artifacts:Wallet Instance Attestation (WIA)|WIA> to Token endpoint (<protocols:OpenID for Verifiable Credentials Issuance (OID4VCI)|OID4VCI>).** The <components:Wallet Instance> sends the <artifacts:Wallet Instance Attestation (WIA)|WIA> signed by the <roles:Wallet Provider (WP)|WP>, attesting that the <components:Wallet Instance> is a valid one.

**Step 9: Send <artifacts:Key Attestation (KA)|KA> to Credential endpoint (<protocols:OpenID for Verifiable Credentials Issuance (OID4VCI)|OID4VCI>).** The <components:Wallet Instance> sends the <artifacts:Key Attestation (KA)|KA> signed by the <roles:Wallet Provider (WP)|WP>, attesting information about the security of cryptographic keys stored in the <components:Wallet Unit>.

**Step 10a: Validate the <artifacts:Key Attestation (KA)|KA> signature.** The <roles:Attestation Provider (AP)|Attestation Provider> checks the <artifacts:Key Attestation (KA)|KA> integrity and authenticity by validating the signature using the <artifacts:Trust Anchor> of the <roles:Trusted Entity> identitied in the <artifacts:List of Trusted Entities (LoTE)|LoTE>.

**Step 10b: Validate the <artifacts:Key Attestation (KA)|KA> contents.** The <roles:Attestation Provider (AP)|Attestation Provider> checks that the cryptographic keys are protected according to its policy if any, and verifies the related Proof-of-Possessions if any.

**Step 11a: Fetch EAA/PID/QEAA/Pub-EAA Provider <artifacts:List of Trusted Entities (LoTE)|LoTE>.** The <components:Wallet Instance> retrieves the <artifacts:List of Trusted Entities (LoTE)|LoTE> listing all the Providers of the corresponding type.

**Step 11b: Validate <roles:Attestation Provider (AP)|Attestation Provider> <artifacts:List of Trusted Entities (LoTE)|LoTE>.** The <components:Wallet Instance> validates the <artifacts:List of Trusted Entities (LoTE)|LoTE> signature in order to make sure the <artifacts:List of Trusted Entities (LoTE)|LoTE> is authentic. A good practice is to follow the [ETSI TS 319 102-1, Clause 5] for validating AdES digital signatures. Extra checks are performed in order to make sure the <artifacts:List of Trusted Entities (LoTE)|LoTE> is not outdated.

**Step 11c: Validate Attestation signature.** The <components:Wallet Instance> checks the integrity and authenticity of the Attestation by validating the signature using the trust anchor identified in the <artifacts:List of Trusted Entities (LoTE)|LoTE>. If multiple Attestations were received, they are all validated.

!!! note

    If any of the checks described in the previous steps fail, the process SHALL be aborted either by the <components:Wallet Instance>, the user, or the <roles:Attestation Provider (AP)|Attestation Provider>.
