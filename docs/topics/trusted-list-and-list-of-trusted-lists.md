This section describes the format and contents of the <artifacts:List of Trusted Entities (LoTE)|LoTE> and how it is used to provide <artifacts:Trust Anchor|Trust Anchors> within APTITUDE.

The <artifacts:List of Trusted Entities (LoTE)|LoTE> is a compilation of the information submitted by Member States about the following entities:

1. <roles:Provider of Person Identification Data (PID Provider)|PID Providers>;
1. <roles:Wallet Provider (WP)|Wallet Providers>;
1. <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)|Providers of WRPAC>;
1. <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|PuB-EAA Providers>;
1. <roles:Registrar|Registrars> and <components:Register|Registers>.

In the context of the <components:EUDI Wallet>, the EC will publish the related <artifacts:List of Trusted Entities (LoTE)|LoTE> on the eIDAS Dashboard, which will be accessible at <https://eidas.ec.europa.eu/efda/wallet>.

The <artifacts:List of Trusted Entities (LoTE)|LoTE> follows the same structure defined for <artifacts:Trusted List (TL)|Trusted Lists> on [ETSI TS 119 612]. A <artifacts:List of Trusted Entities (LoTE)|LoTE>, however, supports both the JSON and XML formats, as defined in [ETSI TS 119 602].

All <artifacts:List of Trusted Entities (LoTE)|LoTE> SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1] for JSON-formatted <artifacts:List of Trusted Entities (LoTE)|LoTE>, and with XML Advanced Electronic Signatures (XAdES) Baseline B signature, as defined in [ETSI EN 319 132-1] for XML-formatted <artifacts:List of Trusted Entities (LoTE)|LoTE>.

!!! choice "APTITUDE Implementation Choices"

    - Only the <artifacts:List of Trusted Entities (LoTE)|LoTE> SHALL be used; <artifacts:Trusted List (TL)|Trusted Lists> and <artifacts:List Of Trusted Lists (LOTL)|LOTL> SHALL NOT be used.
    - <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)|QEAA Providers> and <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|EAA Providers> SHALL have a dedicated <artifacts:List of Trusted Entities (LoTE)|LoTE>.
    - Each <artifacts:List of Trusted Entities (LoTE)|LoTE> type SHALL be published at a distinct endpoint. A <artifacts:List of Trusted Entities (LoTE)|LoTE> consumer SHALL use the endpoint published for the required <artifacts:List of Trusted Entities (LoTE)|LoTE> type and SHALL NOT infer the endpoint of one <artifacts:List of Trusted Entities (LoTE)|LoTE> type from that of another.
    - The <artifacts:Official Journal of APTITUDE (OJA)>, which represents the counterpart of the <artifacts:Official Journal of the European Union (OJEU)> within the APTITUDE ecosystem, SHALL provide <artifacts:List of Trusted Entities (LoTE)|LoTE> discovery information to all APTITUDE entities. For each <artifacts:List of Trusted Entities (LoTE)|LoTE> type, the <artifacts:Official Journal of APTITUDE (OJA)|OJA> SHALL publish the <artifacts:List of Trusted Entities (LoTE)|LoTE> location and the certificate(s) authorized to verify that <artifacts:List of Trusted Entities (LoTE)|LoTE>'s signature. The <artifacts:Official Journal of APTITUDE (OJA)|OJA> SHALL contain the distinct locations and <artifacts:List of Trusted Entities (LoTE)|LoTE> signing certificates applicable to each <artifacts:List of Trusted Entities (LoTE)|LoTE> type.
    - APTITUDE entities MAY cache a <artifacts:List of Trusted Entities (LoTE)|LoTE> signing certificate used as a Trust Anchor, together with the authenticated <artifacts:List of Trusted Entities (LoTE)|LoTE> from which it was obtained. Cached material SHALL be refreshed no later than the <artifacts:List of Trusted Entities (LoTE)|LoTE>'s `NextUpdate` value, and whenever updated discovery information is published in the <artifacts:Official Journal of APTITUDE (OJA)|OJA>.

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

### Data Models

This section specifies the profiles and formats that the various <artifacts:List of Trusted Entities (LoTE)|LoTE> within the APTITUDE ecosystem SHALL utilize, depending on their specific use cases.

