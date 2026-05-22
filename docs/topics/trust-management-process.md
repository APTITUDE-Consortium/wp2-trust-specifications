
This section describes the high level trust management process within the APTITUDE Trust Framework. It defines the various entities and their roles within the ecosystem ([Ecosystem Partecipants](#ecosystem-participants)), the relationship between their Attributes, the Trust Artifacts that assert these Attributes ([Entity Attribute Schema](#entity-attribute-schema)), introduces the State Machine that governs the lifecycle of WRPs and Wallet Providers within the ecosystem ([Abstract State Machine](#abstract-state-machine)), and describes the operational procedures triggered by changes in these Attributes ([Entity Lifecycle Operations](#entity-lifecycle-operations)).

Each WRP and Wallet Provider partaking the Ecosystem is represented by specific *Attributes* (Identity Information, Technical Information, and Policy and Authorization Information) and possesses a *State*. This State is an abstraction at the governance level that captures the entity's current operational status and trustworthiness within the ecosystem. The state of an Entity is determined by the information contained in the Trust Artifacts associated with it, which are in turn issued and managed by other entities within the ecosystem (Trusted Lists and Trust Artifacts Providers).

When a WRP's, Wallet Provider's, or Trust Artifacts Provider's Attributes changes (e.g., key rotation), it triggers an operational procedure that instructs the Trust Artifact Provider or Trusted Lists Providers to update and re-sign the corresponding Trust Artifact or Trusted Lists, without necessarily altering the underlying Abstract State of the WRP. These operational procedures are defined in [Entity Lifecycle Operations](#entity-lifecycle-operations).

#### Ecosystem Participants

The entities in the ecosystem are divided in different groups depending on their role and the artifact that they issue.

- *Supervisory Bodies* continuously *supervise* other ecosystem entities. Supervision affect the states of dependent Entities.
- *Member States and the European Commission* *define* and *manage* Attestation Rulebooks, and *define* *Ecosystem Policies and Certification Schemas*. These affect dependent Entities during onboarding and their lifecycle.
- *Trusted Lists Providers* (LoTE/LOTL Scheme Operators, EUMS TL Scheme Operators) *publish* and *manage* *Trusted Lists* (LoTE, LOTL, EUMS TL) that contain Trust Anchors and Attributes of other Entities. Inclusion in these artifacts is, by itself, also a statement about the role and authorization of the included entities within the ecosystem.
- *Trust Artifacts Providers* (MS Registrars, QTSPs, Providers of WRPAC/WRPRC) *publish* and *manage* *Trust Artifacts* (MS Registers, WRPACs, WRPRCs, Signature/Seal Certificates) which transports Attributes (Identity Information, Technical configurations, and Authorization Information) of End-Entities.
- *End-Entities* (Attestation Providers, PID Providers, Relying Parties, Wallet Provider) rely on Trusted Lists and Trust Artifacts for assessing their trustworthiness to other participants within the ecosystems. In addition, they *issue*, *receive* or *manage* User Attestations or Wallet Attestations to and from Wallet Units during issuance, presentation and WP-specific management flows respectively.

The diagram below highlights the relationships between the aforementioned entities and artifacts, and the dependences between them in terms of supervision, publication, and the effects that changes in the artifacts have on the entities. The arrows indicate the direction of supervision, publication, and effect propagation.

```mermaid
flowchart LR
    %%Entities and Artifacts
    ms["Member States and European Commission"]
    sup["Supervisory Body<br>(EC, CAB, NAB, Member States)"]
    sup_art{{"Ecosystem Artifacts<br>(Attestation Rulebboks, Ecosystem Policies, Certification Schemas)"}}
    init_ent["Trusted Lists Providers<br>(LoTE/LOTL Scheme Operators, EUMS TL Scheme Operators)"]
    init_ent_art{{"Trusted Lists<br>(LoTE, LOTL, EUMS TL)"}}
    mid_ent["Trust Artifacts Providers<br>(MS Registrars, QTSP, Providers of WRPAC/WRPRC)"]
    mid_ent_art{{"Trust Artifacts<br>(MS Registers, WRPAC, WRPRC, Signature/Seal Certificate)"}}
    end_ent["End-Entities<br>(Attestation Providers, PID Providers, Wallet Providers, Relying Parties, Relying Party Intermediaries)"]
    end_ent_art{{"User Attestations, Wallet Attestations"}}
    %%end_ent_2["End-Entities <br>()"]

    %%Modification propagation arrows
    sup e1@=="Supervise"==> init_ent
    sup e2@=="Supervise"==> mid_ent
    sup e3@=="Supervise"==> end_ent
    %%sup e8@=="Supervise"==> end_ent_2
    ms --"Provides/Publishes"--> sup_art
    sup_art e4@--"Affects"--> init_ent
    sup_art e5@--"Affects"--> mid_ent
    sup_art e6@--"Affects"--> end_ent
    %%sup_art e7@--"Affects"--> end_ent_2
    mid_ent -."Are included".-> init_ent_art
    end_ent -."Are included".-> init_ent_art
    mid_ent_art --"to"----> end_ent
    init_ent --"Publishes"--> init_ent_art
    %%init_ent --"Impacts"--> mid_ent
    mid_ent --"Issue"--> mid_ent_art
    %%mid_ent --"Impacts"--> end_ent
    end_ent --"Issue"--> end_ent_art --"to"--> wi["Wallet Units"]
    wi["Wallet Units"] --"Present Attestations"--> end_ent
    
    
    e1@{ animate: true }
    e2@{ animation: fast }
    e3@{ animation: fast }
    %%e8@{ animation: fast }
    %%Artifacts inclusion arrows
    %%mid_ent e4@-. Referenced in.-> init_ent_art
    %%end_ent e5@-. Referenced in.-> init_ent_art
    %%end_ent e6@-. Referenced in.-> mid_ent_art
    e4@{ animation: fast }
    e5@{ animation: fast }
    e6@{ animation: fast }
    %%e7@{ animation: fast }
```

#### Entity Attribute Schema

Trust Artifacts Providers and End-Entities are characterized by three main classes of *Attributes*:

- **Identity Information**: This includes the organization's name, contact information, and organizational policies.
- **Technical Configuration**: This includes the cryptographic materials (signature/seal keys, authentication keys) and technical endpoints necessary for ecosystem interactions.
- **Policy and Authorization Information**: This includes the entity's entitlements, attestation provision capabilities, attestation request capabilities, intermediary use permissions, intended use cases, and compliance with certification schemas.

##### Attribute Schema and associated Trust Artifacts

In the table below are found the relationship between the aforementioned Attributes and the Trust Artifacts in which they are contained for both WRP and Wallet Providers.

| Entity Type | Attribute Class | Entity Attributes | Trust Artifacts |
| :--- | :--- | :--- | :--- |
| WRP | Identity Information | Organization name | WRPAC, WRPRC, Register |
| WRP | Identity Information | Contact information | WRPAC, Register |
| WRP | Identity Information | Organizational Policy | WRPAC, WRPRC, Register |
| PID Provider or Attestation Provider | Technical Configuration | Signature/Seal key | Signature/Seal Certificate |
| WRP | Technical Configuration | Authentication key | WRPAC |
| PID Provider or Attestation Provider | Authorization Information | Attestation provision capabilities | WRPRC, Register |
| RP | Authorization Information | Attestation request capabilities | WRPRC, Register |
| WRP | Authorization Information | Entitlements | WRPRC, Register |
| WRP | Authorization Information | Intermediary use permissions | WRPRC, Register |
| WRP | Authorization Information | Service descriptions | WRPRC, Register |
| WRP | Authorization Information | Supervision information | WRPRC, Register |
| WP, PID and Pub-EAA Provider | Identity Information | Organization name | LoTE |
| WP, PID and Pub-EAA Provider | Identity Information | Contact information | LoTE |
| WP, PID and Pub-EAA Provider | Identity Information | Organizational Policy | LoTE |
| WP, PID and Pub-EAA Provider | Authorization Information | Service descriptions | LoTE |
| WP, PID and Pub-EAA Provider | Authorization Information | Service endpoints | LoTE |
| WP, PID and Pub-EAA Provider | Authorization Information | Service status | LoTE |
| WP, PID and Pub-EAA Provider | Technical Configuration | Signature/Seal trust anchors | LoTE |

!!! note

    The inclusion of Wallet Providers and PID/Pub-EAA Providers in the LoTE is an implicit assertion of their role and authorization within the ecosystem. In particular, their inclusion is a result of the succesful completion of the registration and notification procedures as defined in CIR 2025/848 (registration of WRP) and CIR 2024/2980 (notifications of WRP and WP).

The diagram below highlights the dependences between WRP's and Wallet Provider's Attributes, the Trusted Lists in which these Attributes are contained and the Entities that use the attribute's information to issue additional Trust Artifacts. For both WRPs and WPs, the inclusion in the Trusted Lists attests the implicit, ongoing, compliance to the polices set up by the EC and the MS during onboarding for the respective roles.

```mermaid
flowchart LR
    wrp["WRP"]

    subgraph abst["WRP Attributes"]
        direction LR
        id(["Identity Information<br>(organization name, contact information, organization policies)"])
        tech(["Technical Configuration<br>(signature/seal key,<br>AuthN key, endpoints)"])
        authz(["Policy and Authorization<br>(entitlements, attestation provvision, attestation request, intermediary use, intended use, compliance to certification schema)"])
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
    tlp["LoTE Scheme Operator"]

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
    abst --"used by<br>(when PID/Pub-EAA Provider)"--> tlp
    tlp --"issues/manages"--> tl
    

    wp["Wallet Provider"]

    subgraph abst_wp["WP Attributes"]
        direction LR
        id_wp(["Identity Information<br>(organization name, contact information, organization policies)"])
        tech_wp(["Technical Configuration<br>(signature/seal key,<br>endpoints)"])
        authz_wp(["Policy and Authorization<br>(wallet attestation provvision, compliance to certification schema)"])
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

In the table below we map the relationship between the aforementioned Attributes and the Trust Artifacts in which they are contained for Trust Artifacts Providers.

| Entity Type | Attribute Class | Entity Attributes | Trust Artifacts |
| :--- | :--- | :--- | :--- |
| Registrar, Provider of WRPAC/WRPRC | Identity Information | Organization name | LoTE |
| Registrar, Provider of WRPAC/WRPRC | Identity Information | Contact information | LoTE |
| Registrar, Provider of WRPAC/WRPRC | Identity Information | Organizational Policy | LoTE |
| Registrar, Provider of WRPAC/WRPRC | Authorization Information | Service descriptions | LoTE |
| Registrar, Provider of WRPAC/WRPRC | Authorization Information | Service endpoints | LoTE |
| Registrar, Provider of WRPAC/WRPRC | Authorization Information | Service status | LoTE |
| Registrar, Provider of WRPAC/WRPRC | Technical Configuration | Signature/Seal key | Signature/Seal Certificate |
| Registrar, Provider of WRPAC/WRPRC | Technical Configuration | Signature/Seal Trust Anchor | LoTE |
| QTSP | Identity Information | Organization name | EUMS TL |
| QTSP | Identity Information | Contact information | EUMS TL |
| QTSP | Identity Information | Organizational Policy | EUMS TL |
| QTSP | Authorization Information | Service descriptions | EUMS TL |
| QTSP | Authorization Information | Service endpoints | EUMS TL |
| QTSP | Authorization Information | Service status | EUMS TL |
| QTSP | Technical Configuration | Signature/Seal key | EUMS TL |

The diagram below highlights these dependences between Trust Artifact Provider Attributes, artifacts in which these Attributes are contained and entities that use this information to issue/publish Trust Artifacts:

```mermaid
flowchart LR
    mid_ent["Trust Artifact Provider<br>(Registrar, Provider of WRPAC/WRPRC, QTSP)"]

    subgraph abst["Entity Attributes"]
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

    tl{{"LoTE or EUMS TL"}}

    ca["Signature/Seal<br>Certificate Authority"]
    tlp["LoTE/EUMS TL Scheme Operator"]

    mid_ent --"characterized by"--> abst

    id --"used by"--> ca
    tech --"used by"--> ca
    ca --"issues/manages"--> csig

    abst --"used by"--> tlp
    tlp --"publishes/maintains"--> tl

    ms --"defines"--> authz
    authz --"is reflected in"--> tl
```

##### Abstract State Machine

State Machines are described only for WRPs and Wallet Providers since they are the only entities that have a direct, active role in the ecosystem operations and protocols. Wallet Providers and WRPs participating in the APTITUDE Trust Framework are classified into one of the following mutually exclusive lifecycle States at any given time. The State dictates the entity's authorization level, operational capabilities, and how other participants SHALL interact with its cryptographic artifacts.

- `UNREGISTERED`: Indicates that an entity does not currently hold a valid subscription or registration within the APTITUDE Trust Framework. This is the default baseline state. Entities in this state are outside the trust boundary and SHALL NOT participate in framework operations or federation protocols.
- `REGISTERED`: Indicates that an entity has successfully completed the onboarding process, verified its identity, and has established ecosystem access.
    - A WRP is in `REGISTERED` state if the Registrar has inserted its Identity information within the Register, and possesses the WRPAC binding this Identity information to a key controlled by the entity.
    - The Wallet Provider is in `REGISTERED` when it has completed the necessary certification and successfully completed the onboarding process.
- `OPERATIONAL`: Indicates that an entity has successfully completed onboarding, and, crucially, has been authorized to perform role-related operations, provide services, and issue or verify artifacts in accordance with framework policies.
    - A RP or RP Intermediary is in `OPERATIONAL` state if it is `REGISTERED`, the Registrar has inserted its Authorization information within the Register, and (optionally) it possesses a valid WRPRC.
    - A (Q)EAA Provider is in `OPERATIONAL` state if it is `REGISTERED`, the Registrar has inserted its Authorization information within the Register, (optionally) it possesses a valid WRPRC and possesses a valid (qualified) Signature/Seal certificate to sign the attestations.
    - A PID Provider, Pub-EAA Provider is in `OPERATIONAL` state if it is `REGISTERED`, the Registrar has inserted its Authorization information within the Register, (optionally) it possesses a valid WRPRC, it possesses valid Signature/Seal certificate, and is listed in the relevant LoTE with `ServiceStatus` set to `granted`.
    - A Wallet Provider or Trust Artifacts Provider is in the `OPERATIONAL` state if it is `REGISTERED`, listed in the relevant Trusted List with `ServiceStatus` set to `granted`, and possesses valid Signature/Seal certificate.
- `REMOVED`: Indicates the revocation of an entity's `REGISTERED` status due to voluntary offboarding, a severe security breach, or a critical compliance failure.
    - A WRP is in `REMOVED` state if the WRPAC is `revoked`.
    - A Wallet Provider or Trust Artifacts Provider is in `REMOVED` state when it is not listed in the latest version of the relevant LoTE or EUMS TL.
    - **Forward Operations**: Ecosystem participants SHALL reject new interactions or transactions initiated by a `REMOVED` entity, and all cryptographic keys, active attestations, and operational capabilities associated with the entity SHALL be immediately revoked.
    - **Historical Operations**: Ecosystem participants MAY continue to validate historical data, signatures, and attestations generated prior to the Removal timestamp, subject to local risk policies. These historical data are found in the corresponding Trusted List's `ServiceHistory` component.

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
    
    Reg --> Op : Authorization Granted<br>(Signature/Seal Issued & LoTE ServiceState `granted`)
    
    Op --> Reg : Authorization Lost<br>(e.g., Signature Cert Expired, LoTE  ServiceState `withdrawn`)
    
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
| `REGISTERED` | Indicates that an entity has successfully completed onboarding, verified its identity, and established baseline ecosystem network access. | WRPs (RPs, PID, and EAA Providers) and Wallet Providers. | WRP: Valid WRPAC and identity inclusion in the Register.<br>Wallet Provider: Finalized certification and onboarding records. | WRP: OCSP response with good status (or absence in CRL) for the WRPAC; active status in the Register. |
| `OPERATIONAL` | Indicates that an entity is explicitly authorized to perform role-related operations, provide services, and issue or verify artifacts. | `REGISTERED` WRPs and Wallet Providers. | **RP (Intermediary)**: Authorization in Register, WRPRC (optional).<br>**(Q)EAA Provider**: Valid Signature/Seal certificate, Authorization in Register, WRPRC (optional).<br>**PID / Pub-EAA**: Valid Signature/Seal certificate, entry in the relevant LoTE, Authorization in Register, WRPRC (optional).<br>**Wallet Provider**: Valid Signature/Seal certificate, entry in the relevant Trusted List. | **Certificates**: OCSP response with `good` status or absence in CRL for Signature/Seal certificates and WRPACs; SLT with status set to `0x00`.<br>**LoTE**: Entry matching the entity with `ServiceStatus` set to `granted`.<br>Register: Validated role-specific authorization schema Attributes. |
| `REMOVED` | Indicates the revocation of an entity's `REGISTERED` status due to voluntary offboarding, a severe security breach, or a critical compliance failure. | All deactivated, offboarded, or permanently banned framework participants. | **WRP**: Revoked WRPAC, removal from LoTE (if applicable) and Register entry.<br>**Wallet Provider**: Removal from the current active LoTE. | OCSP response with `revoked` status or presence in a CRL for the WRPAC.<br>Complete absence from the active Register or Trusted List (if applicable); resolution of historical status via the `ServiceHistory` component. |

Depending on the circumstances, an entity in the `REMOVED` state MAY have its Signature/Seal certificates revoked, when this is not the case, all artifacts the entity has issued SHALL be considered valid for historical operations. Further details on this are found in the [Operational Effects of Removal](#operational-effects-of-Removal) section.

#### Entity Lifecycle Operations

Below are detailed the operational procedures, which affects the Attributes of Trust Artifact Provider and End-Entities and the resulting effects on their State.

##### Onboarding Process

The onboarding process governs the transition of a End-Entity (WRP or Wallet Provider) from the `UNREGISTERED` state to the `OPERATIONAL` state. During the onboarding process, it is up to the Entities running the process and necessary checks to take the onboardee's Attributes and (depending on its role) issue the corresponding Trust Artifacts. Further details are found in (Onboarding Process)[#onboarding-process.md].

##### Active Operations and Maintenance

While in the `OPERATIONAL` state, entities MAY require *organizational updates* to their registered Attributes including, entities profile, cryptographic materials, or operational parameters. Below we describe these updates and their operational effects on the trust artifacts and the entity's state.

###### Organizational Updates

As their organizational or regulatory circumstances evolve, WRPs and Wallet Providers SHALL update identity, authorization information and technical configurations accordingly through the standard channels as defined at Member State and European Commission level. Identity and cryptographic updates SHALL follow standard framework governance processes and SHOULD NOT affect the underlying technical operations of the Trust Framework. In particular, updates that directly affect federation protocol operations or cryptographic trust boundaries require strictly coordinated procedures. These technical updates SHALL be validated by the designated MS authority or EC designated body prior to deployment to maintain trust relationships and ecosystem operational integrity.

###### Operational Effects of Organizational Updates

When there are organizational updates, the Trust Framework infrastructure SHALL propagate these changes to the relevant trust artifacts. The specific operational effects depend on the entity's role, and the artifacts it utilizes.

**WRP Updates**: For WRP updating their Identity Information, Technical Configurations, and/or Policies and Authorizations, the update event SHALL trigger the following procedures:

- **Identity Information and Policies and Authorizations Updates**:
    - **Registry Update**: the WRP SHALL update its information within the Register via the authenticated API.
    - **WRPAC Revocation**: The Provider of WRPAC SHALL revoke the entity's current WRPAC. Revocation SHALL be executed by appending the certificate's serial number to the active CRL or by returning a `revoked` status in the OCSP response.
    - **WRPAC Re-issuance**:The Provider of WRPAC SHALL issue a new WRPAC with the updated data.
    - **WRPRC Revocation**: The Provider of WRPRC SHALL revoke the entity's current WRPRC if present. Revocation SHALL be executed by setting the status value of the WRPRC within the corresponding Status List token to `0x01`.
    - **WRPRC Re-issuance**: The Provider of WRPRC SHALL issue a new WRPRC with the updated data if required.
    - **LoTE Update** [ONLY for PID and Pub-EAA Providers]: the PID/Pub-EAA Provider SHALL notify the LoTE Scheme Operator with the update, the latter which will publish a new version of the LoTE using the pivoting mechanism with the PID/Pub-EAA Provider's updated information. The `TrustedEntityServices.ServiceInformation.ServiceDigitalIdentity` SHALL stay to the URI `http://uri.aptitude.org/TrstSvc/TrustedList/Svcstatus/granted`.
- **Technical Configurations Updates**:
    - **Signature/Seal Key update**: the WRP SHALL notify Signature/Seal Key updates to the Certificate Authority responsible for the issuance of these certificates.
        - **Signature/Seal Certificate Revocation**: The Certificate Authority SHALL revoke the entity's current Signature/Seal certificate.
        - **Signature/Seal Certificate Re-issuance**:The Certificate Authority SHALL issue a new Signature/Seal certificate with the updated key.
        - **LoTE Update** [ONLY for PID Providers TA certificates]: Upon obtaining a new Signature/Seal certificate with the updated key the PID Provider SHALL notify the LoTE Scheme Operator which will publish a new version of the LoTE using the pivoting mechanism with the PID Providers' updated Signature/Seal certificate. The `TrustedEntityServices.ServiceInformation.ServiceDigitalIdentity` SHALL stay to the URI `http://uri.aptitude.org/TrstSvc/TrustedList/Svcstatus/granted`.
    - **AuthN Key update**: The WRP SHALL notify WRPAC Key updates to the Provider of WRPAC.
        - **WRPAC Revocation**: The Provider of WRPAC SHALL revoke the entity's current WRPAC. Revocation SHALL be executed by appending the certificate's serial number to the active CRL or by returning a `revoked` status in the OCSP response.
        - **WRPAC Re-issuance**:The Provider of WRPAC SHALL issue a new WRPAC with the updated key.

**Wallet Providers and Trust Artifact Provider Updates**: For Wallet Providers, Registrars, Providers of WRPAC/WRPRC updating their Identity Information and/or Technical Configurations, the update event SHALL trigger the following procedures:

- **Identity Information Updates**:
    - **LoTE Update**: the entity SHALL notify the LoTE Scheme Operator with the update, the latter which will publish a new version of the LoTE using the pivoting mechanism with the PID/Pub-EAA Provider's updated information.
- **Technical Configurations Updates**:
    - **Signature/Seal Key update**: the entity SHALL notify the Signature/Seal Key updates to the Certificate Authority responsible for the issuance of these certificates.
        - **Signature/Seal Certificate Revocation**: The Certificate Authority SHALL revoke the entity's current Signature/Seal certificate.
        - **Signature/Seal Certificate Re-issuance**:The Certificate Authority SHALL issue a new Signature/Seal certificate with the updated key.
        - **LoTE Update** [ONLY for TA certificates]: Upon obtaining a new Signature/Seal certificate with the updated key the entity SHALL notify the LoTE Scheme Operator which will publish a new version of the LoTE using the pivoting mechanism with the entity's updated Signature/Seal certificate. The `TrustedEntityServices.ServiceInformation.ServiceDigitalIdentity` SHALL stay to the URI `http://uri.aptitude.org/TrstSvc/TrustedList/Svcstatus/granted`.
    - **Endpoints Update** [ONLY for Registrars or Wallet Providers]: When updating endpoint, the Registrar or Wallet Provider SHALL notify the LoTE Scheme Operator which will publish a new version of the LoTE using the pivoting mechanism with the updated endpoint.

##### Removal Process

The Removal process defines the rapid-response workflows and administrative procedures executed to transition an entity from the `OPERATIONAL` state to the `REMOVED` state. This transition MAY be initiated voluntarily by the entity or forcefully enacted by the Supervisory Body.

###### Triggers for Removal

Removal events are categorized based on their initiation source:

- Voluntary Exit: Organizations MAY choose to exit the federation for standard business or operational reasons. Permitted reasons include:
    - Business Changes: Organizational restructuring, mergers, acquisitions, or complete service discontinuation.
- Supervisory Body Removal (use the MS, EC, CAB, NAB, DPA bodies): The Supervisory Body MAY initiate a forced Removal due to severe compliance failures, fatal security breaches, or other critical ecosystem threats.

###### Operational Effects of Removal

When an entity is transitioned to the `REMOVED` state, the APTITUDE Trust Framework infrastructure SHALL immediately execute a series of cryptographic and registry updates to halt the entity's operations while preserving historical evidence.  The specific operational effects depend on the entity's role, and the artifacts it utilizes.

**WRP Withdrawal or Removal**: For WRP updating their Identity Information, Technical Configurations, and/or Policies and Authorizations, the update event SHALL trigger the following procedures:

- **Registry Update**: the WRP or Supervisory body MAY remove the WRP information within the Register.
- **WRPAC Revocation**: The Provider of WRPAC SHALL revoke the entity's current WRPAC. Revocation SHALL be executed by appending the certificate's serial number to the active CRL or by returning a `revoked` status in the OCSP response.
- **WRPRC Revocation**: The Provider of WRPRC SHALL revoke the entity's current WRPRC if present. Revocation SHALL be executed by setting the status value of the WRPRC within the corresponding Status List token to `0x01`.
- **Signature/Seal Certificate Revocation**: The Certificate Authority SHALL revoke the entity's current Signature/Seal certificate.
- **LoTE Update** [ONLY for PID and Pub-EAA Providers]: the WRP or Supervisory body SHALL notify the LoTE Scheme Operator which will publish a new version of the LoTE using the pivoting mechanism where the PID/Pub-EAA Provider's `TrustedEntityServices.ServiceInformation.ServiceStatus` component SHALL be set to the URI `http://uri.aptitude.org/TrstSvc/TrustedList/Svcstatus/withdrawn`. To maintain non-repudiation for past transactions, the superseded parameters SHALL be retained as historical records within the `TrustedEntityServices.ServiceHistory`.

**Trust Artifact Provider Withdrawal or Removal**: For Wallet Providers, Registrars, Providers of WRPAC/WRPRC updating their Identity Information and/or Technical Configurations, the removal event SHALL trigger the following procedures:

- **LoTE Update**: the Trust Artifact Provider or Supervisory body SHALL notify the LoTE Scheme Operator which will publish a new version of the LoTE using the pivoting mechanism where the entity's `TrustedEntityServices.ServiceInformation.ServiceStatus` component SHALL be set to the URI `http://uri.aptitude.org/TrstSvc/TrustedList/Svcstatus/withdrawn`. To maintain non-repudiation for past transactions, the superseded parameters SHALL be retained as historical records within the `TrustedEntityServices.ServiceHistory`.

!!! note

    When executing the revocation on the CRL, the `ReasonFlag` element SHALL accurately reflect the nature of the Removal:
    - If the Removal is a temporary suspension pending investigation, the `ReasonFlag` SHALL be set to `(6)`: `certificateHold`.
    - If the Removal is a permanent termination, the `ReasonFlag` SHALL be set to the appropriate code based on the circumstances, such as `(1)`: `keyCompromise`, `(2)`: `cACompromise`, or `(5)`: `cessationOfOperation`.
