This section specifies the <artifacts:Embedded Disclosure Policy (EDP)|Embedded Disclosure Policy> (<artifacts:Embedded Disclosure Policy (EDP)|EDP>) for the <components:EUDI Wallet> ecosystem. It defines the following aspects:

- What an <artifacts:Embedded Disclosure Policy (EDP)|EDP> is, and which policy types are supported.
- The data model and structure.
- The distribution mechanism.
- The lifecycle rules.

The authorization evaluation logic that the WI applies when processing an <artifacts:Embedded Disclosure Policy (EDP)|EDP> during presentation is defined in the [Authorization Process](#authorization-process) section of this specification.

#### Definition and Applicability

An <artifacts:Embedded Disclosure Policy (EDP)|Embedded Disclosure Policy> is defined in Article 2(9) of [CIR 2024/2979] as:

*"A set of rules, embedded in an electronic attestation of attributes by its provider, that indicates the conditions that a wallet-relying party has to meet to access the electronic attestation of attributes"*.

The <artifacts:Embedded Disclosure Policy (EDP)|EDP> allows APs to indicate which RPs can access specific Attestations. APs can optionally express an <artifacts:Embedded Disclosure Policy (EDP)|EDP> for their Attestations (EDP_01). The Article 10 of [CIR 2024/2979] establishes that <roles:Wallet Provider (WP)|Wallet Providers> SHALL ensure that Attestations with common EDPs (as listed in Annex III of [CIR 2024/2979]) can be processed by their <components:Wallet Instance|Wallet Instances>.

EDPs are applicable to <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAAs>, <credentials:Public Electronic Attestation of Attributes (PuB-EAA)|PuB-EAAs>, and <credentials:Electronic Attestation of Attributes (EAA)|non-qualified EAAs>. They are not applicable to <credentials:Person Identification Data (PID)|PIDs> as the <components:EUDI Wallet> Regulation does not provide any requirement for <credentials:Person Identification Data (PID)|PIDs> to contain an <artifacts:Embedded Disclosure Policy (EDP)|EDP> (EDP_01 note).

The main use cases enabled by <artifacts:Embedded Disclosure Policy (EDP)|EDPs> are:

- Implementing sector-specific access control (e.g., only public sector RPs or only healthcare RPs).
- Implementing Member-State-specific access control (e.g., only RPs registered within a specific Member State).

#### Policy Types

Annex III of [CIR 2024/2979] defines three common <artifacts:Embedded Disclosure Policy (EDP)|EDP> types:

**No Policy.** No <artifacts:Embedded Disclosure Policy (EDP)|EDP> is present, or the <artifacts:Embedded Disclosure Policy (EDP)|EDP> explicitly indicates that no restrictions apply (ISS-MDATA-EBD-4.2.5.2-06).

**Authorized Relying Parties Only.** The <artifacts:Embedded Disclosure Policy (EDP)|EDP> contains a list of RPs that are allowed to access the Attestation. According to [ETSI TS 119 472-3] (ISS-MDATA-EBD-4.2.5.2-07), authorized RPs are identified by their subject distinguished name as held in the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>, in LDAP string form as defined in RFC 4514.
For legal persons, the relevant DN attributes are `commonName`, `organizationName`, `organizationIdentifier`, and `countryName`.
For natural persons: `commonName`, `givenName`, `surname`, `serialNumber`, and `countryName`. The organizationIdentifier attribute type is represented by the LDAP string "ORGID"; the serialNumber attribute type is represented by "SN" (according to [ETSI TS 119 472-3] NOTE 1 and NOTE 2 to ISS-MDATA-EBD-4.2.5.2-07).

!!! note

    [ETSI TS 119 472-3] (ISS-MDATA-EBD-4.2.5.2-07) also allows identifying authorized RPs by URI-encoded entitlements as specified in [ETSI TS 119 475], held in the <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC>. [ETSI TS 119 475, Annex A.3] defines sub-entitlements for Service Providers, currently for Payment Service Providers (e.g. `https://uri.etsi.org/19475/SubEntitlement/psp/psp-ai`). Future versions may include additional sector-specific sub-entitlements at national or EU level. This specification supports both the subject DN and the entitlement URI identification mechanisms.

!!! note

    [ARF] HLR EDP_02 refers to "EU-wide unique identifiers", as defined in Reg_32, for the authorized RP list. [ETSI TS 119 472-3] (ISS-MDATA-EBD-4.2.5.2-07) identifies authorized RPs by their subject DN from the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>. The organizationIdentifier attribute within the DN has the same semantics as the identifier given in Reg_32. This specification aligns with the [ETSI TS 119 472-3] formulation. Future ARF versions are expected to align accordingly.

**Specific Root of Trust.** The <artifacts:Embedded Disclosure Policy (EDP)|EDP> contains a list of trusted roots or intermediate certificates. Only RPs whose <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs> chain to one of these roots are allowed to access the Attestation. According to [ETSI TS 119 472-3] (ISS-MDATA-EBD-4.2.5.2-08/09), each authorized root is identified by its issuer distinguished name in LDAP string form as defined in RFC 4514 and the issuer's certificate serial number.

#### Data Model

The data model of the <artifacts:Embedded Disclosure Policy (EDP)|EDP> is defined in [ETSI TS 119 472-3, Section 4.2.5.2] through requirements ISS-MDATA-EBD-4.2.5.2-01 to ISS-MDATA-EBD-4.2.5.2-13.

##### Data Model Requirements

The data model defines the following elements:

- The <artifacts:Embedded Disclosure Policy (EDP)|EDP> SHALL be identified by a unique URI (ISS-MDATA-EBD-4.2.5.2-01). The <artifacts:Embedded Disclosure Policy (EDP)|EDP> MAY be accessible through this URI (ISS-MDATA-EBD-4.2.5.2-02).
- The <artifacts:Embedded Disclosure Policy (EDP)|EDP> association with an EAA SHALL be established by including its unique URI. The AP SHALL either include the URI together with the full policy data set, or provide only the URI if the policy data set has already been pre-loaded into the WI (ISS-MDATA-EBD-4.2.5.2-03).
- The <artifacts:Embedded Disclosure Policy (EDP)|EDP> MAY include a description of the applicability of the policy to a particular community and/or class of application with common security requirements (ISS-MDATA-EBD-4.2.5.2-04).
- The <artifacts:Embedded Disclosure Policy (EDP)|EDP> MAY include an identifier of the authority responsible for the policy (ISS-MDATA-EBD-4.2.5.2-05).
- The <artifacts:Embedded Disclosure Policy (EDP)|EDP> MAY indicate that no policy restrictions apply for the associated EAA (ISS-MDATA-EBD-4.2.5.2-06).
- The <artifacts:Embedded Disclosure Policy (EDP)|EDP> MAY contain a list of authorized RPs, identified by subject DN as described in the *Policy Types* section (ISS-MDATA-EBD-4.2.5.2-07).
- The <artifacts:Embedded Disclosure Policy (EDP)|EDP> MAY define a specific list of roots of trust, identified by issuer DN and certificate serial number (ISS-MDATA-EBD-4.2.5.2-08/09).
- Other information MAY be included in an <artifacts:Embedded Disclosure Policy (EDP)|EDP> Extension which MAY be ignored by the WI (ISS-MDATA-EBD-4.2.5.2-10). The WI SHOULD be able to process the <artifacts:Embedded Disclosure Policy (EDP)|EDP> even if unrecognized extensions are present (ISS-MDATA-EBD-4.2.5.2-11).
- An <artifacts:Embedded Disclosure Policy (EDP)|EDP> Extension MAY contain alternative policy rules to be applied to specified attributes within the EAA which are subject to <processes:Selective Disclosure> (ISS-MDATA-EBD-4.2.5.2-12).
- The <artifacts:Embedded Disclosure Policy (EDP)|EDP> SHOULD contain a link to a website of the AP explaining the disclosure policy in layman's terms (ISS-MDATA-EBD-4.2.5.2-13, EDP_05).

!!! note

    [ETSI TS 119 472-3] (ISS-MDATA-EBD-4.2.5.2-12) provides for attribute-level policies, where alternative policy rules (no policy, authorized RP only, or specific root of trust) can be defined for specific attributes within an EAA that are subject to <processes:Selective Disclosure>. This capability is recognized but is not further detailed in this specification. Detailed handling of attribute-level <artifacts:Embedded Disclosure Policy (EDP)|EDP> will be addressed when the ETSI JSON schema for <artifacts:Embedded Disclosure Policy (EDP)|EDP> is finalized and the policy mechanisms are fully defined.

##### Structure and Encoding

The following JSON structure is derived from the [ETSI TS 119 472-3] data model requirements.

!!! warning

    The JSON schema and the parameter names are defined in this section and are not based on a normative ETSI specification. [ETSI TS 119 472-3, Section 4.2.5.2] defines the high level requirements for data model, but the final JSON schema will be published separately by ETSI (see [ETSI TS 119 472-3, Annex C]). The structure defined here is an implementation profile based on the ETSI data model requirements, and parameter names MAY change when the ETSI schema is published.

| Parameter | Type | Description | Based on |
|-----------|------|-------------|----------|
| `policy_uri` | string (URI) | REQUIRED. Unique identifier of the <artifacts:Embedded Disclosure Policy (EDP)\|EDP>. | ISS-MDATA-EBD-4.2.5.2-01 |
| `policy_type` | string | REQUIRED. Policy type. Values: `"no_policy"`, `"authorized_rp_only"`, `"specific_root_of_trust"`. | ISS-MDATA-EBD-4.2.5.2-06/07/08 |
| `description` | string | OPTIONAL. Description of the applicability of the policy to a particular community or class of application. | ISS-MDATA-EBD-4.2.5.2-04 |
| `policy_authority` | string | OPTIONAL. Identifier of the authority responsible for the policy. | ISS-MDATA-EBD-4.2.5.2-05 |
| `policy_info_url` | string (URL) | OPTIONAL. Link to a website explaining the policy in layman's terms. | ISS-MDATA-EBD-4.2.5.2-13, EDP_05 |
| `authorized_parties` | array of objects | REQUIRED if `policy_type` is `"authorized_rp_only"`. List of authorized RPs. | ISS-MDATA-EBD-4.2.5.2-07 |
| `authorized_parties[].subject_dn` | string | OPTIONAL. Subject DN of the RP from the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>, in LDAP string form as defined in RFC 4514. At least one of `subject_dn` or `entitlement_uri` SHALL be present in each element. | ISS-MDATA-EBD-4.2.5.2-07 |
| `authorized_parties[].entitlement_uri` | string (URI) | OPTIONAL. URI-encoded entitlement or sub-entitlement as specified in [ETSI TS 119 475, Annex A], held in the <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>. At least one of `subject_dn` or `entitlement_uri` SHALL be present in each element. | ISS-MDATA-EBD-4.2.5.2-07 |
| `trusted_roots` | array of objects | REQUIRED if `policy_type` is `"specific_root_of_trust"`. List of trusted roots. | ISS-MDATA-EBD-4.2.5.2-08 |
| `trusted_roots[].issuer_dn` | string | REQUIRED. Issuer DN in LDAP string form compliant with RFC 4514. | ISS-MDATA-EBD-4.2.5.2-09 |
| `trusted_roots[].serial_number` | string | REQUIRED. Certificate serial number of the issuer. | ISS-MDATA-EBD-4.2.5.2-09 |

#### Distribution

The <artifacts:Embedded Disclosure Policy (EDP)|EDP> is distributed through <artifacts:Credential Issuer Metadata> at issuance time. The <roles:Attestation Provider (AP)|AP> SHALL include the <artifacts:Embedded Disclosure Policy (EDP)|EDP> (if any) by value in the Issuer Metadata, within the `credential_configurations_supported` parameter, in compliance with [OpenID4VCI] or the extension thereof specified in [ETSI TS 119 472-3] (EDP_09). The <artifacts:Embedded Disclosure Policy (EDP)|EDP> SHALL NOT be revealed to the <roles:Relying Party (RP)|RP> through the presentation protocol (per [ETSI TS 119 472-3, Section 4.2.5.1]).

!!! warning

    According to ISS-MDATA-EBD-4.2.5.2-03, the <roles:Attestation Provider (AP)|AP> may provide only the `policy_uri` if the policy data set has already been pre-loaded into the <components:Wallet Instance|WI>. As the mechanism for pre-loading policies into a <components:Wallet Instance|WI> is not specified in the current normative references, this option SHALL be considered out-of-scope of this specification, at least until further implementation details are provided by ETSI.

As described in section [Authorization Process](#authorization-process), during attestation issuance, the <artifacts:Embedded Disclosure Policy (EDP)|EDP> (if available) is stored locally by the <components:Wallet Instance|WI> and it is associated with the specific Attestation for which it was retrieved.

#### Lifecycle

##### Validity Binding

The locally stored <artifacts:Embedded Disclosure Policy (EDP)|EDP> SHALL remain valid as long as the Attestation it is associated with is valid and not revoked. The <artifacts:Embedded Disclosure Policy (EDP)|EDP> SHALL NOT have an independent validity status or revocation mechanism separate from the Attestation.

##### Update Mechanism

If an <roles:Attestation Provider (AP)|AP> adds, changes, or deletes an <artifacts:Embedded Disclosure Policy (EDP)|EDP> for an <credentials:Attestation>, the <roles:Attestation Provider (AP)|AP> SHALL revoke that <credentials:Attestation> (EDP_11). The <components:Wallet Instance|WI> detects the policy change indirectly through the normal Attestation status checking mechanism (Status List), which will report that the <credentials:Attestation> is revoked. The locally stored <artifacts:Embedded Disclosure Policy (EDP)|EDP> is then implicitly invalidated together with the <credentials:Attestation>. The User needs to request a new issuance to obtain the <credentials:Attestation> with the updated policy.

Even a minor policy change (e.g., adding a single RP to the authorized list) requires revocation and re-issuance. The timing of detection depends on when the <components:Wallet Instance|WI> checks the <credentials:Attestation> status: if the WI checks only at presentation time, a policy change will not be detected until the next presentation attempt.

!!! warning

    Proactive refresh. The <roles:Attestation Provider (AP)|AP> MAY provide <artifacts:Embedded Disclosure Policy (EDP)|EDP> though its URI. In this case, the <components:Wallet Instance> MAY proactively fetch the policy content at the `policy_uri` to check for updates, without waiting for an <credentials:Attestation> revocation signal. However, this mechanism SHALL NOT be used in this specification for the following reason:
    
    - It enables <roles:Attestation Provider (AP)|AP> to unilaterally change an <artifacts:Embedded Disclosure Policy (EDP)|EDP>, and it may introduce privacy risks and management overhead (as stated in the Discussion Topic D)
    - Technical details of this mechanism are not defined within ETSI standard.

??? references

    | Reference | Description |
    |-----------|-------------|
    | [CIR 2024/2979, Article 2(9)] | Definition of <artifacts:Embedded Disclosure Policy (EDP)\|Embedded Disclosure Policy> |
    | [CIR 2024/2979, Article 10] | <roles:Wallet Provider (WP)> obligations for <artifacts:Embedded Disclosure Policy (EDP)\|EDP> processing |
    | [CIR 2024/2979, Annex III] | Common <artifacts:Embedded Disclosure Policy (EDP)\|EDP> types |
    | [ETSI TS 119 472-3, Section 4.2.5] | <artifacts:Embedded Disclosure Policy (EDP)\|EDP> data model requirements (ISS-MDATA-EBD-4.2.5.2-01 through 13) |
    | [ETSI TS 119 475] Annex A.2 | Common entitlement URIs |
    | [ETSI EN 319 412-1, Section 5.1.4] | organizationIdentifier semantics |
    | RFC 4514 | LDAP string representation of Distinguished Names |
