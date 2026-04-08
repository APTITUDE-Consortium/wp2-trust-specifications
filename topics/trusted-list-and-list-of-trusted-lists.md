# Trusted List and List of Trusted Lists

## Introduction

This section describes the format and contents of the Trusted Lists and how they are used for the purpose of the List of Trusted Lists and List of Trusted Entities within the context of the EUDIW.

## Regulatory background

The Trusted List is defined in article 22 of eIDAS regulation EU 910/2014 as the means to keep current and historical information about the accredited trust service providers in each Member State. One Trusted List must be maintained and published by each Member State.

Furthermore, according to Chapter II of Annex I of The CID (EU) 2015/1505, further amended by CID (EU) 2025/2164, Trusted Lists must follow the technical specification ETSI TS 119 612 version 2.4.1, becoming effective and live on April 29th, 2026.

Also in CID (EU) 2015/150, article 4(3) establishes that the Comission publishes the information received from MS about their Trust Lists in machine readable format for automated processing. This is what is known by "List of Trusted Lists" (LOTL). Under article 4(4), the Commission may also publish the same information in human readable format.

Specifically for the EUDIW, the Commission defines the additional "Lists of Trusted Entities" (LOTE). The principles of the LOTEs are established under Articles 4 and 5 in CIR (EU) 2024/2980, which points the direction to the creation and publishing of two lists:

1. one list to include:
	- registrars of wallet-relying parties
	- registers of wallet-relying parties
1. another list to include:
	- wallet providers
	- providers of person identification data
	- and providers of wallet-relying party access certificates

## Trusted List (TL)

The Trusted List (TL) is a mecanhism to convey information about trust anchors in an wide interoperable ecosystem such as the eIDAS framework. It was originally designed to hold current and historical information about the accreditation of trust service providers, particulary Qualified Trust Service Providers (QTSP), albeit other non-qualified can also be included, including those recognized exclusively at a national level.

For each trust service provider included, the following services can be listed:

1. Qualified certificates issuing
1. OCSP for qualified certificates (e.g. if the OCSP responder is external to the QTSP or is not listed in the OCSP URL is not indicated in the Authority Information Access extensio)
1. CRL for qualified certificates (e.g. if the CRL issuing is delegated or the CRL publishing URL is not included in the CRL Distribution Point extension)
1. Qualified timestamping
1. Qualified electronic registered delivery
1. Qualified electronic registered mail delivery
1. Qualified preservation for qualified electronic signatures and/or qualified electronic seals
1. Qualified validation of qualified electronic signatures and/or qualified electronic seals
1. Remote qualified electronic signature creation device, also known as "remote signing"
1. Remote qualified electronic seal creation device, also known as "remote sealing"
1. Qualified electronic attestations of attributes issuing
1. Qualified electronic archiving
1. Qualified electronic ledgers

Further to the qualified services, a similar set of services can be listed for non-qualified trust services as well as the following additional services:
1. Not qualified electronic attestation of attributes issued by or on behalf of a public sector body responsible for an authentic source (usually referred by "Pub-EAA")
1. Certificate validation
1. Preservation of certificates
1. Validation of electronic attestation of attributes
1. Validation of timestamps
1. Validation of data transmitted through electronic registered delivery services and the validation of related evidences
1. Certificates issuing for purposes other than electronic signing/sealing
1. Validation of certificates issued for purposes other than electronic signing/sealing

A TL may also include additional trust services defined at national level:
1. Registration service
1. Attribute certificates issuing
1. Policy authority for issuing, publishing and maintaining signature policies
1. Archiving
1. Identity verification
1. Key escrow
1. Identity credentials based on static passwords
1. Trusted List issuing (e.g. a sector specific national Trusted List)
1. National Root CA
1. Other trust services

The structure and semantics of the TL are defined in ETSI TS 119 612. For automated processing, the TL is provided in XML format. A browsable and human readable format is also available on the eIDAS Dashboard at https://eidas.ec.europa.eu/efda/trust-services/browse/eidas/tls.

