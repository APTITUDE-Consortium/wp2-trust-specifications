# Trust Management Process
**Table of Contents**

## tech refs
1. certificate policy : https://www.etsi.org/deliver/etsi_ts/119400_119499/11941108/01.01.01_60/ts_11941108v010101p.pdf
par. 5.1 di TS 119 475


## Intro
The goal of this section is to describe the lifecycle of access (Wallet relying Party Access Certificate, aka WRPAC) and registration (Wallet relying Party Registration  Certificate, aka WRPRC) certificates in EUDIW ecosystem.
All available regulation and normative references will be included in this document for each phase of the lifeycle process.
This topic is not fully covered by ARF or actual legislation (topic is open?), and so it could be useful to identify best practices and success stories from the market that could provide an "inspirational starting point" in order to define a sustainable and effective proposal. 
Banking sector is probably by nature a good example to be taken into consideration, and so there is a specific chapter that aims to describe the state of the art relating the authentication mechanisms in place at the present. 

The WRPAC is used in OIDC4VP and OID4VCI for authentication, so represents the identity key of an entity. Access Certificates are used to sign the OID4VP request and also for signing the OID4VCI issuer metadata.
The WRPRC is optional and used for authorization both in credential issuance and request steps whether the credential is regulated in the credential catalogue.

The de
Registrar manages the register : repository of identities and authorizations for identities related to specific credential types.
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

# Definition






