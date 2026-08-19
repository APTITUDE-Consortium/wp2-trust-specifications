This section describes the format and contents of the <artifacts:List of Trusted Entities (LoTE)|LoTE> and how it is used to provide <artifacts:Trust Anchor|Trust Anchors> within the context of the <components:EUDI Wallet>.

!!! choice

    Within the APTITUDE profiles, only the <artifacts:List of Trusted Entities (LoTE)|LoTE> is used, as the <artifacts:Trusted List (TL)|Trusted Lists> and <artifacts:List Of Trusted Lists (LOTL)|LOTL> are not required.

The <artifacts:List of Trusted Entities (LoTE)|LoTE> is a compilation of the information submitted by Member States about the following entities:

1. <roles:Provider of Person Identification Data (PID Provider)|PID Providers>;
1. <roles:Wallet Provider (WP)|Wallet Providers>;
1. <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)|Providers of Wallet Relying Party Access Certificate>;
1. <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|Providers of Public Electronic Attestations of Attributes>;
1. <roles:Registrar|Registrars> and <components:Register|Registers>.

In the context of the <components:EUDI Wallet>, the EC will publish the related <artifacts:List of Trusted Entities (LoTE)|LoTE> on the eIDAS Dashboard, which will be accessible at <https://eidas.ec.europa.eu/efda/wallet>.

!!! choice

    Within the APTITUDE profiles, the following entities SHALL have a dedicated <artifacts:List of Trusted Entities (LoTE)|LoTE>:

    - <roles: Qualified Electronic Attestation of Attributes (QEAA) Provider|QEAA Providers>;
    - <roles: Electronic Attestation of Attributes (EAA) Provider|EAA Providers>.

The <artifacts:List of Trusted Entities (LoTE)|LoTE> follows the same structure defined for <artifacts:Trusted List (TL)|TLs> on [ETSI TS 119 612]. A LoTE, however, supports both the JSON and XML formats, as defined in [ETSI TS 119 602].

All <artifacts:List of Trusted Entities (LoTE)|LoTE> SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1] for JSON-formatted LoTEs, and with XML Advanced Electronic Signatures (XAdES) Baseline B signature, as defined in [ETSI EN 319 132-1] for XML-formatted LoTEs.

!!! choice

    Within the APTITUDE profiles, each <artifacts:List of Trusted Entities (LoTE)|LoTE> type SHALL be published at a distinct endpoint. A LoTE consumer SHALL use the endpoint published for the required LoTE type and SHALL NOT infer the endpoint of one LoTE type from that of another type.

!!! choice

    The Official Journal of APTITUDE (OJA) SHALL provide LoTE discovery information to all APTITUDE entities. For each LoTE type, the OJA SHALL publish the LoTE location and the certificate or certificates authorized to verify that LoTE's signature. The OJA SHALL contain the distinct locations and LoTE signing certificates applicable to the different LoTE types.

!!! choice

    APTITUDE entities MAY cache a LoTE signing certificate used as a Trust Anchor, together with the authenticated LoTE from which it was obtained. Cached material SHALL be refreshed no later than the LoTE's `NextUpdate` value and when updated discovery information is published in the OJA.

??? note "EUDI Wallet trusted list ecosystem"

    The following table dictates the governing standard, publication scope (i.e., at the Member State or European Union level), and the mandated data format for each list type. This table is informative only and SHALL NOT be used within the APTITUDE Profiles.

    | List Type | Governing Standard | Publication Scope | Format |
    | :--- | :--- | :--- | :--- |
    | Traditional eIDAS <artifacts:Trusted List (TL)\|Trusted Lists> | [ETSI TS 119 612] | Member State | XML |
    | List of <artifacts:Trusted List (TL)\|Trusted Lists> (<artifacts:List Of Trusted Lists (LOTL)\|LOTL>) | [ETSI TS 119 612] | European Union | XML |
    | PID Provider Lists | [ETSI TS 119 602 Annex D] | European Union | JSON |
    | <roles:Wallet Provider (WP)> Lists | ETSI TS 119 602 Annex E | European Union | JSON |
    | <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC> | [ETSI TS 119 602 Annex F] | European Union | JSON |
    | <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> | [ETSI TS 119 602 Annex G] | European Union | JSON |
    | <roles:PuB-EAA Provider> Lists | [ETSI TS 119 602 Annex H] | European Union | JSON or XML |
    | <roles:Registrar> and <components:Register> Provider Lists | [ETSI TS 119 602 Annex I] | European Union | JSON |

### Data Models

This section specifies the profiles and formats that the various <artifacts:List of Trusted Entities (LoTE)> within the APTITUDE pilot SHALL utilize, depending on their specific use cases.