Within eIDAS, one TL is maintained per Member State, responsible for keeping record of the trusted services providers under their respective jurisdiction. TLs are numbered and renewed periodically, and published in a website for unrestricted download. To protect their integrity and assure authenticity TLs are also signed with trusted certificates. 

## List of Trusted Lists (LOTL)

The Trusted List standard ETSI TS 119 612 allows a hierarchy of Trusted Lists by means of referencing to other TLs from a parent TL.

Within eIDAS, a decentralized trust model is established, where the parent TL is the _List of Trusted Lists_ (LOTL), managed and operated by the Commission. For each Member State, the LOTL contains a URL that points to the respective Member State TL.

Currently, the LOTL is published in the following URI: https://ec.europa.eu/tools/lotl/eu-lotl.xml.

### LOTL signing and Pivot XML

The LOTL is electronically signed with a XAdES-B-B signature as defined by ETSI EN 319 132-1. For verification of the signature, the original signing certificates were initally published on the Official Journal of the European Union, here https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=uriserv:OJ.C_.2019.276.01.0001.01.ENG.

Afterwards, a follow up method of providing traceable changes to the LOTL is provided through the "Pivot LOTL". Whenever the LOTL signing certificates are changed (as they expire over time and are replaced by new certificates), and/or the LOTL publishing URL is changed, a "Pivot LOTL" is created. A "snapshot" of the current LOTL is created and published at a specific URL and a reference to that Pivot LOTL is added to the new (main) LOTL. The LOTL contains the history of Pivot LOTLs, which allows participants in the eIDAS ecosystem to rebuild the history of the LOTL trust any given point in time. More information about the Pivot LOTL mechanism is availabe here: https://ec.europa.eu/tools/lotl/pivot-lotl-explanation.html.

## List of Trusted Entities (LOTE)

The LOTE is a compilation of the information submitted by Member States about the following entities:

1. providers of person identity data;
1. wallet providers;
1. providers of wallet relying party access certificates;
1. public sector bodies issuing electronic attestations of attributes.

The LOTE follows the same structure defined for TLs on ETSI TS 119 612, yet a specific data model is defined in ETSI TS 119 602 and 2 formats - JSON or XML - are allowed, depending on the type of LOTE.

The LOTE types can be one of the following, as defined in annex C.2:
- PID providers
- Wallet providers
- Relying Party access certificate providers
- Relying Party registration certificates
- Public sector bodies issuing electronic attestations of attributes
- List of registrars and registers

## Tools

This section presents a non-exhaustive list of tools to processing Trusted Lists.

### TLManager

The TLManager is a tool for creating Trusted Lists compliant withy ETSI TS 116 612. Examples of use of the TLManager are:

- non-EU countries willing to establish a national trusted list compatible with eIDAS. Following the same standard may facilitate bilateral trust.
- setup of a sector specific trusted list - for example, healthcare, energy production and distribution, transportation, etc.
- setup of a lab Trusted List for testing purposes

TLManager is licenced under LGPL and is available for download here:

https://ec.europa.eu/digital-building-blocks/sites/spaces/TLSO/pages/75665517/Trusted+List+Manager+non-EU

### eIDAS Dashboard

The eIDAS Dashboard is a platform in the format of a dynamic website where all information and tools necessary to make use of the EUDI Wallet, Trust Services and eID schemes are openly available.

The eIDAS Dashboard is available online here: https://eidas.ec.europa.eu/efda/home. Specifically for the EUDI Wallet ecosystem, the eIDAS Dashboard already has the placeholders for the several types of entities to be listed in the LOTEs, here: https://eidas.ec.europa.eu/efda/wallet.


## Data Models

This section specifies the profiles and formats that the various Trusted Lists defined above SHALL utilize, depending on their specific use cases. 

The following table dictates the governing standard, publication scope (i.e., at the Member State or European Union level), and the mandated data format for each list type.

