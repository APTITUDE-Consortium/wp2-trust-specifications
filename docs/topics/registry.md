The <components:Register> of <roles:Wallet-Relying Party (WRP)|WRPs> is the publicly accessible system (dataset and API) that provides signed/sealed registration statements about <roles:Wallet-Relying Party (WRP)|WRPs> and their authorizations/declared usage. It is managed by the <roles:Registrar>, which is the designated body that:

- Handles the <roles:Wallet-Relying Party (WRP)|WRP> registration lifecycle (onboarding, update, suspension, cancellation);
- Ensures the integrity and publication of registration information;
- Ensures interoperability by exposing <roles:Wallet-Relying Party (WRP)|WRP> registration data via a national website and a single common REST API.

!!! choice "APTITUDE Implementation Choice"

    The APTITUDE ecosystem SHALL feature a unique <components:Register> for all the entities.

??? references

    The list below enumerates all the applicable standards and specifications that have been used to populate the table below:

    - **CIR 2025/848** on <roles:Wallet-Relying Party (WRP)|WRP> registration and <components:Register|Registers>.
    - **CIR 2025/848-Amendment**. This draft slightly modifies Annexes I-V of [CIR 2025/848] and introduces Annex VI for common API and data schema for <components:Register> of <roles:Wallet-Relying Party (WRP)|WRPs>.
    - **ETSI TS 119 475** on <roles:Wallet-Relying Party (WRP)|WRP> attributes, entitlement URIs, <roles:Relying Party (RP)|RP> authorization decision support.
    - **RFC 7515**
    - **RFC 7519**
    - **RFC 8392**
    - **TS05** on common formats and API for <roles:Wallet-Relying Party (WRP)|WRP> registration information.
    - **TS06** on common set of <roles:Wallet-Relying Party (WRP)|WRP> information to be registered.

### Register Data Schema

This section defines the data schema for each <roles:Wallet-Relying Party (WRP)\|WRP> registered in the <roles:Wallet-Relying Party (WRP)|WRP> <components:Register>. The values are extracted from [CIR 2025/848-Amendment, Annex VI].

!!! warning "Address Field Publication Rule"

    [CIR 2025/848-Amendment, Annex VI] says the published API payload excludes `WalletRelyingParty.physicalAddress`, while Table 1 uses the attribute name `postalAddress`. This document uses `postalAddress` as the schema field name and applies the publication rule to that field (i.e., do not publish it in API statements).