The following repository provides the base normative JSON and XML schemas required for implementing the <artifacts:List of Trusted Entities (LoTE)>: [https://forge.etsi.org/rep/esi/x19_60201_lists_of_trusted_entities](https://forge.etsi.org/rep/esi/x19_60201_lists_of_trusted_entities).

#### Specific Formats and Uses

The following table details the governing standards, publication scopes, and mandated data formats regarding the specific provider lists that SHALL be utilized within the APTITUDE ecosystem:

| List Type | Governing Standard | Publication Scope | Format | Signature Format |
| :--- | :--- | :--- | :--- | :--- |
| PID Provider Lists | TS 119 602 Annex D | European Union | JSON | Compact JAdES Baseline B |
| <roles:Wallet Provider (WP)> Lists | TS 119 602 Annex E | European Union | JSON | Compact JAdES Baseline B |
| <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC> Lists | TS 119 602 Annex F | European Union | JSON | Compact JAdES Baseline B |
| <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> Lists | TS 119 602 Annex G | European Union | JSON | Compact JAdES Baseline B |
| <roles:PuB-EAA Provider> Lists | TS 119 602 Annex H | European Union | JSON | Compact JAdES Baseline B |
| <roles:Registrar> and <components:Register> Provider Lists | TS 119 602 Annex I | European Union | JSON | Compact JAdES Baseline B |
| <roles:Qualified Electronic Attestation of Attributes (QEAA) Provider|QEAA Providers> Lists | This Specification | European Union | JSON or XML | Compact JAdES Baseline B or XAdES Baseline B |
| <roles:Electronic Attestation of Attributes (EAA) Provider|EAA Providers> Lists | This Specification | European Union | JSON | Compact JAdES Baseline B |

!!! choice

    Within the APTITUDE profiles, the following formats SHALL be used for the different types of lists:

    - <roles:PuB-EAA Provider> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Wallet Provider (WP)> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Registrar> and <components:Register> Provider Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Provider of Person Identification Data (PID Provider)\|PID Provider> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].
    - <roles:Qualified Electronic Attestation of Attributes (QEAA) Provider|QEAA Providers> Lists are published in JSON or XML format and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1], or with XML Advanced Electronic Signatures (XAdES) Baseline B signature, as defined in [ETSI EN 319 132-1].
    - <roles:Electronic Attestation of Attributes (EAA) Provider|EAA Providers> Lists are published in JSON format, and SHALL be signed with Compact JAdES Baseline B signature, as defined in [ETSI TS 119 182-1].

##### Compact JAdES Baseline B Signature Profile

!!! choice

    Within the APTITUDE profiles, the use of a JWT representation for a JSON-formatted LoTE and the selection of the `x5t#S256` certificate-reference mechanism are implementation choices. This profile selects `x5t#S256` for JSON Compact JAdES signatures. The JWT Claims Set SHALL contain the LoTE object as the private `LoTE` claim.

For a JSON-formatted <artifacts:List of Trusted Entities (LoTE)|LoTE>, the Compact JAdES Baseline B signature SHALL be used, its protected JOSE header SHALL satisfy [ETSI TS 119 182-1, clauses 5.1 and 6.3]:

| Header Parameter | Presence | Requirement |
| :--- | :--- | :--- |
| `alg` | REQUIRED | Identifies the signature algorithm. |
| `iat` | REQUIRED | Specifies the claimed signing time. |
| `x5t#S256` | REQUIRED | Contains the Base64url-encoded SHA-256 thumbprint of the DER encoding of the LoTE signing certificate published in the OJA. The verifier SHALL retrieve the matching certificate from the OJA, verify that its thumbprint matches this parameter, and use that certificate to verify the LoTE signature. |

The `kid` header parameter MAY be used as a certificate lookup hint, but it SHALL NOT be used as the certificate binding. ETSI TS 119 182-1 also permits `x5c`, `x5t#o`, and `sigX5ts` as certificate-binding mechanisms; their use is outside this implementation choice.

The following example shows the protected JOSE header and decoded JWT Claims Set for a PID Provider LoTE. The JWS signature part is omitted. The certificate and thumbprint values are placeholders; an implementation SHALL replace them with the actual certificate DER value and the Base64url-encoded SHA-256 digest of the certificate published in the OJA.

