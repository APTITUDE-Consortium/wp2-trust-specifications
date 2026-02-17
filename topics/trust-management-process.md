# Trust Management Process
**Table of Contents**

## normative & technical references
CIR
1. 2025/848 CIR 2025/848 of 6 May 2025 laying down rules for the application of Regulation (EU) No 910/2014 of the European Parliament and of the Council as regards the registration of wallet-relying parties (https://eur-lex.europa.eu/eli/reg_impl/2025/848/oj/eng)

ARF
1. TS02 : Specification of systems enabling the notification and subsequent publication of Provider information (https://github.com/eu-digital-identity-wallet/eudi-doc-standards-and-technical-specifications/blob/main/docs/technical-specifications/ts2-notification-publication-provider-information.md)

Tech standards
3. Policy and security requirements for Trust Service Providers issuing certificates; Part 8: Access Certificate Policy for EUDI Wallet Relying Parties : ETSI TS 119 411 part 8 (https://www.etsi.org/deliver/etsi_ts/119400_119499/11941108/01.01.01_60/ts_11941108v010101p.pdf)
4. Relying party attributes supporting EUDI Wallet user's authorization decisions (Certificate profile and policy requirements for access and registration certificates) ETSI TS 119 475 (https://www.etsi.org/deliver/etsi_ts/119400_119499/119475/01.01.01_60/ts_119475v010101p.pdf)
5. 


## Intro
The aim of this chapter is to describe the lifecycle of 
1. entity identity and authorization information managed in the national registers
2. and the related certificates that are used to claim that identity and related authorization in EUDIW ecosystem: access (Wallet relying Party Access Certificate, aka WRPAC) and registration (Wallet relying Party Registration  Certificate, aka WRPRC) certificates.
All available normative and technical references will be referred for each phase.

This topic is not fully covered by ARF or actual legislation (topic is open?) and probably some details will be delegated to member states, and so it could be useful to identify best practices and success stories from the market that could provide an "inspirational starting point" in order to define a sustainable and effective design. 
Banking sector is probably by nature a good example to be taken into consideration, and so there is a specific chapter that aims to describe the state of the art relating the authentication mechanisms in place at the present, and is described in Annex I. 

The WRPAC is used in OIDC4VP and OID4VCI for authentication, so represents the identity keys of an entity. Access Certificates are used to sign the OID4VP request and also for signing the OID4VCI issuer metadata.The WRPRC is optional and used for authorization both in credential issuance and request steps whether the credential is some how referred to policies in the credential catalogue. For their description and use refer to [475]

# Trust management overview

475 Figure 1: Institutional architecture for registration of wallet-relying parties
national registers under Annex I, point 12 of CIR (EU) 2025/848 [i.2].

* qui mettiamo le swimline con ruoli e fase

blocchi di insieme e sequence diagram per blocco
 
# Credential catalogue and EAA policy management

## Entity license registration (Onboarding relying parties)
Each Member State will delegate a Registrar to manage the national register: it's a repository of identities and authorizations for entities that will handle attestations and attributes (in the issuance or presentation request phases).
The process and related attributes that must be collected are described in [CIR 848].This enrollment represents a license to operate in the EUDIW ecosystem.
The first step is entity identification: the onboarding process must ensure adequate controls on the entity identity claims, using EUDI busines wallet or other authentication mechanisms. A unique identifier is assigned to the entity (WRP identifier) and operational attributes must be linked to that and that will be referred by WRPAC: credential offer endpoints, privacy policy statement URL.
The second step is entity authorization to handle credentials: both for the credential issuance and request operations, in case of explicit policy requirements enlisted in the EU credential catalogue, an explicit authorization must be provided on specific referred attributes or attestation types.
In this phase, entity must notify the registrar if it's intermediated by a technical provider, that will be verified against trusted lists and national registers.

The register information data model is described in [TS02]
The credential catalogue and related policies are not in scope of this chapter and are managed centrally by EU Commission. 


### Management services
The Member State Registrar will provide:
1. Registration service: api/interface to request registration or updating entity's information in the national register
2. Cancellation service: authenticates and manages cancellation requests
3. Inquiry service: publishes register information for certificate authorities to enable WRPAC & WRPRC issuance

## WRPAC and WRPRC issuance
In order to make the entity and its license effectevely operational, a certificate authority has to provide the authentication keys, and so issues a WRPAC and WRPRC.
This step requires a mutual authentication: the certificate authority must identify the applicant entity, and the entity must be able to check if the CA is present with this role in the trusted lists.
Certificate profile and policy requirements are described in ETSI 119.475

Different ways to manage the registration phase could be supported by the MS registrar:
1. ACME
2. integration with existing license sectorial repositories: the banking sector is strongly regulated and in the latest years faced a transformation with the PSD2 regulation that allowed the entrance in this market of different actors able to integrate and extend the service offered by traditional banks. The use of authentication certificates could be taken as source of inspiration for defining a large scale application like the eudiw ecosystem

and all these possibilities must satisfy a set of requirements...

The Certificate Authority has to notify the Registrar as soon a WRPAC or WRPRC has been issued. Registrar should record all issued certificates in order to be able to ask for revocation if required.



### Management services

1. Certificate request service: 
2. Revocation service: receives and authenticates revocation requests
3. Status service: 


## Operational WRPAC and WRPRC application use
the use of these 2 certificates is not in scope.
we simply remind that the attestation presentation request and issuance requires the authentication of entities using certs. if the wrprc is not provided could be retrieved by somewhere

## License information update or revocation
Updates to the register of course could be managed by entity's active request or autonomously by the registrar. The information update could affect identification data or registration and attestation permissions. The Registrar is responsible for handling this operation, it does not matter throughout which application mechanism (is automatic data collection after a notification, or after to be notified by a sectorial National Competent Authority) .
This information change triggers a notification to the Certificate Authorities that issued certificates (tracked in the register) on the basis of the trusted information in the register. CA's contact information is in the trusted list. 
The CA is responsible to revoke the certificates and eventualy to issue updated new ones for the entity. In any case the CA is in charge to notify the certificate status to the entity.





* legal endorsement of the authentication mechanism is to be found in
* ARF  Reg_10a (separate certificate per Relying Party Instance), and clarifies that access certificates must include a user-presentable name (Reg_31)
* 
Identity: different sectors manages licenses and appartenza in modo diverso con valenze e modalità. a good example is the banking sector, more structured and advanced under a regulation and standardization across europe.

Certificate authority manages certificate issuance on the base of the information in the register (VAT+LEI and other specs). 
There are different sectors that act in different ways. 
banking case
different responsibilities for different information types
different lifecycle for certificates and for license

Lifecyle is based on different process phases:
1. registration: entity onboarding that includes register and
2. WRPAC & WRPRC issuance: after this phase entity can interact with ather actors in the ecosystem
3. authorization to operate could be revoked ( or information of entity could change affecting what's in the wrpac)
4. authorizations could change >> affecting wrprc that need reissuance, or rekey according to cert validity
5. license could change>> affecting certificate lifecycle

all certificate states and revocation mechanisms are in  ETSI 119 411-8 describes Access Certificate Policy for EUDI Wallet Relying Parties
# Service API
entity deve esporre pubblicamente i due certificati
CA CRL e OCSP
Register api exposed by registrar
registrar exposes a process to collect registration, update o revocation requests


# Definition

# Banking usecase