The following repository provides the base normative JSON and XML schemas required for implementing the <artifacts:List of Trusted Entities (LoTE)|LoTE>: <https://forge.etsi.org/rep/esi/x19_60201_lists_of_trusted_entities>.

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
| <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)\|QEAA Providers> Lists | JSON or XML | Compact JAdES Baseline B or XAdES Baseline B | - |
| <roles:Provider of Electronic Attestation of Attributes (EAA Provider)\|EAA Providers> Lists | JSON | Compact JAdES Baseline B | - |

!!! choice "APTITUDE Implementation Choice"

    The following formats SHALL be used for the different types of lists:

    - <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|PuB-EAA Provider> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Wallet Provider (WP)|Wallet Provider> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Registrar> and <components:Register> Provider Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Provider of Person Identification Data (PID Provider)\|PID Provider> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)|QEAA Provider> Lists are published in JSON or XML format and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1], or with XML Advanced Electronic Signatures (XAdES) Baseline B signature, as defined in [ETSI EN 319 132-1].
    - <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|EAA Provider> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].

##### Compact JAdES Baseline B Signature Profile

!!! choice "APTITUDE Implementation Choice"

    The use of a JWT representation for a JSON-formatted <artifacts:List of Trusted Entities (LoTE)|LoTE> and the selection of the `x5t#S256` certificate-reference mechanism are implementation choices. This profile selects `x5t#S256` for JSON Compact JAdES signatures. The JWT Claims Set SHALL contain the <artifacts:List of Trusted Entities (LoTE)|LoTE> object as the private `LoTE` claim.

For a JSON-formatted <artifacts:List of Trusted Entities (LoTE)|LoTE>, the Compact JAdES Baseline B signature SHALL be used, its protected JOSE header SHALL satisfy [ETSI TS 119 182-1, Clauses 5.1 and 6.3]:

| Parameter     | Presence  | Requirement           |
| ------------- | :-------: | --------------------- |
| `alg`         | REQUIRED  | Identifies the signature algorithm. |
| `iat`         | REQUIRED  | Specifies the claimed signing time. |
| `x5t#S256`    | REQUIRED  | Contains the Base64url-encoded SHA-256 thumbprint of the DER encoding of the <artifacts:List of Trusted Entities (LoTE)\|LoTE> signing certificate published in the <artifacts:Official Journal of APTITUDE (OJA)\|OJA>. The verifier SHALL retrieve the matching certificate from the <artifacts:Official Journal of APTITUDE (OJA)\|OJA>, verify that its thumbprint matches this parameter, and use that certificate to verify the <artifacts:List of Trusted Entities (LoTE)\|LoTE> signature. |

The `kid` header parameter MAY be used as a certificate lookup hint, but it SHALL NOT be used as the certificate binding. [ETSI TS 119 182-1] also permits `x5c`, `x5t#o`, and `sigX5ts` as certificate-binding mechanisms; their use is outside this implementation choice.

The following example shows the protected JOSE header and decoded JWT Claims Set for a <roles:Provider of Person Identification Data (PID Provider)|PID Provider> <artifacts:List of Trusted Entities (LoTE)|LoTE>. The JWS signature part is omitted. The certificate and thumbprint values are placeholders; an implementation SHALL replace them with the actual certificate DER value and the Base64url-encoded SHA-256 digest of the certificate published in the <artifacts:Official Journal of APTITUDE (OJA)|OJA>.

??? example "Example: PID Provider LoTE"

    {% include-markdown "../examples/lote-pid-provider.md" %}

The `LoTE` claim uses the field names from `LoTE_Payload_Json_schema.yaml`, including `PolicyOrLegalNotice`, `PointersToOtherLoTE`, `DistributionPoints`, `TrustedEntitiesList`, `ServiceDigitalIdentity`, and `ServiceTypeIdentifier`. The same <roles:Provider of Person Identification Data (PID Provider)|PID Provider> certificate is shown for the `Issuance` and `Revocation` services, as required by the APTITUDE profile.

##### XAdES Baseline B Signature Profile

!!! note

    This section therefore uses [ETSI EN 319 132-1] as the normative reference for the requested Baseline B profile.

For an XML-formatted <artifacts:List of Trusted Entities (LoTE)|LoTE>, the XAdES Baseline B signature SHALL be an enveloped XML signature. The following requirements apply in addition to the XML <artifacts:List of Trusted Entities (LoTE)|LoTE> schema and the requirements in [ETSI TS 119 602, Clauses 6.8.0 and 6.8.1]:

| Component                                     | Presence  | Requirement   |
| --------------------------------------------- | :-------: | ------------- |
| `ds:Signature`                                | REQUIRED  | The signature SHALL be a child of the XML `ListOfTrustedEntities` document element. |
| Document reference                            | REQUIRED  | A `ds:Reference` with `URI=""` SHALL reference the <artifacts:List of Trusted Entities (LoTE)\|LoTE> document and SHALL use the enveloped-signature transform followed by exclusive XML canonicalization. |
| `ds:CanonicalizationMethod`                   | REQUIRED  | The `ds:SignedInfo/ds:CanonicalizationMethod` SHALL identify exclusive XML canonicalization. |
| `ds:KeyInfo/ds:X509Data/ds:X509Certificate`   | REQUIRED  | The signing certificate SHALL be present. It SHALL be the certificate used to verify `ds:SignatureValue`. |
| `xades:QualifyingProperties`                  | REQUIRED  | Exactly one `xades:QualifyingProperties` element SHALL be directly incorporated in one `ds:Object`, and its `Target` SHALL reference the `ds:Signature` identifier. |
| `xades:SignedProperties` reference            | REQUIRED  | A `ds:Reference` SHALL reference `xades:SignedProperties` with `Type="http://uri.etsi.org/01903#SignedProperties"`. |
| `xades:SigningTime`                           | REQUIRED  | Exactly one `xades:SigningTime` SHALL be present in `xades:SignedSignatureProperties` and SHALL express the claimed signing time in UTC. |
| `xades:SigningCertificateV2`                  | REQUIRED  | Exactly one `xades:SigningCertificateV2` SHALL be present. Its first `xades:Cert` SHALL identify the signing certificate through a digest of that certificate's DER encoding. |
| `xades:DataObjectFormat`                      | REQUIRED  | One `xades:DataObjectFormat` SHALL describe the signed <artifacts:List of Trusted Entities (LoTE)\|LoTE> document, excluding `xades:SignedProperties`, and SHALL contain its MIME type. |

!!! choice "APTITUDE Implementation Choice"

    The digest in `xades:SigningCertificateV2/xades:Cert/xades:CertDigest` SHALL use SHA-256 and its `ds:DigestValue` SHALL be the standard XML Signature Base64 encoding of the digest of the signing certificate's DER encoding. `IssuerSerialV2` SHALL NOT be used as the certificate binding, and the `xades:Cert/@URI` SHALL be omitted.

The `xades:SigningTime` value is a claimed signing time and SHALL NOT be treated as a trusted timestamp.

The certificate in `ds:KeyInfo` and the first certificate identified by `xades:SigningCertificateV2` SHALL match exactly, by DER certificate identity, one of the certificates published by the <artifacts:Official Journal of APTITUDE (OJA)|OJA> for the applicable <artifacts:List of Trusted Entities (LoTE)|LoTE> type. A valid XAdES signature whose signing certificate is not authorized by the <artifacts:Official Journal of APTITUDE (OJA)|OJA> SHALL be rejected.

##### LoTE Additional Requirements

!!! choice "APTITUDE Implementation Choice"

    <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)|QEAA Provider> and <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|EAA Provider> <artifacts:List of Trusted Entities (LoTE)|LoTE> SHALL satisfy the same additional requirements as <roles:Provider of Person Identification Data (PID Provider)|PID Provider> <artifacts:List of Trusted Entities (LoTE)|LoTE>, with the provider type and type-specific URI values changed accordingly. The rows below specify those type-specific values.

