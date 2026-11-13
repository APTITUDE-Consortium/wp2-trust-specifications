This section defines the APTITUDE Trust Architecture, including all components that enable the functional trust evaluation mechanisms used within the APTITUDE ecosystem. It first identifies the entities involved in the Large Scale Pilot, then describes the infrastructure through which APTITUDE WP2 establishes their trust, and finally introduces the Onboarding System that renders those entities operational and recognizable within the ecosystem.

### Entities

The APTITUDE Large Scale Pilot implement business use cases that exercise interactions within the <components:EUDI Wallet> ecosystem. As a result, the roles defined by that ecosystem remain applicable, while the supporting trust infrastructure is realized specifically within the APTITUDE boundaries. The main entities involved in APTITUDE are:

- The <roles:User>, who controls and uses a <components:Wallet Unit>, that is a configuration of a <components:Wallet Solution> provided by a <roles:Wallet Provider (WP)>.
- <roles:Wallet-Relying Party (WRP)|Wallet-Relying Parties (WRPs)>, which interact with the <components:Wallet Unit> in one or both of the following capacities:
    - <roles:Provider of Person Identification Data (PID Provider)|Providers of Person Identification Data (PID Providers)> and <roles:Attestation Provider (AP)|Attestation Providers (APs)> issue <credentials:Person Identification Data (PID)|PID> or <credentials:Attestation|Attestations> to the <components:Wallet Unit>. <roles:Attestation Provider (AP)|Attestation Providers> comprise:
        - <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|Providers of Public Electronic Attestation of Attributes (PuB-EAA Providers)>;
        - <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)|Providers of Qualified Electronic Attestation of Attributes (QEAA Providers)>;
        - <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|Providers of Electronic Attestation of Attributes (EAA Providers)>.
    - <roles:Relying Party (RP)|Relying Parties (RPs)> and <roles:Relying Party Intermediary (RPI)|Relying Party Intermediaries (RPIs)> request <credentials:Attestation|Attestations> from the <components:Wallet Unit>.

```mermaid
flowchart TD
    WP["Wallet Provider (WP)"]
    User(("User"))
    WU["Wallet Unit<br/>[WIA/KA]"]

    subgraph WRP["Wallet-Relying Parties (WRPs) [WRPAC, WRPRC]"]
        direction LR
        PIDP["PID Provider"]
        subgraph AP["Attestation Providers"]
            QEAAP["QEAA Provider"]
            PubP["PuB-EAA Provider"]
            EAAP["EAA Provider"]
        end
        RP["Relying Party (RP)"]
        RPI["Relying Party<br/>Intermediary (RPI)"]
    end

    WP -->|"provides the Wallet Solution"| WU
    User -->|"controls and uses"| WU
    WU <-->|"PID/Attestation<br/>issuance or presentation"| WRP

    classDef wrpEntity fill:#ffefd5,stroke:#ffdab9,color:#000;
    class PIDP,QEAAP,PubP,EAAP,RP,RPI wrpEntity;
    style WRP stroke:#ffdab9,stroke-width:2px,rx:20,ry:20
    style AP stroke:#ffdab9,stroke-width:2px,rx:20,ry:20
```

The <roles:User> and <components:Wallet Unit> participate in runtime Issuance and Presentation interactions but are not onboarded as organizational entities. The organizational entities made operational through the APTITUDE trust infrastructure are the <roles:Wallet Provider (WP)|WPs> and the various types of <roles:Wallet-Relying Party (WRP)|WRPs> introduced above.

### Trust Infrastructure

The APTITUDE Large Scale Pilot does not deploy the full-stack Member State and European Commission infrastructure assumed by the <components:EUDI Wallet> framework. For piloting purposes, APTITUDE WP2 operates the corresponding capabilities regarding registration, certificate issuance, and publication of the pilot TL and LOTL for QEAA services and the seven retained <artifacts:List of Trusted Entities (LoTE)|LoTE> types. Together, these capabilities establish the <artifacts:Trust Anchor|Trust Anchors> and trust artifacts used by the [Trust Evaluation Processes](../sections/trust-evaluation-process.md).

The trust infrastructure employed for APTITUDE consists of:

- The APTITUDE <components:Public Key Infrastructure (PKI)|Public Key Infrastructure (PKI)>, which issues and manages the X.509 certificates required by the ecosystem.
- The Registration Service and <components:Register>, which record the identity, role, and authorization information of <roles:Wallet-Relying Party (WRP)|WRPs>.
- The Certificate Issuance Services, which issue and manage <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs> and <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRCs> during onboarding. The PKI also issues and manages the Entity Sign/Seal Certificates used by entities.
- The Publication Service, which signs and publishes the pilot LOTL and TL for QEAA services and the seven retained LoTE types shown below. WP2 emulates the Member State TL and European Commission LOTL scheme operators. Pilot trust does not confer institutional EU qualified status.
- The Onboarding UI, which coordinates these services for each entity requesting onboarding.

The pilot architecture follows [ETSI TS 119 612 V2.4.1 (2025-08), Clauses 4, 5.3.13, 5.5.3, 5.7.1 and Annex A], and [ETSI TS 119 615 V1.4.1 (2026-05), Clauses 4.0–4.2]. An explicit pilot <artifacts:Official Journal of APTITUDE (OJA)|OJA> bootstrap supplies the directly trusted LOTL signing certificates and location; the authenticated LOTL supplies the TL signing certificates and location; the authenticated TL identifies the QEAA service through its service digital identity, following [ARF, Chapter 6, Section 6.3.2.4, main commit f5789a77dfc6d5a85834c431465afbe543d0141a]. Scheme-operator list-signing certificates authenticate lists independently of entity CA chains. TL service digital identities identify services and are distinct in role from list-signing certificates, CA Trust Anchor Certificates and entity Sign/Seal Certificates. List and certificate profiles are defined in [Trust Artifacts](../sections/trust-artifacts.md).

#### Public Key Infrastructure

The APTITUDE PKI establishes the certificate chains used to authenticate the entities involved and to validate the <artifacts:Electronic Signature|signatures> or <artifacts:Electronic Seal|seals> they create. APTITUDE WP2 SHALL establish the <roles:Certificate Authority (CA)|Certificate Authorities (CAs)> shown below. The <artifacts:Trust Anchor> Certificate of each <roles:Certificate Authority (CA)|CA> for a retained LoTE path SHALL be published in the corresponding <artifacts:List of Trusted Entities (LoTE)|LoTE>.

The diagram shows the Publication Service, pilot lists, certificate authorities and corresponding entities, together with the OJA bootstrap. The OJA supplies the LOTL signing certificates and location, and the LOTL supplies the TL signing certificates and location. The dashed link from the pilot TL identifies the QEAA service through its service digital identity; the seven other dashed links connect retained LoTEs to the <roles:Certificate Authority (CA)|CAs> whose <artifacts:Trust Anchor|Trust Anchors> they publish. Solid arrows show publication relationships and certificate issuance, as labelled.

```mermaid
flowchart TB
    PubSvc["APTITUDE WP2 Publication Service"]:::publication

    subgraph Lists["APTITUDE TL and seven retained LoTEs"]
        direction LR
        QEAA_L["Pilot TL: QEAA service digital identity"]
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
        EAA_Entity["EAA Provider"]
        WRP_Entity["Wallet-Relying Party"]
        Wallet_Entity["Wallet Provider"]
    end

    OJA["Pilot OJA bootstrap"]
    LOTL["Pilot LOTL"]
    OJA -->|"LOTL signing certificates and location"| LOTL
    LOTL -->|"TL signing certificates and location"| QEAA_L
    PubSvc -->|"signs and publishes"| LOTL
    PubSvc -->|"signs and publishes"| QEAA_L
    PubSvc -->|"publishes"| PID_L
    PubSvc -->|"publishes"| PuBEAA_L
    PubSvc -->|"publishes"| EAA_L
    PubSvc -->|"publishes"| WRPAC_L
    PubSvc -->|"publishes"| Wallet_L
    PubSvc -->|"publishes"| WRPRC_L
    PubSvc -->|"publishes"| Registrar_L

    QEAA_L -. "identifies QEAA service" .- QEAA_Entity
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
    style Lists fill:#fff,stroke:#abb2bf,stroke-width:2px,color:#000,rx:20,ry:20
    style PKI fill:#fff,stroke:#ffc107,stroke-width:2px,color:#000,rx:20,ry:20
    style Entities fill:#fff,stroke:#ffdab9,stroke-width:2px,color:#000,rx:20,ry:20
```

