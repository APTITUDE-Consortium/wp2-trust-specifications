This section defines <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|Wallet-Relying Party Registration Certificates> (<artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC>), as described in [ARF]. The <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> provides detailed information about the <roles:Attestation Provider (AP)|Attestation Provider>'s entitlements, the <credentials:Attestation|Attestations> they issue, and their intended use.

??? references

    - **CIR 2025/848**
    - **ETSI EN 319 411-1**
    - **ETSI TS 119 182-1**
    - **ETSI TS 119 475**
    - **ISO 3166-1**
    - **RFC 5646**
    - **RFC 7519**
    - **RFC 8392**
  
!!! choice "APTITUDE Implementation Choice"

    WRPRCs SHALL be issued only to legal persons.

### Format

- The <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> SHALL be formatted as signed JSON Web Token (JWT) or CBOR Web Token (CWT).
- The <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> SHALL comply with the syntactic and semantic requirements specified in [CIR 2025/848, Annex V, Paragraph 3].
- The <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> SHALL be signed with the digital signature of <roles:Provider of Wallet Relying Party Registration Certificate (Provider of WRPRC)|Providers of WRPRC>.
- The JWT SHALL be signed with a JSON Advanced Electronic Signature with the B-B profile as defined in [ETSI TS 119 182-1].
- The CWT SHALL be signed with an Advanced Electronic Signature following structure as defined in [RFC 9052] and [RFC 9360].

---

### Attribute Overview