Following [ETSI TS 119 602, Annexes D-I], together with the APTITUDE-specific <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)|QEAA Provider> and <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|EAA Provider> profiles, below are detailed the additional requirements spelled out by type. As seen in [List of Trusted Entities](#list-of-trusted-entities), the <artifacts:List of Trusted Entities (LoTE)|LoTE> contains a sequence of two components: `ListAndSchemeInformation` and `TrustedEntitiesList`. Depending on the <artifacts:List of Trusted Entities (LoTE)|LoTE> type, the `ListAndSchemeInformation` component is further specified by the following parameters:

| Parameter                         | Format        | Presence  | Description   | References    |
| --------------------------------- | :-----------: | :-------: | ------------- | ------------- |
| `LoTEVersionIdentifier`           | `Integer`     | REQUIRED  | The value of the `LoTEVersionIdentifier` component SHALL be `1`. | [ETSI TS 119 602, Clause 6.3.1] |
| `LoTESequenceNumber`              | `Integer`     | REQUIRED  | The first instance of a <roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)\|QEAA Provider>, or <roles:Provider of Electronic Attestation of Attributes (EAA Provider)\|EAA Provider> list SHALL be issued with the value of the `LoTESequenceNumber` component set to `1`. | [ETSI TS 119 602, Clause 6.3.2] |
| `LoTEType`                        | `String`      | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the value of the `LoTEType` component SHALL be one of the following URIs:<ul><li>"http://uri.etsi.org/19602/LoTEType/EUPIDProvidersList" for <roles:Provider of Person Identification Data (PID Provider)\|PID Providers>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUQEAAProvidersList" for <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)\|QEAA Providers>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUEAAProvidersList" for <roles:Provider of Electronic Attestation of Attributes (EAA Provider)\|EAA Providers>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUWalletProvidersList" for <roles:Wallet Provider (WP)\|Wallet Providers>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUWRPACProvidersList" for Providers of <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUWRPRCProvidersList" for Providers of <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUPubEAAProvidersList" for <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|Pub-EAA Providers>;</li><li>"http://uri.etsi.org/19602/LoTEType/RegistrarsAndRegistersList" for <roles:Registrar\|Registrars>.</li></ul> | [ETSI TS 119 602, Clause 6.3.3] |
| `SchemeOperatorName`              | `Object`      | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.3.4] |
| `SchemeOperatorAddress`           | `Object`      | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.3.5] |
| `SchemeName`                      | `Object`      | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.3.6] |
| `SchemeInformationURI`            | `Object`      | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the `SchemeInformationURI` component SHALL contain a URI where users can receive information about the respective list (<roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)\|QEAA Provider>, <roles:Provider of Electronic Attestation of Attributes (EAA Provider)\|EAA Provider>, <roles:Wallet Provider (WP)>, <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC>, <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Provider>, <roles:Registrar> and <components:Register\|Registers>), and a URI where users can retrieve all previous instances of those lists. | [ETSI TS 119 602, Clause 6.3.7] |
| `StatusDeterminationApproach`     | `String`      | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the value of the `StatusDeterminationApproach` component SHALL be one of the following URIs:<ul><li>"http://uri.etsi.org/19602/PIDProvidersList/StatusDetn/EU" for <roles:Provider of Person Identification Data (PID Provider)\|PID Providers>;</li><li>"http://uri.etsi.org/19602/QEAAProvidersList/StatusDetn/EU" for <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)\|QEAA Providers>;</li><li>"http://uri.etsi.org/19602/EAAProvidersList/StatusDetn/EU" for <roles:Provider of Electronic Attestation of Attributes (EAA Provider)\|EAA Providers>;</li><li>"http://uri.etsi.org/19602/WalletProvidersList/StatusDetn/EU" for <roles:Wallet Provider (WP)\|Wallet Providers>;</li><li>"http://uri.etsi.org/19602/WRPACProvidersList/StatusDetn/EU" for Providers of <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>;</li><li>"http://uri.etsi.org/19602/WRPRCProvidersList/StatusDetn/EU" for Providers of <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>;</li><li>"http://uri.etsi.org/19602/PubEAAProvidersList/StatusDetn/EU" for <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|Pub-EAA Providers>;</li><li>"http://uri.etsi.org/19602/RegistrarsAndRegistersList/StatusDetn/EU" for <roles:Registrar\|Registrars>.</li></ul> | [ETSI TS 119 602, Clause 6.3.8] |
| `SchemeTypeCommunityRules`        | `Object`      | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the value of the `SchemeTypeCommunityRules` component SHALL be one of the following URIs:<ul><li>"http://uri.etsi.org/19602/PIDProvidersList/schemerules/EU" for <roles:Provider of Person Identification Data (PID Provider)\|PID Providers>;</li><li>"http://uri.etsi.org/19602/QEAAProvidersList/schemerules/EU" for <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)\|QEAA Providers>;</li><li>"http://uri.etsi.org/19602/EAAProvidersList/schemerules/EU" for <roles:Provider of Electronic Attestation of Attributes (EAA Provider)\|EAA Providers>;</li><li>"http://uri.etsi.org/19602/WalletProvidersList/schemerules/EU" for <roles:Wallet Provider (WP)\|Wallet Providers>;</li><li>"http://uri.etsi.org/19602/EUWRPACProviders/schemerules/EU" for Providers of <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>;</li><li>"http://uri.etsi.org/19602/WRPRCProvidersList/schemerules/EU" for Providers of <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>;</li><li>"http://uri.etsi.org/19602/EUPubEAAProvidersList/schemerules/EU" for <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|Pub-EAA Providers>;</li><li>"http://uri.etsi.org/19602/RegistrarsAndRegistersList/schemerules/EU" for <roles:Registrar\|Registrars>.</li></ul> | [ETSI TS 119 602, Clause 6.3.9] |
| `SchemeTerritory`                 | `String`      | REQUIRED  | The value of the `SchemeTerritory` component SHALL be `EU`. | [ETSI TS 119 602, Clause 6.3.10] |
| `LoTEPolicyLegalNotice`           | `Object`      | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.3.11] |
| `HistoricalInformationPeriod`     | `Integer`     | REQUIRED  | For the <roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)\|QEAA Provider>, <roles:Provider of Electronic Attestation of Attributes (EAA Provider)\|EAA Provider>, <roles:Wallet Provider (WP)>, <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC>, <roles:Registrar> and <components:Register\|Registers> <artifacts:List of Trusted Entities (LoTE)\|LoTE>, the `HistoricalInformationPeriod` component SHALL NOT be present.<br><br>For the <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|Pub-EAA Providers> <artifacts:List of Trusted Entities (LoTE)\|LoTE>, the `HistoricalInformationPeriod` component value SHALL be `65535` (representing a year). | [ETSI TS 119 602, Clause 6.3.12] |
| `PointersToOtherLoTEs`            | `Object`      | REQUIRED  | For the <roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)\|QEAA Provider>, <roles:Provider of Electronic Attestation of Attributes (EAA Provider)\|EAA Provider>, <roles:Wallet Provider (WP)>, <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC>, <roles:Registrar> and <components:Register\|Registers> <artifacts:List of Trusted Entities (LoTE)\|LoTE>, the `PointersToOtherLoTE` component SHALL contain at least a pointer to the present <artifacts:List of Trusted Entities (LoTE)\|LoTE> itself.<br><br>For the <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Provider> <artifacts:List of Trusted Entities (LoTE)\|LoTE>, the `PointersToOtherLoTE` component SHALL NOT be present. | [ETSI TS 119 602, Clause 6.3.13] |
| `ListIssueDateTime`               | `String`      | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.3.14] |
| `NextUpdate`                      | `String`      | REQUIRED  | The maximum value between the list issue date and time and the next update SHALL be 6 months. | [ETSI TS 119 602, Clause 6.3.15] |
| `DistributionPoints`              | `Object`      | REQUIRED  | The component SHALL contain the endpoint dedicated to the applicable LoTE type. This endpoint SHALL be the location published for that LoTE type in the <artifacts:Official Journal of APTITUDE (OJA)\|OJA>. | [ETSI TS 119 602, Clause 6.3.16] |
| `SchemeExtensions`                | `Object`      | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.3.17] |