| Parameter                 | Type                      | Presence      | Description   |
| ------------------------- | :-----------------------: | :-----------: | ------------- |
| `legalPerson`             | `LegalPerson`             | CONDITIONAL   | **REQUIRED FOR:** legal persons. Specific attributes of a legal person. |
| `naturalPerson`           | `NaturalPerson`           | CONDITIONAL   | **REQUIRED FOR:** natural persons. Specific attributes of a natural person. |
| `identifier`              | `Identifier[]`            | REQUIRED      | One or more identifiers from official records. |
| `postalAddress`           | `String[]`                | OPTIONAL      | Postal address(es) of the legal entity. |
| `country`                 | `String`                  | REQUIRED      | ISO 3166-1 alpha-2 country code, or `EU` for providers operating in the Union. |
| `email`                   | `String[]`                | OPTIONAL      | Contact email address(es) compliant with [RFC 5322]. |
| `phone`                   | `String[]`                | OPTIONAL      | Contact phone number(s), in international form with `+` prefix. |
| `infoURI`                 | `String[]`                | OPTIONAL      | Web page URI(s) for information about the entity. |
| `providerType`            | `String`                  | REQUIRED      | Provider subtype. For <roles:Wallet-Relying Party (WRP)\|WRP> records, typically `WalletRelyingParty`. |
| `policy`                  | `Policy[]`                | REQUIRED      | Policy/terms/privacy/registration policy URL(s) with policy type URI. |
| `x5c`                     |  `String[]`               | OPTIONAL      | X.509 certificate chain(s) for provider services (JWS `x5c`-style chains; supports rollover). |
| `tradeName`               | `String`                  | OPTIONAL      | User-facing trade/service name recognisable to users. |
| `supportURI`              | `String[]`                | REQUIRED      | Support/helpdesk URI(s) for the service. |
| `srvDescription`          | `MultiLangString[][]`     | REQUIRED      | Array of service descriptions, each being an array of localised strings (one inner array per service). |
| `intendedUse`             | `IntendedUse[]`           | CONDITIONAL   | **REQUIRED IF:** the entity is not an <roles:Relying Party Intermediary (RPI)\|Intermediary>. Intended-use definitions and requested attestation data. |
| `isPSB`                   | `boolean`                 | REQUIRED      | Whether the <roles:Wallet-Relying Party (WRP)\|WRP> is a <roles:Public Sector Body> (explicitly present; `false` if not <roles:Public Sector Body>). |
| `entitlement`             | `String[]`                | REQUIRED      | <data-elements:Entitlement> URI(s) (see note below). |
| `providesAttestations`    | `Credential[]`            | CONDITIONAL   | **REQUIRED FOR:** <roles:Provider of Person Identification Data (PID Provider)\|PID Providers> and <roles:Attestation Provider (AP)\|Attestation Providers>. <data-elements:Attestation Type\|Attestation Types> the <roles:Wallet-Relying Party (WRP)\|WRP> intends to issue to <components:Wallet Unit\|Wallet Units>. It SHALL be present if any <data-elements:Entitlement> is `QEAA_Provider`, `Non_Q_EAA_Provider`, `PUB_EAA_Provider`, or `PID_Provider`. |
| `supervisoryAuthority`    | `LegalEntity`             | REQUIRED      | Competent supervisory authority (Art. 46a eIDAS) including contact information. |
| `registryURI`             | `String`                  | REQUIRED      | URI of the API of the <roles:Wallet-Relying Party (WRP)\|WRP> <components:Register>. |
| `usesIntermediary`        | `WalletRelyingParty[]`    | OPTIONAL      | If present, indicates designated <roles:Relying Party Intermediary (RPI)\|Intermediary(ies)>. Only the subset `{identifier, tradeName, registryURI}` is needed for each intermediary reference. |
| `isIntermediary`          | `boolean`                 | REQUIRED      | Whether the registered entity is a designated <roles:Relying Party Intermediary (RPI)\|Intermediary>. SHALL be `false` if `usesIntermediary` is present. |

!!! note

    Mapping between CIR entitlement label and [ETSI TS 119 475, Annex A.2] normative URI:

    | CIR entitlement label | Normative URI | 
    | --------------------- | ------------- |
    | `Service_Provider` | `https://uri.etsi.org/19475/Entitlement/Service_Provider`| 
    | `QEAA_Provider` | `https://uri.etsi.org/19475/Entitlement/QEAA_Provider` |
    | `Non_Q_EAA_Provider` | `https://uri.etsi.org/19475/Entitlement/Non_Q_EAA_Provider` | 
    | `PUB_EAA_Provider` | `https://uri.etsi.org/19475/Entitlement/PUB_EAA_Provider` |
    | `PID_Provider` | `https://uri.etsi.org/19475/Entitlement/PID_Provider`| 
    | `QCert_for_ESeal_Provider` | `https://uri.etsi.org/19475/Entitlement/QCert_for_ESeal_Provider` | 
    | `QCert_for_ESig_Provider` | `https://uri.etsi.org/19475/Entitlement/QCert_for_ESig_Provider` |
    | `rQSigCDs_Provider` | `https://uri.etsi.org/19475/Entitlement/rQSigCDs_Provider`  | 
    | `rQSealCDs_Provider` | `https://uri.etsi.org/19475/Entitlement/rQSealCDs_Provider` | 
    | `ESig_ESeal_Creation_Provider` | `https://uri.etsi.org/19475/Entitlement/ESig_ESeal_Creation_Provider` | 

    [ETSI TS 119 475, Annex A.3] defines additional sub-entitlement URIs for specific service provider roles. For example, Payment Service Provider sub-entitlements include:

    | Sub-entitlement | URI |
    | --------------- | --- |
    | Account Servicing PSP | `https://uri.etsi.org/19475/SubEntitlement/psp/psp-as` |
    | Payment Initiation Service Provider | `https://uri.etsi.org/19475/SubEntitlement/psp/psp-pi` |
    | Account Information Service Provider | `https://uri.etsi.org/19475/SubEntitlement/psp/psp-ai` |
    | PSP issuing card-based payment instruments | `https://uri.etsi.org/19475/SubEntitlement/psp/psp-ic` |
    | Unspecified PSP | `https://uri.etsi.org/19475/SubEntitlement/psp/unspecified` |

    Future editions may define additional sub-entitlements at national or EU level.

