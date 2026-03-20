# Trust Evaluation Process (Authorization)

---

# 0. Section positioning

## 0.1 Purpose

This document specifies the Authorization Process Implementation Profile for the APTITUDE trust framework.  
It defines the rules that a conformant Wallet Unit **SHALL** implement, after successful requester authentication, when interacting with a Wallet-Relying Party (WRP) in the following cases:

- issuance of a PID to a Wallet Unit;
- issuance of an attestation to a Wallet Unit;
- intermediated issuance through an intermediary (Is it in scope? Reference: ETSI TS 119 472-3 v1.1.1 (2026-03));
- direct presentation to a Relying Party (RP);
- intermediated presentation through an intermediary acting on behalf of a final RP.

## 0.2 Objective

This profile defines, in an implementation-oriented form:

- the authorization inputs that **SHALL** be available once the requester has already been authenticated;
- the authoritative and non-authoritative sources from which those inputs **MAY** be derived;
- the elements that **SHALL** be exchanged or resolved in each scenario;
- the minimum fields that **SHALL** be available to the wallet;
- the processing steps that **SHALL** be executed during authorization;
- the distinction between advisory conditions and negative authorization outcomes;
- the cases in which a negative authorization outcome **MAY** be overruled by the Wallet User;
- the handling of Register resolution and verification;
- the handling of Embedded Disclosure Policies (EDP);
- the precedence rules between authenticated requester context, WRPRC (Wallet-Relying Party Registration Certificate), Register-derived data, and self-declared information (is the latter in scope? ARF Req. ISSU_24a, 34a, 34b);
- the sequence of interactions across the relevant scenarios.

## 0.3 Notation

Normative requirements are expressed with **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT** and **MAY**.

The present document assigns one identifier for each requirement.  
These identifiers result from the concatenation of the following two components:

1. A topic identifier, for signalling the topic targeted by the requirement;
2. A number of 2 digits. In each clause the number will start in 01 and it will increase in one unity for each requirement.

Requirement identifiers use the following prefixes:

- `AUTHZ-GEN-*` for general rules;
- `AUTHZ-IN-*` for exchanged elements, source provenance, and minimum fields;
- `AUTHZ-ISS-*` for issuance;
- `AUTHZ-PRES-*` for direct presentation;
- `AUTHZ-INT-*` for intermediated presentation;
- `AUTHZ-REG-*` for Register resolution and verification;
- `AUTHZ-EDP-*` for Embedded Disclosure Policy;
- `AUTHZ-UI-*` for Wallet User transparency and decision semantics.

# 1. Scope and conformance

## 1.1 Scope

This profile applies to the authorization process for:

- issuance interactions involving a PID Provider or an Attestation Provider (AP);
- issuance interactions involving an intermediary (Is it in scope? ETSI TS 119 472-3 v1.1.1 (2026-03));
- direct presentation interactions involving a direct RP;
- intermediated presentation interactions involving an intermediary and a final RP.

## 1.2 Out of scope

Authentication of the technical requester is out of scope of this profile.

This profile therefore does not define in detail:

- access-certificate validation rules;
- LoTE validation procedures;
- certificate-path validation algorithms;
- revocation checking procedures for access certificates;
- the full trust-anchor validation model.

This profile does define how the Wallet Unit **SHALL** use the already-authenticated requester context as an input to authorization, including coherence checks between:

- the authenticated technical requester;
- the authorization subject; and
- the WRPRC- or Register-derived authorization context.

## 1.3 Preconditions

**AUTHZ-GEN-01** The authorization process defined in this profile **SHALL** start only after the technical requester has already been authenticated according to the applicable specifications.

**AUTHZ-GEN-02** If the technical requester has not been successfully authenticated, the authorization process **SHALL NOT** start.

> **Informative note**  
> This boundary is deliberate. Authentication is a necessary prerequisite for authorization, but the focus of this profile is the authorization step itself: authorization-context resolution, entitlement verification, scope verification, EDP evaluation, Register-based verification, transparency rendering, and Wallet User approval semantics.

## 1.4 Conformance target

**AUTHZ-GEN-03** A wallet claiming conformance with this profile **SHALL** implement the authorization-processing rules defined in Clauses 3 to 10.

## 1.5 Source-model neutrality

**AUTHZ-GEN-04** The wallet **SHALL** support authorization-context resolution from:

- a Wallet-Relying Party Registration Certificate (WRPRC), where available and applicable; and
- the Register, where a WRPRC is not available or cannot be relied upon.

**AUTHZ-GEN-05** The wallet **SHALL NOT** change the substantive authorization logic solely because authorization data is sourced from a WRPRC rather than directly from the Register.

**AUTHZ-GEN-06** Where both a verified WRPRC and verified Register-derived data are available, the wallet **SHALL** normalize both into the same internal authorization model before applying authorization rules.

**AUTHZ-GEN-07** The wallet **SHALL** treat verified WRPRC-derived data and verified Register-derived data as authoritative authorization inputs.

**AUTHZ-GEN-08** The wallet **SHALL** treat request-carried fields or metadata-carried fields that are not confirmed by a verified WRPRC or by verified Register-derived data as non-authoritative information.

# 2. Terminology and outcome model

## 2.1 Authentication subject and authorization subject

**AUTHZ-GEN-09** The wallet **SHALL** distinguish between:

- the authenticated technical requester; and
- the authorization subject.

