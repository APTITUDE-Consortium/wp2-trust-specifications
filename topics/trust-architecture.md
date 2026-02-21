# Trust Architecture

The main entities involved in the EUDIW ecosystem are:
- the Wallet Unit, installed and activated by the User and provided through a Wallet Solution by the Wallet Provider (WP)
- Wallet Relying Parties (WRPs)
    - the PID Providers and Attestation Providers that interact with the Wallet Unit to issue Attestations
    - the Relying Parties (RPs) and RP Intermediaries that interact with the Wallet Unit to request Attestations


```mermaid
graph TD

    WP["Wallet Provider (WP)"]
    User((User))
    WU["Wallet Unit <br/> [WIA]"]

   subgraph WRP["Wallet Relying Parties (WRPs) [WRPAC, WRPRC]"]
        direction LR
        PIDP["PID Providers"]
        subgraph AP["Attestation Providers"]
            QEAAP["QEAA <br/>Providers"]
            PubP["Pub-EAA <br/>Providers"]
            EAAP["non-qualified <br/>EAA Providers"]
        end
        RP["Relying Parties (RPs)"]
        RPI["RP <br/>Intermediaries"]
    end

    %% Skeleton
    PIDP ~~~ RPI
    RPI ~~~ AP
    RP ~~~ RPI

    %% Style
    classDef WRP_entities fill:#ffefd5, stroke:#ffdab9
    style WRP fill:#ffff,stroke:#ffdab9,stroke-width:2px,rx:20,ry:20
    style AP fill:#ffff,stroke:#ffdab9,stroke-width:2px,rx:20,ry:20

    class QEAAP,PIDP,PubP,EAAP,RP,RPI WRP_entities;


    %% Arrows
    WP ---|Provides Wallet Solution| User 
    User ---|Controls/activates| WU
    WU ---|"Interacts (issue/present <br/>PID/Attestation)"| WRP 
```

However, these entities alone are not enough to establish trust between each others. Indeed, to trust the interactions between these entities, the following processes are needed:
- *Authentication Process*: a way to authenticate the entity they interact with. To achieve this: 
    - the Wallet Unit needs a Wallet Instance Attestation (WIA), an object that attests its integrity and is signed by the WP.
    - the WRPs needs an WRP Access Certificate (WRPAC).
- *Authorization Process*: a way to check the authorization of an entity (e.g., it is the WRP eligible to issue/request an Attestation). To achieve this: 
    - the intended use of a WRP is written in a signed Register, and optionally in a WRP Registration Certificate (WRPRC).
    - the Attestation Providers may write their own embedded disclosure policies.
- *Trust Anchor validation process*: a way to check the authenticity of signed objects, e.g., PID, Attestations, certificates and Register. To achieve this:
    - the public key of the corresponding private key used to sign is published on EU Member State Trusted List (EUMS TLs) or on List of Trusted Entities (LoTE) managed by the European Commission.

While these trust evaluation processes will be further detailed in the following sections, the processes to obtain and manage the artifacts needed for the trust evaluation are:
- *WRP Registration Process*: to rely on Wallet Units for the purpose of providing a service, WRPs register at a Registrar in the Member State where they are established. Based on the type of service registered, registration includes: the attributes that the RP intends to request from Wallet Units or the attestation type(s) the Attestation Provider wants to issue to Wallet Units. The following steps are in common to all WRPs:
  1. *Identity and Catalogue Verification:*  Registrar verifies the identity of WRP according to requirements in ETSI TS 119 461. The specific identity proofing level may vary based on entity type and applicable regulatory framework (e.g. QTSP requirements or MS national legislation) and it is out of scope of the piloting. In this process, Registrar may use the Catalogue of Attributes and Catalogue of Schemes for the Attestation of Attributes managed by the Commission for evaluating the registration request.
  2. *Registration Record Creation*: Registrar creates registration record in national Register and made available online both in human-readable and machine-readable format. Record contains at least:
     - WRP identification information.
     - WRP type (RP, PID Provider, QEAA Provider, PuB-EAA Provider, EAA Provider).
     - Entity-specific capabilities
  3. *WRPAC Issuance*: WRP obtains a WRPAC provided by a Provider of WRPAC.
  4. optionally *WRPRC Issuance*: If the Member State mandates WRPRC issuance according to CIR 2025/848 Article 8, the Provider of WRPRCs must issue a signed WRPRC containing registered capabilities. If it is not mandated, Wallet Instance may retrieve information from Register.

    ```mermaid
    graph TD

    WRP["Wallet Relying Parties <br/> (WRPs)"]

    subgraph MS["Member State (MS)"]
        MSReg[MS <br/>Registrar]
        ProvAC[Provider of <br/>WRPAC]
        ProvRC[Provider of <br/>WRPRC]
        Reg[/"Register(s)"/]
        MSReg---|"Publishes data"| Reg
    end

    subgraph EC["European Commission (EC)"]
        Cat[/Catalogues/]
    end

    %% Style
    style WRP fill:#ffefd5, stroke:#ffdab9,stroke-width:2px,rx:20,ry:20
    style MS fill:#ffff,stroke:#2f4f4f,stroke-width:2px,rx:20,ry:20
    style EC fill:#ffff,stroke:#abb2bf,stroke-width:2px,rx:20,ry:20
    classDef blue fill:#e8f0fe,stroke:#abb2bf
    classDef green fill:#8fbc8f,stroke:#2f4f4f

    class QEAAP,PIDP,PubP,EAAP,RP,RPI WRP_entities;
    class ECLoTE,ECNS,Cat,LoTEs blue;
    class MSReg,ProvAC,ProvRC,TLs,Reg green;

    %% Arrows
    WRP ---|"Request registration"| MSReg
    ProvAC ---|"Issues WRPAC"| WRP
    ProvRC-. "Issues WRPRC" .-> WRP
    MSReg ---|"Checks Catalogues"| Cat
    ```