??? example "Example PID Provider LoTE"

    **Protected JOSE header**:

    ```json
    {
    "alg": "ES256",
    "iat": 1787054400,
    "x5t#S256": "<base64url-sha256-thumbprint-of-oja-certificate>"
    }
    ```

    **JWT Claims Set**:

    ```json
    {
    "LoTE": {
        "ListAndSchemeInformation": {
        "LoTEVersionIdentifier": 1,
        "LoTESequenceNumber": 1,
        "LoTEType": "http://uri.etsi.org/19602/LoTEType/EUPIDProvidersList",
        "SchemeOperatorName": [
            {
            "lang": "en",
            "value": "APTITUDE LoTE Provider"
            }
        ],
        "SchemeOperatorAddress": {
            "SchemeOperatorPostalAddress": [
            {
                "lang": "en",
                "StreetAddress": "1 APTITUDE Avenue",
                "Locality": "Brussels",
                "PostalCode": "1000",
                "Country": "BE"
            }
            ],
            "SchemeOperatorElectronicAddress": [
            {
                "lang": "en",
                "uriValue": "https://oja.aptitude.example/contact"
            }
            ]
        },
        "SchemeName": [
            {
            "lang": "en",
            "value": "APTITUDE PID Provider Scheme"
            }
        ],
        "SchemeInformationURI": [
            {
            "lang": "en",
            "uriValue": "https://oja.aptitude.example/publications/pid-providers/2026-08-18"
            },
            {
            "lang": "en",
            "uriValue": "https://lote.aptitude.example/pid-providers/history"
            }
        ],
        "StatusDeterminationApproach": "http://uri.etsi.org/19602/PIDProvidersList/StatusDetn/EU",
        "SchemeTypeCommunityRules": [
            {
            "lang": "en",
            "uriValue": "http://uri.etsi.org/19602/PIDProvidersList/schemerules/EU"
            }
        ],
        "SchemeTerritory": "EU",
        "PolicyOrLegalNotice": [
            {
            "LoTELegalNotice": "https://oja.aptitude.example/lote/pid-providers/legal-notice"
            }
        ],
        "PointersToOtherLoTE": [
            {
            "LoTELocation": "https://lote.aptitude.example/pid-providers/current.jwt",
            "ServiceDigitalIdentities": [
                {
                "X509Certificates": [
                    {
                    "encoding": "urn:ietf:rfc:5280",
                    "specRef": "RFC 5280",
                    "val": "<base64-encoded-DER-signing-certificate>"
                    }
                ]
                }
            ],
            "LoTEQualifiers": [
                {
                "LoTEType": "http://uri.etsi.org/19602/LoTEType/EUPIDProvidersList",
                "SchemeOperatorName": [
                    {
                    "lang": "en",
                    "value": "APTITUDE LoTE Provider"
                    }
                ],
                "SchemeTypeCommunityRules": [
                    {
                    "lang": "en",
                    "uriValue": "http://uri.etsi.org/19602/PIDProvidersList/schemerules/EU"
                    }
                ],
                "SchemeTerritory": "EU",
                "MimeType": "application/jwt"
                }
            ]
            }
        ],
        "ListIssueDateTime": "2026-08-18T12:00:00Z",
        "NextUpdate": "2027-02-18T12:00:00Z",
        "DistributionPoints": [
            "https://lote.aptitude.example/pid-providers/current.jwt"
        ]
        },
        "TrustedEntitiesList": [
        {
            "TrustedEntityInformation": {
            "TEName": [
                {
                "lang": "en",
                "value": "Example PID Provider"
                }
            ],
            "TETradeName": [
                {
                "lang": "en",
                "value": "BE:PID-EXAMPLE-001"
                }
            ],
            "TEAddress": {
                "TEPostalAddress": [
                {
                    "lang": "en",
                    "StreetAddress": "10 Example Street",
                    "Locality": "Brussels",
                    "PostalCode": "1000",
                    "Country": "BE"
                }
                ],
                "TEElectronicAddress": [
                {
                    "lang": "en",
                    "uriValue": "mailto:pid-provider@example.eu"
                }
                ]
            },
            "TEInformationURI": [
                {
                "lang": "en",
                "uriValue": "https://example.eu/pid-provider"
                }
            ]
            },
            "TrustedEntityServices": [
            {
                "ServiceInformation": {
                "ServiceName": [
                    {
                    "lang": "en",
                    "value": "PID issuance service"
                    }
                ],
                "ServiceDigitalIdentity": {
                    "X509Certificates": [
                    {
                        "encoding": "urn:ietf:rfc:5280",
                        "specRef": "RFC 5280",
                        "val": "<base64-encoded-DER-pid-provider-certificate>"
                    }
                    ]
                },
                "ServiceTypeIdentifier": "http://uri.etsi.org/SvcType/PID/Issuance"
                }
            },
            {
                "ServiceInformation": {
                "ServiceName": [
                    {
                    "lang": "en",
                    "value": "PID revocation service"
                    }
                ],
                "ServiceDigitalIdentity": {
                    "X509Certificates": [
                    {
                        "encoding": "urn:ietf:rfc:5280",
                        "specRef": "RFC 5280",
                        "val": "<base64-encoded-DER-pid-provider-certificate>"
                    }
                    ]
                },
                "ServiceTypeIdentifier": "http://uri.etsi.org/SvcType/PID/Revocation"
                }
            }
            ]
        }
        ]
    }
    }
    ```