**AUTHZ-GEN-10** The authorization subject **SHALL** be:

- the PID Provider or AP in issuance;
- the RP in direct presentation;
- the final RP in intermediated presentation.

**AUTHZ-GEN-11** In intermediated presentation, the authenticated technical requester **SHALL** be the intermediary.

**AUTHZ-GEN-12** In intermediated presentation, the WRPRC or Register-derived subject identity **SHALL** refer to the final RP, not to the intermediary.

## 2.2 Authorization decision

**AUTHZ-UI-01** The wallet **SHALL** produce an authorization decision expressed as one of the following:

- `AUTHORIZED`; or
- `NOT_AUTHORIZED`.

## 2.3 Advisories

**AUTHZ-UI-02** User-relevant trust, registration, transparency, or data-source limitations **SHALL** be represented as advisories.

**AUTHZ-UI-03** Advisories **SHALL** be displayed to the Wallet User as part of the authorization decision evaluation outcome.

## 2.4 Wallet User approval and override

**AUTHZ-UI-04** Wallet User approval **SHALL** be a separate step from the authorization decision evaluation outcome.

**AUTHZ-UI-05** A `NOT_AUTHORIZED` decision **MAY** be either:

- non-overridable; or
- overridable by the Wallet User, where this profile explicitly allows override.

**AUTHZ-UI-06** In this profile, Wallet User override of `NOT_AUTHORIZED` **SHALL** be permitted only in the following two cases:

- negative outcome of the verification of the requested attributes against the registered attributes or registered scope for the intended use; and
- negative outcome of the evaluation of an Embedded Disclosure Policy.

**AUTHZ-UI-07** Outside the two cases defined in `AUTHZ-UI-06`, a `NOT_AUTHORIZED` decision **SHOULD** be non-overridable.

# 3. Inputs to the authorization process

## 3.1 General rule

**AUTHZ-IN-01** The wallet **SHALL** base authorization decisions only on information that is:

- derived from already authenticated requester context and related trusted inputs;
- conveyed through a verified WRPRC or other verified signed authorization metadata;
- obtained from the Register through a verified Register response; or
- explicitly identified as self-declared fallback information.

## 3.2 Input provenance model

**AUTHZ-IN-02** The wallet **SHALL** maintain an internal distinction between the following input classes:

- authenticated requester context;
- verified WRPRC-derived information;
- verified Register-derived information;
- self-declared request or metadata information.

**AUTHZ-IN-03** The wallet **SHALL** treat authenticated requester context as authoritative only for the identity of the technical requester.

**AUTHZ-IN-04** The wallet **SHALL** treat verified WRPRC-derived information and verified Register-derived information as authoritative for:

- subject identity;
- entitlements;
- intended use;
- registered attributes or scope;
- intermediary relationship data, where relevant;
- issuance-type information, where relevant;
- privacy-policy references, where available;
- subject status.

**AUTHZ-IN-05** The wallet **SHALL NOT** rely solely on self-declared request or metadata information for authorization checks that require registered information.

## 3.3 Conflict handling

**AUTHZ-IN-06** Where authoritative sources conflict with non-authoritative sources, the authoritative sources **SHALL** prevail.

**AUTHZ-IN-07** Where the authenticated requester context conflicts with the identity or intermediary binding expressed in the verified authorization context, the wallet **SHALL** produce the authorization decision `NOT_AUTHORIZED`.

**AUTHZ-IN-08** The `NOT_AUTHORIZED` decision produced under `AUTHZ-IN-07` **SHALL** be non-overridable.

## 3.4 Minimum requester-context fields

**AUTHZ-IN-09** When the authorization process starts, the wallet **SHALL** already have access to requester context derived from the prior authentication step, including at least:

- requester identifier; and
- requester name, where available.

## 3.5 Minimum WRPRC- and/or Register-derived fields

**AUTHZ-IN-10** From the WRPRC or the Register, the wallet **SHALL** derive at least:

- subject identifier (`sub`);
- user-facing name, where available;
- entitlement information;
- subject status.

**AUTHZ-IN-11** Where relevant to the scenario, the wallet **SHALL** also derive:

- `registry_uri` or equivalent Register endpoint reference;
- intended use identifier, where available;
- intended use description or purpose;
- registered attributes, claims, or credential scope for the intended use;
- privacy-policy reference, where available;
- intermediary relationship data, where relevant;
- issuance-type information, where relevant;
- WRPRC status information, where available.

## 3.6 Minimum direct-presentation request fields

**AUTHZ-IN-12** For each direct presentation request, the wallet **SHALL** be able to process the following RP information:

- RP user-friendly name;
- RP unique identifier;
- RP user-friendly intended-use description;
- RP Registrar URL or equivalent Register endpoint hint;
- RP intended-use identifier, where available;
- requested attributes, claims, or credential selectors;
- RP WRPRC by value, where available.

## 3.7 Minimum intermediated-presentation request fields

**AUTHZ-IN-13** For each intermediated presentation request, the wallet **SHALL** be able to process the following information about the final RP:

- final RP user-friendly name;
- final RP unique identifier;
- final RP Registrar URL or equivalent Register endpoint hint;
- final RP intended-use identifier, where available;
- final RP user-friendly intended-use description;
- final RP WRPRC by value, where available;
- requested attributes, claims, or credential selectors.

## 3.8 Minimum issuance fields

