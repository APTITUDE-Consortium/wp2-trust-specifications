## Trusted List

The pilot <artifacts:Trusted List (TL)|Trusted List> is the XML trust source for <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA> services, as envisaged in [ARF Trust Model, Section 6.3.2.4]. [ETSI TS 119 612 V2.4.1, Clauses 5.1–5.7, Annexes B–E and G] governs its data model.

!!! choice "APTITUDE Implementation Choice"

    The <artifacts:Trusted List (TL)|TL> SHALL use XML encoded in UTF-8, `TSLVersionIdentifier = 6`, `TSLType = http://uri.etsi.org/TrstSvc/TrustedList/TSLType/EUgeneric`, and `SchemeTerritory` identifying the emulated Member State (`CC`). WP2 SHALL operate the pilot scheme as specified in [Trust Architecture](../sections/trust-architecture.md).

### Runtime-Consumed Fields

Presence and interpretation follow the cited clauses of [ETSI TS 119 612 V2.4.1]. This table identifies the fields used by the pilot; it does not replace the complete model or its other mandatory fields.

| Field | Presence | Pilot role and source clause |
| --- | --- | --- |
| `TSLVersionIdentifier`, `TSLType`, `SchemeTerritory` | REQUIRED | Values specified above; Clauses 5.3.1, 5.3.3, 5.3.10. |
| `SchemeOperatorName`, `SchemeOperatorAddress`, `SchemeName` | REQUIRED | SHALL identify the WP2 pilot operator and scheme; Clauses 5.3.4–5.3.6. |
| `PolicyOrLegalNotice` | REQUIRED | SHALL identify pilot emulation and the absence of institutional EU qualified status; Clause 5.3.11. |
| `TSLSequenceNumber` | REQUIRED | Version sequence with source-defined increment semantics; Clause 5.3.2. |
| `SchemeInformationURI` | REQUIRED | Pilot scheme information; Clause 5.3.7. |
| `PointersToOtherTSL` | REQUIRED for the emulated EU Member State profile | SHALL include the pilot <artifacts:List Of Trusted Lists (LOTL)\|LOTL> pointer with location; Clause 5.3.13. |
| `ListIssueDateTime`, `NextUpdate` | REQUIRED | Issue and latest update times; Clauses 5.3.14–5.3.15. |
| `HistoricalInformationPeriod` | REQUIRED | `65535`; Clause 5.3.12. |
| `DistributionPoints` | OPTIONAL | Current-list locations; Clause 5.3.16. |
| `TSPName`, `TSPTradeName` | REQUIRED | Provider name and registration identifier/trade names, including the condition on availability of an official registration identifier; Clauses 5.4.1–5.4.2. |
| `ServiceTypeIdentifier` | REQUIRED | SHALL be `http://uri.etsi.org/TrstSvc/Svctype/EAA/Q` for <credentials:Qualified Electronic Attestation of Attributes (QEAA)\|QEAA> services; Clause 5.5.1.1(k). |
| `ServiceDigitalIdentity` | REQUIRED | Listed service identity; Clause 5.5.3. |
| `ServiceStatus`, `StatusStartingTime` | REQUIRED | Current status and its effective start; Clauses 5.5.4–5.5.5. |
| `ServiceHistory` | CONDITIONAL | Present only when history applies; absent where no prior history exists. Instances follow Clauses 5.5.10–5.6. |
| `ServiceInformationExtensions` | OPTIONAL, subject to applicable source conditions | Presence, criticality and interpretation follow Clauses 5.5.9, 5.6.6 and Annexes D and G. |

<credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA> qualification and binding to the listed provider SHALL be evaluated by the [Sign/Seal Validation procedure](../sections/trust-evaluation-process.md#signseal-validation-process). Runtime acceptance, including rejection of overdue <artifacts:Trusted List (TL)|TLs> while preserving the authentication result, is specified in [Trust Anchor Validation](../sections/trust-evaluation-process.md#trust-anchor-validation-process).

### Signature and Publication

The <artifacts:Trusted List (TL)|TL> SHALL carry the scheme operator's XAdES-B-B signature and satisfy [ETSI TS 119 612, Clause 5.7 and Annex B], including its algorithm and list-signer certificate restrictions. The protected `ds:KeyInfo` contains the TLSO signing certificate without an associated certificate chain. XML retrieval and publication SHALL follow [ETSI TS 119 612, Clauses 6.1–6.2], using `application/vnd.etsi.tsl+xml`. The version-specific schema is the Annex C attachment `ts_119612v020401p0.zip` for V2.4.1.

### Illustrative XML Excerpt

This non-normative excerpt is deliberately incomplete, omitting mandatory fields, provider/service containers, pointer tuples and the signature. It is not a complete valid or signed <artifacts:Trusted List (TL)|TL>. `CC` denotes the configured emulated territory.

```xml
<tsl:TrustServiceStatusList xmlns:tsl="http://uri.etsi.org/02231/v2#">
  <tsl:SchemeInformation>
    <tsl:TSLVersionIdentifier>6</tsl:TSLVersionIdentifier>
    <tsl:TSLSequenceNumber>1</tsl:TSLSequenceNumber>
    <tsl:TSLType>http://uri.etsi.org/TrstSvc/TrustedList/TSLType/EUgeneric</tsl:TSLType>
    <!-- Other mandatory scheme fields omitted. -->
    <tsl:SchemeTerritory>CC</tsl:SchemeTerritory>
    <!-- Pilot LOTL pointer and update metadata omitted. -->
  </tsl:SchemeInformation>
  <!-- Provider/service containers omitted; QEAA ServiceTypeIdentifier:
       http://uri.etsi.org/TrstSvc/Svctype/EAA/Q -->
  <!-- XAdES-B-B signature omitted. -->
</tsl:TrustServiceStatusList>
```

## List Of Trusted Lists

The pilot <artifacts:List Of Trusted Lists (LOTL)|LOTL> is the signed pointer list through which the pilot <artifacts:Trusted List (TL)|TL> locations and authorized TL-signing identities are published. [ETSI TS 119 612 V2.4.1, Clauses 5.3.3, 5.3.7, 5.3.13–5.3.18, 5.7, 6 and Annexes A–D] governs its structure, signature and publication except for the pilot substitutions below. Authentication metadata and pivot information follow [ETSI TS 119 615 V1.4.1, Clauses 4.0–4.1].

!!! choice "APTITUDE Implementation Choice"

    WP2 SHALL operate the sole pilot signed pointer-list profile as the <artifacts:List Of Trusted Lists (LOTL)|LOTL> scheme operator identified in [Trust Architecture](../sections/trust-architecture.md). The <artifacts:List Of Trusted Lists (LOTL)|LOTL> SHALL use XML encoded in UTF-8, `TSLVersionIdentifier = 6`, `TSLType = http://uri.etsi.org/TrstSvc/TrustedList/TSLType/EUlistofthelists`, and `SchemeTerritory = EU`.

### LOTL Profile Metadata

The source model and its presence rules apply; the following table specifies the pilot bindings rather than reproducing that model.

| Field | Pilot binding and source clause |
| --- | --- |
| `SchemeOperatorName`, `SchemeOperatorAddress`, `SchemeName`, `PolicyOrLegalNotice` | SHALL identify the WP2 operator and pilot scheme, with a legal notice identifying pilot emulation and the absence of institutional EU qualified status. ETSI TS 119 612, Clauses 5.3.4–5.3.6 and 5.3.11. |
| `TSLSequenceNumber` | SHALL carry the list sequence number with source-defined increment semantics; Clause 5.3.2. |
| `SchemeInformationURI` | SHALL provide scheme information and the applicable <artifacts:Official Journal of APTITUDE (OJA)\|OJA> and archived pivot references, retaining the source order and transition information under the <artifacts:Official Journal of APTITUDE (OJA)\|OJA> substitution below; Clause 5.3.7 and ETSI TS 119 615, Clause 4.1. |
| `ListIssueDateTime`, `NextUpdate` | SHALL carry issue and latest-update metadata under Clauses 5.3.14–5.3.15. |
| `PointersToOtherTSL` | SHALL include the self-pointer as the first tuple and a pointer to each pilot <artifacts:Trusted List (TL)\|TL>. Each tuple SHALL bind `TSLLocation`, authorized signing identities in `ServiceDigitalIdentities`, and the `TSLType`, `SchemeTerritory` and MIME-type qualifiers under Clause 5.3.13 and Annex D. The self-pointer identifies the pilot <artifacts:List Of Trusted Lists (LOTL)\|LOTL> with territory `EU`; each <artifacts:Trusted List (TL)\|TL> pointer identifies its emulated territory `CC`. XML pointers use `application/vnd.etsi.tsl+xml`. |
| `TrustServiceProviderList` | SHALL be absent: this pointer-only artefact contains no TSP/service list; Clause 5.3.18. |

The self-pointer and applicable archived pivot references SHALL preserve the source-defined signer/location continuity information of [ETSI TS 119 615 V1.4.1, Clause 4.1]. The <artifacts:List Of Trusted Lists (LOTL)|LOTL> signature and publication SHALL follow [ETSI TS 119 612 V2.4.1, Clauses 5.7 and 6, Annexes A–D], using the version-specific Annex C schema attachment `ts_119612v020401p0.zip`.

### Pilot OJA Bootstrap

The pilot substitutes the following parameters for those in [ETSI TS 119 615 V1.4.1, Clause 4.0]:

| Pilot parameter | Source parameter | Pilot meaning |
| --- | --- | --- |
| `OJA-Loc` | `OJEU-Loc` | Fixed configured URI of the pilot <artifacts:Official Journal of APTITUDE (OJA)\|OJA> publication. |
| `OJA-LOTL-Loc` | `OJEU-LOTL-Loc` | Initial current XML <artifacts:List Of Trusted Lists (LOTL)\|LOTL> location supplied by that publication. |
| `OJA-LOTL-Certs-Set` | `OJEU-LOTL-Certs-Set` | Full initial authorized LOTL-signing certificate set supplied by that publication. |

The <artifacts:Official Journal of APTITUDE (OJA)|OJA> publication is unsigned and is not independently authenticated. Consumers SHALL accept its bootstrap data under the explicit APTITUDE discovery assumption at the fixed configured <artifacts:Official Journal of APTITUDE (OJA)|OJA> URI.

### Illustrative LOTL XML Excerpt

This non-normative, deliberately incomplete XML excerpt omits mandatory metadata, signing identities, qualifiers and the signature. It is not a valid complete or signed <artifacts:List Of Trusted Lists (LOTL)|LOTL>. Comments identify the omitted tuple content; deployment values come from configuration.

```xml
<tsl:TrustServiceStatusList xmlns:tsl="http://uri.etsi.org/02231/v2#">
  <tsl:SchemeInformation>
    <tsl:TSLVersionIdentifier>6</tsl:TSLVersionIdentifier>
    <tsl:TSLSequenceNumber>1</tsl:TSLSequenceNumber>
    <tsl:TSLType>http://uri.etsi.org/TrstSvc/TrustedList/TSLType/EUlistofthelists</tsl:TSLType>
    <!-- WP2 operator, scheme information and pilot legal notice omitted. -->
    <tsl:SchemeTerritory>EU</tsl:SchemeTerritory>
    <tsl:PointersToOtherTSL>
      <!-- First OtherTSLPointer: self-pointer; LOTL location and signers,
           EUlistofthelists type, EU territory, XML MIME qualifier. -->
      <!-- One OtherTSLPointer per pilot TL: TL location and signers,
           EUgeneric type, CC territory, XML MIME qualifier. -->
    </tsl:PointersToOtherTSL>
    <!-- ListIssueDateTime and NextUpdate omitted. -->
  </tsl:SchemeInformation>
  <!-- No TrustServiceProviderList; XAdES signature omitted. -->
</tsl:TrustServiceStatusList>
```

## List of Trusted Entities

This section describes the format and contents of the <artifacts:List of Trusted Entities (LoTE)|LoTE> and how it is used to provide <artifacts:Trust Anchor|Trust Anchors> within APTITUDE.

The <artifacts:List of Trusted Entities (LoTE)|LoTE> is a compilation of the information submitted by Member States about the following entities:

1. <roles:Provider of Person Identification Data (PID Provider)|PID Providers>;
1. <roles:Wallet Provider (WP)|Wallet Providers>;
1. <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)|Providers of WRPAC>;
1. <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|PuB-EAA Providers>;
1. <roles:Registrar|Registrars> and <components:Register|Registers>.