??? info "Data Schema: `Identifier`"

    | Parameter                 | Type                      | Presence      | Description   |
    | ------------------------- | :-----------------------: | :-----------: | ------------- |
    | `identifier`              | `String`                  | REQUIRED      | Identifier value of the LegalEntity. |
    | `type`                    | `String`                  | REQUIRED      | Identifier scheme/type URI (see normative URIs below). |

    Normative identifier type URIs defined in [ETSI TS 119 475]:

    | Label | Normative URI | Description   | References    |
    | ----- |-------------- | ------------- | ------------- |
    | EORI-No | `http://data.europa.eu/eudi/id/EORI-No` | Economic Operator Registration and Identification Number | [CIR 1352/2013] |
    | LEI | `http://data.europa.eu/eudi/id/LEI` | Legal Entity Identifier | [CIR 2022/1860], [ISO 17442-1] |
    | EUID | `http://data.europa.eu/eudi/id/EUID` | European Unique Identifier | [CIR 2021/1042] |
    | VATIN | `http://data.europa.eu/eudi/id/VATIN` | Value Added Tax Identification Number | [EU DIR 2006/112/EC] |
    | TIN | `http://data.europa.eu/eudi/id/TIN` | Taxpayer Identification Number |
    | Excise | `http://data.europa.eu/eudi/id/Excise` | Excise Number | [EU REG 389/2012] |

??? info "Data Schema: `MultiLangString`"

    | Parameter                 | Type                      | Presence      | Description   |
    | ------------------------- | :-----------------------: | :-----------: | ------------- |
    | `lang`                    | `String`                  | REQUIRED      | Language tag (e.g., `en`, `fr`). |
    | `content`                 | `String`                  | REQUIRED      | Language-specific content. |

??? info "Data Schema: `IntendedUse`"

    | Parameter                 | Type                      | Presence      | Description   |
    | ------------------------- | :-----------------------: | :-----------: | ------------- |
    | `intendedUseIdentifier`   | `String`                  | REQUIRED      | <components:Register>-level unique identifier for the intended use. |
    | `purpose`                 | `MultiLangString[]`       | REQUIRED      | Description of intended use of the data to request from <components:Wallet Unit\|Wallet Units>. |
    | `privacyPolicy`           | `Policy[]`                | REQUIRED      | Privacy policy URL(s) for the intended use. |
    | `credential`              | `Credential[]`            | REQUIRED      | Machine-readable list of requested data (attestations/attributes). |
    | `createdAt`               | `String`                  | REQUIRED      | Validity start date of the intended use, compliant with [ISO 8601-1] `YYYY-MM-DD` format. |
    | `revokedAt`               | `String`                  | OPTIONAL      | End date for the validity of the intended use, compliant with [ISO 8601-1] `YYYY-MM-DD` format. |