`TrustedEntitiesList` is an `Array` of `Objects`, each possessing two primary subcomponents: `TrustedEntityInformation` and `TrustedEntityServices`.
The following table details the additional requirements that `TrustedEntityInformation` SHALL satisfy depending on the <artifacts:List of Trusted Entities (LoTE)|LoTE> type.

| Parameter                         | Format        | Presence  | Description   | References    |
| --------------------------------- | :-----------: | :-------: | ------------- | ------------- |
| `TEName`                          | `Array`       | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the value of the `TEName` component SHALL be the name of the <roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)\|QEAA Provider>, <roles:Provider of Electronic Attestation of Attributes (EAA Provider)\|EAA Provider>, <roles:Wallet Provider (WP)\|Wallet Provider>, <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC>, <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Provider>, or <roles:Registrar>. | [ETSI TS 119 602, Clause 6.5.1] |
| `TETradeName`                     | `Array`       | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the value of the `TETradeName` component SHALL include an official registration identifier as registered in official records (where such a registered identifier exists) that unambiguously identifies the entity.<br><br>In the case of a legal entity, the `TETradeName` component SHALL have the same semantics as the `organizationIdentifier` attribute in [ETSI EN 319 412-1].<br><br>In the case of a natural person, the `TETradeName` component SHALL have the same semantics as the `serialNumber` attribute in [ETSI EN 319 412-1].<br><br>For <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Providers>, the `TETradeName` SHALL additionally include the reference to the Union or national law under which the <roles:Public Sector Body> is established as responsible for the <components:Authentic Source>, formatted as a URI: `OJ` for the scheme part, followed by either `EU` or the 2 ISO 3166-1 country code characters, terminating with the unique identifier of the law. | [ETSI TS 119 602, Clause 6.5.2] |
| `TEAddress`                       | `Array`       | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the `TEAddress` component SHALL contain:<ul><li>the postal address of the provider;</li><li>the contact email and contact phone number of the provider.</li></ul>| [ETSI TS 119 602, Clause 6.5.3] |
| `TEInformationURI`                | `Object`      | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the `TEInformationURI` component SHALL contain:<ul><li>The URL of the webpage that contains the policies, terms, and conditions of the respective provider applying to the provision and use of their services/components;</li><li>where applicable, the URL of the webpage that contains additional information about the provider;</li><li>a URI formatted as `http://uri.etsi.org/19602/ListOfTrustedEntities/[Type]/CC`, where `[Type]` is `PIDProvider`, `QEAAProvider`, `EAAProvider`, or another applicable provider type and `CC` is replaced by the ISO 3166-1 Alpha 2 country code of the responsible Member State.</li></ul> | [ETSI TS 119 602, Clause 6.5.4] |
| `TEInformationExtensions`         | `Array`       | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.5.5] |