In the context of the <components:EUDI Wallet>, the EC will publish the related <artifacts:List of Trusted Entities (LoTE)|LoTE> on the eIDAS Dashboard, which will be accessible at <https://eidas.ec.europa.eu/efda/wallet>.

The <artifacts:List of Trusted Entities (LoTE)|LoTE> follows the same structure defined for <artifacts:Trusted List (TL)|Trusted Lists> on [ETSI TS 119 612]. A <artifacts:List of Trusted Entities (LoTE)|LoTE>, however, supports both the JSON and XML formats, as defined in [ETSI TS 119 602].

All retained <artifacts:List of Trusted Entities (LoTE)|LoTE> SHALL use JSON and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].

!!! choice "APTITUDE Implementation Choices"

    - <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|EAA Providers> SHALL have a dedicated <artifacts:List of Trusted Entities (LoTE)|LoTE>.
    - Each <artifacts:List of Trusted Entities (LoTE)|LoTE> type SHALL be published at a distinct endpoint. A <artifacts:List of Trusted Entities (LoTE)|LoTE> consumer SHALL use the endpoint published for the required <artifacts:List of Trusted Entities (LoTE)|LoTE> type and SHALL NOT infer the endpoint of one <artifacts:List of Trusted Entities (LoTE)|LoTE> type from that of another.
    - The <artifacts:Official Journal of APTITUDE (OJA)> SHALL publish a fixed location and fixed authorized signing certificate set for each <artifacts:List of Trusted Entities (LoTE)|LoTE> type. The publication URI, type-specific locations, and certificate sets SHALL remain unchanged during APTITUDE.

!!! choice "APTITUDE OJA Publication"

    The <artifacts:Official Journal of APTITUDE (OJA)|OJA> publication SHALL remain at a fixed URI for the duration of APTITUDE. It is not signed or independently authenticated. <artifacts:List of Trusted Entities (LoTE)|LoTE> consumers accept its type-specific locations and signing certificate sets as APTITUDE discovery data. A successful comparison with that certificate set does not independently authenticate the <artifacts:Official Journal of APTITUDE (OJA)|OJA> publication.