??? info "Data Schema: `Policy`"

    | Parameter                 | Type                      | Presence      | Description   |
    | ------------------------- | :-----------------------: | :-----------: | ------------- |
    | `type`                    | `String`                  | REQUIRED      | Policy type URI [RFC 3986]. See defined policy type URIs below. |
    | `policyURI`               | `String`                  | REQUIRED      | URL where the policy is published. |

    Defined policy type URIs:

    | Policy Type                       | URI   | References    |
    | --------------------------------- | ----- | ------------- |
    | Privacy policy                    | `http://data.europa.eu/eudi/policy/privacy-policy` | [ETSI TS 119 475, B.2.8]; [CIR 2025/848, Article 8(2)(g)] |
    | Terms and conditions              | `http://data.europa.eu/eudi/policy/terms-and-conditions` | [CIR 2025/848-Amendment, Annex VI, Table 7] |
    | Privacy statement (intended use)  | `http://data.europa.eu/eudi/policy/privacy-statement` | [CIR 2025/848-Amendment, Annex VI, Table 7] |

??? info "Data Schema: `Credential`"

    | Parameter                 | Type                      | Presence      | Description   |
    | ------------------------- | :-----------------------: | :-----------: | ------------- |
    | `format`                  | `String`                  | REQUIRED | Credential format identifier (e.g., `dc+sd-jwt`, `mso_mdoc`). |
    | `meta`                    | `Object`                  | REQUIRED | Additional grouping/type metadata defined per credential format (e.g., `{"vct": "..."}` for `dc+sd-jwt`, `{"doctype_value": "..."}` for `mso_mdoc`). See [OpenID4VP, §6.1]. |
    | `claim`                   | `Claim[]`                 | OPTIONAL | Requested claim paths and allowed values (if constrained). |

??? info "Data Schema: `Claim`"

    | Parameter                 | Type                      | Presence      | Description   |
    | ------------------------- | :-----------------------: | :-----------: | ------------- |
    | `path`                    | `Array`                   | REQUIRED      | Non-empty path array of strings / `null` / non-negative integers (OpenID4VP-style path pointer segments). |
    | `values`                  | `Array`                   | OPTIONAL      | Optional allowed values; elements may be `string`, `integer`, or `boolean`. |

??? info "Data Schema: `LegalEntity` Type (for `supervisoryAuthority`)"

    | Parameter                 | Type                      | Presence      | Description   |
    | ------------------------- | :-----------------------: | :-----------: | ------------- |
    | `legalPerson`             | `LegalPerson`             | OPTIONAL      | Present when the authority is a legal person. |
    | `naturalPerson`           | `NaturalPerson`           | OPTIONAL      | Present when the authority is a natural person. |
    | `identifier`              | `Identifier[]`            | OPTIONAL      | Identifier(s) of the authority. |
    | `postalAddress`           | `String[]`                | OPTIONAL      | Postal address(es) of the authority. |
    | `country`                 | `String`                  | REQUIRED      | Country code (or `EU` where applicable). |
    | `email`                   | `String[]`                | OPTIONAL      | Email address(es) of the authority. |
    | `phone`                   | `String[]`                | OPTIONAL      | Phone number(s) of the authority. |
    | `infoURI`                 | `String[]`                | OPTIONAL      | Information URI(s) of the authority. |

??? info "Data Schema: `LegalPerson`"

    | Parameter                 | Type                      | Presence      | Description   |
    | ------------------------- | :-----------------------: | :-----------: | ------------- |
    | `legalName`               | `String[]`                | REQUIRED      | Legal name(s) as in official records. |
    | `establishedBylaw`        | `Law[]`                   | CONDITIONAL   | **REQUIRED FOR:** <roles:Public Sector Body\|Public Sector Bodies> responsible for <components:Authentic Source\|Authentic Sources>. Legal basis for establishment. |