**AUTHZ-IN-14** For issuance, the wallet **SHALL** be able to process the following information from Credential Issuer Metadata and related structures:

- provider identifier from authenticated requester context;
- provider WRPRC by value, where available;
- Registrar URI or `registry_uri`, where available;
- provider entitlement information;
- PID type or attestation type to be issued;
- issuance metadata describing the credential family;
- EDP by value, where applicable to attestation issuance.

## 3.9 Extended fields

**AUTHZ-IN-15** Where available, the wallet **SHOULD** also derive and use:

- `privacy_policy`;
- `support_uri` or equivalent support reference;
- data-deletion request channels;
- supervisory-authority name and country;
- supervisory-authority contact channels;
- `purpose`;
- `intended_use_id`;
- `credentials[*].format`;
- `credentials[*].meta`;
- `credentials[*].claim`;
- `provides_attestations[*]`;
- `intermediary.*`.

# 4. Common authorization process

## 4.1 Processing order

**AUTHZ-GEN-13** The wallet **SHALL** execute authorization processing in the following order:

1. resolve the authorization context;
2. determine the interaction type and authorization subject;
3. verify coherence between authenticated requester context and authorization context;
4. verify registration status and linkage relevant to authorization;
5. evaluate role or entitlement basis;
6. evaluate declared scope, where relevant;
7. evaluate EDP, where relevant;
8. generate advisories, where applicable;
9. render Wallet User transparency information;
10. produce the authorization decision.

## 4.2 Authorization-context resolution

**AUTHZ-GEN-14** Where a WRPRC is available, the wallet **SHALL** verify its authenticity and validity before relying on it.

**AUTHZ-GEN-15** WRPRC validation under `AUTHZ-GEN-14` **SHALL** include, as applicable:

- verification of the signature or seal;
- verification of certificate-chain or trust-anchor requirements applicable to WRPRC validation;
- verification of the temporal validity of the WRPRC;
- verification of the WRPRC status through the applicable status mechanism;
- verification that the WRPRC subject and fields are coherent with the scenario.

**AUTHZ-GEN-16** Where no WRPRC is available, or where the WRPRC cannot be relied upon, the wallet **SHALL** query the Register whenever authorization requires registered information.

**AUTHZ-GEN-17** The wallet **SHALL NOT** treat a request-carried Registrar URL as sufficient proof of registered information by itself.

**AUTHZ-GEN-18** A request-carried Registrar URL or equivalent Register endpoint hint **MAY** be used only as a discovery hint, unless it is itself confirmed by an authoritative source.

## 4.3 Register retrieval and validation

**AUTHZ-REG-01** Where Register resolution is used, the wallet **SHALL** retrieve Register information through the relevant machine-processable Register interface.

**AUTHZ-REG-02** The wallet **SHALL** verify the authenticity and integrity of the Register response before relying on it.

**AUTHZ-REG-03** The wallet **SHALL** verify that the Register response pertains to the relevant authorization subject and, where applicable, to the relevant intended use.

**AUTHZ-REG-04** The wallet **SHALL** verify, where relevant to the scenario:

- subject status;
- intended-use status;
- entitlement information;
- registered attributes or registered scope;
- intermediary relationship data;
- issuance-type information.

**AUTHZ-REG-05** The wallet **SHALL** normalize Register-derived information into the same internal authorization model used for WRPRC-derived processing.

## 4.4 Coherence verification

**AUTHZ-GEN-19** Where both requester-derived authenticated context and a WRPRC or Register-derived authorization context are present, the wallet **SHALL** verify that they are coherent through matching identifiers or equivalent registered bindings.

**AUTHZ-GEN-20** In intermediated presentation, the wallet **SHALL** verify that the authenticated intermediary identity matches the intermediary binding contained in the verified WRPRC or in the verified Register-derived authorization context for the final RP.

**AUTHZ-GEN-21** If the coherence verification under `AUTHZ-GEN-19` or `AUTHZ-GEN-20` fails, the wallet **SHALL** produce the authorization decision `NOT_AUTHORIZED`.

**AUTHZ-GEN-22** The `NOT_AUTHORIZED` decision produced under `AUTHZ-GEN-21` **SHALL** be non-overridable.

## 4.5 Registration-status verification

**AUTHZ-GEN-23** The wallet **SHALL** verify that the authorization subject is registered and active.

**AUTHZ-GEN-24** The wallet **SHALL** distinguish between:

- registration status of the authorization subject; and
- status or validity of the WRPRC, where a WRPRC is used.

**AUTHZ-GEN-25** If the wallet cannot confirm the active registration status of the authorization subject where such confirmation is required for authorization, the wallet **SHALL** produce the authorization decision `NOT_AUTHORIZED`.

**AUTHZ-GEN-26** The `NOT_AUTHORIZED` decision produced under `AUTHZ-GEN-25` **SHALL** be non-overridable.

# 5. Issuance authorization profile

## 5.1 Scope

This clause applies to issuance authorization for:

- PID issuance by a PID Provider; and
- attestation issuance by an AP.

## 5.2 Authorization precondition

**AUTHZ-ISS-01** Before the issuance authorization process starts, the PID Provider or AP **SHALL** already have been authenticated according to the applicable authentication rules.

## 5.3 Exchanged and resolved elements

The following elements **SHALL** be exchanged or resolved in issuance authorization:

- Credential Issuer Metadata;
- provider identifier from authenticated requester context;
- provider WRPRC by value, where available;
- Registrar URI or `registry_uri`, where available;
- entitlement information;
- PID or attestation type information;
- EDP by value, where applicable to attestation issuance.

## 5.4 Provider-role verification for PID issuance

**AUTHZ-ISS-02** After successful requester authentication, the wallet **SHALL** apply the following order of authorization verification before requesting issuance of a PID:

1. inspect the entitlement member in the provider WRPRC, if provided in the Credential Issuer Metadata, and verify the authenticity and validity of the WRPRC;
2. if no WRPRC is present or the WRPRC cannot be relied upon, query the responsible Registrar for the registered entitlement value using the Registrar URI or `registry_uri`, if possible;
3. if querying the Registrar is not possible, the wallet **MAY** inspect the entitlement member included in the Credential Issuer Metadata itself as self-declared fallback information only for advisory purposes.

**AUTHZ-ISS-03** If the procedure in `AUTHZ-ISS-02` does not confirm that the provider is registered as a PID Provider, the wallet **SHALL**:

- generate an advisory explaining that the provider role could not be confirmed; and
- produce the authorization decision `NOT_AUTHORIZED`.

**AUTHZ-ISS-04** The `NOT_AUTHORIZED` decision produced under `AUTHZ-ISS-03` **SHALL** be non-overridable.

## 5.5 Provider-role verification for attestation issuance

**AUTHZ-ISS-05** After successful requester authentication, the wallet **SHALL** apply the following order of authorization verification before requesting issuance of an attestation:

1. inspect the entitlement member in the provider WRPRC, if provided in the Credential Issuer Metadata, and verify the authenticity and validity of the WRPRC;
2. if no WRPRC is present or the WRPRC cannot be relied upon, query the responsible Registrar for the registered entitlement value using the Registrar URI or `registry_uri`, if possible;
3. if querying the Registrar is not possible, the wallet **MAY** inspect the entitlement member included in the Credential Issuer Metadata itself as self-declared fallback information only for advisory purposes.

**AUTHZ-ISS-06** If the procedure in `AUTHZ-ISS-05` does not confirm that the provider is registered in the relevant attestation-provider role, the wallet **SHALL**:

- generate an advisory explaining that the provider role could not be confirmed; and
- produce the authorization decision `NOT_AUTHORIZED`.

**AUTHZ-ISS-07** The `NOT_AUTHORIZED` decision produced under `AUTHZ-ISS-06` **SHALL** be non-overridable.

## 5.6 Self-declared fallback rule

**AUTHZ-ISS-08** Where entitlement information is taken from Credential Issuer Metadata rather than from a verified WRPRC or the Register, the wallet **SHALL** treat that information as self-declared fallback information.

**AUTHZ-ISS-09** The wallet **SHALL NOT** present self-declared entitlement information as verified registration information.

**AUTHZ-ISS-10** Self-declared fallback information **SHALL NOT** be sufficient on its own to produce an `AUTHORIZED` decision where role confirmation is required by this profile.

## 5.7 Metadata signature and authorization linkage

**AUTHZ-ISS-11** For attestation issuance, where Credential Issuer Metadata is signed, the wallet **SHALL** verify that the metadata signature and the associated certificate linkage satisfy the authorization-relevant requirements needed to rely on the metadata.

**AUTHZ-ISS-12** If the checks in `AUTHZ-ISS-11` fail, the wallet **SHALL** produce the authorization decision `NOT_AUTHORIZED`.

**AUTHZ-ISS-13** The `NOT_AUTHORIZED` decision produced under `AUTHZ-ISS-12` **SHALL** be non-overridable.

## 5.8 Verification of issuance type

**AUTHZ-ISS-14** The wallet **SHALL** verify that the PID or attestation type it is about to request is registered for the provider.

**AUTHZ-ISS-15** Where issuance-type granularity is available in the WRPRC or Register, the wallet **SHALL** compare the requested PID or attestation type against the registered issuance-type information.

**AUTHZ-ISS-16** If the wallet cannot confirm that the requested PID or attestation type is registered for the provider, the wallet **SHALL** produce the authorization decision `NOT_AUTHORIZED`.

**AUTHZ-ISS-17** The `NOT_AUTHORIZED` decision produced under `AUTHZ-ISS-16` **SHALL** be non-overridable.

## 5.9 EDP retrieval during issuance

**AUTHZ-ISS-18** During attestation issuance, if an EDP is present in issuer metadata, the wallet **SHALL** retrieve it by value and store it locally with the attestation context.

**AUTHZ-ISS-19** The wallet **SHALL NOT** expect PID issuance to contain EDP.

## 5.10 Issuance authorization steps

**AUTHZ-ISS-20** The wallet **SHALL** execute the following issuance authorization steps:

1. receive Credential Issuer Metadata and issuance parameters;
2. identify the authenticated technical requester from requester context;
3. resolve provider WRPRC, if available;
4. if WRPRC is available, verify its authenticity, validity, status, subject coherence, and entitlement information;
5. if WRPRC is not available or cannot be relied upon, query the Register using the Registrar URI or `registry_uri`, if possible;
6. if the Register cannot be queried, optionally inspect self-declared entitlement from Credential Issuer Metadata as non-authoritative fallback information;
7. verify that the provider role matches the issuance being requested;
8. verify that the requested PID or attestation type is registered;
9. where applicable, verify metadata signature and EDP packaging requirements;
10. generate advisories, where applicable;
11. produce the authorization decision.