??? note "EUDI Wallet Trusted List Ecosystem"

    The following table dictates the governing standard, publication scope (i.e., at the Member State or European Union level), and the mandated data format for each list type. This table is informative only and SHALL NOT be used within the APTITUDE Profiles.

    | List Type | Governing Standard | Publication Scope | Format |
    | :--- | :--- | :--- | :--- |
    | Traditional eIDAS <artifacts:Trusted List (TL)\|Trusted Lists> | [ETSI TS 119 612] | Member State | XML |
    | List of <artifacts:Trusted List (TL)\|Trusted Lists> (<artifacts:List Of Trusted Lists (LOTL)\|LOTL>) | [ETSI TS 119 612] | European Union | XML |
    | PID Provider Lists | [ETSI TS 119 602 Annex D] | European Union | JSON |
    | <roles:Wallet Provider (WP)> Lists | ETSI TS 119 602 Annex E | European Union | JSON |
    | <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC> | [ETSI TS 119 602 Annex F] | European Union | JSON |
    | <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> | [ETSI TS 119 602 Annex G] | European Union | JSON |
    | <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Provider> Lists | [ETSI TS 119 602 Annex H] | European Union | JSON or XML |
    | <roles:Registrar> and <components:Register> Provider Lists | [ETSI TS 119 602 Annex I] | European Union | JSON |

Runtime acceptance, caching, refresh failure and persistent rollback state are specified in [Trust Anchor Validation](../sections/trust-evaluation-process.md#trust-anchor-validation-process). <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA> trust uses the pilot <artifacts:Trusted List (TL)|TL> and <artifacts:List Of Trusted Lists (LOTL)|LOTL> profiles above, following [ARF Trust Model, Section 6.3.2.4].

### Data Models

This section specifies the profiles and formats that the various <artifacts:List of Trusted Entities (LoTE)|LoTE> within the APTITUDE ecosystem SHALL utilize, depending on their specific use cases.

The following repository provides the base normative JSON and XML schemas required for implementing the <artifacts:List of Trusted Entities (LoTE)|LoTE>: <https://forge.etsi.org/rep/esi/x19_60201_lists_of_trusted_entities>.

The [LoTE OpenAPI description](../api/lote-api.md) documents the APTITUDE type-specific retrieval endpoints and the JSON <artifacts:List of Trusted Entities (LoTE)|LoTE> carried in a signed compact JWT. Its paths and example values are illustrative; the actual fixed endpoint and authorized signing certificates for each type are published by the <artifacts:Official Journal of APTITUDE (OJA)|OJA>. The OpenAPI document covers the seven retained JSON <artifacts:List of Trusted Entities (LoTE)|LoTE> types. XML <artifacts:Trusted List (TL)|TL> and <artifacts:List Of Trusted Lists (LOTL)|LOTL> publication is specified in their sibling profiles above.

#### Specific Formats and Uses

The following table details the governing standards, publication scopes, and mandated data formats regarding the specific provider lists that SHALL be utilized within the APTITUDE ecosystem:

| List Type             | Format        | Signature Format  | References    |
| --------------------- | :-----------: | :---------------: | ------------- |
| <roles:Provider of Person Identification Data (PID Provider)\|PID Provider> Lists | JSON | Compact JAdES Baseline B | [ETSI TS 119 602, Annex D] |
| <roles:Wallet Provider (WP)\|Wallet Provider> Lists | JSON | Compact JAdES Baseline B | [ETSI TS 119 602, Annex E] |
| <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC> Lists | JSON | Compact JAdES Baseline B | [ETSI TS 119 602, Annex F] |
| <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> Lists | JSON | Compact JAdES Baseline B | [ETSI TS 119 602, Annex G] |
| <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Provider> Lists | JSON | Compact JAdES Baseline B | [ETSI TS 119 602, Annex H] |
| <roles:Registrar> and <components:Register> Provider Lists | JSON | Compact JAdES Baseline B | [ETSI TS 119 602, Annex I] |
| <roles:Provider of Electronic Attestation of Attributes (EAA Provider)\|EAA Providers> Lists | JSON | Compact JAdES Baseline B | - |

!!! choice "APTITUDE Implementation Choice"

    The following formats SHALL be used for the different types of lists:

    - <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|PuB-EAA Provider> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Wallet Provider (WP)|Wallet Provider> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Registrar> and <components:Register> Provider Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Provider of Person Identification Data (PID Provider)\|PID Provider> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|EAA Provider> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].

##### Compact JAdES Baseline B Signature Profile

!!! choice "APTITUDE Implementation Choice"

    The use of a JWT representation for a JSON-formatted <artifacts:List of Trusted Entities (LoTE)|LoTE> and the selection of `x5t#S256` as the certificate-binding parameter are implementation choices. The JWT Claims Set SHALL contain the <artifacts:List of Trusted Entities (LoTE)|LoTE> object as the private `LoTE` claim.

For a JSON-formatted <artifacts:List of Trusted Entities (LoTE)|LoTE>, the Compact JAdES Baseline B signature SHALL be used, its protected JOSE header SHALL satisfy [ETSI TS 119 182-1, Clauses 5.1 and 6.3]:

| Parameter     | Presence  | Requirement           |
| ------------- | :-------: | --------------------- |
| `alg`         | REQUIRED  | Identifies the signature algorithm. It SHALL be `ES256`. |
| `iat`         | REQUIRED  | Specifies the claimed signing time. |
| `x5t#S256`    | REQUIRED  | Contains the Base64url-encoded SHA-256 thumbprint of the DER encoding of the authorized signing certificate in the type-specific <artifacts:Official Journal of APTITUDE (OJA)\|OJA> certificate set. |

