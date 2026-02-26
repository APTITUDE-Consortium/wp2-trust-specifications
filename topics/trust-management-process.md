# Trust Management Process
to do: ref webuild tech specs wrprc e wrpac

cosa gestiscono le policy?
se il cred catalogue è a livello MS, dovranno esserci policy a livello eu e a livello MS. le policy sono sia per identità che per autorizzazione. la policy discovery è interrogata da wallet: wallet nazionale interroga il proprio endpoint e quando opera in contesto MS?
il certificato esprime ciò che c'è nel register. info register deve rimanere sync con quella trasportata dal certificato . o registrar notifica ai issuer o qtsp e ca interrogano il registro per recuperare informazioni che sono state aggiornate. owner non avrà la responsabilità.

il ctlog è un servizio che raccoglie i timestamp di quando sono stati registrati i certificati . sprattutto nella prima fase di avvio ci sarà un alto tasso di cambiamento delle informazioni. 

aggiungere nota che la DPA Data Protection Authorities (che espone api tramite TS 08) notifica al registrar eventuale sospensione, idem altre authorities

Sectors have sectorial registries recognized by market or regulation (ie banks) where both identities and license registration could be reused in eudiw ecosystem. MS/EU/Registrars could adopt strategies in order to federate existing registries in order to use these information in eidas framework.
Sectorial authorities could act as NCA National Competent Authority, defining and notifing to eu commission a credential catalogue and license repository for sectorial operators and perhaps the data policies in accordance with european sectorial authority. EU commission's criteria to identify these actors is out of scope
If this scenario would be supported, different levels of trust should be managed, because different sectors could have different level of trust and this could qualify entities issuing EAA creds

**Table of Contents**