!!! warning

    The `TEAddress` component's description for the <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|Pub-EAA Providers> <artifacts:List of Trusted Entities (LoTE)|LoTE> differs from c) of the `TEAddress` component's description in [ETSI TS 119 602, Annex H.3, Table H.2], which states "*the URI "<http://uri.etsi.org/19602/ListOfTrustedEntities/PubEAAProvider/CC>" where "CC" is replaced by the ISO 3166-1 [2] Alpha 2 code of the Member State which is responsible for that <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|Pub-EAA provider>*". For conformance to the other <artifacts:List of Trusted Entities (LoTE)|LoTE> types, this has been moved to the `TEInformationURI` component's description, as it is more appropriate for the information it conveys.

`TrustedEntityServices` is an `Array` of `TrustedEntityService`. Each `TrustedEntityService` possesses two primary subcomponents: `ServiceInformation` and `ServiceHistoryInstance`. The following table details the additional requirements that `ServiceInformation` SHALL satisfy depending on the <artifacts:List of Trusted Entities (LoTE)|LoTE> type.

| Parameter                         | Format        | Presence  | Description   | References    |
| --------------------------------- | :-----------: | :-------: | ------------- | ------------- |
| `ServiceTypeIdentifier`           | `String`      | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, specific URIs MAY be used as the value of the `ServiceTypeIdentifier` component, to the exclusion of any other (e.g., `http://uri.etsi.org/SvcType/PID/Issuance` and `http://uri.etsi.org/SvcType/PID/Revocation` for <credentials:Person Identification Data (PID)\|PID> services). | [ETSI TS 119 602, Clause 6.6.1] |
| `ServiceName`                     | `Array`       | REQUIRED  | For a <roles:Wallet Provider (WP)\|Wallet Provider>, the `ServiceName` component SHALL be the name of the <components:Wallet Solution> it provides.<br><br>For a <roles:Registrar>, the `ServiceName` component SHALL contain the name of the <components:Register> for which the <roles:Registrar> is responsible.<br><br>No additional requirements for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. | [ETSI TS 119 602, Clause 6.6.2] |
| `ServiceDigitalIdentity`          | `Object`      | REQUIRED  | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the `ServiceDigitalIdentity` component SHALL contain one or more <artifacts:Trust Anchor> certificates used to verify the signature or seal created by the provider to validate and authenticate their respective artifacts. The certified identity data SHALL include the name and registration number as specified in the `TEName` and `TETradeName` components. All certificates used as APTITUDE trust anchors SHALL be published in the applicable <artifacts:List of Trusted Entities (LoTE)\|LoTE>. | [ETSI TS 119 602, Clause 6.6.3] |
| `ServiceStatus`                   | `String`      | REQUIRED  | The `ServiceStatus` component SHALL be present for <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Provider> <artifacts:List of Trusted Entities (LoTE)\|LoTE>. Specific URIs MAY be used as the value to indicate if the entity is notified or withdrawn.<br><br>The `ServiceStatus` component SHALL NOT be used for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. | [ETSI TS 119 602, Clause 6.6.4] |
| `StatusStartingTime`              | `String`      | REQUIRED  | The `StatusStartingTime` component SHALL be present for <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Provider> <artifacts:List of Trusted Entities (LoTE)\|LoTE>.<br><br>The `StatusStartingTime` component SHALL NOT be used for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. | [ETSI TS 119 602, Clause 6.6.5] |
| `SchemeServiceDefinitionURI`      | `Array`       | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.6.6] |
| `ServiceSupplyPoint`              | `Array`       | REQUIRED  | For the <roles:Registrar> <artifacts:List of Trusted Entities (LoTE)\|LoTE>, the `ServiceSupplyPoint` component SHALL contain the URI where the <components:Register> is available in a machine-processable manner. Any signed or sealed <components:Register> data obtained at this URI SHALL be able to be authenticated using one of the certificates listed in the `ServiceDigitalIdentity` component.<br><br>No additional requirements for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. | [ETSI TS 119 602, Clause 6.6.7] |
| `TEServiceDefinitionURI`          | `Array`       | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.6.8] |
| `ServiceInformationExtensions`    | `Array`       | REQUIRED  | For a <roles:Wallet Provider (WP)\|Wallet Provider>, the `ServiceInformationExtensions` component SHALL be used to provide the reference number of the <components:Wallet Solution> identified by the `ServiceName` component.<br><br>No additional requirements for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. | [ETSI TS 119 602, Clause 6.6.9] |