The `x5c`, `kid`, and `x5u` header parameters SHALL NOT be used in the APTITUDE profile. A validator SHALL select the signing certificate only from the type-specific <artifacts:Official Journal of APTITUDE (OJA)|OJA> certificate set, using `x5t#S256`.

The following example shows the protected JOSE header and decoded JWT Claims Set for a <roles:Provider of Person Identification Data (PID Provider)|PID Provider> <artifacts:List of Trusted Entities (LoTE)|LoTE>. The JWS signature part is omitted. The thumbprint value is a placeholder.

??? example "Example: PID Provider LoTE"

    {% include-markdown "../examples/lote-pid-provider.md" %}

The `LoTE` claim uses the field names from `LoTE_Payload_Json_schema.yaml`, including `PolicyOrLegalNotice`, `TrustedEntitiesList`, `ServiceDigitalIdentity`, and `ServiceTypeIdentifier`. The same <roles:Provider of Person Identification Data (PID Provider)|PID Provider> certificate is shown for the `Issuance` and `Revocation` services, as required by the APTITUDE profile.

##### LoTE Additional Requirements

The EAA-associated `http://aptitude-consortium.github.io/LoTEType/QEAAProviderList` value below is retained as an unresolved <credentials:Electronic Attestation of Attributes (EAA)|EAA> identifier; it does not identify a <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA> <artifacts:List of Trusted Entities (LoTE)|LoTE> profile.

!!! choice "APTITUDE Implementation Choice"

    <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|EAA Provider> <artifacts:List of Trusted Entities (LoTE)|LoTE> SHALL satisfy the same additional requirements as <roles:Provider of Person Identification Data (PID Provider)|PID Provider> <artifacts:List of Trusted Entities (LoTE)|LoTE>, with the provider type and type-specific URI values changed accordingly. The rows below specify those type-specific values.