??? info "Data Schema: `NaturalPerson`"

    | Parameter                 | Type                      | Presence      | Description   |
    | ------------------------- | :-----------------------: | :-----------: | ------------- |
    | `givenName`               | `String`                  | REQUIRED      | Current first name(s), including middle names where applicable. |
    | `familyName`              | `String`                  | REQUIRED      | Current surname(s). |
    | `dateOfBirth`             | `String`                  | OPTIONAL      | Date of birth (where present in official records). |
    | `placeOfBirth`            | `String`                  | OPTIONAL      | Place of birth (where present in official records). |

??? info "Data Schema: `Law`"

    | Parameter                 | Type                      | Presence      | Description   |
    | ------------------------- | :-----------------------: | :-----------: | ------------- |
    | `lang`                    | `String`                  | REQUIRED      | Two-letter language code, compliant with [ISO 639]. |
    | `legalBasis`              | `String`                  | REQUIRED      | Legal basis text establishing the legal person (or requiring/recommending access to a claim). |

??? example "Example: WRP Object for a Relying Party"

    A bank registered as a service provider (requesting <credentials:Person Identification Data (PID)|PID> for KYC).

    {% include-markdown "../examples/wrp-object-rp.md" %}

??? example "Example: WRP Object for a Relying Party that is also an Attestation Provider"

    A bank registered as both a service provider (requesting <credentials:Person Identification Data (PID)|PID> for KYC) and a <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)|QEAA Provider> (issuing bank account attestations to <components:Wallet Unit|Wallet Units>). It has both `intendedUse` and `providesAttestations`.

    {% include-markdown "../examples/wrp-object-rp-ap.md" %}

??? example "Example: WRP Object for a Designated Intermediary"

    An entity registered as a designated <roles:Relying Party Intermediary (RPI)|Intermediary> that acts on behalf of <roles:Wallet-Relying Party (WRP)|WRPs> during Wallet interactions. It has `isIntermediary: true` and does not declare `intendedUse` (not required when registering solely as an <roles:Relying Party Intermediary (RPI)|Intermediary>).

    {% include-markdown "../examples/wrp-object-intermediary.md" %}

??? example "Example: WRP Object for a WRP Using a Designated Intermediary"

    A small e-commerce business that relies on TrustBridge (see example above) to conduct Wallet interactions on its behalf. It has `usesIntermediary` pointing to the <roles:Relying Party Intermediary (RPI)|Intermediary>'s registry entry, and `isIntermediary: false`.

    {% include-markdown "../examples/wrp-object-wrp-using-intermediary.md" %}

### Common Register API

This section documents a [TS05] aligned common <components:Register> API profile that satisfies [CIR 2025/848, Annex II] and [CIR 2025/848-Amendment] constraints.

!!! note

    The OpenAPI Specification (OAS) of the API described in this section is available in [this page](../api/register-api.md).

!!! choice "APTITUDE Implementation Choice"

    The <components:Register> SHALL be managed by APTITUDE WP2. Information is entered into the <components:Register> through a dedicated Onboarding Process that does not use the <components:Register> API. Consequently, only the read operations of the <components:Register> API are relevant to this specification and are described below.

The <components:Register> read API SHALL be open for public access (no prior authentication) and return JWS-signed statements.

#### Search/List

Provides the list of <roles:Wallet-Relying Party (WRP)|WRPs> corresponding to the optional filtering and pagination parameters.

The request SHALL be performed as a `GET` to the `/wrp` endpoint. The following parameters are supported:

| Parameter                 | Type          | Presence      | Description       |
| ------------------------- | :-----------: | :-----------: | ----------------- |
| `identifier`              | `String`      | OPTIONAL      | Filter by official/business registration number/identifier. |
| `legalname`               | `String`      | OPTIONAL      | Filter by official company name. |
| `tradename`               | `String`      | OPTIONAL      | Filter by trade name. |
| `policy`                  | `String`      | OPTIONAL      | Filter by privacy policy URL (or policy URI as profiled). |
| `entitlement`             | `String`      | OPTIONAL      | Filter by entitlement type (URI). |
| `usesintermediary`        | `String`      | OPTIONAL      | Filter by <roles:Relying Party Intermediary (RPI)\|Intermediary> identifier. |
| `isintermediary`          | `boolean`     | OPTIONAL      | Filter by <roles:Relying Party Intermediary (RPI)\|Intermediary> status. |
| `intendeduseidentifier`   | `String`      | OPTIONAL      | Filter by <roles:Registrar>-provided intended-use identifier. |
| `claimpath`               | `String`      | OPTIONAL      | Filter by intended-use requested claim path. |
| `credentialmeta`          | `String`      | OPTIONAL      | Filter by intended-use credential metadata (format-specific). |
| `credentialformat`        | `String`      | OPTIONAL      | Filter by intended-use credential format. |
| `cursor`                  | `String`      | OPTIONAL      | Cursor for pagination (profile-defined token format). |
| `limit`                   | `integer`     | OPTIONAL      | The number of items to return per page (profile-defined). |
| `providesattestation`     | `Credential`  | OPTIONAL      | Filter by <data-elements:Attestation Type\|Attestation Types> provided. |

!!! warning

    The name of some query parameters differ from [TS05] and the corresponding YAML file containing the OpenAPI specification of the JSON and REST based application programming interfaces (e.g., `intendedusecredentialmeta` vs `credentialmeta`). This profile follows the OpenAPI specification.

    In addition, this specification adds `providesattestation` to cover the [CIR 2025/848-Amendment] requirement for filtering parameter: <data-elements:Attestation Type> provided, returning the complete data set of each of the registered <roles:Wallet-Relying Party (WRP)|WRP> matching the value provided for this parameter.

Upon success, the endpoint SHALL return a `200 OK` HTTP status code and a JWT with content type `application/jwt`, containing the JWS compact serialization.
The decoded JWS payload SHALL contain an array of `WalletRelyingParty` objects (matching the query), with address field excluded from published entries, and, where relevant, accompanied by <artifacts:Wallet-Relying Party Access Certificate (WRPAC)\|WRPAC> history information.

In case no parameter is provided, the list of all registered <roles:Wallet-Relying Party (WRP)|WRPs> is returned.

!!! note

    The published API view excludes only `postalAddress` ([CIR 2025/848-Amendment, Annex I, point 4]). All other fields, including intended-use claims, are published as registered.

#### Intended Use Check

Provides information on the registered intended use of a specific <roles:Wallet-Relying Party (WRP)|WRP>.

The request SHALL be performed as a `GET` to the `/wrp/check-intended-use` endpoint. The following parameters are supported:

| Parameter                 | Type          | Presence      | Description       |
| ------------------------- | :-----------: | :-----------: | ----------------- |
| `rpidentifier`            | `String`      | REQUIRED      | Identifier of the <roles:Wallet-Relying Party (WRP)\|WRP> whose intended-use registration is being checked. |
| `intendeduseidentifier`   | `String`      | OPTIONAL      | Intended-use identifier registered by the <roles:Registrar>. |
| `claimpath`               | `String`      | OPTIONAL      | Requested claim path to check (serialised representation of path array; profile-defined encoding). |
| `credentialformat`        | `String`      | OPTIONAL      | Credential format to check. |
| `credentialmeta`          | `String`      | OPTIONAL      | Credential metadata filter (profile-defined serialisation). |
| `policyurl`               | `String`      | OPTIONAL      | Used when checking if the privacy policy URL is registered for the identified <roles:Wallet-Relying Party (WRP)\|WRP>. |

Upon success, the endpoint SHALL return a `200 OK` HTTP status code and a JWT with content type `application/jwt`, containing the JWS compact serialization.
The decoded JWS payload SHALL contain a single boolean claim.

In case of errors, the endpoint SHALL return one of the following HTTP status codes:

- `400 Bad Request`: if the request parameters are invalid or incomplete.
- `404 Not Found`: if no <roles:Wallet-Relying Party (WRP)|WRP> with the given `rpidentifier` was found.
