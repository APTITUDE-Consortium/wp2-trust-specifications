This section describes the high level trust management process within the APTITUDE Trust Framework. Its scope is describing the lifecycle of Entities and Trust Artifacts related to <roles:Wallet-Relying Party (WRP)|WRPs> and <roles:Wallet Provider (WP)|WPs> within the ecosystem, and the relationships between them. Trust Artifacts are the transport mechanism of the Properties (specific Entity attributes categorized in Identity Information, Technical Information, and Policy and Authorization Information) which characterize the entities within the ecosystem, and they are issued and managed by other entities within the ecosystem (LoTE Providers and Trust Artifact Providers).

In particular, this section is structured as follows:

- Section [Ecosystem Participants](#ecosystem-participants) describes the various entities within the ecosystem, their roles and relationships.
- Section [Entity Properties Schema](#entity-properties-schema) describes the various Properties of <roles:Wallet-Relying Party (WRP)|WRPs> and <roles:Wallet Provider (WP)|WPs>, the Trust Artifacts in which these Properties are contained, and the relationships between them.
- Section [Abstract State Machine](#abstract-state-machine) describes the lifecycle *State* (an abstraction at the governance level that captures the current operational status and trustworthiness within the ecosystem) of <roles:Wallet-Relying Party (WRP)|WRPs>, <roles:Wallet Provider (WP)|WPs>, Trust Artifacts, and LoTEs, their definitions, and the effects that these states have on the entities' operational capabilities and trustworthiness.
- Section [Entity Lifecycle Operations](#entity-lifecycle-operations) describes the operational procedures triggered by changes in the Properties of <roles:Wallet-Relying Party (WRP)|WRPs> and <roles:Wallet Provider (WP)|WPs>, and the resulting effects on their lifecycle states and trustworthiness within the ecosystem.

When a <roles:Wallet-Relying Party (WRP)|WRP>'s, <roles:Wallet Provider (WP)|WP>'s, or Trust Artifacts Properties change (e.g., key rotation), the Trust Artifact Providers or LoTE Providers have to update, revoke and issue or re-sign the corresponding Trust Artifacts or LoTEs, without necessarily altering the underlying Abstract State of the <roles:Wallet-Relying Party (WRP)|WRP>. These operational procedures are defined in [Entity Lifecycle Operations](#entity-lifecycle-operations).

### Ecosystem Participants

The entities in the ecosystem are divided in different groups depending on their role and the artifact that they issue.

- *<roles:Supervisory Body|Supervisory Bodies>* continuously *supervise* other ecosystem entities. Supervision affect the states of dependent Entities.
- *Member States and the European Commission* *define* and *manage* <artifacts:Attestation Rulebook|Attestation Rulebooks>, and *define* *Ecosystem Policies and Certification Schemas*. These affect dependent Entities during onboarding and their lifecycle.
- *Scheme Operators* (<roles:List of Trusted Entities Provider (LoTE Provider)|LoTE Provider>, <roles:List of Trusted Lists Scheme Operator (LOTLSO)|LOTL Scheme Operators>, <roles:Trusted List Provider|Trusted List Providers>) *publish* and *manage* *Trust Lists* (<artifacts:List of Trusted Entities (LoTE)|LoTE>, <artifacts:List Of Trusted Lists (LOTL)|LOTL>, <artifacts:Trusted List (TL)|TL>) that contain <artifacts:Trust Anchor|Trust Anchors> and Properties of other Entities. Inclusion in these artifacts is, by itself, also a statement about the role and authorization of the included entities within the ecosystem.
- *Trust Artifacts Providers* (MS <roles:Registrar|Registrars>, <roles:Qualified Trust Service Provider (QTSP)|QTSPs>, <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)|Providers of WRPAC>, <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)|Providers of WRPRC>) *publish* and *manage* *Trust Artifacts* (<components:Register|Registers>, <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs>, <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRCs>, <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> Certificates) which transports Properties (Identity Information, Technical configurations, and Authorization Information) of End-Entities.
- *End-Entities* (<roles:Attestation Provider (AP)|Attestation Providers>, <roles:Provider of Person Identification Data (PID Provider)|PID Providers>, <roles:Relying Party (RP)|Relying Parties>, <roles:Wallet Provider (WP)|Wallet Provider>) rely on Trust Lists and Trust Artifacts for assessing their trustworthiness to other participants within the ecosystems. In addition, they *issue*, *receive* or *manage* User Attestations or Wallet Attestations to and from <components:Wallet Unit|Wallet Units> during issuance, presentation and <roles:Wallet Provider (WP)|WP>-specific management flows respectively.

!!! choice

    Within the APTITUDE profiles WP2 SHALL implement and make available all the necessary infrastructure to provide a functional Trust ecosystem as profiled in this specifications.

    Due to the differences between the APTITUDE and the EUDI ecosystem, the following entities will not be represented in the reminder of the section:
    
    - LOTL and TL Scheme Operators;
    - Supervisory Bodies. 

??? warning "Terminology Differences Between ARF and ETSI Specifications"

    Please be aware of some differences between ARF and ETSI specifications terminology. The following table summarizes such differences, as well as the terminology choices for this document:

    | Artifact Name (ARF) | Artifact Name (ETSI) | Artifact Provider (ARF) | Artifact Provider (ETSI) | References | Artifacts Name in this document | Artifact Provider in this document |
    | ------------------- | -------------------- | ----------------------- | ------------------------ | ---------- | ------------------------------- | ---------------------------------- |
    | List of Trusted Entities (LoTE) |  List of Trusted Entities (LoTE) |  List of Trusted Entities (LoTE) Provider | List of Trusted Entities Scheme Operator  (LoTESO) | [ETSI TS 119 602], [ARF, Annex I] | LoTE | List of Trusted Entities (LoTE) Provider |
    | N/A | List of Trusted Lists (LOTL) | N/A | List of Trusted Lists Scheme Operator (LOTLSO) | [ETSI TS 119 615] | LOTL | LOTLSO |
    | Trusted List (TL) | Trusted List (TL) | Trusted List (TL) Provider | Trusted Lists Scheme Operator (TLSO) | [ETSI TS 119 612], [ARF, Annex I] | TL  | Trusted List (TL) Provider |
    | N/A | EUMS TL | N/A | EUMS TLSO | [ETSI TS 119 615] | N/A | N/A |

### Entity Properties Schema

Trust Artifact Providers and End-Entities are characterized by three main classes of *Properties*:

- **Identity Information**: This includes the organization's name, contact information, and organizational policies.
- **Technical Configuration**: This includes the cryptographic materials (<artifacts:Electronic Signature|signature>/<artifacts:Electronic Seal|seal> keys, authentication keys) and technical endpoints necessary for ecosystem interactions.
- **Policy and Authorization Information**: This includes the entity's entitlements, attestation provision capabilities, attestation request capabilities, <roles:Relying Party Intermediary (RPI)|intermediary> use permissions, intended use cases, <artifacts:Embedded Disclosure Policy (EDP)|EDPs>, and compliance with certification schemas.

#### Properties Schema and associated Trust Artifacts

In the tables below are found the relationship between the aforementioned Properties and the Trust Artifacts in which they are contained for specific entity types: <roles:Relying Party (RP)|Relying Party> (<roles:Relying Party Intermediary (RPI)|Intermediary>), <roles:Provider of Person Identification Data (PID Provider)|PID Providers>, <roles:Attestation Provider (AP)|Attestation Providers> (<roles:QEAA Provider|QEAA Providers>, <roles:EAA Provider|EAA Providers>, and <roles:PuB-EAA Provider|Pub-EAA Providers>), and <roles:Wallet Provider (WP)|Wallet Providers>. Since different entity types have their information stored in different artifacts, the tables below are divided by specific types of entities.

All <roles:Wallet-Relying Party (WRP)|WRPs> (<roles:Relying Party (RP)|Relying Parties>, <roles:Relying Party Intermediary (RPI)|Intermediaries>, <roles:Provider of Person Identification Data (PID Provider)|PID Providers>, and <roles:Attestation Provider (AP)|Attestation Providers>) properties are embedded in various Trust Artifacts as follows:

| Entity Type | Properties Class | Entity Properties | Trust Artifacts |
| :--- | :--- | :--- | :--- |
| <roles:Wallet-Relying Party (WRP)\|WRP> | Identity Information | Organization name | <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>, <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>, <components:Register> |
| <roles:Wallet-Relying Party (WRP)\|WRP> | Identity Information | Contact information | <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>, <components:Register> |
| <roles:Wallet-Relying Party (WRP)\|WRP> | Identity Information | Organizational Policy | <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>, <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>, <components:Register> |
| <roles:Wallet-Relying Party (WRP)\|WRP> | Technical Configuration | Authentication key | <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC> |
| <roles:Wallet-Relying Party (WRP)\|WRP> | Authorization Information | Entitlements | <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>, <components:Register> |
| <roles:Wallet-Relying Party (WRP)\|WRP> | Authorization Information | Intermediary use permissions | <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>, <components:Register> |
| <roles:Wallet-Relying Party (WRP)\|WRP> | Authorization Information | Service descriptions | <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>, <components:Register> |
| <roles:Wallet-Relying Party (WRP)\|WRP> | Authorization Information | Supervision information | <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>, <components:Register> |

All <roles:Provider of Person Identification Data (PID Provider)|PID Providers> and <roles:Attestation Provider (AP)|Attestation Providers> have additional specific property requirements embedded in various Trust Artifacts as follows:

| Entity Type | Properties Class | Entity Properties | Trust Artifacts |
| :--- | :--- | :--- | :--- |
| <roles:Provider of Person Identification Data (PID Provider)\|PID Provider> or <roles:Attestation Provider (AP)\|Attestation Provider> | Technical Configuration | <artifacts:Electronic Signature\|Signature>/<artifacts:Electronic Seal\|Seal> key | <artifacts:Electronic Signature\|Signature>/<artifacts:Electronic Seal\|Seal> Certificate |
| <roles:Provider of Person Identification Data (PID Provider)\|PID Provider> or <roles:Attestation Provider (AP)\|Attestation Provider> | Authorization Information | RP Permissions | <artifacts:Embedded Disclosure Policy (EDP)\|EDP> |
| <roles:Provider of Person Identification Data (PID Provider)\|PID Provider> or <roles:Attestation Provider (AP)\|Attestation Provider> | Authorization Information | Attestation provision capabilities | <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>, <components:Register> |

All <roles:Relying Party (RP)|Relying Parties> and <roles:Relying Party Intermediary (RPI)|Intermediaries> have additional specific property requirements embedded in various Trust Artifacts as follows:

| Entity Type | Properties Class | Entity Properties | Trust Artifacts |
| :--- | :--- | :--- | :--- |
| <roles:Relying Party (RP)\|Relying Party> or <roles:Relying Party Intermediary (RPI)\|RPI> | Authorization Information | Attestation request capabilities | <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>, Register |

!!! choice

    Within the APTITUDE profiles, <roles:QEAA Provider|QEAA Providers> and <roles:EAA Provider|EAA Providers> SHALL be included in their respective dedicated <artifacts:List of Trusted Entities (LoTE)|LoTE>. Their LoTE entries SHALL provide the identity, service, and signature/seal <artifacts:Trust Anchor|Trust Anchor> properties used to establish their operational trust. Registration and role-specific authorization properties remain in the <components:Register> and, where applicable, the <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC>.

All <roles:Wallet Provider (WP)|Wallet Providers>, <roles:Provider of Person Identification Data (PID Provider)|PID Providers>,<roles:Attestation Provider (AP)|Attestation Providers>, being referenced in the <artifacts:List of Trusted Entities (LoTE)|LoTE> as entities authorized to provide services to the ecosystem, have additional specific properties embedded in the <artifacts:List of Trusted Entities (LoTE)|LoTE> as follows:

| Entity Type | Properties Class | Entity Properties | Trust Artifacts |
| :--- | :--- | :--- | :--- |
| <roles:Wallet Provider (WP)\|WP>, <roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Attestation Provider (AP)\|Attestation Providers> | Identity Information | Organization name | <artifacts:List of Trusted Entities (LoTE)\|LoTE> |
| <roles:Wallet Provider (WP)\|WP>, <roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Attestation Provider (AP)\|Attestation Providers> | Identity Information | Contact information | <artifacts:List of Trusted Entities (LoTE)\|LoTE> |
| <roles:Wallet Provider (WP)\|WP>, <roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Attestation Provider (AP)\|Attestation Providers> | Identity Information | Organizational Policy | <artifacts:List of Trusted Entities (LoTE)\|LoTE> |
| <roles:Wallet Provider (WP)\|WP>, <roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Attestation Provider (AP)\|Attestation Providers> | Authorization Information | Service descriptions | <artifacts:List of Trusted Entities (LoTE)\|LoTE> |
| <roles:Wallet Provider (WP)\|WP>, <roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Attestation Provider (AP)\|Attestation Providers> | Authorization Information | Service endpoints | <artifacts:List of Trusted Entities (LoTE)\|LoTE> |
| <roles:PuB-EAA Provider\|Pub-EAA Provider> | Authorization Information | Service status | <artifacts:List of Trusted Entities (LoTE)\|LoTE> |
| <roles:Wallet Provider (WP)\|WP>, <roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Attestation Provider (AP)\|Attestation Providers> | Authorization Information | Compliance to certification schema | <artifacts:List of Trusted Entities (LoTE)\|LoTE> (implicit via inclusion) |
| <roles:Wallet Provider (WP)\|WP>, <roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Attestation Provider (AP)\|Attestation Providers> | Technical Configuration | Signature/Seal trust anchors | <artifacts:List of Trusted Entities (LoTE)\|LoTE> |

!!! note

    The inclusion of <roles:Wallet Provider (WP)|Wallet Providers>, <roles:Provider of Person Identification Data (PID Provider)|PID Providers>,<roles:Attestation Provider (AP)|Attestation Providers> in the <artifacts:List of Trusted Entities (LoTE)\|LoTE> is an implicit assertion of their role and authorization within the ecosystem. In particular, their inclusion is a result of the successful completion of the registration and <processes:Notification|notification> procedures as defined in [CIR 2025/848] (registration of <roles:Wallet-Relying Party (WRP)|WRP>) and [CIR 2024/2980] (notifications of <roles:Wallet-Relying Party (WRP)|WRP> and <roles:Wallet Provider (WP)|WP>).

The diagram below highlights the dependences between <roles:Wallet-Relying Party (WRP)|WRP>'s and <roles:Wallet Provider (WP)|WP>'s Properties, the LoTE (diamond shaped boxes) in which these Properties (round shaped boxes) are contained and the Entities (square boxes) that use the Properties' information to issue additional Trust Artifacts.

```mermaid
flowchart LR
    wrp["WRP"]

    subgraph abst["WRP Properties"]
        direction LR
        id(["Identity Information<br>(organization name, contact information, organization policies)"])
        tech(["Technical Configuration<br>(signature/seal key,<br>AuthN key, endpoints)"])
        authz(["Policy and Authorization<br>(entitlements, attestation provision, attestation request, intermediary use, intended use, compliance to certification schema)"])
    end

    subgraph arti["WRP Artifacts"]
        direction LR
        ac{{"WRPAC"}}
        csig{{"Signature/Seal Certificate"}}
        rc{{"WRPRC"}}
    end

    tl{{"LoTE"}}
    reg{{"Register"}}

    ca["Signature/Seal<br>Certificate Authority or QTSP"]
    acca["Provider of WRPAC"]
    rcca["Provider of WRPRC"]
    ent_reg["Registrar"]
    tlp["LoTE Provider"]

    ent_reg --"publishes/manages"--> reg
    wrp --"characterized by"--> abst

    reg --"used by"--> acca
    tech --"used by"--> acca
    acca --"issues/manages"--> ac

    reg --"used by"--> ca
    tech --"used by"--> ca
    ca --"issues/manages"--> csig

    reg -."used by".-> rcca
    rcca --"issues/manages"--> rc

    id --"contained in"--> reg
    authz --"reflected in"--> tl
    authz --"contained in"--> reg
    abst --"used by<br>(when PID/QEAA/EAA/Pub-EAA Provider)"--> tlp
    tlp --"issues/manages"--> tl
    

    wp["Wallet Provider"]

    subgraph abst_wp["WP Properties"]
        direction LR
        id_wp(["Identity Information<br>(organization name, contact information, organization policies)"])
        tech_wp(["Technical Configuration<br>(signature/seal key,<br>endpoints)"])
         authz_wp(["Policy and Authorization<br>(wallet attestation provision, compliance to certification schema)"])
    end

    subgraph arti_wp["WP Artifacts"]
        direction LR
        csig_wp{{"Signature/Seal Certificate"}}
    end
    ca_wp["Signature/Seal<br>Certificate Authority or QTSP"]

    wp --"characterized by"--> abst_wp
    authz_wp --"reflected in"--> tl
    tech_wp --"used by"--> ca_wp
    ca_wp --"issues/manages"--> csig_wp

    abst_wp --"used by"--> tlp
```

In the tables below are found the relationship between the aforementioned Properties and the Trust Artifacts in which they are contained for specific entity types: <roles:Registrar|Registrars>, <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)|Providers of WRPAC>, and <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)|Providers of WRPRC>. Since different entity types have their information stored in different artifacts, the tables below are divided by specific types of entities.

The following table describes the relationship between the Properties of Registrars and Providers of WRPAC/WRPRC and the LoTEs in which these Properties are contained.

| Entity Type | Properties Class | Entity Properties | Trust Artifacts |
| :--- | :--- | :--- | :--- |
| <roles:Registrar>, <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> | Identity Information | Organization name | <artifacts:List of Trusted Entities (LoTE)\|LoTE> |
| <roles:Registrar>, <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> | Identity Information | Contact information | <artifacts:List of Trusted Entities (LoTE)\|LoTE> |
| <roles:Registrar>, <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> | Identity Information | Organizational Policy | <artifacts:List of Trusted Entities (LoTE)\|LoTE> |
| <roles:Registrar>, <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> | Authorization Information | Service descriptions | <artifacts:List of Trusted Entities (LoTE)\|LoTE> |
| <roles:Registrar>, <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> | Authorization Information | Service endpoints | <artifacts:List of Trusted Entities (LoTE)\|LoTE> |
| <roles:Registrar>, <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> | Technical Configuration | <artifacts:Electronic Signature\|Signature>/<artifacts:Electronic Seal\|Seal> key | <artifacts:Electronic Signature\|Signature>/<artifacts:Electronic Seal\|Seal> Certificate |
| <roles:Registrar>, <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> | Technical Configuration | <artifacts:Electronic Signature\|Signature>/<artifacts:Electronic Seal\|Seal> <artifacts:Trust Anchor> | <artifacts:List of Trusted Entities (LoTE)\|LoTE> |

The diagram below highlights these dependences between Trust Artifact Provider Properties, artifacts in which these Properties are contained and entities that use this information to issue/publish Trust Artifacts:

```mermaid
flowchart LR
    mid_ent["Trust Artifact Provider<br>(Registrar, Provider of WRPAC/WRPRC)"]

    subgraph abst["Entity Properties"]
        direction LR
        id(["Identity Information<br>(organization name, contact information, organization policies)"])
        tech(["Technical Configuration<br>(signature/seal key,<br> endpoints)"])
        authz(["Policy and Authorization<br>(compliance to certification schema)"])
    end

    subgraph arti["Entity Artifacts"]
        direction LR
        csig{{"Signature/Seal Certificate"}}
    end

    ms["Member State, European Commission"]

    tl{{"LoTE"}}

    ca["Signature/Seal<br>Certificate Authority"]
    tlp["LoTE Provider"]

    mid_ent --"characterized by"--> abst

    id --"used by"--> ca
    tech --"used by"--> ca
    ca --"issues/manages"--> csig

    abst --"used by"--> tlp
    tlp --"publishes/maintains"--> tl

    ms --"defines"--> authz
    authz --"is reflected in"--> tl
```

### Abstract State Machine

This section describes the lifecycle *State* of <roles:Wallet-Relying Party (WRP)|WRPs> and <roles:Wallet Provider (WP)|WPs>, as well as Trust Artifacts and LoTEs.

!!! choice

    Within the APTITUDE profiles, WRPs and Wallet Solutions SHALL NOT have the `SUSPENDED` state.

#### Entity Lifecycle State Machine

State Machines are described only for <roles:Wallet-Relying Party (WRP)|WRPs>, <roles:Wallet Provider (WP)|WPs>, and the APTITUDE-profiled Trust Artifact Providers (Registrars and Providers of WRPAC/WRPRC). Their status is determined through Trust Artifacts or applicable LoTE entries. <roles:Wallet-Relying Party (WRP)|WRPs>, <roles:Wallet Provider (WP)|WPs>, and APTITUDE-profiled Trust Artifact Providers participating in the APTITUDE Trust Framework are classified into one of the following mutually exclusive lifecycle States at any given time. The State dictates the entity's authorization level, operational capabilities, and how other participants SHALL interact with its cryptographic artifacts.

- `UNREGISTERED`: Indicates that an entity does not currently hold a valid subscription or registration within the APTITUDE Trust Framework. This is the default baseline state. Entities in this state are outside the trust boundary and SHALL NOT participate in framework operations or federation protocols.
- `REGISTERED`: Indicates that an entity has successfully completed the onboarding process, verified its identity, and has established ecosystem access.
    - A <roles:Wallet-Relying Party (WRP)|WRP> is in `REGISTERED` state if the <roles:Registrar> has inserted its Identity information within the <components:Register>, and possesses the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> binding this Identity information to a key controlled by the entity.
    - A <roles:Wallet Provider (WP)|Wallet Provider> is in `REGISTERED` when it has completed the necessary certification and successfully completed the onboarding process.
- `OPERATIONAL`: Indicates that an entity has successfully completed onboarding, and, crucially, has been authorized to perform role-related operations, provide services, and issue or verify artifacts in accordance with framework policies.
    - A <roles:Relying Party (RP)|RP> or <roles:Relying Party Intermediary (RPI)|RPI> is in `OPERATIONAL` state if it is `REGISTERED`, the <roles:Registrar> has inserted its Authorization information within the <components:Register>, and it possesses a valid <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC>.
    - A <roles:Provider of Person Identification Data (PID Provider)|PID Provider> or <roles:Attestation Provider|Attestation Provider> is in `OPERATIONAL` state if it is `REGISTERED`, the <roles:Registrar> has inserted its Authorization information within the <components:Register>, it is listed in the applicable LoTE, it possesses a valid <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC>, and a valid <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> certificate.
    - A <roles:Wallet Provider (WP)|Wallet Provider> or Trust Artifact Provider is in the `OPERATIONAL` state if it is `REGISTERED`, listed in the applicable LoTE, and possesses a valid <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> certificate.
- `REMOVED`: Indicates the revocation of an entity's `REGISTERED` status due to voluntary offboarding, a severe security breach, or a critical compliance failure.
    - A <roles:Wallet-Relying Party (WRP)|WRP> is in `REMOVED` state if the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> is `revoked` or its applicable LoTE entry is removed or no longer active.
    - A <roles:Wallet Provider (WP)|Wallet Provider> or Trust Artifact Provider is in `REMOVED` state when it is not listed in the latest version of the applicable LoTE.
    - **Forward Operations**: Ecosystem participants SHALL reject new interactions or transactions initiated by a `REMOVED` entity, and all cryptographic keys, active attestations, and operational capabilities associated with the entity SHALL be immediately revoked.
    - **Historical Operations**: Ecosystem participants MAY continue to validate historical data, signatures, and attestations generated prior to the Removal timestamp, subject to local risk policies.

!!! choice

    Within the APTITUDE profiles, the following historical-information rules SHALL apply:

    - For <roles:Provider of Person Identification Data (PID Provider)|PID Providers>, <roles:QEAA Provider|QEAA Providers>, <roles:EAA Provider|EAA Providers>, <roles:Wallet Provider (WP)|Wallet Providers>, Providers of <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> and <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC>, and <roles:Registrar|Registrars> and <components:Register|Registers> LoTEs, historical information, including historical keys and service states, SHALL NOT be retained in the current LoTE or its `ServiceHistory`. QEAA and EAA Provider LoTEs SHALL follow the PID Provider LoTE structure and management for this purpose. Previous states SHALL instead be archived as previous LoTE instances and made available through `SchemeInformationURI`.
    - For <roles:PuB-EAA Provider|Pub-EAA Providers> LoTEs, withdrawn services and their certificates SHALL be retained in `ServiceHistory`. `HistoricalInformationPeriod` SHALL be `65535`; `ServiceStatus` SHALL use `notified` or `withdrawn`; and `StatusStartingTime` SHALL record when the status applies.

Below the state diagram of the various actors.

```mermaid
stateDiagram-v2
    %% Define states
    [*] --> Unreg
    
    state "UNREGISTERED" as Unreg
    state "REGISTERED" as Reg
    state "OPERATIONAL" as Op
    state "REMOVED" as Withdrawn
    
    %% Define transitions
    Unreg --> Reg : Onboarding & Identity Verification<br>(WRPAC Issued & Register Inclusion)
    
    Reg --> Op : Authorization Granted<br>(Signature/Seal Issued & listed in LoTE)
    
    Op --> Reg : Authorization Lost<br>(e.g., Signature Certificate Expired or LoTE Entry Removed/Inactive)
    
    Reg --> Withdrawn : Registration Revoked<br>(WRPAC Revoked, Exclusion from Register)
    
    Op --> Withdrawn : Critical Failure / Offboarding<br>(WRPAC, Signature/Seal Cert. Revoked, & Removed from LoTE)
    
    Withdrawn --> [*] : Terminal State
    
    %% Add descriptive notes
    note right of Unreg
        Baseline state. 
        Outside the trust boundary.
    end note
    
    note right of Reg
        Identity established. 
        Ecosystem access granted.
    end note
    
    note right of Op
        Fully authorized. 
        Can issue/verify artifacts.
    end note
    
    note right of Withdrawn
        Forward operations rejected. 
        Historical operations may be validated.
    end note
```

The table below summarizes the lifecycle states, their definitions, the entity to which it refers, the Trust Artifacts that assert the entity's state, and the technical mean that conveys the validity of the Trust Artifacts.

| State | Definition | Applicable Entities | Asserting Trust Artifacts | Technical Mean |
| :--- | :--- | :--- | :--- | :--- |
| `UNREGISTERED` | Indicates that an entity does not currently hold a valid subscription or registration within the APTITUDE Trust Framework. | All potential ecosystem participants prior to onboarding. | N/A | N/A |
| `REGISTERED` | Indicates that an entity has successfully completed onboarding, verified its identity, and established baseline ecosystem network access. | All <roles:Wallet-Relying Party (WRP)\|WRPs>, <roles:Wallet Provider (WP)\|Wallet Providers>. | <roles:Wallet-Relying Party (WRP)\|WRP>: Valid <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC> and identity inclusion in the <components:Register>.<br><br><roles:Wallet Provider (WP)\|Wallet Provider>: Finalized onboarding records. | <roles:Wallet-Relying Party (WRP)\|WRP>: <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> response with good status (or absence in CRL) for the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>; active status in the <components:Register>.|
| `OPERATIONAL` | Indicates that an entity is explicitly authorized to perform role-related operations, provide services, and issue or verify artifacts. | `REGISTERED` <roles:Wallet-Relying Party (WRP)\|WRPs> and <roles:Wallet Provider (WP)\|Wallet Providers>. | **<roles:Relying Party (RP)\|RP> (<roles:Relying Party Intermediary (RPI)\|Intermediary>)**: Authorization in <components:Register>, <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>.<br><br>**<roles:Provider of Person Identification Data (PID Provider)\|PID Provider> / <roles:Attestation Provider\|Attestation Provider>**: Valid <artifacts:Electronic Signature\|Signature>/<artifacts:Electronic Seal\|Seal> certificate, entry in the applicable LoTE, active LoTE status where applicable, authorization in <components:Register>, and <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>.<br><br>**<roles:Wallet Provider (WP)\|Wallet Provider>**: Valid <artifacts:Electronic Signature\|Signature>/<artifacts:Electronic Seal\|Seal> certificate and entry in the applicable LoTE. | **Certificates**: <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> response with `good` status or absence in <artifacts:Certificate Revocation List (CRL)\|CRL> for <artifacts:Electronic Signature\|Signature>/<artifacts:Electronic Seal\|Seal> certificates and WRPACs; <artifacts:Status List Token> with status set to `0x00`.<br><br>**<artifacts:List of Trusted Entities (LoTE)\|LoTE>**: Entry matching the entity.<br><br>**<components:Register>**: Validated role-specific authorization schema Properties. |
| `REMOVED` | Indicates the revocation of an entity's `REGISTERED` status due to voluntary offboarding, a severe security breach, or a critical compliance failure. | All deactivated, offboarded, or permanently banned framework participants. | **<roles:Wallet-Relying Party (WRP)\|WRP>**: Revoked <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>, removal from, or inactive status in, the applicable <artifacts:List of Trusted Entities (LoTE)\|LoTE> (if applicable), and <components:Register> entry.<br><br><roles:Wallet Provider (WP)\|Wallet Provider>: Removal from, or inactive status in, the current applicable <artifacts:List of Trusted Entities (LoTE)\|LoTE>. | <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> response with `revoked` status or presence in a <artifacts:Certificate Revocation List (CRL)\|CRL> for the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>.|

Depending on the circumstances, an entity in the `REMOVED` state MAY have its <artifacts:Electronic Signature\|Signature>/<artifacts:Electronic Seal\|Seal> certificates revoked, when this is not the case, all artifacts the entity has issued SHALL be considered valid for historical operations. Further details on this are found in the [Operational Effects of Removal](#operational-effects-of-removal) section.

#### Trust Artifacts and LoTE Lifecycle State Machine

State Machines for Trust Artifacts and LoTEs are described below:

- For <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>, <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> and <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> Certificates, the lifecycle states are `VALID` and `REVOKED`. The transition from `VALID` to `REVOKED` is triggered by the revocation of the artifact, which can be initiated by the corresponding Trust Artifact Provider due to various reasons such as key compromise, organizational changes, or non-compliance with framework policies. Once an artifact is in the `REVOKED` state, it SHALL NOT be trusted for any operational use within the ecosystem, and any entity relying on it SHALL reject it for authentication, authorization, or any other trust-related operations.
    - A <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> in `VALID` state SHALL NOT be present in the designated <artifacts:Certificate Revocation List (CRL)|CRL> and/or SHALL return a `good` status in the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> response. A WRPAC in `REVOKED` state SHALL be present in the designated <artifacts:Certificate Revocation List (CRL)|CRL> and/or SHALL return a `revoked` status in the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> response.
    - A <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> in `VALID` state SHALL return a `0x00` status in the corresponding <artifacts:Status List Token>. A <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> in `REVOKED` state SHALL have status value `0x01` within the corresponding <artifacts:Status List Token>.
- For <artifacts:List of Trusted Entities (LoTE)|LoTE>s, the lifecycle states are `CURRENT` and `HISTORICAL`. The transition from `CURRENT` to `HISTORICAL` is triggered by the publication of a new LoTE version that replaces the previous version. Once a LoTE or its historical service data is in the `HISTORICAL` state, it SHALL NOT be used for operational trust decisions. Historical operations SHALL be resolved through `ServiceHistory` for Pub-EAA LoTEs and through archived previous LoTE instances referenced by `SchemeInformationURI` for the other LoTE types; LoTE trustworthiness SHALL be validated through authenticated pivoting (see [Trust Anchor Validation Process](../sections/trust-evaluation-process.md#trust-anchor-validation-process)).
- For <components:Register|Registers>, <artifacts:Embedded Disclosure Policy (EDP)|EDPs>, Status Lists, the lifecycle state is only `CURRENT`, since any change in these artifacts is reflected as an update of the artifact itself, and the previous version is not retained as a historical record.

The diagram below highlights the state machine of the aforementioned artifacts:

```mermaid
stateDiagram-v2
    %% Define Layout Orientation
    direction TB

    %% 1. Certificates Lifecycle Group
    state "Certificates (WRPAC, WRPRC, Signature/Seal)" as CertGroup {
        [*] --> VALID : Issuance / Provisioning
        VALID --> REVOKED : Revocation Trigger<br>(CRL, OCSP, or Status List)
        REVOKED --> [*] : Terminal State
    }

    %% 2. LoTE Lifecycle Group
    state "LoTEs" as LoTEGroup {
        [*] --> LoTE_CURRENT : Publication of Current Version
        state "CURRENT" as LoTE_CURRENT
        
        LoTE_CURRENT --> HISTORICAL : Superseded by New Version<br> ServiceHistory for Pub-EAA,<br>archived LoTE otherwise
        HISTORICAL --> [*]
    }

    %% 3. Registers, EDP, and Status Lists Lifecycle Group
    state "Registers, EDP, and Status Lists" as RegGroup {
        [*] --> REG_CURRENT : Initial Publication
        state "CURRENT" as REG_CURRENT
        
        REG_CURRENT --> REG_CURRENT : In-place Content Mutation<br>(No History Retained)
    }
```

The table below summarizes the lifecycle states, their definitions, the applicable Trust Artifacts and LoTEs, and the technical mean that conveys the validity of these artifacts. The three tables are divided by artifact type since they have different lifecycle states and transition triggers, these are respectively: `VALID` and `REVOKED` for <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>, <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> and <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> Certificates, `CURRENT` and `HISTORICAL` for LoTEs, and only `CURRENT` for <components:Register|Registers>, <artifacts:Embedded Disclosure Policy (EDP)|EDPs> and Status Lists.

| State | Definition | Applicable Artifacts | Technical Mean |
| :--- | :--- | :--- | :--- |
| `VALID` | Indicates that a Trust Artifact is currently valid and can be trusted for operational use within the ecosystem. | <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>, <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>, <artifacts:Electronic Signature\|Signature>/<artifacts:Electronic Seal\|Seal> Certificates. | <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> response with `good` status or absence in <artifacts:Certificate Revocation List (CRL)\|CRL> for <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPACs> and <artifacts:Electronic Signature\|Signature>/<artifacts:Electronic Seal\|Seal> certificates; <artifacts:Status List Token> with status set to `0x00` for <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRCs>. |
| `REVOKED` | Indicates that a Trust Artifact has been revoked and SHALL NOT be trusted for any operational use within the ecosystem. | <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>, <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>, <artifacts:Electronic Signature\|Signature>/<artifacts:Electronic Seal\|Seal> Certificates. | <protocols:Online Certificate Status Protocol (OCSP)\|OCSP> response with `revoked` status or presence in <artifacts:Certificate Revocation List (CRL)\|CRL> for <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPACs> and <artifacts:Electronic Signature\|Signature>/<artifacts:Electronic Seal\|Seal> certificates; <artifacts:Status List Token> with status set to `0x01` for <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRCs>. |

| State | Definition | Applicable Artifacts | Technical Mean |
| :--- | :--- | :--- | :--- |
| `CURRENT` | Indicates that the current LoTE is the newest version, and previous versions are no longer valid for operational use within the ecosystem. | <artifacts:List of Trusted Entities (LoTE)\|LoTE>. | Publication of a new LoTE version; authenticated pivoting for LoTE trustworthiness; retention of withdrawn service history in `ServiceHistory` for Pub-EAA LoTEs; archival of previous LoTE instances through `SchemeInformationURI` for the other LoTE types. |
| `HISTORICAL` | Indicates that a LoTE or its service history is a historical record and SHALL NOT be used for operational trust decisions, except for validating historical operations and LoTE trustworthiness via the applicable history mechanism. | <artifacts:List of Trusted Entities (LoTE)\|LoTE>. | For Pub-EAA LoTEs, resolution through `ServiceHistory`; for the other LoTE types, retrieval of archived previous LoTE instances through `SchemeInformationURI`; validation of LoTE trustworthiness via authenticated pivoting. |

| State | Definition | Applicable Artifacts | Technical Mean |
| :--- | :--- | :--- | :--- |
| `CURRENT` | Indicates that the current version of a Register, <artifacts:Embedded Disclosure Policy (EDP)\|EDP>, or Status List has the newest information, previous versions are no longer valid, SHOULD NOT be published and SHALL NOT be used for operational use within the ecosystem. | <components:Register\|Registers>, <artifacts:Embedded Disclosure Policy (EDP)\|EDPs>, Status Lists. | Publication of an updated version of the artifact. |

### Entity Lifecycle Operations

The following are the operational procedures that affect the Properties of APTITUDE Trust Artifact Providers and End-Entities, and the resulting effects on their State.

#### Onboarding Process

The onboarding process governs the transition of an End-Entity (<roles:Wallet-Relying Party (WRP)|WRP> or <roles:Wallet Provider (WP)|Wallet Provider>) from the `UNREGISTERED` state to the `REGISTERED` state. This includes <roles:Attestation Provider (AP)|Attestation Providers>. During onboarding, the entities running the process collect and validate the onboardee's Properties and, depending on its role, issue the corresponding Trust Artifacts.

#### Active Operations and Maintenance

While in the `OPERATIONAL` state, entities MAY require *organizational updates* to their registered Properties, including their entity profiles, cryptographic materials, or operational parameters. Below we describe these updates and their operational effects on the Trust Artifacts, applicable LoTE, and the entity's state.

##### Organizational Updates

As their organizational or regulatory circumstances evolve, <roles:Wallet-Relying Party (WRP)|WRPs> and <roles:Wallet Provider (WP)|Wallet Providers> SHALL update identity, authorization information and technical configurations accordingly through the APTITUDE Onboarding system. Identity and cryptographic updates SHALL follow standard framework governance processes and SHOULD NOT affect the underlying technical operations of the Trust Framework. In particular, updates that directly affect federation protocol operations or cryptographic trust boundaries require strictly coordinated procedures.

##### Operational Effects of Organizational Updates

When there are organizational updates, the Trust Framework infrastructure SHALL propagate these changes to the relevant Trust Artifacts and, where applicable, to the entity's dedicated LoTE. The specific operational effects depend on the entity's role and the artifacts it utilizes.

**<roles:Wallet-Relying Party (WRP)|WRP> Updates**: For a <roles:Wallet-Relying Party (WRP)|WRP> updating its Identity Information, Technical Configurations, and/or Policies and Authorizations, the update SHALL trigger the following procedures:

- **Identity Information and Policies and Authorizations Updates**:
    - **Registry Update**: the <roles:Wallet-Relying Party (WRP)|WRP> SHALL update its information within the <components:Register> via the authenticated API.
    - **<artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> Revocation**: The <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC> SHALL revoke the entity's current <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>. Revocation SHALL be executed by appending the certificate's serial number to the active <artifacts:Certificate Revocation List (CRL)|CRL> or by returning a `revoked` status in the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> response.
    - **<artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> Re-issuance**: The <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC> SHALL issue a new <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> with the updated data.
    - **<artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> Revocation**: The <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)|Provider of WRPRC> SHALL revoke the entity's current <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> if present. Revocation SHALL be executed by setting the status value of the <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> within the corresponding <artifacts:Status List Token> to `0x01`.
    - **<artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> Re-issuance**: The <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)|Provider of WRPRC> SHALL issue a new <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> with the updated data if required.
    - **<artifacts:List of Trusted Entities (LoTE)|LoTE> Update** [only for <roles:Provider of Person Identification Data (PID Provider)|PID Providers>,<roles:Attestation Provider (AP)|Attestation Providers>]: the provider SHALL notify the <roles:List of Trusted Entities Provider (LoTE Provider)|LoTE Provider>, which SHALL publish a new version of the provider's dedicated LoTE with the updated `TrustedEntityInformation` and/or `ServiceInformation` components using the pivoting mechanism.
- **Technical Configurations Updates**:
    - **<artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> Key update**: the <roles:Wallet-Relying Party (WRP)|WRP> SHALL notify <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> Key updates to the <roles:Certificate Authority (CA)|Certificate Authority> responsible for the issuance of these certificates.
        - **<artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> Certificate Revocation**: The <roles:Certificate Authority (CA)|Certificate Authority> SHALL revoke the entity's current <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> certificate.
        - **<artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> Certificate Re-issuance**: The <roles:Certificate Authority (CA)|Certificate Authority> SHALL issue a new <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> certificate with the updated key.
        - **<artifacts:List of Trusted Entities (LoTE)|LoTE> Update** [for a certificate used as a LoTE <artifacts:Trust Anchor>]: Upon obtaining a new <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> certificate with the updated key, an entity listed in a dedicated LoTE SHALL notify the <roles:List of Trusted Entities Provider (LoTE Provider)|LoTE Provider>, which SHALL publish a new version of that LoTE with the updated `ServiceInformation` component using the pivoting mechanism.
    - **Authentication Key update**: The <roles:Wallet-Relying Party (WRP)|WRP> SHALL notify <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> Key updates to the <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC>.
        - **<artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> Revocation**: The <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC> SHALL revoke the entity's current <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>. Revocation SHALL be executed by appending the certificate's serial number to the active <artifacts:Certificate Revocation List (CRL)|CRL> or by returning a `revoked` status in the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> response.
        - **<artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> Re-issuance**: The <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC> SHALL issue a new <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> with the updated key.

**<roles:Wallet Provider (WP)|Wallet Providers> and Trust Artifact Provider Updates**: For <roles:Wallet Provider (WP)|Wallet Providers>, <roles:Registrar|Registrars>, <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)|Providers of WRPAC>, or <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)|Providers of WRPRC> updating their Identity Information and/or Technical Configurations, the update SHALL trigger the following procedures:

- **Identity Information Updates**:
    - **<artifacts:List of Trusted Entities (LoTE)|LoTE> Update**: the entity SHALL notify the <roles:List of Trusted Entities Provider (LoTE Provider)|LoTE Provider>, which SHALL publish a new version of the entity's applicable LoTE with the updated `TrustedEntityInformation` and/or `ServiceInformation` components using the pivoting mechanism.
- **Technical Configurations Updates**:
    - **<artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> Key update**: the entity SHALL notify the <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> Key updates to the <roles:Certificate Authority (CA)|Certificate Authority> responsible for the issuance of these certificates.
        - **<artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> Certificate Revocation**: The <roles:Certificate Authority (CA)|Certificate Authority> SHALL revoke the entity's current <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> certificate.
        - **<artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> Certificate Re-issuance**: The <roles:Certificate Authority (CA)|Certificate Authority> SHALL issue a new <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> certificate with the updated key.
        - **<artifacts:List of Trusted Entities (LoTE)|LoTE> Update** [for a certificate used as a LoTE <artifacts:Trust Anchor>]: Upon obtaining a new <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> certificate with the updated key, the entity SHALL notify the <roles:List of Trusted Entities Provider (LoTE Provider)|LoTE Provider>, which SHALL publish a new version of the applicable LoTE with the updated `ServiceInformation` component using the pivoting mechanism.
    - **Endpoints Update**: When an endpoint published in an applicable LoTE is updated, the entity SHALL notify the <roles:List of Trusted Entities Provider (LoTE Provider)|LoTE Provider>, which SHALL publish a new version of that LoTE with the updated `ServiceInformation` component using the pivoting mechanism.