Following [ETSI TS 119 602, Annexes D-I], together with the APTITUDE-specific <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|EAA Provider> profiles, below are detailed the additional requirements spelled out by type. As seen in [List of Trusted Entities](#list-of-trusted-entities), the <artifacts:List of Trusted Entities (LoTE)|LoTE> contains a sequence of two components: `ListAndSchemeInformation` and `TrustedEntitiesList`. Depending on the <artifacts:List of Trusted Entities (LoTE)|LoTE> type, the `ListAndSchemeInformation` component is further specified by the following parameters:

!!! choice "APTITUDE Implementation Choice"

    The <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|EAA Provider> `LoTEType`, `StatusDeterminationApproach`, `SchemeTypeCommunityRules`, and `ServiceTypeIdentifier` URIs are APTITUDE-specific; the other type-specific values below are the ETSI profile values.

| Parameter                         | Format        | Presence  | Description   | References    |
| --------------------------------- | :-----------: | :-------: | ------------- | ------------- |
| `LoTEVersionIdentifier`           | `Integer`     | REQUIRED  | The value of the `LoTEVersionIdentifier` component SHALL be `1`. | [ETSI TS 119 602, Clause 6.3.1] |
| `LoTESequenceNumber`              | `Integer`     | REQUIRED  | The first instance of every <artifacts:List of Trusted Entities (LoTE)\|LoTE> type SHALL have `LoTESequenceNumber` set to `1`. Each subsequent published version of every <artifacts:List of Trusted Entities (LoTE)\|LoTE> type SHALL have a higher `LoTESequenceNumber` than the preceding version. | [ETSI TS 119 602, Clause 6.3.2] |
| `LoTEType`                        | `String`      | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the value of the `LoTEType` component SHALL be one of the following URIs:<ul><li>"http://uri.etsi.org/19602/LoTEType/EUPIDProvidersList" for <roles:Provider of Person Identification Data (PID Provider)\|PID Providers>;</li><li>"http://aptitude-consortium.github.io/LoTEType/QEAAProviderList" for <roles:Provider of Electronic Attestation of Attributes (EAA Provider)\|EAA Providers>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUWalletProvidersList" for <roles:Wallet Provider (WP)\|Wallet Providers>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUWRPACProvidersList" for <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)\|Providers of WRPAC>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUWRPRCProvidersList" for <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)\|Providers of WRPRC>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUPubEAAProvidersList" for <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|Pub-EAA Providers>;</li><li>"http://uri.etsi.org/19602/LoTEType/EURegistrarsAndRegistersList" for <roles:Registrar\|Registrars>.</li></ul> | [ETSI TS 119 602, Clause 6.3.3] |
| `SchemeOperatorName`              | `Array`       | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.3.4] |
| `SchemeOperatorAddress`           | `Object`      | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.3.5] |
| `SchemeName`                      | `Array`       | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.3.6] |
| `SchemeInformationURI`            | `Array`       | REQUIRED  | The component SHALL contain exactly one URI: the <artifacts:Official Journal of APTITUDE (OJA)\|OJA> publication URI for the applicable <artifacts:List of Trusted Entities (LoTE)\|LoTE> type. | [ETSI TS 119 602, Clause 6.3.7], This Specification |
| `StatusDeterminationApproach`     | `String`      | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the value of the `StatusDeterminationApproach` component SHALL be one of the following URIs:<ul><li>"http://uri.etsi.org/19602/PIDProvidersList/StatusDetn/EU" for <roles:Provider of Person Identification Data (PID Provider)\|PID Providers>;</li><li>"http://aptitude-consortium.github.io/SvcType/EAAProviderList/StatusDetn" for <roles:Provider of Electronic Attestation of Attributes (EAA Provider)\|EAA Providers>;</li><li>"http://uri.etsi.org/19602/WalletProvidersList/StatusDetn/EU" for <roles:Wallet Provider (WP)\|Wallet Providers>;</li><li>"http://uri.etsi.org/19602/WRPACProvidersList/StatusDetn/EU" for <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)\|Providers of WRPAC>;</li><li>"http://uri.etsi.org/19602/WRPRCProvidersList/StatusDetn/EU" for <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)\|Providers of WRPRC>;</li><li>"http://uri.etsi.org/19602/PubEAAProvidersList/StatusDetn/EU" for <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|Pub-EAA Providers>;</li><li>"http://uri.etsi.org/19602/RegistrarsAndRegistersList/StatusDetn/EU" for <roles:Registrar\|Registrars>.</li></ul> | [ETSI TS 119 602, Clause 6.3.8] |
| `SchemeTypeCommunityRules`        | `Array`       | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the value of the `SchemeTypeCommunityRules` component SHALL be one of the following URIs:<ul><li>"http://uri.etsi.org/19602/PIDProviders/schemerules/EU" for <roles:Provider of Person Identification Data (PID Provider)\|PID Providers>;</li><li>"https://aptitude-consortium/SvcType/EAAProvider/schemerules/EU" for <roles:Provider of Electronic Attestation of Attributes (EAA Provider)\|EAA Providers>;</li><li>"http://uri.etsi.org/19602/WalletProvidersList/schemerules/EU" for <roles:Wallet Provider (WP)\|Wallet Providers>;</li><li>"http://uri.etsi.org/19602/WRPACProvidersList/schemerules/EU" for <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)\|Providers of WRPAC>;</li><li>"http://uri.etsi.org/19602/WRPRCProvidersList/schemerules/EU" for <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)\|Providers of WRPRC>;</li><li>"http://uri.etsi.org/19602/PubEAAProvidersList/schemerules/EU" for <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|Pub-EAA Providers>;</li><li>"http://uri.etsi.org/19602/RegistrarsAndRegistersList/schemerules/EU" for <roles:Registrar\|Registrars>.</li></ul> | [ETSI TS 119 602, Clause 6.3.9] |
| `SchemeTerritory`                 | `String`      | REQUIRED  | The value of the `SchemeTerritory` component SHALL be `EU`. | [ETSI TS 119 602, Clause 6.3.10] |
| `PolicyOrLegalNotice`             | `Array`       | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.3.11] |
| `HistoricalInformationPeriod`     | `Integer`     | CONDITIONAL | For every <artifacts:List of Trusted Entities (LoTE)\|LoTE> type other than <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Provider>, this component SHALL NOT be present.<br><br>For the <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Provider> <artifacts:List of Trusted Entities (LoTE)\|LoTE>, it SHALL be `65535`, meaning that historical information in the list is never removed. | [ETSI TS 119 602, Clause 6.3.12] |
| `PointersToOtherLoTE`             | `Array`       | PROHIBITED | For every <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the component SHALL NOT be present. | This Specification |
| `ListIssueDateTime`               | `String`      | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.3.14] |
| `NextUpdate`                      | `String`      | REQUIRED  | The interval from `ListIssueDateTime` to `NextUpdate` SHALL NOT exceed 6 months. | [ETSI TS 119 602, Clause 6.3.15] |
| `DistributionPoints`              | `Array`       | PROHIBITED | The fixed endpoint is supplied by the <artifacts:Official Journal of APTITUDE (OJA)\|OJA> and SHALL NOT be duplicated in the list. | [ETSI TS 119 602, Clause 6.3.16] |
| `SchemeExtensions`                | `Array`       | PROHIBITED | APTITUDE does not use scheme extensions. | [ETSI TS 119 602, Clause 6.3.17] |

!!! choice "APTITUDE History and Publication"

    - APTITUDE WP2 SHALL publish only the current <artifacts:List of Trusted Entities (LoTE)|LoTE> version for each type at its fixed endpoint.

    - For types other than <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|PuB-EAA Provider>, the current list SHALL NOT contain historical service information, and the <roles:List of Trusted Entities Provider (LoTE Provider)|LoTE Provider> SHALL NOT publish earlier instances for historical membership validation.

    These APTITUDE choices depart from the archive retrieval URI and self-pointer requirements for the corresponding profiles in [ETSI TS 119 602, Annexes D-G and I]. The <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|PuB-EAA Provider> <artifacts:List of Trusted Entities (LoTE)|LoTE> SHALL retain its required `ServiceHistory` in the current list.

`TrustedEntitiesList` is an `Array` of `Objects`, each possessing two primary subcomponents: `TrustedEntityInformation` and `TrustedEntityServices`.
The following table details the additional requirements that `TrustedEntityInformation` SHALL satisfy depending on the <artifacts:List of Trusted Entities (LoTE)|LoTE> type.