## 5.11 Issuance sequence diagram

~~~mermaid
sequenceDiagram
    autonumber
    participant Wallet as Wallet Unit
    participant Issuer as PID Provider / AP
    participant Status as WRPRC Status List
    participant Register as National Register / Registrar

    Note over Wallet,Issuer: Precondition: technical requester already authenticated
    Issuer->>Wallet: Credential Issuer Metadata + issuance parameters + optional WRPRC + optional EDP
    Wallet->>Wallet: Identify authorization subject = issuer

    alt WRPRC included
        Wallet->>Wallet: Verify WRPRC signature, validity, subject coherence
        Wallet->>Status: Resolve WRPRC status
        Status-->>Wallet: WRPRC status
        alt WRPRC reliable
            Wallet->>Wallet: Extract entitlements, issuance types, registry_uri
        else WRPRC not reliable
            Wallet->>Register: Query authoritative registration data
            Register-->>Wallet: Verified Register response
        end
    else No WRPRC
        Wallet->>Register: Query authoritative registration data
        Register-->>Wallet: Verified Register response
    end

    Wallet->>Wallet: Normalize authorization context
    Wallet->>Wallet: Verify provider role
    Wallet->>Wallet: Verify requested PID / attestation type

    opt Attestation issuance
        Wallet->>Wallet: Verify metadata signature / linkage
        Wallet->>Wallet: Retrieve and store EDP if present
    end

    alt Authorization positive
        Wallet->>Issuer: Request issuance
        Issuer-->>Wallet: PID / Attestation
    else Authorization negative
        Wallet->>Wallet: Produce NOT_AUTHORIZED
    end
~~~

# 6. Direct presentation authorization profile

## 6.1 Scope

This clause applies to direct presentation authorization between the Wallet Unit and a direct RP.

## 6.2 Authorization precondition

**AUTHZ-PRES-01** Before the direct presentation authorization process starts, the RP **SHALL** already have been authenticated according to the applicable authentication rules.

## 6.3 Exchanged and resolved elements

The following elements **SHALL** be exchanged or resolved in direct presentation authorization:

- presentation request;
- RP requester context from prior authentication;
- RP WRPRC by value, where available;
- RP name, unique identifier, Registrar URL or equivalent Register endpoint hint, and intended-use data in the request;
- requested attributes, claims, or credential selectors;
- privacy-policy link, where available through WRPRC or Register.

## 6.4 Approval view content

**AUTHZ-PRES-02** If authorization processing starts, the Wallet Instance **SHALL** display to the Wallet User:

- the name of the RP as obtained from the authenticated requester context;
- the credential type and related attributes requested by the RP;
- the user-friendly description of the RP intended use, where available;
- the link to the applicable privacy policy, if available;
- advisories, where applicable.

## 6.5 Register verification and user verification option

**AUTHZ-REG-06** The wallet **SHALL** resolve authoritative registered information about the RP whenever such information is necessary to perform authorization checks required by this profile.

**AUTHZ-REG-07** In addition to the mandatory resolution under `AUTHZ-REG-06`, the wallet **SHALL** offer the Wallet User the possibility to request enhanced display of registered information about the RP.

**AUTHZ-REG-08** The Wallet User option under `AUTHZ-REG-07` **SHALL** affect transparency rendering only and **SHALL NOT** disable authorization checks that require authoritative registered information.

## 6.6 Verification path when WRPRC is present

**AUTHZ-REG-09** If an RP sends a WRPRC, the wallet **SHALL** verify the authenticity, validity, and status of the WRPRC before relying on it.

**AUTHZ-REG-10** If the verification in `AUTHZ-REG-09` is negative, the wallet **SHALL** disregard that WRPRC as an authoritative source and **SHALL** attempt Register resolution where authorization requires registered information.

**AUTHZ-REG-11** If authoritative registered information still cannot be obtained where required, the wallet **SHALL** produce the authorization decision `NOT_AUTHORIZED`.

**AUTHZ-REG-12** The `NOT_AUTHORIZED` decision produced under `AUTHZ-REG-11` **SHALL** be non-overridable.

## 6.7 Verification path when WRPRC is absent

**AUTHZ-REG-13** If no WRPRC is sent and authorization requires registered information, the wallet **SHALL** connect to the relevant Register interface to obtain the registered information.

**AUTHZ-REG-14** If the wallet cannot obtain or verify the registered information required for mandatory authorization checks, it **SHALL** produce the authorization decision `NOT_AUTHORIZED`.

**AUTHZ-REG-15** The `NOT_AUTHORIZED` decision produced under `AUTHZ-REG-14` **SHALL** be non-overridable.

## 6.8 Requested-attributes verification

**AUTHZ-PRES-03** Where the wallet has obtained authoritative registered information about the RP from a verified WRPRC or the Register, the wallet **SHALL** verify that the requested attributes, claims, or credential selectors are included in the registered list of attributes or in the registered scope for the relevant intended use.

**AUTHZ-PRES-04** If the verification in `AUTHZ-PRES-03` is negative, the wallet **SHALL**:

- produce the authorization decision `NOT_AUTHORIZED`;
- generate an advisory; and
- allow Wallet User override of that negative authorization decision.

## 6.9 Direct-presentation authorization steps