| Attribute Group                                                       | Presence              | Description   |
| --------------------------------------------------------------------- | :-------------------: | ------------- |
| [Header Attributes](#header-attributes)                               | REQUIRED              | Required header fields used to identify, sign, and validate <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>. |
| [Core Identity Attributes](#core-identity-attributes)                 | REQUIRED              | Identity attributes of the subject WRP. |
| [Service Description Attributes](#service-description-attributes)     | REQUIRED              | Multilingual service descriptions defining services provided by the WRP's. |
| [Entitlements Attribute](#entitlements-attribute)                     | REQUIRED              | <data-elements:Entitlement\|Entitlements> defining what the WRP is authorised to do. |
| [Privacy and Policy Attributes](#privacy-and-policy-attributes)       | Partially REQUIRED    | Privacy policy information. |
| [Supervisory Authority Attributes](#supervisory-authority-attributes) | REQUIRED              | Supervisory authority contact details for reporting suspicious data-processing behaviour. |
| [Service Provider Attributes](#service-provider-attributes)           | CONDITIONAL           | Credential queries, purposes, and intended-use identifiers for service providers.<br />**REQUIRED FOR:** Service Providers. |
| [Attestation Provider Attributes](#attestation-provider-attributes)   | CONDITIONAL           | Attributes describing attestations issued by an <roles:EAA Provider>.<br />**REQUIRED FOR:** <roles:EAA Provider\|EAA Providers>. |
| [Technical Attributes](#technical-attributes)                         | Partially REQUIRED    | Technical metadata such as policies, timestamps, and status-list configuration. |
| [Uses Intermediary Attributes](#uses-intermediary-attributes)         | CONDITIONAL           | Attributes required when the WRP operates through an <roles:Relying Party Intermediary (RPI)\|Intermediary>.<br />**REQUIRED IF:** Intermediary is used. |

### Header Attributes

#### JWT Header Attributes

| Attribute | Type              | Presence  | Description   | Reference |
| --------- | :---------------: | :-------: | ------------- | --------- |
| `typ`     | `string`          | REQUIRED  | Specifies the object type. The value is set to `rc-wrp+jwt` for JWT. | [ETSI TS 119 475, Table 5] |
| `alg`     | `string`          | REQUIRED  | Indicates the algorithm used to sign the JWT as defined in [ETSI TS 119 182-1, Clause 5.1.2]. It SHOULD be one of the algorithms recommended in [ETSI TS 119 312]. | [ETSI TS 119 475, Table 5] |
| `x5c`     | `array[string]`   | REQUIRED  | Contains the whole certificate chain to verify the JWT as defined in [ETSI TS 119 182-1, Clause 5.1.8]. | [ETSI TS 119 475, Table 5] |

#### CWT Header Attributes

| Attribute | Type              | Presence  | Description   | Reference |
| --------- | :---------------: | :-------: | ------------- | --------- |
| `typ`     | `string`          | REQUIRED  | Specifies the object type. The value is set to `rc-wrp+cwt` for CWT. | [ETSI TS 119 475, Table 6] |
| `alg`     | `string`          | REQUIRED  | Indicates the algorithm used to sign the CWT as specified in [RFC 9052, Section 3.1]. | [ETSI TS 119 475, Table 6] |
| `x5chain` | `array[string]`   | REQUIRED  | Contains the whole certificate chain to verify the CWT as specified in [RFC 9360, Section 2]. | [ETSI TS 119 475, Table 6] |

### Payload Attributes

#### Core Identity Attributes

| Attribute         | Type      | Presence  | Description   | Reference |
| ----------------- | :-------: | :-------: | ------------- | --------- |
| `name`            | `string`  | REQUIRED  | The subject of the <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC> trade name. | [ETSI TS 119 475, Table 7] - `tradeName` |
| `sub_ln`          | `string`  | REQUIRED  | Official legal name. | [ETSI TS 119 475, Table 7] - `legalName` |
| `sub`             | `string`  | REQUIRED  | Organizational identifier, whose semantics is defined in [ETSI EN 319 412-1, Clause 5.1.4]. | [ETSI TS 119 475, Table 7] - `identifier` |
| `country`         | `string`  | REQUIRED  | ISO 3166-1 alpha-2 code. | [ETSI TS 119 475, Table 7] - `country` |
| `registry_uri`    | `string`  | REQUIRED  | URL pointing to the national registry API endpoint of the registered WRP. | [ETSI TS 119 475, Table 7] - `registryURI` |
| `info_uri`        | `string`  | REQUIRED  | URL general-purpose web address. | [ETSI TS 119 475, Table 7] - `infoURI` |
| `support_uri`     | `string`  | REQUIRED  | URL or email address to use in data deletion or portability requests related to the WRP. | [ETSI TS 119 475, Table 7] - `supportURI` |

!!! note "Organizational Identifiers"

    According to [ETSI TS 119 475, Clauses 5.1.3], the three initial characters of the `sub` field SHALL contain one of the following Semantic Identifiers.

    | Type URI                                  | Semantic Identifier   | ETSI Reference        | EU Regulation             |
    | ----------------------------------------- | :-------------------: | :-------------------: | ------------------------- |
    | `http://data.europa.eu/eudi/id/EUID`      | `NTR`                 | GEN-5.1.3-02, Table 2 | [CIR 2020/2244]           |
    | `http://data.europa.eu/eudi/id/LEI`       | `LEI`                 | GEN-5.1.3-02, Table 2 | [CIR 2022/1860]           |
    | `http://data.europa.eu/eudi/id/TIN`       | `VAT`                 | GEN-5.1.5-02, Table 4 | [EU DIR 2006/112/EC]      |
    | `http://data.europa.eu/eudi/id/VATIN`     | `VAT`                 | GEN-5.1.3-02, Table 2 | [EU DIR 2006/112/EC]      |

#### Service Description Attributes

| Attribute                 | Type              | Presence  | Description   | Reference |
| ------------------------- | :---------------: | :-------: | ------------- | --------- |
| `srv_description`         | `array[object]`   | REQUIRED  | Multilingual service descriptions. | [ETSI TS 119 475, Table 7] - `srvDescription` |
| `srv_description[].lang`  | `string`          | REQUIRED  | Language identifier, referring the BCP47 language tag format defined in [RFC 5646]. | [ETSI TS 119 475, Table 7] - `lang` |
| `srv_description[].value` | `string`          | REQUIRED  | Service description in specified language. | [ETSI TS 119 475, Table 7] - `content` |

#### Entitlements Attribute

| Attribute         | Type              | Presence  | Description   | Reference |
| ----------------- | :---------------: | :-------: | ------------- | --------- |
| `entitlements`    | `array[string]`   | REQUIRED  | A list of entitlement URIs assigned to the WRP. | [ETSI TS 119 475, Table 7] - `entitlement` |

!!! note "Defined Entitlements"

    [ETSI TS 119 475, Annex A.2] defines the following possible entitlements:

    | Entitlement                       | URI                                                                   | Description   | ETSI Reference    |
    | --------------------------------- | :-------------------------------------------------------------------: | ------------- | ----------------- |
    | `Service_Provider`                | `https://uri.etsi.org/19475/Entitlement/Service_Provider`             | General Service Provider | Annex A.2.1 |
    | `QEAA_Provider`                   | `https://uri.etsi.org/19475/Entitlement/QEAA_Provider`                | <roles:QEAA Provider> | Annex A.2.2 |
    | `Non_Q_EAA_Provider`              | `https://uri.etsi.org/19475/Entitlement/Non_Q_EAA_Provider`           | <roles:EAA Provider> | Annex A.2.3 |
    | `PUB_EAA_Provider`                | `https://uri.etsi.org/19475/Entitlement/PUB_EAA_Provider`             | <roles:PuB-EAA Provider> | Annex A.2.4 |
    | `PID_Provider`                    | `https://uri.etsi.org/19475/Entitlement/PID_Provider`                 | <roles:Provider of Person Identification Data (PID Provider)\|PID Provider> | Annex A.2.5 |
    | `QCert_for_ESeal_Provider`        | `https://uri.etsi.org/19475/Entitlement/QCert_for_ESeal_Provider`     | QTSP issuing qualified certificates for electronic seals | Annex A.2.6 |
    | `QCert_for_ESig_Provider`         | `https://uri.etsi.org/19475/Entitlement/QCert_for_ESig_Provider`      | QTSP issuing qualified certificates for electronic signatures | Annex A.2.7 |
    | `rQSealCDs_Provider`              | `https://uri.etsi.org/19475/Entitlement/rQSealCDs_Provider`           | QTSP managing remote qualified electronic seal creation devices | Annex A.2.8 |
    | `rQSigCDs_Provider`               | `https://uri.etsi.org/19475/Entitlement/rQSigCDs_Provider`            | QTSP managing remote qualified electronic signature creation devices  | Annex A.2.9 |
    | `ESig_ESeal_Creation_Provider`    | `https://uri.etsi.org/19475/Entitlement/ESig_ESeal_Creation_Provider` | Non-qualified provider for remote signature/seal creation | Annex A.2.10 |

#### Privacy and Policy Attributes

| Attribute         | Type          | Presence  | Description   | Reference |
| ----------------- | :-----------: | :-------: | ------------- | --------- |
| `privacy_policy`  | `string`      | REQUIRED  | URL to the WRP's privacy policy explaining data processing and storage practices. | [ETSI TS 119 475, Table 7] - `policyURI` |
| `public_body`     | `boolean`     | OPTIONAL  | Boolean indicating whether the WRP is a <roles:Public Sector Body>. | [ETSI TS 119 475, Table 10] - `isPSB` |

#### Supervisory Authority Attributes

| Attribute                     | Type          | Presence  | Description   | Reference |
| ----------------------------- | :-----------: | :-------: | ------------- | --------- |
| `supervisory_authority`       | `object`      | REQUIRED  | Information on the Data Protection Authority. | [ETSI TS 119 475, Table 7] - `supervisoryAuthority` |
| `spervisory_authority.uri`    | `string`      | REQUIRED  | The URL of web form provided by the Data Protection Authority supervising the Relying Party, which users can use to report suspicious attribute presentation requests. | [ETSI TS 119 475, Table 7] - `infoURI` |
| `supervisory_authority.email` | `string`      | REQUIRED  | An e-mail address on which the Data Protection Authority is prepared to receive reports about suspicious attribute presentation requests from users. | [ETSI TS 119 475, Table 7] - `email` |
| `supervisory_authority.phone` | `string`      | REQUIRED  | A telephone number on which the Data Protection Authority is prepared to receive reports about suspicious attribute presentation requests from users. | [ETSI TS 119 475, Table 7] - `phone` |

#### Service Provider Attributes

| Attribute                 | Type              | Presence      | Description   | Reference |
| ------------------------- | :---------------: | :-----------: | ------------- | --------- |
| `credentials`             | `array[object]`   | CONDITIONAL   | A set of credential queries, used to request Attestations from the Wallet. The <components:EUDI Wallet> will use this information to perform an over-asking validation.<br />**REQUIRED FOR:** Service Providers. | [ETSI TS 119 475, Table 9] - `credential` |
| `credentials[].format`    | `string`          | CONDITIONAL   | Format of the Attestation.<br />**REQUIRED FOR:** Service Providers. | [ETSI TS 119 475, Table 9] - `format` |
| `credentials[].meta`      | `object`          | CONDITIONAL   | Object defining additional properties.<br />**REQUIRED FOR:** Service Providers. | [ETSI TS 119 475, Table 9] - `meta` |
| `credentials[].claim`     | `array[object]`   | CONDITIONAL   | Array of objects that specifies attributes in the requested Attestation. If claim is absent, the <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC> does not declare any specific attributes intended to be requested by the WRP.<br />**REQUIRED FOR:** Service Providers. | [ETSI TS 119 475, Table 9] - `claim` |
| `purpose`                 | `array[object]`   | CONDITIONAL   | A list describing the data processing associated with the intended use.<br />**REQUIRED FOR:** Service Providers. | [ETSI TS 119 475, Table 9] - `purpose` |
| `purpose[].lang`          | `string`          | CONDITIONAL   | Language identifier, referring the BCP 47 language tag format defined in [RFC 5646].<br />**REQUIRED FOR:** Service Providers. | [ETSI TS 119 475, Table 9] - `lang` |
| `purpose[].value`         | `string`          | CONDITIONAL   | Purpose description provided in the language specified above.<br />**REQUIRED FOR:** Service Providers. | [ETSI TS 119 475, Table 9] - `value` |
| `intended_use_id`         | `string`          | CONDITIONAL   | Unique identifier of the intended use if provided by the <components:Register>. Used to fetch the intented use directly from the <components:Register>.<br />**REQUIRED FOR:** Service Providers only if provided by the <components:Register>. | [ETSI TS 119 475, Table 9] - `intendedUserIdentifier` |

#### Attestation Provider Attributes

| Attribute                         | Type              | Presence      | Description   | Reference |
| --------------------------------- | :---------------: | :-----------: | ------------- | --------- |
| `provides_attestations`           | `array[object]`   | CONDITIONAL   | A set of Attestations issued by the WRP with EAA entitlements.<br />**REQUIRED FOR:** <roles:EAA Provider\|EAA Providers>. | [ETSI TS 119 475, Table 8] - `providesAttestations` |
| `provides_attestations[].format`  | `string`          | CONDITIONAL   | Format of the Attestation.<br />**REQUIRED FOR:** <roles:EAA Provider\|EAA Providers>. | [ETSI TS 119 475, Table 8] - `format` |
| `provides_attestations[].meta`    | `object`          | CONDITIONAL   | Metadata to identify the Attestation type.<br />**REQUIRED FOR:** <roles:EAA Provider\|EAA Providers>. | [ETSI TS 119 475, Table 8] - `meta` |
| `provides_attestations[].claim`   | `array[object]`   | CONDITIONAL   | Objects that specifies attributes in the requested Attestation.<br />**REQUIRED FOR:** <roles:EAA Provider\|EAA Providers> only if provided by the <components:Register>. | [ETSI TS 119 475, Table 8] - `claim` |

#### Technical Attributes

| Attribute                 | Type              | Presence      | Description   | Reference |
| ------------------------- | :---------------: | :-----------: | ------------- | --------- |
| `policy_id`               | `array[string]`   | REQUIRED      | List of policy identifiers as defined in Clause 6.1.3. | [ETSI TS 119 475, Table 7] - `technical` |
| `certificate_policy`      | `string`          | REQUIRED      | URL to the certificate policy and certificate practice statement. | [ETSI TS 119 475, Table 7] - `technical` |
| `iat`                     | `unix_timestamp`  | REQUIRED      | Unix timestamp indicating when the WRPRC was issued. | [ETSI TS 119 475, Table 7] - `technical` |
| `exp`                     | `unix_timestamp`  | OPTIONAL      | Expiration time of the WRPRC as a Unix timestamp. | [ETSI TS 119 475, Table 10] - `technical` |
| `status`                  | `object`          | REQUIRED      | A URI to a <artifacts:Status List Token> presenting information about validity of the <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)\|WRPRC>. | [ETSI TS 119 475, Table 7] - `technical` |
| `status.status_list.idx`  | `int`             | REQUIRED      | Position in status bitstring. | [ETSI TS 119 475, GEN-6.2.6.1-04, GEN-6.2.6.1-05] |
| `status.status_list.uri`  | `string`          | REQUIRED      | <artifacts:Status List Token> URI. | [ETSI TS 119 475, GEN-6.2.6.1-04] |

#### Uses Intermediary Attributes

| Attribute             | Type          | Presence      | Description   | Reference |
| --------------------- | :-----------: | :-----------: | ------------- | --------- |
| `intermediary`        | `object`      | CONDITIONAL   | Used when the WRP operates via an Intermediary.<br />**REQUIRED IF:** Intermediary is used. | [ETSI TS 119 475, Table 10] - `usesIntermediary` |
| `intermediary.sub`    | `string`      | CONDITIONAL   | Identifier of the Intermediary as specified by the Intermediary <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>.<br />**REQUIRED IF:** Intermediary is used. | [ETSI TS 119 475, Table 10] - `usesIntermediary` |
| `intermediary.sname`  | `string`      | CONDITIONAL   | Common name of the Intermediary as specified by the Intermediary <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC>.<br />**REQUIRED IF:** Intermediary is used. | [ETSI TS 119 475, Table 10] - `usesIntermediary` |

!!! note "Intermediary Identifier Format"

    Regarding the format of the `intermediary.sub` field, refer to the "Organizational Identifiers" note in [Core Identity Attributes](#core-identity-attributes).

!!! note "CWT Claims"

    CWT claims SHALL be registered in the following register by IANA: <https://www.iana.org/assignments/cwt/cwt.xhtml>.

??? example "Example: JWT Header"

    {% include-markdown "../examples/registration-certificate-header-jwt.md" %}

??? example "Example: CWT Header"

    {% include-markdown "../examples/registration-certificate-header-cwt.md" %}

??? example "Example: JWT Payload - Service Provider"

    {% include-markdown "../examples/registration-certificate-payload-jwt-sp.md" %}

??? example "Example: JWT Payload - QEAA Provider"

    {% include-markdown "../examples/registration-certificate-payload-jwt-qeaa.md" %}

??? example "Example: JWT Payload - EAA Provider (University)"

    {% include-markdown "../examples/registration-certificate-payload-jwt-eaa.md" %}

??? example "Example: JWT Payload - Banking KYC (Multiple Credentials)"

    {% include-markdown "../examples/registration-certificate-payload-jwt-kyc.md" %}

??? example "Example: JWT Payload - With Intermediary"

    {% include-markdown "../examples/registration-certificate-payload-jwt-intermediary.md" %}