| Parameter                         | Format        | Presence  | Description   | References    |
| --------------------------------- | :-----------: | :-------: | ------------- | ------------- |
| `TEName`                          | `Array`       | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the value of the `TEName` component SHALL be the name of the <roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Provider of Electronic Attestation of Attributes (EAA Provider)\|EAA Provider>, <roles:Wallet Provider (WP)\|Wallet Provider>, <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC>, <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Provider>, or <roles:Registrar>. | [ETSI TS 119 602, Clause 6.5.1] |
| `TETradeName`                     | `Array`       | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the value of the `TETradeName` component SHALL include an official registration identifier as registered in official records (where such a registered identifier exists) that unambiguously identifies the entity.<br><br>In the case of a legal entity, the `TETradeName` component SHALL have the same semantics as the `organizationIdentifier` attribute in [ETSI EN 319 412-1].<br><br>In the case of a natural person, the `TETradeName` component SHALL have the same semantics as the `serialNumber` attribute in [ETSI EN 319 412-1].<br><br>For <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Providers>, the `TETradeName` SHALL additionally include the reference to the Union or national law under which the <roles:Public Sector Body> is established as responsible for the <components:Authentic Source>, formatted as a URI: `OJ` for the scheme part, followed by either `EU` or the 2 ISO 3166-1 country code characters, terminating with the unique identifier of the law. | [ETSI TS 119 602, Clause 6.5.2] |
| `TEAddress`                       | `Array`       | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the `TEAddress` component SHALL contain:<ul><li>the postal address of the provider;</li><li>the contact email and contact phone number of the provider.</li></ul>| [ETSI TS 119 602, Clause 6.5.3] |
| `TEInformationURI`                | `Object`      | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the `TEInformationURI` component SHALL contain:<ul><li>The URL of the webpage that contains the policies, terms, and conditions of the respective provider applying to the provision and use of their services/components;</li><li>where applicable, the URL of the webpage that contains additional information about the provider;</li><li>a URI formatted as `http://uri.etsi.org/19602/ListOfTrustedEntities/[Type]/CC`, where `[Type]` is `PIDProvider`, `EAAProvider`, or another applicable provider type and `CC` is replaced by the ISO 3166-1 Alpha 2 country code of the responsible Member State.</li></ul> | [ETSI TS 119 602, Clause 6.5.4] |
| `TEInformationExtensions`         | `Array`       | PROHIBITED | APTITUDE SHALL NOT use trusted entity information extensions. | [ETSI TS 119 602, Clause 6.5.5] |

!!! warning

    The `TEAddress` component's description for the <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|Pub-EAA Providers> <artifacts:List of Trusted Entities (LoTE)|LoTE> differs from c) of the `TEAddress` component's description in [ETSI TS 119 602, Annex H.3, Table H.2], which states "*the URI "<http://uri.etsi.org/19602/ListOfTrustedEntities/PubEAAProvider/CC>" where "CC" is replaced by the ISO 3166-1 [2] Alpha 2 code of the Member State which is responsible for that <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|Pub-EAA provider>*". For conformance to the other <artifacts:List of Trusted Entities (LoTE)|LoTE> types, this has been moved to the `TEInformationURI` component's description, as it is more appropriate for the information it conveys.

`TrustedEntityServices` is an `Array` of `TrustedEntityService`. Each `TrustedEntityService` contains `ServiceInformation`; `ServiceHistory` applies to the <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|PuB-EAA Provider> profile. The following table details the additional requirements that `ServiceInformation` SHALL satisfy depending on the <artifacts:List of Trusted Entities (LoTE)|LoTE> type.