**AUTHZ-PRES-05** The wallet **SHALL** execute the following steps for direct presentation authorization:

1. receive presentation request and associated authenticated requester context;
2. identify the RP as authenticated technical requester;
3. display RP name and requested attributes for approval preparation;
4. extract RP name, unique identifier, Registrar URL or equivalent Register endpoint hint, intended-use identifier, and user-friendly intended-use description from the request;
5. if a WRPRC is included, verify its authenticity, validity, status, and coherence with the authenticated requester context;
6. if no reliable WRPRC is available and registered information is required, query the Register;
7. where authoritative registered information is available, compare requested attributes to the registered list or registered scope for the intended use;
8. show intended-use description and privacy-policy link, if available;
9. evaluate EDP, where applicable;
10. generate advisories, where applicable;
11. produce the authorization decision.

## 6.10 Direct-presentation negative authorization cases

**AUTHZ-PRES-06** The wallet **SHALL** produce the authorization decision `NOT_AUTHORIZED` where:

- the request is missing the minimum information needed to identify the RP or to evaluate EDP where EDP applies;
- mandatory authoritative registered information required for authorization cannot be obtained or relied upon;
- EDP evaluation is negative; or
- requested-attributes verification is negative as defined in `AUTHZ-PRES-04`.

## 6.11 Override rule for direct presentation

**AUTHZ-PRES-07** Wallet User override of `NOT_AUTHORIZED` in direct presentation **SHALL** be permitted only for:

- the case defined in `AUTHZ-PRES-04`; and
- the case defined in `AUTHZ-EDP-12`.

## 6.12 Direct-presentation sequence diagram

~~~mermaid
sequenceDiagram
    autonumber
    actor User as Wallet User
    participant Wallet as Wallet Unit
    participant RP as Direct RP
    participant Status as WRPRC Status List
    participant Register as National Register / Registrar

    Note over Wallet,RP: Precondition: RP already authenticated
    RP->>Wallet: Presentation request + requested claims/selectors + intended-use data + optional WRPRC
    Wallet->>Wallet: Identify authorization subject = RP
    Wallet-->>User: Show RP identity from authenticated context + requested attributes

    alt WRPRC included
        Wallet->>Wallet: Verify WRPRC signature, validity, subject coherence
        Wallet->>Status: Resolve WRPRC status
        Status-->>Wallet: WRPRC status
        alt WRPRC reliable
            Wallet->>Wallet: Extract intended use, registered scope, privacy policy
        else WRPRC not reliable
            Wallet->>Register: Query authoritative registration data
            Register-->>Wallet: Verified Register response
        end
    else No WRPRC
        Wallet->>Register: Query authoritative registration data
        Register-->>Wallet: Verified Register response
    end

    Wallet->>Wallet: Normalize authorization context
    Wallet->>Wallet: Compare requested claims/selectors against registered scope
    Wallet->>Wallet: Evaluate EDP where applicable
    Wallet-->>User: Show intended use, privacy policy, advisories, decision context

    alt Requested scope valid and EDP positive
        Wallet->>Wallet: Produce AUTHORIZED
        Wallet-->>User: Ask for normal approval
    else Over-asking or negative EDP
        Wallet->>Wallet: Produce NOT_AUTHORIZED
        Wallet-->>User: Show negative outcome + advisories + override option
    end
~~~

# 7. Intermediated presentation authorization profile

## 7.1 Scope

This clause applies to presentation authorization where the requester is an intermediary acting on behalf of a final RP.

## 7.2 Authorization precondition

**AUTHZ-INT-01** Before the intermediated presentation authorization process starts, the intermediary **SHALL** already have been authenticated according to the applicable authentication rules.

## 7.3 Exchanged and resolved elements

The following elements **SHALL** be exchanged or resolved in intermediated presentation authorization:

- presentation request sent by the intermediary;
- intermediary requester context from prior authentication;
- final RP WRPRC by value, where available;
- final RP user-friendly name;
- final RP unique identifier;
- final RP Registrar URL or equivalent Register endpoint hint;
- final RP intended-use identifier, where available;
- final RP user-friendly intended-use description;
- requested attributes and credential type.

## 7.4 Approval view content

**AUTHZ-INT-02** If authorization processing starts, the Wallet Instance **SHALL** display to the Wallet User:

- the name of the intermediary as obtained from authenticated requester context;
- the name of the final RP on whose behalf the request is made;
- the credential type and related attributes requested;
- the intended-use description, where available;
- the privacy-policy link, where available;
- advisories, where applicable.

## 7.5 Mandatory relationship and scope verification

**AUTHZ-INT-03** In intermediated presentation, the wallet **SHALL** verify whether the authenticated intermediary is the intermediary bound to the final RP in the verified WRPRC or in the verified Register-derived authorization context.

**AUTHZ-INT-04** The verification in `AUTHZ-INT-03` **MAY** be performed:

- by inspecting the final RP WRPRC where the intermediary relationship is conveyed; or
- by querying the Register.

**AUTHZ-INT-05** If the verification in `AUTHZ-INT-03` fails, the wallet **SHALL** produce the authorization decision `NOT_AUTHORIZED`.

**AUTHZ-INT-06** The `NOT_AUTHORIZED` decision produced under `AUTHZ-INT-05` **SHALL** be non-overridable.

**AUTHZ-INT-07** Where authoritative registered information about the final RP is available, the wallet **SHALL** verify that the requested attributes are included in the registered list of attributes or in the registered scope of the final RP for the relevant intended use.

