# Trust Management Process
**Table of Contents**

## tech refs
certificate policy : https://www.etsi.org/deliver/etsi_ts/119400_119499/11941108/01.01.01_60/ts_11941108v010101p.pdf
par. 5.1 di TS 119 475


## Intro
The goal of this section is to describe the lifecycle of access (WRPAC) and registration (WRPRC) certificates.
Registrar manages the register : repository of identities and authorizations for identities related to specific credential types.
Certificate authority manages certificate issuance on the base of the information in the register (VAT+LEI and other specs). 
There are different sectors that act in different ways. 
banking case
different responsibilities for different information types
different lifecycle for certificate and for license

Lifecyle is based on different process phases:
1. registration: entity onboarding that includes register and
2. WRPAC & WRPRC issuance: after this phase entity can interact with ather actors in the ecosystem
3. authorization to operate could be revoked ( or information of entity could change affecting what's in the wrpac)
4. authorizations could change >> affecting wrprc that need reissuance, or rekey according to cert validity
5. license could change>> affecting certificate lifecycle

all certificate states and revocation mechanisms are in  ETSI 119 411-8 describes Access Certificate Policy for EUDI Wallet Relying Parties