- *Notification Process*: Based on the entity, the MS sends a set of the data to the EC Notification System. 
    - For WPs, PID Providers, Providers of WRPAC, Providers of WRPRC and MS Registrars, MS sends a set of the data (including the Trust Anchors) to the EC. As result, the notified entities are included in a List of Trusted Entities (LoTE) by a EC LoTE Provider.
    - For Pub-EAA Providers, MS sends a set of the data (no Trust Anchor) to the EC. As result, the notified entities are included in a LoTE by a EC LoTE Provider.
    - For QEAA Providers and QTSP, MS sends a set of the data (containing the URL of the EUMS TLs) to the EC. As result, the URL of the EUMS TLs is added in the EU List of Trusted List (LOTL).
    ```mermaid
    graph LR

    subgraph MS["Member State (MS)"]
        MSTLP["MS  <br/>Trusted List Provider  <br/>(TLP)"]
        TLs[/TLs/]
        MSTLP ---|"publish"| TLs
    end

    subgraph EC["European Commission (EC)"]
        ECLoTE[EC LoTE <br/>Provider]
        LoTE1[/WP <br/>LoTE/]
        LoTE2[/PID Providers <br/>LoTE/]
        LoTE3[/Providers of <br/>WRPAC LoTE/]
        LoTE4[/Providers of <br/>WRPRC LoTE/]
        LoTE5[/MS Registrar <br/>LoTE/]
        LoTE6[/Pub-EAA Providers <br/>LoTE/]
        LOTL[/LOTL/]
        ECLoTE ---|"publish"| LoTE1
        ECLoTE ---|"publish"| LoTE2
        ECLoTE ---|"publish"| LoTE3
        ECLoTE ---|"publish"| LoTE4
        ECLoTE ---|"publish"| LoTE5
        ECLoTE ---|"publish"| LoTE6
        ECLoTE ---|"publish"| LOTL
    end

    LoTE1 ~~~ LoTE2
    LoTE3 ~~~ LoTE4
    LoTE5 ~~~ LoTE6

    %% Style
    style EC fill:#ffff,stroke:#abb2bf,stroke-width:2px,rx:20,ry:20
    style MS fill:#ffff,stroke:#2f4f4f,stroke-width:2px,rx:20,ry:20
    classDef blue fill:#e8f0fe,stroke:#abb2bf
    classDef green fill:#8fbc8f,stroke:#2f4f4f

    class ECLoTE,ECNS,LoTE1,LoTE2,LoTE3,LoTE4,LoTE5,LoTE6,LOTL blue;
    class MSTLP,TLs green;

    %% Arrows
    EC ---|"Notification Process <br/>(Trust Anchor or <br/>URL of the EUMS TL)"| MS
    ```

The following figure add these two processes to the previous architecture.

```mermaid
graph TD

    WP["Wallet Provider (WP)"]
    User((User))
    WU["Wallet Unit <br/> [WIA]"]

   subgraph WRP["Wallet Relying Parties (WRPs) <br/>[WRPAC, WRPRC]"]
        direction LR
        PIDP["PID Providers"]
        subgraph AP["Attestation Providers"]
            QEAAP["QEAA <br/>Providers"]
            PubP["Pub-EAA <br/>Providers"]
            EAAP["non-qualified <br/>EAA Providers"]
        end
        RP["Relying Parties (RPs)"]
        RPI["RP <br/>Intermediaries"]
    end

    subgraph MS["Member State (MS)"]
        MSReg[MS <br/>Registrar]
        ProvAC[Provider of <br/>WRPAC]
        ProvRC[Provider of <br/>WRPRC]
        MSTLP["MS  <br/>Trusted List Provider  <br/>(TLP)"]
        TLs[/EUMS TLs/]
        Reg[/"Register(s)"/]
        MSTLP --- TLs
        MSReg--- Reg
    end

    subgraph EC["European Commission (EC)"]
        ECLoTE[EC LoTE <br/>Provider]
        Cat[/Catalogues/]
        LoTEs[/LOTLs or LoTEs/]
        ECLoTE --- LoTEs
    end



    %% Skeleton
    PIDP ~~~ RPI
    RPI ~~~ AP
    RP ~~~ RPI
    ProvAC ~~~ ProvRC
  

    %% Style
    classDef WRP_entities fill:#ffefd5, stroke:#ffdab9
    style WRP fill:#ffff,stroke:#ffdab9,stroke-width:2px,rx:20,ry:20
    style AP fill:#ffff,stroke:#ffdab9,stroke-width:2px,rx:20,ry:20
    style EC fill:#ffff,stroke:#abb2bf,stroke-width:2px,rx:20,ry:20
    style MS fill:#ffff,stroke:#2f4f4f,stroke-width:2px,rx:20,ry:20
    classDef blue fill:#e8f0fe,stroke:#abb2bf
    classDef green fill:#8fbc8f,stroke:#2f4f4f

    class QEAAP,PIDP,PubP,EAAP,RP,RPI WRP_entities;
    class ECLoTE,ECNS,Cat,LoTEs blue;
    class MSTLP,MSReg,ProvAC,ProvRC,TLs,Reg green;


    %% Arrows
    WP ---|Provides Wallet Solution| User 
    User ---|Controls/activates| WU
    WU ---|"Interacts (issue/present <br/>PID/Attestation)"| WRP 
    WRP ---|"WRP Registration Process"| MS  
    EC ---|"Notification Process <br/> through the EC Notification System"| MS
```