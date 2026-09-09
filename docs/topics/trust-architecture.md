This section defines the APTITUDE Trust Architecture, including all components that enable the functional trust evaluation mechanisms used within the APTITUDE ecosystem. It first identifies the entities involved in the Large Scale Pilot, then describes the infrastructure through which APTITUDE WP2 establishes their trust, and finally introduces the Onboarding System that renders those entities operational and recognizable within the ecosystem.

### Entities

The APTITUDE Large Scale Pilot implement business use cases that exercise interactions within the EUDI Wallet ecosystem. As a result, the roles defined by that ecosystem remain applicable, while the trust infrastructure supporting them is realized specifically within the APTITUDE boundaries. The main entities involved in APTITUDE are:

- The <roles:User>, who controls and uses a <components:Wallet Unit>, a configuration of a <components:Wallet Solution> provided by a <roles:Wallet Provider (WP)>.
- <roles:Wallet-Relying Party (WRP)|Wallet-Relying Parties (WRPs)>, which interact with the Wallet Unit in one or both of the following capacities:
    - <roles:Provider of Person Identification Data (PID Provider)|Providers of Person Identification Data (PID Providers)> and <roles:Attestation Provider (AP)|Attestation Providers (AP)> issue <credentials:Person Identification Data (PID)|PID> or <credentials:Attestation|Attestations> to the Wallet Unit. Attestation Providers comprise <roles:QEAA Provider|QEAA Providers>, <roles:PuB-EAA Provider|PuB-EAA Providers>, and non-qualified <roles:EAA Provider|EAA Providers>.
    - <roles:Relying Party (RP)|Relying Parties (RPs)> and <roles:Relying Party Intermediary (RPI)|Relying Party Intermediaries (RPIs)> request <credentials:Attestation|Attestations> from the Wallet Unit.

```mermaid
flowchart TD
    WP["Wallet Provider (WP)"]
    User(("User"))
    WU["Wallet Unit<br/>[WIA/KA]"]

    subgraph WRP["Wallet-Relying Parties (WRPs)<br/>[WRPAC, WRPRC]"]
        direction LR
        PIDP["PID Provider"]
        subgraph AP["Attestation Providers"]
            QEAAP["QEAA Provider"]
            PubP["PuB-EAA Provider"]
            EAAP["Non-qualified<br/>EAA Provider"]
        end
        RP["Relying Party (RP)"]
        RPI["Relying Party<br/>Intermediary (RPI)"]
    end

    WP -->|"provides the Wallet Solution"| WU
    User -->|"controls and uses"| WU
    WU <-->|"PID/Attestation<br/>issuance or presentation"| WRP

    classDef wrpEntity fill:#ffefd5,stroke:#ffdab9,color:#000;
    class PIDP,QEAAP,PubP,EAAP,RP,RPI wrpEntity;
    style WRP fill:#fff,stroke:#ffdab9,stroke-width:2px,rx:20,ry:20
    style AP fill:#fff,stroke:#ffdab9,stroke-width:2px,rx:20,ry:20
```

The <roles:User> and <components:Wallet Unit> participate in runtime issuance and presentation interactions but are not onboarded as organizational entities. The organizational entities made operational through the APTITUDE trust infrastructure are the <roles:Wallet Provider (WP)|WPs> and the various types of <roles:Wallet-Relying Party (WRP)|WRPs> introduced above.

### Trust Infrastructure

The APTITUDE Large Scale Pilot does not deploy the full-stack Member State and European Commission infrastructure assumed by the EUDI Wallet framework. For piloting purposes, APTITUDE WP2 operates the corresponding registration, certificate issuance, and LoTE publication capabilities. Together, these capabilities establish the Trust Anchors and trust artifacts used by the [Trust Evaluation Processes](../sections/trust-evaluation-process.md).

The Trust Infrastructure employed for APTITUDE consists of:

- The APTITUDE <components:Public Key Infrastructure (PKI)|Public Key Infrastructure (PKI)>, which issues and manages the X.509 certificates required by the pilot.
- The Registration Service and <components:Register>, which record the identity, role, and authorization information of WRPs.
- The Certificate Issuance Services, which issue and manage <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs>, <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRCs>, and Entity Sign/Seal Certificates.
- The Publication Service, which signs and publishes the applicable <artifacts:List of Trusted Entities (LoTE)|LoTE>.
- The Onboarding UI, which coordinates these services for each entity requesting onboarding.

#### Public Key Infrastructure

The APTITUDE Public Key Infrastructure establishes the certificate chains used to authenticate pilot entities and to validate the signatures or seals they create. APTITUDE WP2 SHALL establish the <roles:Certificate Authority (CA)|Certificate Authorities (CAs)> shown below. The <artifacts:Trust Anchor|Trust Anchor> Certificate of each CA SHALL be published in the corresponding LoTE.

The diagram is organised into four layers, from the WP2 Publication Service at the top to the APTITUDE entities at the bottom. A solid arrow shows a CA issuing a certificate to the corresponding entity, while a dashed line connects each CA to the LoTE in which its Trust Anchor is published.

```mermaid
flowchart TB
    PubSvc["WP2 Publication Service"]:::publication

    subgraph Lists["APTITUDE Lists of Trusted Entities"]
        direction LR
        QEAA_L["QEAA Providers LoTE"]
        PID_L["PID Providers LoTE"]
        PuBEAA_L["PuB-EAA Providers LoTE"]
        EAA_L["EAA Providers LoTE"]
        WRPAC_L["Providers of WRPAC LoTE"]
        Wallet_L["Wallet Providers LoTE"]
        WRPRC_L["Providers of WRPRC LoTE"]
        Registrar_L["Registrars and Registers LoTE"]
    end

    subgraph PKI["APTITUDE PKI - Certificate Authorities"]
        direction LR
        QEAA_CA["QEAA Provider<br/>Sign/Seal CA"]
        PID_CA["PID Provider<br/>Sign/Seal CA"]
        PuBEAA_CA["PuB-EAA Provider<br/>Sign/Seal CA"]
        EAA_CA["EAA Provider<br/>Sign/Seal CA"]
        WRPAC_CA["Provider of WRPAC"]
        Wallet_CA["Wallet Provider<br/>Sign/Seal CA"]
        WRPRC_CA["Provider of WRPRC"]
        Registrar_CA["Registrar"]
    end

    subgraph Entities["Corresponding APTITUDE Entities"]
        direction LR
        QEAA_Entity["QEAA Provider"]
        PID_Entity["PID Provider"]
        PuBEAA_Entity["PuB-EAA Provider"]
        EAA_Entity["Non-qualified EAA Provider"]
        WRP_Entity["Wallet-Relying Party"]
        Wallet_Entity["Wallet Provider"]
    end

    PubSvc ---->|"publishes"| QEAA_L
    PubSvc -->|"publishes"| PID_L
    PubSvc -->|"publishes"| PuBEAA_L
    PubSvc -->|"publishes"| EAA_L
    PubSvc -->|"publishes"| WRPAC_L
    PubSvc -->|"publishes"| Wallet_L
    PubSvc -->|"publishes"| WRPRC_L
    PubSvc -->|"publishes"| Registrar_L

    QEAA_L -. "Trust Anchor" .- QEAA_CA
    PID_L -. "Trust Anchor" .- PID_CA
    PuBEAA_L -. "Trust Anchor" .- PuBEAA_CA
    EAA_L -. "Trust Anchor" .- EAA_CA
    WRPAC_L -. "Trust Anchor" .- WRPAC_CA
    Wallet_L -. "Trust Anchor" .- Wallet_CA
    WRPRC_L -. "Trust Anchor" .- WRPRC_CA
    Registrar_L -. "Trust Anchor" .- Registrar_CA

    QEAA_CA -->|"issues QEAA Provider Sign/Seal Certificate"| QEAA_Entity
    PID_CA -->|"issues PID Provider Sign/Seal Certificate"| PID_Entity
    PuBEAA_CA -->|"issues PuB-EAA Provider Sign/Seal Certificate"| PuBEAA_Entity
    EAA_CA -->|"issues EAA Provider Sign/Seal Certificate"| EAA_Entity
    WRPAC_CA -->|"issues WRPAC"| WRP_Entity
    Wallet_CA -->|"issues Wallet Provider Sign/Seal Certificate"| Wallet_Entity
    WRPRC_CA -->|"issues WRPRC"| WRP_Entity

    classDef publication fill:#d1ecf1,stroke:#17a2b8,color:#000;
    style Lists fill:#fff,stroke:#abb2bf,stroke-width:2px,rx:20,ry:20
    style PKI fill:#fff,stroke:#ffc107,stroke-width:2px,rx:20,ry:20
    style Entities fill:#fff,stroke:#ffdab9,stroke-width:2px,rx:20,ry:20
```