The <roles:Certificate Authority (CA)|CA> certificates published as <artifacts:Trust Anchor|Trust Anchors> are distinct from the end-entity certificates issued by those <roles:Certificate Authority (CA)|CAs>. The profiles for both certificate types are defined in [Trust Artifacts](../sections/trust-artifacts.md).

#### Trust Service Overview

The trust infrastructure capabilities are exposed through the APTITUDE Onboarding System. In this specification, *Onboarding System* denotes the aggregate logical system, while *Service* denotes one of its constituent components (Registration, WRPAC Issuance, WRPRC Issuance, Sign/Seal Certificate Issuance or Publication).

The Onboarding System operates on a trust infrastructure whose entities are established and whose <artifacts:Trust Anchor|Trust Anchors> are published before operational entity onboarding starts. Within APTITUDE, this one-time prerequisite is established out of band with no APTITUDE software and is not part of the recurring onboarding flow. The recurring process enables APTITUDE operational entities to obtain the trust artifacts required for interactions within the ecosystem. Its detailed inputs, outputs, and entity-specific paths are defined in [Onboarding Process](../sections/onboarding-process.md).

The **Onboarding UI** is the APTITUDE-specific orchestrator and single point of contact for an entity requesting onboarding. It collects the submitted data and SHALL trigger the applicable stages in order: registration, certificate issuance, and, where applicable, publication or update of the pilot TL service entry for QEAA Providers or the applicable retained LoTE entry:

1. A <roles:Wallet-Relying Party (WRP)|WRP> submits its registration data to the Registration Service. Within APTITUDE, registration SHALL be restricted to APTITUDE Partners; the Registration Service SHALL otherwise rely on the submitted self-declaration and SHALL NOT perform the identity proofing defined in [ETSI TS 119 461] or [CIR 2025/848, Article 6]. After successful verification, the Registration Service creates an active record in the <components:Register|WRP Register>.
2. After the registration record is active, the <roles:Wallet-Relying Party (WRP)|WRP> requests the applicable <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> and <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC>. The certificate issuance stage also covers Sign/Seal Certificates where applicable.
3. A notified <roles:Wallet-Relying Party (WRP)|WRP> submits its notifiable data, after certificate issuance, to the Publication Service, which creates or updates the pilot TL service entry for a QEAA Provider or the applicable retained LoTE entry, as specified in [Onboarding Process](../sections/onboarding-process.md). A <roles:Wallet Provider (WP)|Wallet Provider> follows a <processes:Notification|notification>-only path with respect to registration and WRP certificates: it bypasses those stages, obtains its Sign/Seal Certificate, and then submits its notifiable data to the Publication Service.
4. A <roles:Relying Party (RP)|Relying Party> or <roles:Relying Party Intermediary (RPI)|Relying Party Intermediary> completes onboarding after certificate issuance and does not require a <artifacts:List of Trusted Entities (LoTE)|LoTE> entry; trust in it is anchored through the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>.

The figure below provides a logical overview rather than a deployment architecture. The notification data store is an internal detail of the Onboarding Process and is not represented here. The component responsibilities, prerequisites, inputs, outputs, and entity-specific paths are specified in [Onboarding Process](../sections/onboarding-process.md).

```mermaid
flowchart TD
    ENTITY(["Operational entity<br/>submits applicable data"])
    REG["Register WRP;<br/>create active WRP Register record"]
    CERT["Issue applicable certificates<br/>WRPAC / WRPRC<br/>Sign/Seal where applicable"]
    PUB["Publish or update applicable<br/>retained LoTE entry"]
    QPUB["Publish QEAA service in pilot TL<br/>referenced by pilot LOTL"]
    ACTIVE(["Entity is Operational"])

    ENTITY -->|"WRP"| REG
    ENTITY -->|"Wallet Providers"| CERT
    REG --> CERT
    CERT -->|"PID / PuB-EAA / EAA Provider<br/>or Wallet Provider"| PUB
    CERT -->|"QEAA Provider"| QPUB
    QPUB --> ACTIVE
    CERT -->|"RP / RP Intermediary"| ACTIVE
    PUB --> ACTIVE
    ACTIVE -.->|"repeat for next entity"| ENTITY
```

!!! warning

    The implementation architecture of the Trust Services and components will be further defined in task T2.3.1 (*Design and implementation of the trust infrastructure*), but SHOULD adhere to these implementation profiles.