The `LoTE` claim uses the field names from `LoTE_Payload_Json_schema.yaml`, including `PolicyOrLegalNotice`, `PointersToOtherLoTE`, `DistributionPoints`, `TrustedEntitiesList`, `ServiceDigitalIdentity`, and `ServiceTypeIdentifier`. The same PID Provider certificate is shown for the `Issuance` and `Revocation` services, as required by the APTITUDE profile.

##### XAdES Baseline B Signature Profile

!!! note

    This section therefore uses [ETSI EN 319 132-1] as the normative reference for the requested Baseline B profile.

For an XML-formatted <artifacts:List of Trusted Entities (LoTE)|LoTE>, the XAdES Baseline B signature SHALL be an enveloped XML signature. The following requirements apply in addition to the XML LoTE schema and the requirements in [ETSI TS 119 602, clauses 6.8.0 and 6.8.1]:

| Component | Presence | Requirement |
| :--- | :--- | :--- |
| `ds:Signature` | REQUIRED | The signature SHALL be a child of the XML `ListOfTrustedEntities` document element. |
| Document reference | REQUIRED | A `ds:Reference` with `URI=""` SHALL reference the LoTE document and SHALL use the enveloped-signature transform followed by exclusive XML canonicalization. |
| `ds:CanonicalizationMethod` | REQUIRED | The `ds:SignedInfo/ds:CanonicalizationMethod` SHALL identify exclusive XML canonicalization. |
| `ds:KeyInfo/ds:X509Data/ds:X509Certificate` | REQUIRED | The signing certificate SHALL be present. It SHALL be the certificate used to verify `ds:SignatureValue`. |
| `xades:QualifyingProperties` | REQUIRED | Exactly one `xades:QualifyingProperties` element SHALL be directly incorporated in one `ds:Object`, and its `Target` SHALL reference the `ds:Signature` identifier. |
| `xades:SignedProperties` reference | REQUIRED | A `ds:Reference` SHALL reference `xades:SignedProperties` with `Type="http://uri.etsi.org/01903#SignedProperties"`. |
| `xades:SigningTime` | REQUIRED | Exactly one `xades:SigningTime` SHALL be present in `xades:SignedSignatureProperties` and SHALL express the claimed signing time in UTC. |
| `xades:SigningCertificateV2` | REQUIRED | Exactly one `xades:SigningCertificateV2` SHALL be present. Its first `xades:Cert` SHALL identify the signing certificate through a digest of that certificate's DER encoding. |
| `xades:DataObjectFormat` | REQUIRED (APTITUDE profile) | One `xades:DataObjectFormat` SHALL describe the signed LoTE document, excluding `xades:SignedProperties`, and SHALL contain its MIME type. |

!!! choice

    Within the APTITUDE profiles, the digest in `xades:SigningCertificateV2/xades:Cert/xades:CertDigest` SHALL use SHA-256 and its `ds:DigestValue` SHALL be the standard XML Signature Base64 encoding of the digest of the signing certificate's DER encoding. `IssuerSerialV2` SHALL NOT be used as the certificate binding, and the `xades:Cert/@URI` SHALL be omitted.

The `xades:SigningTime` value is a claimed signing time and SHALL NOT be treated as a trusted timestamp.

The certificate in `ds:KeyInfo` and the first certificate identified by `xades:SigningCertificateV2` SHALL match exactly, by DER certificate identity, one of the certificates published by the OJA for the applicable LoTE type. A valid XAdES signature whose signing certificate is not authorized by the OJA SHALL be rejected.

##### LoTE Additional Requirements

!!! choice

    Within the APTITUDE profiles, QEAA Provider and EAA Provider LoTEs SHALL satisfy the same additional requirements as PID Provider LoTEs, with the provider type and type-specific URI values changed accordingly. The rows below specify those type-specific values.