The CA certificates published as Trust Anchors are distinct from the end-entity certificates issued by those CAs. The profiles for both certificate types are defined in [Trust Artifacts](../sections/trust-artifacts.md).

#### Trust Service Overview

The trust infrastructure capabilities are exposed through the APTITUDE **Onboarding System**. In this specification, Onboarding System denotes the aggregate logical system, while service denotes one of its constituent components (Registration, Certificate Issuance, or Publication).

The Onboarding System enables APTITUDE Partners to obtain the trust artifacts required for interactions within the ecosystem. The path varies by entity type, as detailed in [Onboarding Paths by Entity Type](../sections/onboarding-process.md#onboarding-paths-by-entity-type), but comprises the following activities where applicable:

1. The entity submits its identity and authorization information to the Registration Service. Within APTITUDE, the Registration Service SHALL verify that the requester is an APTITUDE participant, and SHALL otherwise rely on the submitted self-declaration; it SHALL NOT perform the identity proofing defined in [ETSI TS 119 461] or [CIR 2025/848, Article 6].
2. The entity submits the technical configuration and cryptographic material required for its role. The applicable Certificate Issuance Services issue the corresponding WRPAC, WRPRC, or Entity Sign/Seal Certificate.
3. For an entity whose Trust Anchor must be published, the Publication Service uses its notifiable information to create or update the applicable LoTE entry.

The figure below provides a logical overview rather than a deployment architecture. The component responsibilities, prerequisites, inputs, outputs, and entity-specific paths are specified in [Onboarding Process](../sections/onboarding-process.md).

```mermaid
flowchart TB
    Entity(["APTITUDE participant<br/>requesting onboarding"])

    subgraph System["APTITUDE Onboarding System"]
        direction LR
        UI["Onboarding UI"]:::interface
        RegSvc["Registration Service"]:::service
        CertSvc["Certificate Issuance Services<br/>WRPAC, WRPRC, Sign/Seal"]:::certificate
        PubSvc["Publication Service"]:::service
        Register[("Register")]:::store
        Notification[("Notification dataset")]:::store

        UI -->|"registration data"| RegSvc
        RegSvc <-->|"create, read, update"| Register
        UI -->|"certificate requests"| CertSvc
        CertSvc -.->|"verify registration"| RegSvc
        UI -->|"notifiable data"| PubSvc
        PubSvc <-->|"manage"| Notification
    end

    Certificates{{"Issued Certificates"}}
    Lists{{"LoTE"}}

    Entity <-->|"submit data and receive results"| UI
    CertSvc -->|"issues"| Certificates
    PubSvc -->|"signs and publishes"| Lists

    classDef interface fill:#d4edda,stroke:#28a745,color:#000;
    classDef service fill:#d1ecf1,stroke:#17a2b8,color:#000;
    classDef certificate fill:#fff3cd,stroke:#ffc107,color:#000;
    classDef store fill:#f5f5f5,stroke:#999,color:#000;
    style System fill:#fff,stroke:#2f4f4f,stroke-width:2px,rx:20,ry:20
```

!!! warning

    The implementation architecture of the Trust Services and components will be further defined in T2.3.1, but SHOULD adhere to these implementation profiles.