| Parameter                         | Format        | Presence  | Description   | References    |
| --------------------------------- | :-----------: | :-------: | ------------- | ------------- |
| `ServiceTypeIdentifier`           | `String`      | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, specific URIs MAY be used as the value of the `ServiceTypeIdentifier` component, to the exclusion of any other (e.g., `http://uri.etsi.org/19602/SvcType/PID/Issuance` and `http://uri.etsi.org/19602/SvcType/PID/Revocation` for <credentials:Person Identification Data (PID)\|PID> services). | [ETSI TS 119 602, Clause 6.6.1] |
| `ServiceName`                     | `Array`       | REQUIRED  | For a <roles:Wallet Provider (WP)\|Wallet Provider>, the `ServiceName` component SHALL be the name of the <components:Wallet Solution> it provides.<br><br>For a <roles:Registrar>, the `ServiceName` component SHALL contain the name of the <components:Register> for which the <roles:Registrar> is responsible.<br><br>No additional requirements for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. | [ETSI TS 119 602, Clause 6.6.2] |
| `ServiceDigitalIdentity`          | `Object`      | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the `ServiceDigitalIdentity` component SHALL contain one or more <artifacts:Trust Anchor> certificates used to verify the signature or seal created by the provider to validate and authenticate their respective artifacts. The certified identity data SHALL include the name and registration number as specified in the `TEName` and `TETradeName` components. All certificates used as APTITUDE trust anchors for retained-LoTE types SHALL be published in the applicable <artifacts:List of Trusted Entities (LoTE)\|LoTE>. | [ETSI TS 119 602, Clause 6.6.3] |
| `ServiceStatus`                   | `String`      | CONDITIONAL | The `ServiceStatus` component SHALL be present for <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Provider> <artifacts:List of Trusted Entities (LoTE)\|LoTE> and SHALL be `http://uri.etsi.org/19602/PubEAAProvidersList/SvcStatus/notified` or `http://uri.etsi.org/19602/PubEAAProvidersList/SvcStatus/withdrawn`.<br><br>The `ServiceStatus` component SHALL NOT be used for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. | [ETSI TS 119 602, Clause 6.6.4] |
| `StatusStartingTime`              | `String`      | CONDITIONAL | The `StatusStartingTime` component SHALL be present for <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Provider> <artifacts:List of Trusted Entities (LoTE)\|LoTE>.<br><br>The `StatusStartingTime` component SHALL NOT be used for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. | [ETSI TS 119 602, Clause 6.6.5] |
| `SchemeServiceDefinitionURI`      | `Array`       | OPTIONAL | No additional requirements. | [ETSI TS 119 602, Clause 6.6.6] |
| `ServiceSupplyPoints`             | `Array`       | CONDITIONAL | For the <roles:Registrar> <artifacts:List of Trusted Entities (LoTE)\|LoTE>, the `ServiceSupplyPoints` component SHALL contain the URI where the <components:Register> is available in a machine-processable manner. Any signed or sealed <components:Register> data obtained at this URI SHALL be able to be authenticated using one of the certificates listed in the `ServiceDigitalIdentity` component.<br><br>It is optional for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. | [ETSI TS 119 602, Clause 6.6.7] |
| `TEServiceDefinitionURI`          | `Array`       | OPTIONAL | No additional requirements. | [ETSI TS 119 602, Clause 6.6.8] |
| `ServiceInformationExtensions`    | `Array`       | CONDITIONAL | For a <roles:Wallet Provider (WP)\|Wallet Provider>, the `ServiceInformationExtensions` component SHALL provide the reference number of the <components:Wallet Solution> identified by the `ServiceName` component.<br><br>It SHALL NOT be present for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. | [ETSI TS 119 602, Clause 6.6.9] |

!!! choice "APTITUDE Implementation Choices"

    The <artifacts:Trust Anchor|Trust Anchors> for the `Issuance` and `Revocation` services SHALL be the same, and SHALL be listed in the `ServiceDigitalIdentity` component of the `ServiceInformation` component.

    For the ETSI-profiled list types other than <roles:Registrar>, the `ServiceTypeIdentifier` SHALL be formed as a URI string `http://uri.etsi.org/19602/SvcType/{Specific_attestation}/Issuance` or `http://uri.etsi.org/19602/SvcType/{Specific_attestation}/Revocation`. The `{specific_attestation}` fragment SHALL be valued as:

    - `PID` for <roles:Provider of Person Identification Data (PID Provider)|PID Providers> <artifacts:Trust Anchor|Trust Anchors>;
    - `WalletSolution` for <roles:Wallet Provider (WP)|Wallet Providers>' owned <components:Wallet Solution> <artifacts:Trust Anchor|Trust Anchors>;
    - `WRPAC` for <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)\|Providers of WRPAC>'s <artifacts:Trust Anchor|Trust Anchors>;
    - `WRPRC` for <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)|Provider of WRPRC>'s <artifacts:Trust Anchor|Trust Anchors>;
    - `PubEAA` for <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|Pub-EAA Providers>' <artifacts:Trust Anchor|Trust Anchors>.

    For the <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|EAA Provider> lists within APTITUDE, `ServiceTypeIdentifier` SHALL use `http://aptitude-consortium.github.io/SvcType/{Specific_attestation}/Issuance`, `http://aptitude-consortium.github.io/SvcType/{Specific_attestation}/Revocation` as applicable.

    For the <roles:Registrar> <artifacts:List of Trusted Entities (LoTE)|LoTE> type, the `ServiceTypeIdentifier` SHALL be formed as a URI string `http://uri.etsi.org/19602/SvcType/Register`.

The following table details the additional requirements the `ServiceHistory.ServiceHistoryInstance` *Object* component SHALL satisfy depending on the <artifacts:List of Trusted Entities (LoTE)|LoTE> type.

| Parameter                         | Format        | Presence  | Description   | References    |
| --------------------------------- | :-----------: | :-------: | ------------- | ------------- |
| `ServiceName`                     | `Array`       | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.6.2] |
| `ServiceDigitalIdentity`          | `Object`      | REQUIRED  | The `ServiceDigitalIdentity` of a <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Provider> <artifacts:List of Trusted Entities (LoTE)\|LoTE> SHALL contain at least the `X509SKI` component and SHALL NOT contain an `X509Certificate` component.<br><br>No additional requirements for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. | [ETSI TS 119 602, Clause 6.6.3] |
| `ServiceStatus`                   | `String`      | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.6.4] |
| `StatusStartingTime`              | `String`      | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.6.5] |
