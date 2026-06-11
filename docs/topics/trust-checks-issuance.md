
```mermaid
sequenceDiagram
    participant User
    participant Wallet as Wallet Instance
    participant EAAProvider as Attestation Provider
    participant WRPACLoTE as WRPAC LoTE Provider
    participant WRPCLoTE as WRRPC LoTE Provider
    participant WProvider as Wallet Providers LoTE Provider
 
    User->>Wallet: 1. Request EAA issuance
    Wallet->>EAAProvider: 2. Fetch Credential Issuer Metadata (OpenID4VCI)
    EAAProvider-->>Wallet: Signed Credential Issuer Metadata
 
    rect rgb(230, 230, 230)
    Note over Wallet: Verify metadata signature
    Wallet->>WRPACLoTE: 3a. Fetch WRPAC LoTE
    WRPACLoTE-->>Wallet: WRPAC LoTE
    Note over Wallet: 3b. Validate LoTE
    Note over Wallet: 3c. Identify the corresponding trusted entity
    Note over Wallet: 3d. Validate the WRPAC
    Note over Wallet: 3e. Validate the metadata signature using the WRPAC
    end

    rect rgb(230, 230, 230)
    Note over Wallet: Verify WRPRC
    Wallet->>WRPCLoTE: 4a. Fetch WRPRC LoTE
    WRPCLoTE-->>Wallet: WRPRC LoTE
    Note over Wallet: 4b. Validate LoTE
    Note over Wallet: 4c. Identify the corresponding trusted entity
    Note over Wallet: 4d. Validate the WRPRC
    Note over Wallet: 4e. Check Provider entitlements
    end
   
    Note over Wallet: 5. Match WRPAC with WRPRC

    Wallet->>EAAProvider: 6. Send WIA to PAR endpoint (OpenID4VCI)

    rect rgb(230, 230, 230)
    Note over EAAProvider: Verify WIA
    EAAProvider->>WProvider: 7a. Fetch Wallet Providers LoTE
    WProvider-->>EAAProvider: Wallet Providers LoTE
    Note over EAAProvider: 7b. Validate LoTE
    Note over EAAProvider: 7c. Identify the corresponding trusted entity
    Note over EAAProvider: 7d. Validate the WIA signature
    Note over EAAProvider: 7e. Validate the WIA contents
    end
    EAAProvider-->>Wallet: Authorization response (code)

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

    Wallet->>EAAProvider: 9. Send WIA and KA to Credential endpoint (OpenID4VCI)

    rect rgb(230, 230, 230)
    Note over EAAProvider: Verify WIA and KA
    EAAProvider->>WProvider: 7a. Fetch Wallet Providers LoTE
    WProvider-->>EAAProvider: Wallet Providers LoTE
    Note over EAAProvider: 7b. Validate LoTE
    Note over EAAProvider: 7c. Identify the corresponding trusted entity
    Note over EAAProvider: 7d. Validate the WIA signature
    Note over EAAProvider: 7e. Validate the WIA contents
    Note over EAAProvider: 10a. Validate the KA signature
    Note over EAAProvider: 10b. Validate the KA contents
    end
    EAAProvider-->>Wallet: Credential response
```

Note 1: EAA Providers can have a dedicated Authorization server that makes authorization-related endpoints available. That kind of implementation details are hidden in this schema, since the EAA Provider bears the overall responsibility for responding to the Wallet Instance's requests.

Note 2: A nonce endpoint might be necessary as well however that feature does not have an impact on the trust-related checks.
