# Trusted List and List of Trusted Lists

## Introduction

This section describes the format and contents of the Trusted Lists and how they are used for the purpose of the List of Trusted Lists and List of Trusted Entities within the context of the EUDIW.

## Regulatory background

The Trusted List is defined in article 22 of eIDAS regulation EU 910/2014 as the means to keep current and historical information about the accredited trust service providers in each Member State. One Trusted List must be maintained and published by each Member State.

Furthermore, according to Chapter II of Annex I of The CID (EU) 2015/1505, further amended by CID (EU) 2025/2164, Trusted Lists must follow the technical specification ETSI TS 119 612 version 2.1.1.

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