Following Annexes D - I in [ETSI TS 119 602], together with the APTITUDE-specific QEAA and EAA provider profiles, below are detailed the additional requirements spelled out by type. As seen in [List of Trusted Entities](#list-of-trusted-entities), the <artifacts:List of Trusted Entities (LoTE)|LoTE> contains a sequence of two components: `ListAndSchemeInformation` and `TrustedEntitiesList`. Depending on the <artifacts:List of Trusted Entities (LoTE)|LoTE> type, the `ListAndSchemeInformation` component is further specified by the following parameters:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----: | :---------- |
| `LoTEVersionIdentifier` | [ETSI TS 119 602, clause 6.3.1] | REQUIRED | *Integer* | The value of the `LoTEVersionIdentifier` component SHALL be `1`. |
| `LoTESequenceNumber` | [ETSI TS 119 602, clause 6.3.2] | REQUIRED | *Integer* | The first instance of a <roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Qualified Electronic Attestation of Attributes (QEAA) Provider\|QEAA Provider>, or <roles:Electronic Attestation of Attributes (EAA) Provider\|EAA Provider> list SHALL be issued with the value of the `LoTESequenceNumber` component set to `1`. |
| `LoTEType` | [ETSI TS 119 602, clause 6.3.3] | REQUIRED | *String* | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the value of the `LoTEType` component SHALL be one of the following URIs:<ul><li>"http://uri.etsi.org/19602/LoTEType/EUPIDProvidersList" for <roles:Provider of Person Identification Data (PID Provider)\|PID Providers>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUQEAAProvidersList" for <roles:Qualified Electronic Attestation of Attributes (QEAA) Provider\|QEAA Providers>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUEAAProvidersList" for <roles:Electronic Attestation of Attributes (EAA) Provider\|EAA Providers>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUWalletProvidersList" for <roles:Wallet Provider (WP)\|Wallet Providers>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUWRPACProvidersList" for Providers of <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUWRPRCProvidersList" for Providers of <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>;</li><li>"http://uri.etsi.org/19602/LoTEType/EUPubEAAProvidersList" for <roles:PuB-EAA Provider\|Pub-EAA Providers>;</li><li>"http://uri.etsi.org/19602/LoTEType/RegistrarsAndRegistersList" for <roles:Registrar\|Registrars>.</li></ul> |
| `SchemeOperatorName` | [ETSI TS 119 602, clause 6.3.4] | REQUIRED | *Object* | No additional requirements. |
| `SchemeOperatorAddress` | [ETSI TS 119 602, clause 6.3.5] | REQUIRED | *Object* | No additional requirements. |
| `SchemeName` | [ETSI TS 119 602, clause 6.3.6] | REQUIRED | *Object* | No additional requirements. |
| `SchemeInformationURI` | [ETSI TS 119 602, clause 6.3.7] | REQUIRED | *Object* | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the `SchemeInformationURI` component SHALL contain a URI where users can receive information about the respective list (<roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Qualified Electronic Attestation of Attributes (QEAA) Provider\|QEAA Provider>, <roles:Electronic Attestation of Attributes (EAA) Provider\|EAA Provider>, <roles:Wallet Provider (WP)>, <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC>, <roles:PuB-EAA Provider>, <roles:Registrar> and <components:Register\|Registers>), and a URI where users can retrieve all previous instances of those lists. |
| `StatusDeterminationApproach` | [ETSI TS 119 602, clause 6.3.8] | REQUIRED | *String* | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the value of the `StatusDeterminationApproach` component SHALL be one of the following URIs:<ul><li>"http://uri.etsi.org/19602/PIDProvidersList/StatusDetn/EU" for <roles:Provider of Person Identification Data (PID Provider)\|PID Providers>;</li><li>"http://uri.etsi.org/19602/QEAAProvidersList/StatusDetn/EU" for <roles:Qualified Electronic Attestation of Attributes (QEAA) Provider\|QEAA Providers>;</li><li>"http://uri.etsi.org/19602/EAAProvidersList/StatusDetn/EU" for <roles:Electronic Attestation of Attributes (EAA) Provider\|EAA Providers>;</li><li>"http://uri.etsi.org/19602/WalletProvidersList/StatusDetn/EU" for <roles:Wallet Provider (WP)\|Wallet Providers>;</li><li>"http://uri.etsi.org/19602/WRPACProvidersList/StatusDetn/EU" for Providers of <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>;</li><li>"http://uri.etsi.org/19602/WRPRCProvidersList/StatusDetn/EU" for Providers of <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>;</li><li>"http://uri.etsi.org/19602/PubEAAProvidersList/StatusDetn/EU" for <roles:PuB-EAA Provider\|Pub-EAA Providers>;</li><li>"http://uri.etsi.org/19602/RegistrarsAndRegistersList/StatusDetn/EU" for <roles:Registrar\|Registrars>.</li></ul> |
| `SchemeTypeCommunityRules` | [ETSI TS 119 602, clause 6.3.9] | REQUIRED | *Object* | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the value of the `SchemeTypeCommunityRules` component SHALL be one of the following URIs:<ul><li>"http://uri.etsi.org/19602/PIDProvidersList/schemerules/EU" for <roles:Provider of Person Identification Data (PID Provider)\|PID Providers>;</li><li>"http://uri.etsi.org/19602/QEAAProvidersList/schemerules/EU" for <roles:Qualified Electronic Attestation of Attributes (QEAA) Provider\|QEAA Providers>;</li><li>"http://uri.etsi.org/19602/EAAProvidersList/schemerules/EU" for <roles:Electronic Attestation of Attributes (EAA) Provider\|EAA Providers>;</li><li>"http://uri.etsi.org/19602/WalletProvidersList/schemerules/EU" for <roles:Wallet Provider (WP)\|Wallet Providers>;</li><li>"http://uri.etsi.org/19602/EUWRPACProviders/schemerules/EU" for Providers of <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>;</li><li>"http://uri.etsi.org/19602/WRPRCProvidersList/schemerules/EU" for Providers of <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>;</li><li>"http://uri.etsi.org/19602/EUPubEAAProvidersList/schemerules/EU" for <roles:PuB-EAA Provider\|Pub-EAA Providers>;</li><li>"http://uri.etsi.org/19602/RegistrarsAndRegistersList/schemerules/EU" for <roles:Registrar\|Registrars>.</li></ul> |
| `SchemeTerritory` | [ETSI TS 119 602, clause 6.3.10] | REQUIRED | *String* | The value of the `SchemeTerritory` component SHALL be `EU`. |
| `LoTEPolicyLegalNotice` | [ETSI TS 119 602, clause 6.3.11] | REQUIRED | *Object* | No additional requirements. |
| `HistoricalInformationPeriod` | [ETSI TS 119 602, clause 6.3.12] | REQUIRED | *Integer* | For the <roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Qualified Electronic Attestation of Attributes (QEAA) Provider\|QEAA Provider>, <roles:Electronic Attestation of Attributes (EAA) Provider\|EAA Provider>, <roles:Wallet Provider (WP)>, <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC>, <roles:Registrar> and <components:Register\|Registers> <artifacts:List of Trusted Entities (LoTE)\|LoTE>, the `HistoricalInformationPeriod` component SHALL NOT be present.<br><br>For the <roles:PuB-EAA Provider\|Pub-EAA Providers> <artifacts:List of Trusted Entities (LoTE)\|LoTE>, the `HistoricalInformationPeriod` component value SHALL be `65535` (representing a year). |
| `PointersToOtherLoTEs` | [ETSI TS 119 602, clause 6.3.13] | REQUIRED | *Object* | For the <roles:Provider of Person Identification Data (PID Provider)\|PID Provider>, <roles:Qualified Electronic Attestation of Attributes (QEAA) Provider\|QEAA Provider>, <roles:Electronic Attestation of Attributes (EAA) Provider\|EAA Provider>, <roles:Wallet Provider (WP)>, <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC>, <roles:Registrar> and <components:Register\|Registers> <artifacts:List of Trusted Entities (LoTE)\|LoTE>, the `PointersToOtherLoTE` component SHALL contain at least a pointer to the present <artifacts:List of Trusted Entities (LoTE)\|LoTE> itself.<br><br>For the <roles:PuB-EAA Provider> <artifacts:List of Trusted Entities (LoTE)\|LoTE>, the `PointersToOtherLoTE` component SHALL NOT be present. |
| `ListIssueDateTime` | [ETSI TS 119 602, clause 6.3.14] | REQUIRED | *String* | No additional requirements. |
| `NextUpdate` | [ETSI TS 119 602, clause 6.3.15] | REQUIRED | *String* | The maximum value between the list issue date and time and the next update SHALL be 6 months. |
| `DistributionPoints` | [ETSI TS 119 602, clause 6.3.16] | REQUIRED | *Object* | The component SHALL contain the endpoint dedicated to the applicable LoTE type. This endpoint SHALL be the location published for that LoTE type in the OJA. |
| `SchemeExtensions` | [ETSI TS 119 602, clause 6.3.17] | REQUIRED | *Object* | No additional requirements. |

The `TrustedEntitiesList` is an *Array* of *Objects*, each possessing two primary subcomponents: the `TrustedEntityInformation` and `TrustedEntityServices` components. The following table details the additional requirements the `TrustedEntityInformation` *Object* component SHALL satisfy depending on the <artifacts:List of Trusted Entities (LoTE)|LoTE> type.

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----: | :---------- |
| `TEName` | [ETSI TS 119 602, clause 6.5.1] | REQUIRED | *Array* | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the value of the `TEName` component SHALL be the name of the PID Provider, <roles:Qualified Electronic Attestation of Attributes (QEAA) Provider\|QEAA Provider>, <roles:Electronic Attestation of Attributes (EAA) Provider\|EAA Provider>, <roles:Wallet Provider (WP)>, <roles:Provider of Wallet Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC>, <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC>, <roles:PuB-EAA Provider>, or <roles:Registrar>. |
| `TETradeName` | [ETSI TS 119 602, clause 6.5.2] | REQUIRED | *Array* | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the value of the `TETradeName` component SHALL include an official registration identifier as registered in official records (where such a registered identifier exists) that unambiguously identifies the entity.<br><br>In the case of a legal entity, the `TETradeName` component SHALL have the same semantics as the `organizationIdentifier` attribute in [ETSI EN 319 412-1].<br><br>In the case of a natural person, the `TETradeName` component SHALL have the same semantics as the `serialNumber` attribute in [ETSI EN 319 412-1].<br><br>For Pub-EAA Providers, the `TETradeName` SHALL additionally include the reference to the Union or national law under which the <roles:Public Sector Body> is established as responsible for the <components:Authentic Source>, formatted as a URI: `OJ` for the scheme part, followed by either `EU` or the 2 ISO 3166-1 country code characters, terminating with the unique identifier of the law. |
| `TEAddress` | [ETSI TS 119 602, clause 6.5.3] | REQUIRED | *Array* | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the `TEAddress` component SHALL contain:<ul><li>the postal address of the provider;</li><li>the contact email and contact phone number of the provider.</li></ul>|
| `TEInformationURI` | [ETSI TS 119 602, clause 6.5.4] | REQUIRED | *Object* | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the `TEInformationURI` component SHALL contain:<ul><li>The URL of the webpage that contains the policies, terms, and conditions of the respective provider applying to the provision and use of their services/components;</li><li>where applicable, the URL of the webpage that contains additional information about the provider;</li><li>a URI formatted as `http://uri.etsi.org/19602/ListOfTrustedEntities/[Type]/CC`, where `[Type]` is `PIDProvider`, `QEAAProvider`, `EAAProvider`, or another applicable provider type and `CC` is replaced by the ISO 3166-1 Alpha 2 country code of the responsible Member State.</li></ul> |
| `TEInformationExtensions` | [ETSI TS 119 602, clause 6.5.5] | REQUIRED | *Array* | No additional requirements. |

!!! warning

    The `TEAddress` component's description for the <roles:PuB-EAA Provider|Pub-EAA Providers> <artifacts:List of Trusted Entities (LoTE)|LoTE> differs from c) of the `TEAddress` component's description in [ETSI TS 119 602, Annex H.3, Table H.2], which states "*the URI "<http://uri.etsi.org/19602/ListOfTrustedEntities/PubEAAProvider/CC>" where "CC" is replaced by the ISO 3166-1 [2] Alpha 2 code of the Member State which is responsible for that <roles:PuB-EAA Provider|Pub-EAA provider>*". For conformance to the other <artifacts:List of Trusted Entities (LoTE)|LoTE> types, this has been moved to the `TEInformationURI` component's description, as it is more appropriate for the information it conveys.

The `TrustedEntityServices` is an *Array* of `TrustedEntityService` *Objects*. Each `TrustedEntityService` *Object* possesses two primary subcomponents: the `ServiceInformation` and `ServiceHistoryInstance` components. The following table details the additional requirements the `ServiceInformation` *Object* component SHALL satisfy depending on the <artifacts:List of Trusted Entities (LoTE)|LoTE> type.

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----: | :---------- |
| `ServiceTypeIdentifier` | [ETSI TS 119 602, clause 6.6.1] | REQUIRED | *String* | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, specific URIs MAY be used as the value of the `ServiceTypeIdentifier` component, to the exclusion of any other (e.g., `http://uri.etsi.org/SvcType/PID/Issuance` and `http://uri.etsi.org/SvcType/PID/Revocation` for PID services). |
| `ServiceName` | [ETSI TS 119 602, clause 6.6.2] | REQUIRED | *Array* | For a <roles:Wallet Provider (WP)>, the `ServiceName` component SHALL be the name of the <components:Wallet Solution> it provides.<br><br>For a <roles:Registrar>, the `ServiceName` component SHALL contain the name of the <components:Register> for which the <roles:Registrar> is responsible.<br><br>No additional requirements for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. |
| `ServiceDigitalIdentity` | [ETSI TS 119 602, clause 6.6.3] | REQUIRED | *Object* | Depending on the <artifacts:List of Trusted Entities (LoTE)\|LoTE> type, the `ServiceDigitalIdentity` component SHALL contain one or more X.509 (Trust Anchor) certificates used to verify the signature or seal created by the provider to validate and authenticate their respective artifacts. The certified identity data SHALL include the name and registration number as specified in the `TEName` and `TETradeName` components. All certificates used as APTITUDE trust anchors SHALL be published in the applicable <artifacts:List of Trusted Entities (LoTE)\|LoTE>. |
| `ServiceStatus` | [ETSI TS 119 602, clause 6.6.4] | REQUIRED | *String* | The `ServiceStatus` component SHALL be present for <roles:PuB-EAA Provider> <artifacts:List of Trusted Entities (LoTE)\|LoTE>. Specific URIs MAY be used as the value to indicate if the entity is notified or withdrawn.<br><br>The `ServiceStatus` component SHALL NOT be used for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. |
| `StatusStartingTime` | [ETSI TS 119 602, clause 6.6.5] | REQUIRED | *String* | The `StatusStartingTime` component SHALL be present for <roles:PuB-EAA Provider> <artifacts:List of Trusted Entities (LoTE)\|LoTE>.<br><br>The `StatusStartingTime` component SHALL NOT be used for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. |
| `SchemeServiceDefinitionURI` | [ETSI TS 119 602, clause 6.6.6] | REQUIRED | *Array* | No additional requirements. |
| `ServiceSupplyPoint` | [ETSI TS 119 602, clause 6.6.7] | REQUIRED | *Array* | For the <roles:Registrar> <artifacts:List of Trusted Entities (LoTE)\|LoTE>, the `ServiceSupplyPoint` component SHALL contain the URI where the <components:Register> is available in a machine-processable manner. Any signed or sealed <components:Register> data obtained at this URI SHALL be able to be authenticated using one of the certificates listed in the `ServiceDigitalIdentity` component.<br><br>No additional requirements for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. |
| `TEServiceDefinitionURI` | [ETSI TS 119 602, clause 6.6.8] | REQUIRED | *Array* | No additional requirements. |
| `ServiceInformationExtensions` | [ETSI TS 119 602, clause 6.6.9] | REQUIRED | *Array* | For a <roles:Wallet Provider (WP)>, the `ServiceInformationExtensions` component SHALL be used to provide the reference number of the <components:Wallet Solution> identified by the `ServiceName` component.<br><br>No additional requirements for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. |

!!! choice

    Within the APTITUDE profiles, the `ServiceTypeIdentifier` for all entities except the <roles:Registrar> SHALL be formed as a URI string `http://uri.etsi.org/SvcType/{Specific_attestation}/Issuance` or `http://uri.etsi.org/SvcType/{Specific_attestation}/Revocation`. The `{specific_attestation}` fragment SHALL be valued as:

    - `PID` for PID Providers Trust Anchors;
    - `WalletSolution` for Wallet Providers's owned Wallet Solutions Trust Anchors;
    - `WRPAC` for Providers of Wallet Relying Party Access Certificate's Trust Anchors;
    - `WRPRC` for Providers of Wallet Relying Party Registration Certificate's Trust Anchors;
    - `PubEAA` for Pub-EAA Providers' Trust Anchors;
    - `QEAA` for QEAA Providers' Trust Anchors;
    - `EAA` for EAA Providers' Trust Anchors;

    For the Registrar LoTE type, the `ServiceTypeIdentifier` SHALL be formed as a URI string `http://uri.etsi.org/SvcType/Register`.

!!! choice

    Within the APTITUDE profiles, the Trust Anchors for the `Issuance` and `Revocation` services SHALL be the same, and SHALL be listed in the `ServiceDigitalIdentity` component of the `ServiceInformation` component.

The following table details the additional requirements the `ServiceHistory.ServiceHistoryInstance` *Object* component SHALL satisfy depending on the <artifacts:List of Trusted Entities (LoTE)|LoTE> type.

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----: | :---------- |
| `ServiceName` | [ETSI TS 119 602, clause 6.6.2] | REQUIRED | *Array* | No additional requirements. |
| `ServiceDigitalIdentity` | [ETSI TS 119 602, clause 6.6.3] | REQUIRED | *Object* | The `ServiceDigitalIdentity` of a <roles:PuB-EAA Provider> <artifacts:List of Trusted Entities (LoTE)\|LoTE> SHALL contain at least the `X509SKI` component and SHALL NOT contain an `X509Certificate` component.<br><br>No additional requirements for the other <artifacts:List of Trusted Entities (LoTE)\|LoTE> types. |
| `ServiceStatus` | [ETSI TS 119 602, clause 6.6.4] | REQUIRED | *String* | No additional requirements. |
| `StatusStartingTime` | [ETSI TS 119 602, clause 6.6.5] | REQUIRED | *String* | No additional requirements. |