#### Removal Process

The Removal process defines the rapid-response workflows and administrative procedures executed to transition an entity from the `OPERATIONAL` state to the `REMOVED` state. This transition MAY be initiated voluntarily by the entity.

##### Triggers for Removal

Removal events are categorized based on their initiation source:

- Voluntary Exit: Organizations MAY choose to exit the federation for standard business or operational reasons. Permitted reasons include:
    - Business Changes: Organizational restructuring, mergers, acquisitions, or complete service discontinuation.

##### Operational Effects of Removal

When an entity transitions to the `REMOVED` state, the relevant APTITUDE Trust Artifact Providers and LoTE Providers SHALL immediately execute the necessary operations to halt the entity's operations while preserving historical evidence. The specific operational effects depend on the entity's role and the artifacts it utilizes.

**<roles:Wallet-Relying Party (WRP)|WRP> Withdrawal or Removal**: For <roles:Wallet-Relying Party (WRP)|WRP> withdrawing or being removed from the Trust Framework following security incidents or policy violations, the removal event SHALL trigger the following procedures:

- **Registry Update**: the <roles:Wallet-Relying Party (WRP)|WRP> or <roles:Supervisory Body> MAY remove the <roles:Wallet-Relying Party (WRP)|WRP> information within the <components:Register>.
- **<artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> Revocation**: The <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC> SHALL revoke the entity's current <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>. Revocation SHALL be executed by appending the certificate's serial number to the active <artifacts:Certificate Revocation List (CRL)|CRL> or by returning a `revoked` status in the <protocols:Online Certificate Status Protocol (OCSP)|OCSP> response.
- **<artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> Revocation**: The <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)|Provider of WRPRC> SHALL revoke the entity's current <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> if present. Revocation SHALL be executed by setting the status value of the <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> within the corresponding <artifacts:Status List Token> to `0x01`.
- **<artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> Certificate Revocation**: The <roles:Certificate Authority (CA)|Certificate Authority> SHALL revoke the entity's current <artifacts:Electronic Signature|Signature>/<artifacts:Electronic Seal|Seal> certificate.
- **<artifacts:List of Trusted Entities (LoTE)|LoTE> Update** [for a LoTE-listed <roles:Provider of Person Identification Data (PID Provider)|PID Provider>, <roles:QEAA Provider|QEAA Provider>, <roles:EAA Provider|EAA Provider>, or <roles:PuB-EAA Provider|Pub-EAA Provider>]: the <roles:Wallet-Relying Party (WRP)|WRP> SHALL notify the <roles:List of Trusted Entities Provider (LoTE Provider)|LoTE Provider>, which SHALL publish a new version of the applicable LoTE using the pivoting mechanism.    
    - For a <roles:PuB-EAA Provider|Pub-EAA Provider>, the applicable LoTE SHALL set `ServiceStatus` to `withdrawn`, set `StatusStartingTime` to the time at which the withdrawn status takes effect, and SHALL retain the withdrawn service and its certificates in `ServiceHistory`. 
    - For the PID, QEAA, and EAA Provider LoTEs, the entity SHALL be removed from the current LoTE; historical keys and service states SHALL NOT be retained in `ServiceHistory` and SHALL instead be available from the archived previous LoTE instances referenced by `SchemeInformationURI`.

**<roles:Wallet Provider (WP)|Wallet Providers> and Trust Artifact Provider Withdrawal or Removal**: For <roles:Wallet Provider (WP)|Wallet Providers>, <roles:Registrar|Registrars>, <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)|Providers of WRPAC>, or <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)|Providers of WRPRC>, the removal event SHALL trigger the following procedures:

- **<artifacts:List of Trusted Entities (LoTE)|LoTE> Update**: the Trust Artifact Provider SHALL notify the <roles:List of Trusted Entities Provider (LoTE Provider)|LoTE Provider>, which SHALL publish a new version of the applicable LoTE using the pivoting mechanism and remove the entity from the current LoTE. Historical keys and service states SHALL NOT be retained in `ServiceHistory`; the archived previous LoTE instance SHALL be made available through `SchemeInformationURI`.
