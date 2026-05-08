
This section specifies the Trust Management Lifecycle for entities participating in the Trust Framework. It defines the operational states, state transitions, and the specific events that trigger these transitions for subscribed entities. 

The scope of this process encompasses the complete lifecycle of an entity, from initial onboarding and active operational maintenance to temporary or permanent withdrawal from the framework. 

By detailing the operational effects on trust artifacts—such as the List of Trusted Entities (LoTE), the EU Member State Trusted List (EUMS TL), and Wallet Relying Party certificates (WRPAC/WRPRC)—this specification details the practices that undergo various entities subscribing to the Trust Framework.

## Trust Management High Level picture

Entities participating in the EUDI Trust Framework MUST be classified into one of the following mutually exclusive lifecycle states at any given time. The state dictates the entity's authorization level, operational capabilities, and how other participants MUST interact with its cryptographic artifacts.

- `UNREGISTERED`: Indicates that an entity does not currently hold a valid subscription or registration within the EUDI Trust Framework. This is the default baseline state. Entities in this state are outside the trust boundary and MUST NOT participate in framework operations or federation protocols.
- `ACTIVE`: Indicates that an entity has successfully completed the onboarding process, verified its identity, and is fully registered within the EUDI Trust Framework. An entity in the ACTIVE state is authorized to perform role-related operations, provide services, and issue or verify trust artifacts in accordance with framework policies.
- `WITHDRAWN`: Indicates the revocation of an entity's operational privileges, enacted either temporarily (e.g., due to a pending investigation or minor security incident) or permanently (e.g., due to voluntary offboarding, a severe security breach, or a critical compliance failure).
  - **Forward Operations**: Ecosystem participants MUST reject new interactions or transactions initiated by a WITHDRAWN entity, and all cryptographic keys, active attestations, and operational capabilities associated with the entity MUST be immediately revoked.
  - **Historical Operations**: Participants MAY continue to validate and trust historical data, signatures, and attestations generated prior to the withdrawal timestamp, subject to local risk policies, UNLESS the severity of a permanent withdrawal event (as defined by the Supervisory Body's revocation broadcast) requires participants to retroactively invalidate historical actions.
  - **Resolution**: If the withdrawal was enacted as a temporary measure, the entity MAY be transitioned back to the ACTIVE state upon successful remediation of the triggering issue. If the withdrawal was permanent, the entity is permanently removed from the Trust Framework.

```mermaid
stateDiagram-v2
    direction LR

    UNREGISTERED --> ACTIVE : Onboarding Process
    ACTIVE --> ACTIVE : Operation Management
    ACTIVE --> WITHDRAWN : Withdrawal
```

## Entity Lifecycle Operations

### Onboarding Process

The onboarding process governs the transition of an entity from the `UNREGISTERED` state to the `ACTIVE` state. Upon the successful completion of the onboarding process, the following trust artifacts and records SHALL be generated or updated:

- **Registry Update**: The entity's authoritative record is committed to the Register database.
- **Trust Anchor Inclusion**: If applicable to the entity's role, its signature key trust chain Trust Anchor (TA) SHALL be included in the List of Trusted Entities (LoTE) or the European Union Member State Trusted List (EUMS TL).
- **WRPAC Issuance**: A WRPAC SHALL be issued to the entity.
- **WRPRC Issuance**:A WRPRC MAY be issued to the entity, depending on its role and authorization profile.

The specific operational effects and artifact configurations resulting from successful onboarding depend on the entity's classification within the Trust Framework ecosystem:

#### Onboarding Effects on Entities

PID Providers, Attestation Providers (AP), Relying Parties (RP), and Wallet Providers (WP) SHALL successfully complete all registration and notification processes as specified in Commission Implementing Regulations (EU) 2025/848 and (EU) 2024/2980 prior to onboarding completion.

Upon successful onboarding, a these entities SHALL:
- have its attestation key or wallet solution key trust anchors registered in the corresponding LoTE `TrustedEntityServices.ServiceInformation.ServiceDigitalIdentity` component;
- be registered in the Register by the MS Registrar;
- obtain a valid WRPAC from the Provider of WRPAC; 
- [OPTIONAL] obtain a valid WRPRC from the Provider of WRPAC; 
- finalize the deployment of its issuance, presentation toolkit or wallet solution depending on the role.

Registrars and Providers of WRPACs/WRPRCs, SHALL be explicitly listed in the appropriate LoTE with the respective trust anchor certificates upon successful onboarding. This listing formally enables trust checks on their core framework functions, such as responding to Register queries and issuing WRPACs and WRPRCs.

QTSPs SHALL be explicitly listed in the appropriate EUMS TL with the respective trust anchor certificates upon successful onboarding. This listing formally enables trust checks on the QTSP-issued Qualified Electronic Seals and\or Qualified Signature certificates.

To assert the entity's `ACTIVE` status, the trust framework infrastructure SHALL apply the following technical configurations.
- **LoTE Status**: the `TrustedEntityServices.ServiceInformation.ServiceStatus` component of the LoTE corresponding to the registered trust anchor key in the `TrustedEntityServices.ServiceInformation.ServiceDigitalIdentity` SHALL be set to the URI `http://uri.aptitude.org/TrstSvc/TrustedList/Svcstatus/granted`.
- **TL Status**:  the `TrustServiceProviderInformation.ServiceInformation.ServiceStatus` component of the LoTE corresponding to the registered trust anchor key in the `TrustServiceProviderInformation.ServiceInformation.ServiceDigitalIdentity` SHALL be set to the URI `http://uri.etsi.org/TrstSvc/TrustedList/Svcstatus/granted` ([ETSI TS 119 612] clause 5.5.4)
- **OCSP Status**: the validation status of the newly issued WRPAC in an Online Certificate Status Protocol (OCSP) response SHALL be returned as `good`.
- **CRL Status**: the serial number of the WRPAC SHALL NOT be present in the active CRL.
- **Token Status**: if a WRPRC is issued, its status value within the Status List Token SHALL be initialized to `0x00`.

### Active Operations and Maintenance

While in the `ACTIVE` state, entities MAY require updates to their registered profiles, cryptographic materials, or operational parameters. To ensure ecosystem stability and continuous non-repudiation, the Trust Framework categorizes these modifications into *Identity Information Updates*, *Technical Configuration Management* and *Policy and Authorization Updates*, each with distinct operational effects.

#### Organizational Updates

As their organizational or regulatory circumstances evolve, organizations SHALL update authentication, authorization and cryptographic information accordingly through standard Registrar channels as defined at MS level. Identity and cryptographic updates SHALL follow standard framework governance processes and SHOULD NOT affect the underlying technical operations of the trust framework. In particular, updates that directly affect federation protocol operations or cryptographic trust boundaries require strictly coordinated procedures. These technical updates SHALL be validated by the designated MS authority or Supervisory Body prior to deployment to maintain trust relationships and ecosystem operational integrity.

Permitted authentication, authorization and cryptographic updates encompass the following categories:

- Legal Entity Changes: Modifications to the company name, organizational restructuring, or changes in legal status.
- Contact Information: Updates to official communication channels, address details, and designated responsible personnel.
- Regulatory Status: Changes in active licenses, security certifications, or overall regulatory compliance status.
- Service Scope: Modifications to business logic, service offerings, user base characteristics, or the specific types of attributes the entity is authorized to issue.
- WRPAC Management: entity cryptographic key rotations, regular certificate renewals, identity information, and revocation handling.
- Infrastructure Changes: Updates to endpoint URIs, service migrations, and capacity modifications.
- Compliance Updates: Migrations to new cryptographic suites, security standard updates, policy alterations, and audit requirement fulfillment.
- Policy Modifications: The addition or removal of functional service features, EDP.
- WRPRC Updates: entitlements, policy attributes, Service Provider or Attestation Provider capabilities, entitlements. 

#### Governance Update

As policies, technical standards, and regulatory circumstances evolve at the European Union (EU) or Member State (MS) level, top-down regulatory changes MAY necessitate systemic modifications across the ecosystem. When such regulatory or policy shifts occur, the Trust Framework Supervisory Body SHALL formally notify the entity in charge of applying the new requirements (e.g., MS Registrars, TL Scheme Operators).

These governance updates encapsulate external modifications that an organization does not actively pursue or initiate. Instead, they represent ecosystem-wide evolutions that legally or operationally mandate the entity to modify its associated trust artifacts to maintain compliance. The execution of these updates MUST strictly adhere to established framework governance processes and SHOULD NOT disrupt the underlying technical operations of the EUDI Trust Framework.

Governance updates typically arise from legal, technical, or procedural evolutions at the highest levels of governance. Specific events triggering a governance update include, but are not limited to:
- **Legal Publications**: The issuance of new regulations, implementing acts, or delegated acts in the Official Journal of the European Union (OJEU).
- **Policy Revisions**: Modifications to specific credential guidelines, credential catalogue or attestation rulebooks published by the European Commission.
- **Standardization Updates**: The release of new, or deprecation of old, technical specifications governing ecosystem cryptographic protocols or federation mechanisms.
- **Infrastructure Evolutions**: Structural, schema, or governance updates applied to the List of the Trust Lists (LoTL), the List of Trusted Entities (LoTE), or the EU Member State Trusted List (EUMS TL).

Upon receiving notification of a governance update from the MS Registrar, affected entities MUST initiate the necessary administrative or technical configuration workflows to align their trust artifacts with the new requirements. Depending on the nature of the update, this MAY require the entity to generate new cryptographic keys, update endpoint URIs, or request re-issuance of their WRPRC.

#### Operational Effects of Updates

When there are organizational updates, the Trust Framework infrastructure MUST propagate these changes to the relevant trust artifacts. The specific operational effects depend on the entity's role, and the artifacts it utilizes.

**Trust Anchors Updates**: For entities needing updates on their trust anchor, or information attested in a Trusted List (e.g., Registrars, Providers of WRPACs/WRPRCs, QTSPs, PID Providers, Pub-EAA Providers, and Wallet Providers), the entity responsible for the publication of the LoTE or EUMS TL SHALL publish a new Trusted List where:
- **Updates**: all values in the `TrustedEntityServices.ServiceInformation` (for a LoTE) or `TrustServiceProviderInformation.ServiceInformation` (for a EUMS TL) components have been updated; and
- **LoTE Service Status**: for Registrars, Providers of WRPACs/WRPRCs, PID Providers, Pub-EAA Providers, and Wallet Providers, managed via LoTEs, the `TrustedEntityServices.ServiceInformation.ServiceStatus` component, SHALL be set to the URI `http://uri.aptitude.org/TrstSvc/TrustedList/Svcstatus/granted`.
- **EUMS TL Service Status**: for QTSPs managed via the EUMS TL, the `TrustServiceProviderInformation.ServiceInformation.ServiceStatus` component, SHALL be set to the URI `http://uri.etsi.org/TrstSvc/TrustedList/Svcstatus/granted` (in accordance with ETSI TS 119 612, clause 5.5.4).
- **Historical Information** [UPDATE DEPENDENT]: to maintain non-repudiation for past transactions, the superseded parameters SHALL be retained as historical records within the `TrustedEntityServices.ServiceHistory` and `TrustServiceProviderInformation.ServiceHistory` components, depending on the Trusted List type.

Furthermore, to ensure a continuous chain of trust, the newly published LoTE or EUMS TL SHALL utilize the pivoting mechanism described in Section [Trust Anchor Validation](#trust-anchor-validation). This is achieved by explicitly referencing the previous version of the list within the `SchemeInformationURI` component of the new Trusted List.

**End-entity Updates**: For entities needing update on WRPAC, WRPRC, QSign, or Qseal certificates (e.g., PID Providers, APs, RPs, and WPs), the update event SHALL trigger the following sequential procedure:
- **Registry Update**: The entity's updates SHALL be notified to the Registrar, which SHALL subsequently update the entity's corresponding information in the Register.
- **Notification**: The Registrar SHALL immediately communicate the updated status to the corresponding providers of WRPAC and WRPRC.
- **Certificate Revocation** [UPDATE DEPENDENT]: the WRPAC, WRPRC providers or QTSP SHALL immediately revoke the associated active certificates.
  - **WRPAC Revocation**: revocation SHALL be executed by appending the certificate's serial number to the active CRL or by returning a `revoked` status in the OCSP response.
  - **WRPRC Revocation**: revocation SHALL be executed by setting the status value of the WRPRC within the corresponding Status List token to `0x01`.
  - **QSeal/QSign Revocation**: revocation SHALL be executed by the method chosen by the QTSP which issued the certificate.
- **Certificate Re-issuance** [UPDATE DEPENDENT]: following revocation, the entity updating its data SHALL request the issuance of a new WRPAC, and MAY request issuance of a new WRPRC, containing the updated parameter fields.

### Withdrawal Process
The withdrawal process defines the rapid-response workflows and administrative procedures executed to transition an entity from the `ACTIVE` state to the `WITHDRAWN` state. This transition MAY be initiated voluntarily by the entity or forcefully enacted by the Supervisory Body.

#### Triggers for Withdrawal

Withdrawal events are categorized based on their initiation source:
- Voluntary Exit: Organizations MAY choose to exit the federation for standard business or operational reasons. Permitted reasons include:
  - Business Changes: Organizational restructuring, mergers, acquisitions, or complete service discontinuation.
  - Technical Migration: Transitioning to alternative technical solutions, infrastructure, or service providers outside the framework's scope.
  - Regulatory Changes: Shifts in the local regulatory environment or the entity's inability to meet ongoing compliance requirements.
- Supervisory Body Removal: The Supervisory Body MAY initiate a forced withdrawal due to severe compliance failures, fatal security breaches, or other critical ecosystem threats. Triggers for forced removal include:
- Compliance Violations: Demonstrated failure to maintain regulatory compliance or adherence to federation policies.
- Security Incidents: Suspected or confirmed compromise of the entity's security infrastructure, or a failure to maintain minimum security standards.
- Operational Failures: Persistent technical outages or failures that negatively affect overall ecosystem security or reliability.
- Policy Violations: Documented violations of federation operational policies, terms of service, or participation agreements.

#### Operational Effects of Withdrawal

When an entity is transitioned to the `WITHDRAWN` state, the Trust Framework infrastructure MUST immediately execute a series of cryptographic and registry updates to halt the entity's operations while preserving historical evidence.  The specific operational effects depend on the entity's role, and the artifacts it utilizes.

**Trust Anchor Removal**: For entities whose trust anchor, or information attested in a Trusted List (e.g., Registrars, Providers of WRPACs/WRPRCs, QTSPs, PID Providers, Pub-EAA Providers, and Walle Providers) is being withdrawn, the entity responsible for the publication of the LoTE or EUMS TL SHALL publish a new Trusted List where:
- **LoTE Service Status**: for Registrars, Providers of WRPACs/WRPRCs, PID Providers, Pub-EAA Providers, and Wallet Providers, managed via LoTEs, the `TrustedEntityServices.ServiceInformation.ServiceStatus` component, SHALL be set to the URI `http://uri.aptitude.org/TrstSvc/TrustedList/Svcstatus/withdrawn`.
- **EUMS TL Service Status**: for QTSPs managed via the EUMS TL, the `TrustServiceProviderInformation.ServiceInformation.ServiceStatus` component, SHALL be set to the URI `http://uri.etsi.org/TrstSvc/TrustedList/Svcstatus/withdrawn` (in accordance with ETSI TS 119 612, clause 5.5.4).
- **Historical Information**: to maintain non-repudiation for past transactions, the superseded parameters SHALL be retained as historical records within the `TrustedEntityServices.ServiceHistory` and `TrustServiceProviderInformation.ServiceHistory` components, depending on the Trusted List type.

Furthermore, to ensure a continuous chain of trust, the newly published LoTE or EUMS TL SHALL utilize the pivoting mechanism described in Section [Trust Anchor Validation](#trust-anchor-validation). This is achieved by explicitly referencing the previous version of the list within the `SchemeInformationURI` component of the new Trusted List.

**End-entity Removal**: For entities needing update on WRPAC, WRPRC, QSign, or Qseal certificates (e.g., PID Providers, APs, RPs, and WPs), the removal event SHALL trigger the following sequential procedure:
- **Registry Removal**: The entity's removal SHALL be notified to the Registrar, which SHALL subsequently update the entity's corresponding information in the Register.
- **Notification**: The Registrar SHALL immediately communicate the updated status to the corresponding providers of WRPAC and WRPRC.
- **Certificate Revocation** [UPDATE DEPENDENT]: the WRPAC, WRPRC providers or QTSP SHALL immediately revoke the associated active certificates.
  - **WRPAC Revocation**: revocation SHALL be executed by appending the certificate's serial number to the active CRL or by returning a `revoked` status in the OCSP response.
  - **WRPRC Revocation**: revocation SHALL be executed by setting the status value of the WRPRC within the corresponding Status List token to `0x01`.
  - **QSeal/QSign Revocation**: revocation SHALL be executed by the method chosen by the QTSP which issued the certificate.

!!! note
    
    When executing the revocation on the CRL, the ReasonFlag element MUST accurately reflect the nature of the withdrawal:
    - If the withdrawal is a temporary suspension pending investigation, the ReasonFlag SHALL be set to (6): certificateHold.
    - If the withdrawal is a permanent termination, the ReasonFlag SHALL be set to the appropriate code based on the circumstances, such as (1): keyCompromise, (2): cACompromise, or (5): cessationOfOperation.

### Operational Effects Diagram

The diagram below illustrates the Trust Management operational effects on the Trusted List and End-entity certificates. It is divided into Trust Anchor and End Entity effects as described into the previous sections.

The top side is governed by the Trusted List Provider (TLP).
- At the top is the public key ($pk_{TLP}$) of the Trusted List Provider. This key is used to sign the entire Trusted List.
- The Trusted List container holds a list of Trust Service Providers (TSPs) and their Trust Anchor public key ($pk_{TA}$) certificates.
- Primary Signature ($\sigma_{TLP}$): The transition from the root key to the Trusted List is secured by the $\sigma_{TLP}$ signature, ensuring the integrity of the list itself.
- Trust Anchor updates or removals occur exclusively on this side of the diagram.

The bottom side is governed by the entity which possesses the private key attested in the Trust Anchor public key ($pk_{TA}$) certificates. This entities issues and maintain WRPAC, WRPRC and certificates attesting signing capabilities. End entities updates or removal affect exclusively on this side of the diagram.


```mermaid
stateDiagram-v2
    
    state "pk_{TLP}" as pkTLP
    %% Left Side: Trust Provisioning
    state "TA Update/Removal " as LeftContext {
        
        state "Trusted List" as TL_Box {
            direction TB
            TSPs: TSP List Data
            pkTA: pk_{TA} (Anchor Key Source)
        }

        pkTLP --> TL_Box : Signed by TLP (σ TLP)
    }

    %% Right Side: End-Entity Updates
    state "End-Entity Context" as RightContext {
        state "QSeal/QSign Certificate" as Q_Cert {
            direction TB
            pkop: pk_{op} (Sign/Seal Key)
            Usage1: Scope: Signing Capabilities
        }

        state "WRPAC" as WRPAC_Cert {
            direction TB
            pkAuth: pk_{AuthN} (AuthN Key)
            Usage2: Scope: AuthN
        }

        state "WRPRC" as WRPRC_Cert {
            direction TB
            Usage3: Scope: AuthZ
        }
    }

    %% Connection Arrows (The Trust Anchoring)
    TL_Box --> Q_Cert : Signs
    TL_Box --> WRPAC_Cert : Signs
    TL_Box --> WRPRC_Cert : Signs

    %% Clarifying Notes
    note left of LeftContext
        TA updates/removal context.
    end note

    note right of RightContext
        End-entity updates
        affect WRPAC/WRPRC/Qseal.
    end note
```

## Trust Management Event Table

The following matrix serves as the operational reference guide for the Trust Management process. It maps every critical lifecycle event to its responsible actors, the required communication protocols, and the resulting technical impacts on the ecosystem.

Table Legend:
- **Event**: The specific operational, organizational, or security trigger occurring within the ecosystem.
- **Sender**: The entity responsible for initiating the communication or action.
- **Receiver**: The actor or system component that receives the notification and executes the necessary updates.
- **Notification Protocol / Type**: The technical or indentity Information method used to transmit the event data (e.g., REST API, Out-of-Band email, automated sync).
- **Consequence (State Change)**: The resulting lifecycle state transition for the affected entity (e.g., from ACTIVE to SUSPENDED).
- **Impact on Trust Artifacts**: The exact technical modifications applied to the trust artifacts.

| Event | Sender | Receiver | Notification Protocol / Type | Consequence (State Change) | Impact on Trust Artifacts |
| :--- | :--- | :--- | :--- | :--- | :--- |


---

**Table of Contents**

**Normative & technical references**  
CIR  
CIR-1 2025/848 CIR 2025/848 of 6 May 2025 laying down rules for the application of Regulation (EU) No 910/2014 of the European Parliament and of the Council as regards the registration of wallet-relying parties [https://eur-lex.europa.eu/eli/reg_impl/2025/848/oj/eng](https://eur-lex.europa.eu/eli/reg_impl/2025/848/oj/eng)  
CIR-2 2025/848 amendement draft [https://ec.europa.eu/info/law/better-regulation/have-your-say/initiatives/16113-European-Digital-Identity-Wallet-registration-of-wallet-relying-parties-update-_en](https://ec.europa.eu/info/law/better-regulation/have-your-say/initiatives/16113-European-Digital-Identity-Wallet-registration-of-wallet-relying-parties-update-_en)  
CIR-3 CIRn (EU) 2025/1569 of 29 July 2025 laying down rules for the application of Regulation (EU) No 910/2014 of the European Parliament and of the Council as regards qualified electronic attestations of attributes and electronic attestations of attributes provided by or on behalf of a public sector body responsible for an authentic source [https://eur-lex.europa.eu/eli/reg_impl/2025/1569/oj/eng] (https://eur-lex.europa.eu/eli/reg_impl/2025/1569/oj/eng)

ARF  
TS02 : Specification of systems enabling the notification and subsequent publication of Provider information [https://github.com/eu-digital-identity-wallet/eudi-doc-standards-and-technical-specifications/blob/main/docs/technical-specifications/ts2-notification-publication-provider-information.md](https://github.com/eu-digital-identity-wallet/eudi-doc-standards-and-technical-specifications/blob/main/docs/technical-specifications/ts2-notification-publication-provider-information.md)  
TS05 : Specification of common formats and API for Relying Party Registration information (https://github.com/eu-digital-identity-wallet/eudi-doc-standards-and-technical-specifications/blob/main/docs/technical-specifications/ts5-common-formats-and-api-for-rp-registration-information.md)  
TS06 : Common Set of Relying Party Information to be Registered (https://github.com/eu-digital-identity-wallet/eudi-doc-standards-and-technical-specifications/blob/main/docs/technical-specifications/ts6-common-set-of-rp-information-to-be-registered.md)  
TS08 : Specification of Common Interface for reporting of Relying Parties to Data Protection Authorities (https://github.com/eu-digital-identity-wallet/eudi-doc-standards-and-technical-specifications/blob/main/docs/technical-specifications/ts8-common-interface-for-reporting-of-wrp-to-dpa.md)  

ARF topics  
Topic X : Relying Party registration (https://github.com/eu-digital-identity-wallet/eudi-doc-architecture-and-reference-framework/discussions/431 and its refinement https://github.com/eu-digital-identity-wallet/eudi-doc-architecture-and-reference-framework/discussions/645)  

Tech standards  
ETSI-119-411 Policy and security requirements for Trust Service Providers issuing certificates; Part 8: Access Certificate Policy for EUDI Wallet Relying Parties (https://www.etsi.org/deliver/etsi_ts/119400_119499/11941108/01.01.01_60/ts_11941108v010101p.pdf)  
ETSI-119-475 Relying party attributes supporting EUDI Wallet user's authorization decisions (Certificate profile and policy requirements for access and registration certificates) (https://www.etsi.org/deliver/etsi_ts/119400_119499/119475/01.01.01_60/ts_119475v010101p.pdf)  
ALL-TS All technical specs referred by ARF are available at https://eudi.dev/latest/technical-specifications/  

## Scope And Introduction
The aim of this chapter is to describe the lifecycle of: 
1. WRP identity and attestation authorization information managed in the national registers (This represents the source of WPR information)
2. the related certificates that are used to claim that identity and related authorizations in EUDIW ecosystem: access (Wallet relying Party Access Certificate, aka WRPAC) and registration (Wallet relying Party Registration  Certificate, aka WRPRC) certificates (This represents the mean to transport WRP information across the ecosystem)
3. the signing seals and certificates that are used to sign attestations by all AP roles foreseen within the Trusted List for EUDIW ecosystem.

# Metamodello
xxx
```mermaid graph
flowchart LR
     
    
    Entity-.->|xx as| ID
    ID -.-> Role --> TLs
    ID -.-> SignCap --> Qseal
    ID --> RegID --> WRPAC
    Entity-.->|xx as| AUTH
    MSPolicy -.-> AUTH
    AttType["Attestation Type"] -.-> AUTH
    AUTH --> RegAuth--> WRPRC
    Role -.->|Authorization on| AUTH 
    Cat --> AttType

    
Policy<-.->|Authorization requirements|AttType
Cat["Catalogue of Schemes"]-.->|defines|AttType
```


```mermaid graph
flowchart LR
     
    Event-.-> EvOwner
    EvOwner -.-> ObOwner
    ObOwner -.-> object
    
```

# Trust management overview
Wallet Relying Parties (WRP) Identity shall be managed by national registrars, according to national trust framework policies. WRP shall apply for registration to the registrar.
National Competent Authorities for different sectors shall be able to interact with registrars to provide information from their registries to fulfill the registration process, aside with information provided directly by entities ([Topic-X] and its refinement , national registers under Annex I, point 12 of CIR (EU) 2025/848 [CIR-1, CIR-2]).
WRP authorization shall be managed by registrars too, according to their requests. The authorization is a link between WRP identifier - role assumed in eudiw ecosystem (AP or RP) and the attestation type identifiers. The goal of authorization process is to fulfill policy requirements by WRP related to attestation types.

```mermaid graph
flowchart LR
    WEP["WRP Identity"]-.->|Authentication as| Role["Entitlement (AP or RP)"]
    Role -.->|Authorization on| Cred["Attestation Type"]
Policy<-.->|Authorization requirements|Cred
Cat["Catalogue of Schemes"]-.->|defines|Cred
```

If an attestation is subject to a policy, the attestation types shall be registered within the catalogue of schemes to be referred. This will ensure that only entitled providers will be allowed to issue specific credential in order to preserve level of assurance and data structure of the information according to sectorial competent authorities. And on the other side, only authorized relying parties shall be allowed to request these credentials.

```mermaid graph
---
title: Identity and authorization lifecycle Flow
---
flowchart LR 
subgraph Cred_Def["Attestation & Policy Catalogue"]
        Cred[["Catalogue of schemes"]]
        IDPol[["Identification Policy Catalogue"]]
        CredPol[["Authorization Policy Catalogue"]]
end
subgraph Register["Primary Information data management"]
        IDReg@{shape: cyl, label: "Identity Register" }
        AuthReg@{shape: cyl, label: "Authorization Register"}
        Registrar@{shape: lin-rect, label: "Registrar" }
        NCA@{shape: lin-rect, label: "EU Comm & NCA" }
        TL@{shape: cyl, label: "Trusted Lists & LoTE" }
end
subgraph C_A["Certificate Management"]
        WRPAC@{ shape: lin-doc, label: "WRPAC" }
        WRPAC_CRL@{ shape: lin-doc, label: "WRPAC_CRL" }
        WRPRC@{ shape: lin-doc, label: "WRPRC" }
        SEAL@{ shape: lin-doc, label: "Seal for Attestations" }
        SEAL_CRL@{ shape: lin-doc, label: "Seal & Certificate CRL" }
        WRPRC_TSL@{ shape: lin-doc, label: "WRPRC_TSL" }
        CA@{shape: lin-rect, label: "Certificate Authority & QTSP" }
        
end

    Registrar-->|Identification|IDReg
    Registrar-->|Identity_Revocation|IDReg
    Registrar<-.->IDPol
    Registrar<-.->Cred
    Registrar<-.->CredPol
    Registrar-->|Authorization|AuthReg
    Registrar-->|Authorization_Suspension|AuthReg
    AuthReg-->|Suspension_Request|CA
    IDReg-->|Revocation_Request|CA
    TL-->|CA_Identification|CA
    TL-->|CA_Identity_Revocation|CA
    Registrar-->|Insert|TL
    Registrar-->|Delete and update|TL

    CA-.->IDReg
    CA-->|Issuance|WRPAC
    CA-->|Revocation|WRPAC_CRL
    CA-->|Suspension|WRPRC_TSL
    CA-.->AuthReg
    CA-->|Issuance|WRPRC
    CA-->|Issuance|SEAL
    CA-->|Revocation|SEAL_CRL
```
The following graph aims to represent the interactions and dependencies between entities and lifecycle actions. 

```mermaid graph
---
title: Lifecycle Flow
---
flowchart LR
subgraph EU["EU Commission & Member State"]
        Pol["Policy update"]
        Cat["Catalogue of schemes update"]
end
 
subgraph National_Register["National Registrar and other National Competent Authorities (Judicial Authorities, Data Protection Authority)"]
        WRP_Id["WRP Identity Registration"]
        WRP_Auth["WRP Authorization Registration"]

        WRP_Id_Rev["WRP Identity Registration Revocation"]
        WRP_Auth_Rev["WRP Authorization Registration Suspension"]
        TL_Rev["Certificate Authority Removal from TL"]
end
 
subgraph CA["Certificate Authority and CTLog Service Provider"]
        WRPAC_I["WRPAC Issuance<br/>Register Notification<br/>CTlog SP notification"]
        WRPRC_I["WRPRC Issuance<br/>Register Notification<br/>CTlog SP notification"]
        WRPAC_Rev["WRPAC Revocation<br/>Update CRL/OCSP"]
        WRPRC_Rev["WRPRC Suspension<br/>Update TSL"]
        CTLog["CTLog"]
end

subgraph EDW["EUDIW operational context"]
        WRP["WRP"] -->uses_certificates["WRPAC (Access)<br/>WRPRC (Registration)<br/>Active/Valid"]
end

    WRP -.->|1. Applies for| WRP_Id
    WRP -.->|2. Applies for| WRP_Auth
    WRP -.->|5. Applies for| WRPAC_I
    WRP -.->|6. Applies for| WRPRC_I

    WRPAC_I -.->|3. Data Request| National_Register
    WRPRC_I -.->|4. Data Request| National_Register
    WRPAC_I-->|Certificate Timestamping| CTLog
    
    WRP -->|Request| WRPAC_Rev
    WRP -->|Request| WRPRC_Rev
    WRP_Id_Rev -->|Request| WRPAC_Rev
    WRP_Auth_Rev -->|Request| WRPRC_Rev

    National_Register-->|Request| WRP_Id_Rev
    National_Register-->|Request| WRP_Auth_Rev
    National_Register-->|Request| WRPAC_Rev
    National_Register-->|Request| WRPRC_Rev
    
    Pol -->|Trigger authorization updates| WRPRC_Rev
    Cat -->|Trigger policy updates| Pol
    WRP_Id_Rev -.->|Trigger| WRPAC_Rev
    WRP_Auth_Rev -.->|Trigger| WRPRC_Rev
 
    style WRP_Id fill:#e1f5fe
    style WRP_Auth fill:#e1f5fe
    style WRPAC_I fill:#c8e6c9
    style WRPRC_I fill:#c8e6c9
    style WRPAC_Rev fill:#ffcdd2
    style WRPRC_Rev fill:#ffcdd2
```

All certificate states and revocation mechanisms are in  ETSI 119-411-8, that describes Access Certificate Policy for EUDI Wallet Relying Parties

# Catalogue of schemes and policy management
The credential catalogue and related policies are not in scope of this chapter and are managed centrally by EU Commission. This topic is not defined yet [ref topic X (https://github.com/eu-digital-identity-wallet/eudi-doc-architecture-and-reference-framework/discussions/431)]
ETSI TS 319.482 will define catalogue of schemes implementation.
> Note: So changes in the credential catalogue and in related policy repositories will affect potentially both authorizations and consequently the validity of registration certificates.

# WRP Registration lifecycle 
## Registration (Onboarding wallet relying parties)
Each Member State will delegate a Registrar to manage the national register: it's a repository of identities and authorizations for WRPs that will handle attestations and attributes (in the issuance or presentation request phases).
The process and related attributes that must be collected are described in [CIR-1 CIR-2], and the process will be specific for member state and it's assumed to be equivalent. 
The first step is WRP's identification: the onboarding process must ensure adequate controls on the entity identity claims. A unique identifier is assigned to the entity (WRP identifier) and related attributes, such as credential offer endpoints, privacy policy statement URL, etc.
The second step is WRP's authorization to handle attestations, autonomously or delegating an intermediary: both for the attestation issuance and presentation request, policy requirements related to attestation type must be satisfied. 

The register information data model is described in [TS02] and api for registration and inquiry in the register are defined in [TS05] , data to be registered in [TS06]. 
This process and register maintenance shall be managed by national registrar.
National Registrar may integrate existing identity repository for specific sectors, according to NCA sector policies. 
Registrar may include the engagement of the CA in the registration process, in order to facilitate the onboarding process, according to WRP preferences.

Specific entities, like 
1. PID providers, 
2. wallet providers,
3. Pub EAA providers
4. QEAA providers
are enlisted in trusted lists and list of trusted entities.

## Registration update and revocation
Both types of information repositories will be subject of lifecycle management.
Each Member State Registrar, as National Competent Authority, shall define a process to manage information update or registration revocation on registers: 
1. in case of cessation of business that could be notified by the Business Register 
2. in case of suspension by the judicial authority 
3. or by DPA Data Protection Authorities (that will publish specific APIs to collect abuses [TS 08]).

EU Commission and NCAs will have authority on information management on trusted lists.

## Further optional and asyncronous information collection
Registrar may collect issued WRPAC and WRPRC references from CAs. This may be done in order to be able to trigger their revocation towards certificate authorities in case of license withdrawal.
Registrar may publish the authorization data bound to WRPidentifier in case WRPRCs are not transmitted to the wallet, in order to fulfill policy requirements.

# Access (WRPAC) and registration (WRPRC) certificate lifecycle

## Introduction
In order to make WRP operational in application protocols, a certificate authority shall provide the authentication keys, and so it shall issue a WRPAC and shall sign WRPRCs (Regulatory requirements are described in Annex E, data model in Annex B of [ETSI-119-475] referred by Commission Implementing Regulation 2024/2982). 
The WRPAC represents the identity key of a WRP. Access Certificates are used to sign the OID4VP request and also for signing the OID4VCI issuer metadata.  
The WRPRC is a JWT used for authorization both in attestation issuance and request steps, whether the attestation is somehow referred by policies. 
WRPRC is optional: 
1. it depends on attestation policy requirements
2. whether required by attestation policy requirements and not sent by WRP during the authentication phase, the same information can also be retrieved from the Registrar's online service. 

## WRPAC and WRPRC Issuance
WRPAC and WRPRC issuance requires a mutual authentication: the certificate authority must identify the applicant entity, and the entity must be able to check if the CA is present with this role in the trusted lists. 
The CA accesses the national register using REST apis and provides the certificates according to certificate profile and policy requirements, described in ETSI 119.475 and referred in Annex V of CIR amendment draft.
As soon a WRPAC and WRPRC have been issued:
1. the CA should notify the Registrar, providing their references. Registrar should record all issued certificates in order to be able to ask for revocation if required. 
2. the CA shall trace certificate issuance on 2 CTlog service providers (using API provided by ctlog managers) according to Certificate transparency policies. CTlog service will keep all timestamps of certificate issuance to enable third party verification that the certificate has been issued by an authorized Certificate Authority at that time that's declared. 
The WRP has to make available its WRPRC and WRPAC certificates online through its website.
## Revocation
WRPAC and WRPRC revocation could be triggered by  identity and authorization changes or revocation, or by indipendent processes.
1. Issuance or revocation can be triggered by Registrar according to information changed in the register 
2. issuance can be triggered by a WRP request directly to a CA
3. revocation can be requested by WRP or other national or EU authorities to the CA.
As soon as the CA revokes a certificate, shall update and publish the information in a certificate revocation list (CRL) or a Token Supension List (TSL).

Specific roles will be managed by specific authorities using trusted lists as persistence repository and way to disseminate information. API endpoint could be provided to publish a subset of TL information.

# Trusted List Issuer Certificates
All seal and signing certificates for attestation issuer will be provided by QTSPs, enlisted in Trusted Lists, that will be subject for their authorization lifecycle by NCAs and CABs.

# Annex I - Banking usecase
TBD  