!!! choice "APTITUDE Implementation Choices"

    The <artifacts:Trust Anchor|Trust Anchors> for the `Issuance` and `Revocation` services SHALL be the same, and SHALL be listed in the `ServiceDigitalIdentity` component of the `ServiceInformation` component.

    The `ServiceTypeIdentifier` for all entities except the <roles:Registrar> SHALL be formed as a URI string `http://uri.etsi.org/SvcType/{Specific_attestation}/Issuance` or `http://uri.etsi.org/SvcType/{Specific_attestation}/Revocation`. The `{specific_attestation}` fragment SHALL be valued as:

    - `PID` for <roles:Provider of Person Identification Data (PID Provider)|PID Providers> <artifacts:Trust Anchor|Trust Anchors>;
    - `WalletSolution` for <roles:Wallet Provider (WP)|Wallet Providers>' owned <components:Wallet Solution> <artifacts:Trust Anchor|Trust Anchors>;
    - `WRPAC` for <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)\|Providers of WRPAC>'s <artifacts:Trust Anchor|Trust Anchors>;
    - `WRPRC` for <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)|Provider of WRPRC>'s <artifacts:Trust Anchor|Trust Anchors>;
    - `PubEAA` for <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|Pub-EAA Providers>' <artifacts:Trust Anchor|Trust Anchors>;
    - `QEAA` for <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)|QEAA Providers>' <artifacts:Trust Anchor|Trust Anchors>;
    - `EAA` for <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|EAA Providers>' <artifacts:Trust Anchor|Trust Anchors>;

    For the <roles:Registrar> <artifacts:List of Trusted Entities (LoTE)|LoTE> type, the `ServiceTypeIdentifier` SHALL be formed as a URI string `http://uri.etsi.org/SvcType/Register`.

The following table details the additional requirements the `ServiceHistory.ServiceHistoryInstance` *Object* component SHALL satisfy depending on the <artifacts:List of Trusted Entities (LoTE)|LoTE> type.

| Parameter                         | Format        | Presence  | Description   | References    |
| --------------------------------- | :-----------: | :-------: | ------------- | ------------- |
| `ServiceName`                     | `Array`       | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.6.2] |
| `ServiceDigitalIdentity`          | `Object`      | REQUIRED  | The `ServiceDigitalIdentity` of a <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)\|PuB-EAA Provider> <artifacts:List of Trusted Entities (LoTE)\|LoTE> SHALL contain at least the `X509SKI` component and SHALL NOT contain an `X509Certificate` component.<br><br>No additional requirements for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. | [ETSI TS 119 602, Clause 6.6.3] |
| `ServiceStatus`                   | `String`      | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.6.4] |
| `StatusStartingTime`              | `String`      | REQUIRED  | No additional requirements. | [ETSI TS 119 602, Clause 6.6.5] |