## normative & technical references
CIR
1. 2025/848 CIR 2025/848 of 6 May 2025 laying down rules for the application of Regulation (EU) No 910/2014 of the European Parliament and of the Council as regards the registration of wallet-relying parties (https://eur-lex.europa.eu/eli/reg_impl/2025/848/oj/eng)
2. 2025/848 amendement draft https://ec.europa.eu/info/law/better-regulation/have-your-say/initiatives/16113-European-Digital-Identity-Wallet-registration-of-wallet-relying-parties-update-_en

ARF
1. general reference 
2. TS02 : Specification of systems enabling the notification and subsequent publication of Provider information (https://github.com/eu-digital-identity-wallet/eudi-doc-standards-and-technical-specifications/blob/main/docs/technical-specifications/ts2-notification-publication-provider-information.md)
3. TS05 : Specification of common formats and API for Relying Party Registration information (https://github.com/eu-digital-identity-wallet/eudi-doc-standards-and-technical-specifications/blob/main/docs/technical-specifications/ts5-common-formats-and-api-for-rp-registration-information.md)
4. TS06 : Common Set of Relying Party Information to be Registered (https://github.com/eu-digital-identity-wallet/eudi-doc-standards-and-technical-specifications/blob/main/docs/technical-specifications/ts6-common-set-of-rp-information-to-be-registered.md)
5. TS08 : Specification of Common Interface for reporting of Relying Parties to Data Protection Authorities (https://github.com/eu-digital-identity-wallet/eudi-doc-standards-and-technical-specifications/blob/main/docs/technical-specifications/ts8-common-interface-for-reporting-of-wrp-to-dpa.md)

topics
Topic x : opic X - Relying Party registration (https://github.com/eu-digital-identity-wallet/eudi-doc-architecture-and-reference-framework/discussions/431)

Tech standards
3. Policy and security requirements for Trust Service Providers issuing certificates; Part 8: Access Certificate Policy for EUDI Wallet Relying Parties : ETSI TS 119 411 part 8 (https://www.etsi.org/deliver/etsi_ts/119400_119499/11941108/01.01.01_60/ts_11941108v010101p.pdf)
4. Relying party attributes supporting EUDI Wallet user's authorization decisions (Certificate profile and policy requirements for access and registration certificates) ETSI TS 119 475 (https://www.etsi.org/deliver/etsi_ts/119400_119499/119475/01.01.01_60/ts_119475v010101p.pdf)
5. 


## Intro
The aim of this chapter is to describe the lifecycle of 
1. entity identity and authorization information managed in the national registers
2. and the related certificates that are used to claim that identity and related authorization in EUDIW ecosystem: access (Wallet relying Party Access Certificate, aka WRPAC) and registration (Wallet relying Party Registration  Certificate, aka WRPRC) certificates.
The integrity and authenticity of these credentials is out of scope, assuming that Q seals and Q signing certificates are consolidated.

Wallet Relying Parties (WRP) Identity is delegated to national registrars according to national trust framework policies.


This topic is not fully covered by ARF or actual legislation (topic is open?) and probably some details will be delegated to member states, and so it could be useful to identify best practices and success stories from the market that could provide an "inspirational starting point" in order to define a sustainable and effective design. 
Banking sector is probably by nature a good example to be taken into consideration, and so there is a specific chapter that aims to describe the state of the art relating the authentication mechanisms in place at the present, and is described in Annex I. [allowed the entrance in this market of different actors able to integrate and extend the service offered by traditional banks. The use of authentication certificates could be taken as source of inspiration for defining a large scale application like the eudiw ecosystem]

The WRPAC is used in OIDC4VP and OID4VCI for authentication, so represents the identity keys of an entity. Access Certificates are used to sign the OID4VP request and also for signing the OID4VCI issuer metadata.The WRPRC is optional and used for authorization both in credential issuance and request steps whether the credential is some how referred to policies in the credential catalogue. For their description and use refer to [475]

webuild reference

# Trust management overview
todo file
475 Figure 1: Institutional architecture for registration of wallet-relying parties
national registers under Annex I, point 12 of CIR (EU) 2025/848 [i.2].

* qui mettiamo le swimline con ruoli e fase

blocchi di insieme e sequence diagram per blocco

different responsibilities for different information types
different lifecycle for certificates and for license

Lifecyle is based on different process phases:
1. registration: entity onboarding that includes register and
2. WRPAC & WRPRC issuance: after this phase entity can interact with ather actors in the ecosystem
3. authorization to operate could be revoked ( or information of entity could change affecting what's in the wrpac)
4. authorizations could change >> affecting wrprc that need reissuance, or rekey according to cert validity
5. license could change>> affecting certificate lifecycle

all certificate states and revocation mechanisms are in  ETSI 119 411-8 describes Access Certificate Policy for EUDI Wallet Relying Parties
 
# Credential catalogue and EAA policy management
The credential catalogue and related policies are not in scope of this chapter and are managed centrally by EU Commission. This topic is not defined yet [ref topic X (https://github.com/eu-digital-identity-wallet/eudi-doc-architecture-and-reference-framework/discussions/431)]
Credential types and their policy are linked to the entity identity as registration profile, aka authorization.
Of course changes in the policy repository will affect potentially the validity of registration certificates!!!

# Entity license management
## Registration (Onboarding wallet relying parties)
Each Member State will delegate a Registrar to manage the national register: it's a repository of identities and authorizations for entities that will handle attestations and attributes (in the issuance or presentation request phases).
The process and related attributes that must be collected are described in [CIR 2025/848 and its amendement https://ec.europa.eu/info/law/better-regulation/have-your-say/initiatives/16113-European-Digital-Identity-Wallet-registration-of-wallet-relying-parties-update-_en], and the process will be specific for member state and it's assumed to be equivalent. This enrollment represents a "license" to operate in the EUDIW ecosystem.
The first step is entity identification: the onboarding process must ensure adequate controls on the entity identity claims, using EUDI busines wallet or other authentication mechanisms. A unique identifier is assigned to the entity (WRP identifier) and operational attributes must be linked to that and that will be referred by WRPAC: credential offer endpoints, privacy policy statement URL.
The second step is entity authorization to handle credentials, autonomously or delegating an intermediary: both for the credential issuance and request operations, in case of explicit policy requirements enlisted in the EU credential catalogue, an explicit authorization must be provided on specific referred attributes or attestation types.
In this phase, entity must notify the registrar if it's intermediated by a technical provider, that will be verified against trusted lists and national registers.

The register information data model is described in [TS02] and api for registration and inquiry in the register are defined in [TS05] , data to be registered in TS06 
This process and register maintenance will be managed by national registrar.
TS06 . The CIR 848 amendement in annex V refers explicitly to etsi 475

National Registrar could integrate existing identity repository for specific sectors, according to NCA sector policies.

Registrar collects issued WRPAC and WRPRC certificates from providers. This must be done in order to be able to trigger their revocation towards certificate authorities in case of license withdrawal, and so cover req of "" in CIR 848
Registrar could publish the authorization data bound to WRPidentifier in case WRPRCs are not transmitted to the wallet, in order to fulfill policy requirements.

* Identity: different sectors manages licenses and appartenza in modo diverso con valenze e modalità. a good example is the banking sector, more structured and advanced under a regulation and standardization across europe.
* Certificate authority manages certificate issuance on the base of the information in the register (VAT+LEI and other specs). 
There are different sectors that act in different ways.

Registrar could include the engagement of the CA in the registration process, according to 
## revoca licenza ad operare 
NCA per wallet è ie ACN (agenzia per la cybersecurity nazionale ) italia 


# Access (WRPAC) and registration (WRPRC) certificate lifecyclwe
## issuance
In order to make the entity and its license effectevely operational in OID4VP and OID4VCI protocols, a certificate authority has to provide the authentication keys, and so it issues a WRPAC and WRPRC (Regulatory requirements are described in Annex E , data model in Annex B of ETSI 119 475).
This step requires a mutual authentication: the certificate authority must identify the applicant entity, and the entity must be able to check if the CA is present with this role in the trusted lists.
The CA so access the national register using management apis and provides the certificates according to certificate profile and policy requirements, described in ETSI 119.475 and referred in Annex V of CIR amendment draft.

****The Certificate Authority has to notify the Registrar as soon a WRPAC or WRPRC has been issued. Registrar should record all issued certificates in order to be able to ask for revocation if required. Revocation process cases and status management is described in [etsi 475]
The CA has the duty to publish all certificate according to Certificate transparency policies rif [?]. ca logga i timestamp sui log (il certificato è stato registrato) e obbligo di ca, logga in due log diversi gestiti da ctlog. quando ti connetti verifica signed certificate timestamp : verifico il certificato 1 emesso da ca in TL e che sia stato registrato gestori del ctlog
The WRP has to make available its WRPRC and WRPAC certificates online (il wallet dove deve cercarli????)
## revoca
1. per synco con NCA register
2. segnalazione abuso

# credntial presentation and issuance according to standard everyday flow
## Operational WRPAC and WRPRC application use
The use in oid4vp and oid4vci of these 2 certificates, policy discovery and WRPAC/WRPRC verification against trusted lists is not in scope.
Whether the WRPAC is mandatory, WRPRC is not (se wallet fa policy discovery, issuer o rp devono necessariamente mandare il wrprc XXX). This have two meanings:
1. credential policy could not require a specific authorization that is in the WRPRC
2. but even if it could require it, it's not mandatory to send it through the communication protocol, and so the wallet should verify the authorization set in the register for the WRP identifier, according to the credential policy.

The authentication mecanism 
* ARF  Reg_10a (separate certificate per Relying Party Instance), and clarifies that access certificates must include a user-presentable name (Reg_31)

## WRPAC and WRPRC examples and profiles
ref to https://github.com/webuild-consortium/wp4-trust-group/tree/main/task5-participants-certificates-policies




# Banking usecase

gestione segnalazioni e frodi (ts08)
qwac, registro dati e licenze su eu
nca possono manifestare interesse per ricevere certificati emessi da CAs