| List Type | Governing Standard | Publication Scope | Format |
| :--- | :--- | :--- | :--- |
| Traditional eIDAS Trusted Lists | TS 119 612 | Member State | XML |
| List of Trusted Lists (LoTL) | TS 119 612 | European Union | XML |
| PID Provider Lists | TS 119 602 Annex D | European Union | JSON |
| Wallet Provider Lists | TS 119 602 Annex E | European Union | JSON |
| Provider of WRPAC | TS 119 602 Annex F | European Union | JSON |
| Provider of WRPRC | TS 119 602 Annex G | European Union | JSON |
| Pub-EAA Provider Lists | TS 119 602 Annex H | European Union | JSON or XML |
| Registrar and Register Provider Lists | TS 119 602 Annex I | European Union | JSON |

### Trusted List and List of Trusted Lists

The following URLs provide the normative XML schemas required for implementing the EU Member State Trusted Lists (EUMS TL) and the List of Trusted Lists (LoTL):

* **EU MSTL Schema:** [https://forge.etsi.org/rep/esi/x19_612_trusted_lists/-/raw/v2.4.1/19612_xsd.xsd](https://forge.etsi.org/rep/esi/x19_612_trusted_lists/-/raw/v2.4.1/19612_xsd.xsd)
* **LoTL Schema:** [https://forge.etsi.org/rep/esi/x19_612_trusted_lists/-/raw/v2.4.1/19612_sie_xsd.xsd](https://forge.etsi.org/rep/esi/x19_612_trusted_lists/-/raw/v2.4.1/19612_sie_xsd.xsd)

### List of Trusted Entities

The following repository provides the normative JSON and XML schemas required for implementing the List of Trusted Entities (LoTE):

* **LoTE Schemas:** [https://forge.etsi.org/rep/esi/x19_60201_lists_of_trusted_entities](https://forge.etsi.org/rep/esi/x19_60201_lists_of_trusted_entities)

#### Trusted List Terminology Comparison

The LoTE and the LoTL / EUMS TL differ not only in their underlying schemas but also in their parameter nomenclature. The following table maps the equivalent terms between the two standards:

| TS 119 602 (LoTE) | TS 119 612 (TSL) |
| :--- | :--- |
| LoTE | TSL |
| Trusted Entity (TE) | Trust Service Provider (TSP) |
| Trusted Entity Service | Trust Service |
| LoTE Version Identifier | TSL Version Identifier |
| LoTE Sequence Number | TSL Sequence Number |
| LoTE Type | TSL Type |
| Scheme Operator | Scheme Operator |
| Service Digital Identity | Service Digital Identity |

### Specific Formats and Uses

The following table details the governing standards, publication scopes, and mandated data formats regarding the specific provider lists utilized within the ecosystem:

| List Type | Governing Standard | Publication Scope | Format |
| :--- | :--- | :--- | :--- |
| Traditional eIDAS Trusted Lists | TS 119 612 | Member State | XML |
| List of Trusted Lists (LoTL) | TS 119 612 | European Union | XML |
| PID Provider Lists | TS 119 602 Annex D | European Union | JSON |
| Wallet Provider Lists | TS 119 602 Annex E | European Union | JSON |
| Provider of WRPAC Lists | TS 119 602 Annex F | European Union | JSON |
| Provider of WRPRC Lists | TS 119 602 Annex G | European Union | JSON |
| Pub-EAA Provider Lists | TS 119 602 Annex H | European Union | JSON or XML |
| Registrar and Register Provider Lists | TS 119 602 Annex I | European Union | JSON |

> _**Note:**_ 
> Within the APTITUDE project, the Pub-EAA Provider Lists are published in JSON format. 

#### LoTE Additional Requirements

Following Annexes D - I in ETSI TS 119 602, below are detailed the additional requirements spelled out by type. As seen in [List of Trusted Entities](#list-of-trusted-entities), the LoTE contains a sequence of two components: `ListAndSchemeInformation` and `TrustedEntitiesList`. Depending on the LoTE type, the `ListAndSchemeInformation` component is further specified by the following parameters:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----: | :---------- |
| `LoTEVersionIdentifier` | ETSI TS 119 602 clause 6.3.1 | REQUIRED | *Integer* | The value of the `LoTEVersionIdentifier` component SHALL be `1`. |
| `LoTESequenceNumber` | ETSI TS 119 602 clause 6.3.2 | REQUIRED | *Integer* | The first instance of the PID providers list SHALL be issued with the value of the `LoTESequenceNumber` component number set to `1`. |
| `LoTEType` | ETSI TS 119 602 clause 6.3.3 | REQUIRED | *String* | Depending on the LoTE type, the value of the `LoTEType` component SHALL be one of the following URIs:<ul><li>"http://uri.etsi.org/19602/LoTEType/EUPIDProvidersList" for PID Providers;</li><li>"http://uri.etsi.org/19602/LoTEType/EUWalletProvidersList" for Wallet Providers;</li><li>"http://uri.etsi.org/19602/LoTEType/EUWRPACProvidersList" for Providers of WRPAC;</li><li>"http://uri.etsi.org/19602/LoTEType/EUPIDProvidersList" for Providers of WRPRC;</li><li>"http://uri.etsi.org/19602/LoTEType/EUPubEAAProvidersList" for Pub-EAA Providers;</li><li>"http://uri.etsi.org/19602/LoTEType/RegistrarsAndRegistersList" for Registrars.</li></ul> |
| `SchemeOperatorName` | ETSI TS 119 602 clause 6.3.4 | REQUIRED | *JSON Object* | No additional requirements. |
| `SchemeOperatorAddress` | ETSI TS 119 602 clause 6.3.5 | REQUIRED | *JSON Object* | No additional requirements. |
| `SchemeName` | ETSI TS 119 602 clause 6.3.6 | REQUIRED | *JSON Object* | No additional requirements. |
| `SchemeInformationURI` | ETSI TS 119 602 clause 6.3.7 | REQUIRED | *JSON Object* | Depending on the LoTE type, the `SchemeInformationURI` component SHALL contain a URI where users can receive information about the respective list (PID Provider, Wallet Provider, Provider of WRPAC, Provider of WRPRC, Pub-EAA Provider, Registrar and Registers), and a URI where users can retrieve all previous instances of those lists. |
| `StatusDeterminationApproach` | ETSI TS 119 602 clause 6.3.8 | REQUIRED | *String* | Depending on the LoTE type, the value of the `StatusDeterminationApproach` component SHALL be one of the following URIs:<ul><li>"http://uri.etsi.org/19602/PIDProvidersList/StatusDetn/EU" for PID Providers;</li><li>"http://uri.etsi.org/19602/WalletProvidersList/StatusDetn/EU" for Wallet Providers;</li><li>"http://uri.etsi.org/19602/WRPACProvidersList/StatusDetn/EU" for Providers of WRPAC;</li><li>"http://uri.etsi.org/19602/WRPRCProvidersList/StatusDetn/EU" for Providers of WRPRC;</li><li>"http://uri.etsi.org/19602/PubEAAProvidersList/StatusDetn/EU" for Pub-EAA Providers;</li><li>"http://uri.etsi.org/19602/RegistrarsAndRegistersList/StatusDetn/EU" for Registrars.</li></ul> |
| `SchemeTypeCommunityRules` | ETSI TS 119 602 clause 6.3.9 | REQUIRED | *JSON Object* | Depending on the LoTE type, the value of the `SchemeTypeCommunityRules` component SHALL be one of the following URIs:<ul><li>"http://uri.etsi.org/19602/PIDProvidersList/schemerules/EU" for PID Providers;</li><li>"http://uri.etsi.org/19602/WalletProvidersList/schemerules/EU" for Wallet Providers;</li><li>"http://uri.etsi.org/19602/EUWRPACProviders/schemerules/EU" for Providers of WRPAC;</li><li>"http://uri.etsi.org/19602/WRPRCProvidersList/schemerules/EU" for Providers of WRPRC;</li><li>"http://uri.etsi.org/19602/EUPubEAAProvidersList/schemerules/EU" for Pub-EAA Providers;</li><li>"http://uri.etsi.org/19602/RegistrarsAndRegistersList/schemerules/EU" for Registrars.</li></ul> |
| `SchemeTerritory` | ETSI TS 119 602 clause 6.3.10 | REQUIRED | *String* | The value of the `SchemeTerritory` component SHALL be `EU`. |
| `LoTEPolicyLegalNotice` | ETSI TS 119 602 clause 6.3.11 | REQUIRED | *JSON Object* | No additional requirements. |
| `HistoricalInformationPeriod` | ETSI TS 119 602 clause 6.3.12 | REQUIRED | *Integer* | For the PID Provider, Wallet Provider, Provider of WRPAC, Provider of WRPRC, Registrar and Registers LoTE, the `HistoricalInformationPeriod` component SHALL NOT be present.<br><br>For the Pub-EAA Providers LoTE, the `HistoricalInformationPeriod` component value SHALL be `65535` (representing a year). |
| `PointersToOtherLoTEs` | ETSI TS 119 602 clause 6.3.13 | REQUIRED | *JSON Object* | For the PID Provider, Wallet Provider, Provider of WRPAC, Provider of WRPRC, Registrar and Registers LoTE, the `PointersToOtherLoTE` component SHALL contain (at least) a pointer to the present LoTE itself.<br><br>For the Pub-EAA Provider LoTE, the `PointersToOtherLoTE` component SHALL NOT be present. |
| `ListIssueDateTime` | ETSI TS 119 602 clause 6.3.14 | REQUIRED | *String* | No additional requirements. |
| `NextUpdate` | ETSI TS 119 602 clause 6.3.15 | REQUIRED | *String* | The maximum value between the list issue date and time and the next update SHALL be 6 months. |
| `DistributionPoints` | ETSI TS 119 602 clause 6.3.16 | REQUIRED | *JSON Object* | No additional requirements. |
| `SchemeExtensions` | ETSI TS 119 602 clause 6.3.17 | REQUIRED | *JSON Object* | No additional requirements. |

The `TrustedEntitiesList` is a JSON Array of objects, each possessing two primary subcomponents: the `TrustedEntityInformation` and `TrustedEntityServices` components. The following table details the additional requirements the `TrustedEntityInformation` component MUST satisfy depending on the LoTE type.

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----: | :---------- |
| `TEName` | ETSI TS 119 602 clause 6.5.1 | REQUIRED | *JSON Object* | Depending on the LoTE type, the value of the `TEName` component SHALL be the name of the PID Provider, Wallet Provider, Provider of WRPAC, Provider of WRPRC, Pub-EAA Provider, or Registrar. |
| `TETradeName` | ETSI TS 119 602 clause 6.5.2 | REQUIRED | *JSON Object* | Depending on the LoTE type, the value of the `TETradeName` component SHALL include an official registration identifier as registered in official records (where such a registered identifier exists) that unambiguously identifies the entity.<br><br>In the case of a legal entity, the `TETradeName` component SHALL have the same semantics as the `organizationIdentifier` attribute in ETSI EN 319 412-1.<br><br>In the case of a natural person, the `TETradeName` component SHALL have the same semantics as the `serialNumber` attribute in ETSI EN 319 412-1.<br><br>For Pub-EAA Providers, the `TETradeName` SHALL additionally include the reference to the Union or national law under which the Public Sector Body is established as responsible for the Authentic Source, formatted as a URI: `OJ` for the scheme part, followed by either `EU` or the 2 ISO 3166-1 country code characters, terminating with the unique identifier of the law. |
| `TEAddress` | ETSI TS 119 602 clause 6.5.3 | REQUIRED | *JSON Object* | Depending on the LoTE type, the `TEAddress` component SHALL contain:<ul><li>the postal address of the provider;</li><li>the contact email and contact phone number of the provider.</li></ul>|
| `TEInformationURI` | ETSI TS 119 602 clause 6.5.4 | REQUIRED | *JSON Object* | Depending on the LoTE type, the `TEInformationURI` component SHALL contain:<ul><li>The URL of the webpage that contains the policies, terms, and conditions of the respective provider applying to the provision and use of their services/components;</li><li>where applicable, the URL of the webpage that contains additional information about the provider;</li><li>a URI formatted as `http://uri.etsi.org/19602/ListOfTrustedEntities/[Type]/CC`, where `[Type]` aligns with the provider type and `CC` is replaced by the ISO 3166-1 Alpha 2 country code of the responsible Member State.</li></ul> |
| `TEInformationExtensions` | ETSI TS 119 602 clause 6.5.5 | REQUIRED | *JSON Object* | No additional requirements. |
| `TrustedEntityServices` | ETSI TS 119 602 clause 6.5.6 | REQUIRED | *JSON Array* | The `TrustedEntityServices` component is an array of `TrustedEntityService` objects. |

Each `TrustedEntityService` object possesses the following parameters:

| Parameter | Defined in | Presence | Format | Description |
| :-------: | :--------: | :------: | :----: | :---------- |
| `ServiceTypeIdentifier` | ETSI TS 119 602 clause 6.6.1 | REQUIRED | *String* | Depending on the LoTE type, specific URIs MAY be used as the value of the `ServiceTypeIdentifier` component, to the exclusion of any other (e.g., `.../SvcType/PID/Issuance` and `.../Revocation` for PID services). |
| `ServiceName` | ETSI TS 119 602 clause 6.6.2 | REQUIRED | *JSON Object* | For a Wallet Provider, the `ServiceName` component SHALL be the name of the Wallet Solution it provides.<br><br>For a Registrar, the `ServiceName` component SHALL contain the name of the Register for which the Registrar is responsible.<br><br>No additional requirements for the other LoTE types. |
| `ServiceDigitalIdentity` | ETSI TS 119 602 clause 6.6.3 | REQUIRED | *JSON Object* | Depending on the LoTE type, the `ServiceDigitalIdentity` component SHALL contain one or more X.509 (Trust Anchor) certificates used to verify the signature or seal created by the provider to validate and authenticate their respective artifacts. The certified identity data MUST include the name and registration number as specified in the `TEName` and `TETradeName` components.<br><br>Pub-EAA Provider LoTE types MAY contain one or more X.509 certificates, which SHALL nonetheless be referenced on a QTSP EUMS TL. |
| `ServiceStatus` | ETSI TS 119 602 clause 6.6.4 | REQUIRED | *String* | The `ServiceStatus` component SHALL be present for Pub-EAA Provider LoTE. Specific URIs MAY be used as the value to indicate if the entity is notified or withdrawn.<br><br>The `ServiceStatus` component SHALL NOT be used for the other LoTE types. |
| `StatusStartingTime` | ETSI TS 119 602 clause 6.6.5 | REQUIRED | *String* | The `StatusStartingTime` component SHALL be present for Pub-EAA Provider LoTE.<br><br>The `StatusStartingTime` component SHALL NOT be used for the other LoTE types. |
| `SchemeServiceDefinitionURI` | ETSI TS 119 602 clause 6.6.6 | REQUIRED | *JSON Object* | No additional requirements. |
| `ServiceSupplyPoint` | ETSI TS 119 602 clause 6.6.7 | REQUIRED | *String* | For the Registrar LoTE, the `ServiceSupplyPoint` component SHALL contain the URI where the Register is available in a machine-processable manner. Any signed or sealed Register data obtained at this URI SHALL be able to be authenticated using one of the certificates listed in the `ServiceDigitalIdentity` component.<br><br>No additional requirements for the other LoTE types. |
| `TEServiceDefinitionURI` | ETSI TS 119 602 clause 6.6.8 | REQUIRED | *JSON Object* | No additional requirements. |
| `ServiceInformationExtensions` | ETSI TS 119 602 clause 6.6.9 | REQUIRED | *JSON Object* | For a Wallet Provider, the `ServiceInformationExtensions` component SHALL be used to provide the reference number of the Wallet Solution identified by the `ServiceName` component.<br><br>No additional requirements for the other LoTE types. |
| `HistoryInformation` | ETSI TS 119 602 clause 6.4.4 | REQUIRED | *JSON Array* | The `ServiceDigitalIdentity` component within a `ServiceHistoryInstance` component of a Pub-EAA Provider LoTE SHALL contain at least the `X509SKI` component and SHALL NOT contain an `X509Certificate` component.<br><br>No additional requirements for the other LoTE types. |