**AUTHZ-INT-08** If the verification in `AUTHZ-INT-07` is negative, the wallet **SHALL**:

- produce the authorization decision `NOT_AUTHORIZED`;
- generate an advisory; and
- allow Wallet User override of that negative authorization decision.

## 7.6 Intermediated-presentation authorization steps

**AUTHZ-INT-09** The wallet **SHALL** execute the following steps for intermediated presentation authorization:

1. receive presentation request from the intermediary;
2. identify the intermediary as authenticated technical requester;
3. display intermediary name, final RP name, and requested attributes for approval preparation;
4. extract final RP name, unique identifier, Registrar URL or equivalent Register endpoint hint, intended-use identifier, and intended-use description from the request;
5. if a final RP WRPRC is included, verify its authenticity, validity, status, and subject coherence;
6. verify that the authenticated intermediary matches the intermediary binding in the verified authorization context for the final RP;
7. if no reliable WRPRC is available and registered information is required, query the Register;
8. where authoritative registered information is available, compare requested attributes to the registered list or registered scope of the final RP for the intended use;
9. show intended-use description and privacy-policy link, if available;
10. evaluate EDP using the final RP as authorization subject;
11. generate advisories, where applicable;
12. produce the authorization decision.

## 7.7 Final-RP field requirements

**AUTHZ-INT-10** In intermediated presentation, the information carried in the request for name, identifier, Registrar URL, intended-use identifier, and intended-use description **SHALL** pertain to the final RP, not to the intermediary.

## 7.8 Intermediated-presentation negative authorization cases

**AUTHZ-INT-11** The wallet **SHALL** produce the authorization decision `NOT_AUTHORIZED` where:

- the request is missing the minimum information needed to identify the final RP or to evaluate EDP where EDP applies;
- the authenticated intermediary cannot be matched to the intermediary binding of the final RP in the authoritative authorization context;
- mandatory authoritative registered information required for authorization cannot be obtained or relied upon;
- EDP evaluation is negative; or
- requested-attributes verification against the registered list or registered scope of the final RP is negative.

## 7.9 Override rule for intermediated presentation

**AUTHZ-INT-12** Wallet User override of `NOT_AUTHORIZED` in intermediated presentation **SHALL** be permitted only for:

- negative requested-attributes verification against the registered list or registered scope of the final RP; and
- the case defined in `AUTHZ-EDP-12`.

## 7.10 Intermediated-presentation sequence diagram

~~~mermaid
sequenceDiagram
    autonumber
    actor User as Wallet User
    participant Wallet as Wallet Unit
    participant Int as Intermediary
    participant Status as WRPRC Status List
    participant Register as National Register / Registrar

    Note over Wallet,Int: Precondition: intermediary already authenticated
    Int->>Wallet: Presentation request on behalf of final RP + final RP data + requested claims/selectors + optional final RP WRPRC
    Wallet->>Wallet: Identify technical requester = intermediary
    Wallet->>Wallet: Identify authorization subject = final RP
    Wallet-->>User: Show intermediary identity + final RP identity + requested attributes

    alt Final RP WRPRC included
        Wallet->>Wallet: Verify WRPRC signature, validity, final-RP subject coherence
        Wallet->>Status: Resolve WRPRC status
        Status-->>Wallet: WRPRC status
        alt WRPRC reliable
            Wallet->>Wallet: Extract final RP intended use, registered scope, intermediary binding
        else WRPRC not reliable
            Wallet->>Register: Query authoritative registration data for final RP
            Register-->>Wallet: Verified Register response
        end
    else No WRPRC
        Wallet->>Register: Query authoritative registration data for final RP
        Register-->>Wallet: Verified Register response
    end

    Wallet->>Wallet: Normalize authorization context
    Wallet->>Wallet: Verify authenticated intermediary matches registered intermediary binding
    Wallet->>Wallet: Compare requested claims/selectors against final RP registered scope
    Wallet->>Wallet: Evaluate EDP using final RP as authorization subject
    Wallet-->>User: Show final RP intended use, privacy policy, advisories, decision context

    alt Binding valid and scope valid and EDP positive
        Wallet->>Wallet: Produce AUTHORIZED
        Wallet-->>User: Ask for normal approval
    else Binding failure
        Wallet->>Wallet: Produce NOT_AUTHORIZED (non-overridable)
    else Over-asking or negative EDP
        Wallet->>Wallet: Produce NOT_AUTHORIZED
        Wallet-->>User: Show negative outcome + advisories + override option
    end
~~~

# 8. Register resolution and verification profile

## 8.1 General rule

**AUTHZ-REG-16** The wallet **SHALL** support Register-based resolution and verification wherever this profile requires authoritative registered information.

## 8.2 Trigger conditions

**AUTHZ-REG-17** Register access **SHALL** be used where:

- no reliable WRPRC is available and the scenario requires registered information;
- WRPRC verification is negative and authorization still requires registered information;
- presentation-scope verification requires authoritative registered attributes or scope;
- intermediary-binding verification requires authoritative relationship data;
- issuance-role confirmation requires Register lookup because no reliable WRPRC is present;
- issuance-type confirmation requires authoritative registered issuance-type information.

## 8.3 Register-derived minimum data

**AUTHZ-REG-18** When Register verification is used, the wallet **SHALL** retrieve, as relevant to the scenario:

- subject identity;
- subject status;
- entitlements;
- registered attributes or scope for the intended use;
- privacy-policy link, where available;
- intermediary relationship data, where relevant;
- issuance-type information, where relevant;
- intended-use status, where relevant.

## 8.4 Validation of Register response

**AUTHZ-REG-19** The wallet **SHALL** verify the authenticity and integrity of the Register response before relying on it.

**AUTHZ-REG-20** The wallet **SHALL** verify that the Register response is coherent with:

- the authorization subject;
- the intended use, where relevant; and
- the authenticated requester context, where relevant.

## 8.5 Normalization rule

**AUTHZ-REG-21** The wallet **SHALL** normalize Register-derived information into the same internal authorization model used for WRPRC-derived processing.

# 9. Embedded Disclosure Policy profile

## 9.1 Scope

This clause applies to EDP carried by attestation-related metadata and evaluated during presentation authorization.

## 9.2 Optionality in issuance

**AUTHZ-EDP-01** The wallet **SHALL** support that an AP **MAY** include an EDP for a QEAA, PuB-EAA, or non-qualified EAA.

**AUTHZ-EDP-02** The wallet **SHALL NOT** assume that PIDs contain EDP.

## 9.3 Storage rule

**AUTHZ-EDP-03** During attestation issuance, the wallet **SHALL** retrieve and store locally the corresponding EDP, if any.

## 9.4 Authorised relying parties only policy

**AUTHZ-EDP-04** The wallet **SHALL** support EDP implementing the authorised relying parties only policy.

**AUTHZ-EDP-05** For direct presentation, the wallet **SHALL** compare the RP unique identifier with the list of authorised identifiers in the EDP.

**AUTHZ-EDP-06** For intermediated presentation, the wallet **SHALL** compare the unique identifier of the final RP, obtained from the presentation request, the final RP WRPRC, or the Register, with the list of authorised identifiers in the EDP.

## 9.5 Specific root of trust policy

**AUTHZ-EDP-07** The wallet **SHALL** support EDP implementing the specific root of trust policy.

**AUTHZ-EDP-08** For direct presentation, the wallet **SHALL** compare the authorization-relevant certificate-chain information associated with the RP with the list of authorised root or intermediate certificates in the EDP.

**AUTHZ-EDP-09** For intermediated presentation, the wallet **SHALL** retrieve the root or relevant authorization certificate-chain information associated with the final RP from the applicable authoritative input and compare it to the list of authorised certificates in the EDP.

## 9.6 Explanatory link

**AUTHZ-EDP-10** If an EDP contains a link to an explanatory website, the wallet **SHALL** display that link to the Wallet User and allow navigation to it.

## 9.7 Policy decision rule

**AUTHZ-EDP-11** The wallet **SHALL** evaluate EDP together with the information received from the requesting RP in order to determine whether the RP or final RP has permission from the AP to access the requested attestation.

**AUTHZ-EDP-12** If EDP evaluation is negative, the wallet **SHALL**:

- produce the authorization decision `NOT_AUTHORIZED`;
- present the negative policy outcome to the Wallet User when asking for approval; and
- allow Wallet User override of that negative authorization decision.

# 10. Wallet User transparency and approval semantics

## 10.1 General transparency rule

**AUTHZ-UI-10** The authorization process **SHALL** support transparent Wallet User decision-making and **SHALL NOT** be implemented as a purely hidden backend check.

## 10.2 Minimum transparency set for presentation

**AUTHZ-UI-11** For presentation interactions, the wallet **SHALL** show the Wallet User at least:

- RP identity or final RP identity as applicable;
- intermediary identity, where applicable;
- requested attributes;
- intended-use description, where available;
- privacy-policy link, where available;
- advisories, where applicable.

## 10.3 Authorization-decision rendering rule

**AUTHZ-UI-12** If the authorization decision is `AUTHORIZED`, the wallet **SHALL** proceed to the normal Wallet User approval step of the flow.

**AUTHZ-UI-13** If the authorization decision is `NOT_AUTHORIZED`, the wallet **SHALL** clearly indicate that the wallet-side authorization outcome is negative.

## 10.4 Override rendering rule

**AUTHZ-UI-14** If the authorization decision is `NOT_AUTHORIZED` and override is allowed under this profile, the wallet **SHALL** present the Wallet User with the negative outcome and the relevant advisories and **MAY** allow the Wallet User to continue.

**AUTHZ-UI-15** If the authorization decision is `NOT_AUTHORIZED` and override is not allowed under this profile, the wallet **SHALL NOT** allow the Wallet User to continue.

## 10.5 Non-overridable cases

**AUTHZ-UI-16** The following cases **SHALL NOT** be overridable by the Wallet User:

- failure to confirm that a PID Provider is registered as PID Provider before PID issuance;
- failure to confirm that an AP is registered in the relevant attestation-provider role before attestation issuance;
- failure to confirm the registered type of PID or attestation where such confirmation is required;
- failure to confirm the active registration status of the authorization subject where such confirmation is required;
- failure of coherence verification between authenticated requester context and authoritative authorization context;
- failure to confirm the intermediary binding in intermediated presentation;
- missing minimum request information where this prevents mandatory authorization checks;
- failure to obtain or verify authoritative registered information where such information is required for authorization;
- negative authorization cases not explicitly listed as overridable in this profile.