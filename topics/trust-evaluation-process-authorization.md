# Trust Evaluation Process (Authorization)

---

## 1. Scope and definitions

### 1.1 What “Authorization” means here
Authorization is the set of checks and decisions that determine whether an interaction is permitted in the EUDI Wallet ecosystem, including:
- Issuance authorization: whether an Issuer (PID Provider / Attestation Provider) is registered for a role and (where applicable) for the specific attestation type(s) to be issued.
- Presentation authorization: whether a Relying Party request is within its registered scope (User-optional verification) and whether any embedded disclosure policy permits disclosure.

### 1.2 Authorization vs Authentication (Trust Evaluation)
Authorization is distinct from authentication trust evaluation:
- Authentication establishes *who the counterparty is* (e.g., validating an Access Certificate and trust anchor).
- Authorization establishes *what the counterparty is allowed to do* (e.g., registration role and type checks; requested versus registered scope checks; embedded disclosure policy evaluation).

> Key premise: Access Certificates do not express role/scope (e.g., “PID Provider”, “QEAA Provider”, or which attestation types are registered). Role/scope is determined via Registration Certificates and/or Registrar online service.

---

## 2. Normative prerequisites

### 2.1 Ordering constraint
The Authorization Process SHALL be performed only after successful Authentication of the counterparty.

### 2.2 Authorization evidence sources
Authorization decisions SHALL rely on one of the following evidence sources:
- Registration Certificate (RC), included by value, when available; and/or
- Registrar online service (registry lookup), when a Registration Certificate is not available or cannot be used.

Issuance MUST confirm registration before proceeding (hard gate).  
Presentation MAY proceed with warnings depending on user choice and failure type (see Section 6).

### 2.3 Embedded disclosure policies
Authorization SHALL conclude with evaluation of embedded disclosure policies (if applicable), which:
- are obtained and securely stored during issuance,
- and evaluated during presentation.

*Note: The User MAY overrule the outcome of disclosure policy evaluation.*

---

## 3. Use cases covered

1) **Issuance Authorization**  
A Wallet Unit authorizes a PID Provider / Attestation Provider before starting issuance, confirming the Provider is registered for the relevant role and for the attestation type(s) to be issued.

2) **Presentation Authorization (Remote)**  
A Wallet Unit authorizes a Relying Party request by:
- always preparing the User approval UI with identity and request scope,
- optionally verifying registered scope if User enabled that verification,
- evaluating embedded disclosure policies if applicable.

3) **Presentation Authorization (Proximity)**  
Same authorization semantics as Remote. Only transport differs (ISO/IEC 18013-5 proximity session vs HTTP/redirect-based remote).

4) **Presentation Authorization via Intermediary**  
Wallet Unit authorizes an Intermediary (authenticated via its own Access Certificate) while applying authorization context of the intermediated RP, including additional binding checks.

---

## 4. Entities involved

- Wallet Unit (WU): performs authorization checks; informs the User; enforces User approval.
- Issuer (PID Provider / Attestation Provider): provides signed Issuer metadata and MAY include a Registration Certificate by value.
- Relying Party Instance (RPI): submits a presentation request; if it has RC(s), it SHALL include a single certificate applicable to the current intended use, by value.
- Registrar online service: authoritative online source for registration information (e.g., registered scope per intended use; intermediary linkage registration; etc.).
- Provider of Registration Certificates: issues and signs registration certificates per ETSI TS 119 475 and applicable regulation.
- Intermediary: special category of Relying Party requesting attributes on behalf of an intermediated RP; authenticates with its own Access Certificate, but uses intermediated RP’s authorization context.

---

## 5. Decision model

### 5.1 Inputs
Authorization SHALL evaluate at least:
- Authenticated identity context (Access Certificate + protocol authentication) — prerequisite.
- Registration evidence:
  - Registration Certificate (by value), if present and usable; otherwise
  - Registrar online service lookup.
- Requested scope (requested attributes/credentials).
- Intended use (identifier and user-friendly description).
- Embedded disclosure policy (if applicable).
- User preference and approval (including whether the User enabled verification of RP registered info).

### 5.2 Outputs
The Wallet Unit SHALL produce:
- Machine decision: `AUTHORIZED` | `AUTHORIZED_WITH_WARNINGS` | `NOT_AUTHORIZED`
- User-facing information:
  - identity of the counterparty (intermediary and intermediated RP if applicable),
  - intended use and (if available) privacy policy link,
  - over-asking warnings (if verification performed and mismatch found),
  - disclosure policy outcome (and override affordance).

### 5.3 Failure semantics (hard-fail vs soft-fail)
- Issuance authorization: failures to confirm Issuer registration SHALL result in `NOT_AUTHORIZED` and MUST block issuance.
- Presentation authorization:
  - authentication failures are out-of-scope.
  - inability to obtain and verify registration info is typically soft-fail: Wallet SHALL notify the User and MAY allow User to continue.
  - “over-asking” mismatch is soft-fail: Wallet SHALL notify User and MAY allow continuation.
  - embedded disclosure policy denial is soft-fail with strong warning, with possible User override.

---

## 6. High-level process (phases and steps)

**Phase A — Collect authorization evidence**
1. Identify whether an Registration Certificate is present by value in the current transaction context.
2. If Registration Certificate is not present (or unusable), determine whether Registrar lookup is required:
   - Issuance: required; if querying the Registrar is not possible, optionally inspect the *entitlement* member included in the Credential Issuer Metadata itself per ETSI TS 119 472-3 section 4.2.3 (self-declaration. Is it in scope? See ISSU-24a and ISSU_34a).
   - Presentation: required only if the User opted-in to verify registered info and no usable Registration Certificate is available.

**Phase B — Validate evidence**
3. If RC present: validate RC (type, signature/chain, time validity, status list).
4. If Registrar lookup performed: validate authenticity and integrity of the registry response (mechanism TBD by applicable specification; treat unverifiable responses as “cannot confirm”).

**Phase C — Derive authorization context**
5. Extract and normalize:
   - subject identifiers (RP / Issuer),
   - entitlements (role),
   - intended use identifiers and user-friendly descriptions,
   - registered scope (credentials/attributes) if available,
   - intermediary fields if present.

**Phase D — Evaluate scope (presentation only; User-optional)**
6. If User enabled verification and registered scope is available: compare requested versus registered scope; produce mismatch warnings.

**Phase E — Evaluate embedded disclosure policies (presentation; when applicable)**
7. Evaluate policy against the authenticated request context (and intermediary rules where applicable).
8. Produce policy outcome and UI explanation (including optional layman link if present).

**Phase F — Prepare UI & obtain User approval**
9. Display required UI: identity, requested attributes, intended use, privacy link (if available), warnings, policy outcome.
10. Obtain User decision: approve/reject (and possible override of policy outcome).

**Phase G — Enforce decision**
11. If approved and authorized: proceed with issuance/presentation protocol.
12. Otherwise: abort or return error.

---

## 7. Process by use case

### 7.1 Issuance Authorization (PID or Attestation issuance)

**Objective**  
Before initiating issuance, the Wallet Unit MUST ensure the Provider is registered for:
- the relevant role (PID Provider vs Attestation Provider); and
- for attestations, the requested attestation type(s).

**Rules (Wallet Unit)**
- PID Provider: follow ISSU_24a (registration certificate entitlement → Registrar lookup → optional self-declared entitlement fallback; if not confirmed, warn User and MUST NOT request issuance).
- Attestation Provider: follow ISSU_34a (analogous).
- Attestation type registration: MUST be verified (not user-optional) (RPRC_23).
- If embedded disclosure policy is present in Issuer metadata: retrieve and store locally (EDP_10).

**Hard-gating**  
Authorization SHALL complete before the Wallet Unit proceeds with the issuance protocol (i.e., it is a gating precondition).

---

### 7.2 Presentation Authorization (Remote)

**Objective**  
After RP authentication and before presenting any attributes, the Wallet Unit:
- shows RP identity and requested attributes to the User,
- optionally verifies registered scope if User opted-in,
- evaluates embedded disclosure policy if applicable,
- and requests User approval.

**Key constraints**
- RP instance SHALL include RPRC_19a extension fields in each request; if it has registration certificates, it SHALL include one applicable certificate by value.
- If the User opted-in to verify registered info:
  - If registration certificate present: validate it and use it.
  - If absent: query Registrar online service.
  - If registered info cannot be obtained and verified: Wallet SHALL notify User.
  - If over-asking detected: Wallet SHALL notify User.

---

### 7.3 Presentation Authorization (Proximity)

Same semantics as Remote; only transport differs (ISO/IEC 18013-5 presentation session).  
Authorization steps and UI obligations remain identical.

---

### 7.4 Presentation Authorization via Intermediary

**Objective**  
Authorize a request sent by an Intermediary while applying authorization context of the intermediated RP, including relationship verification when user opted-in.

**Rules**
- Authenticate the Intermediary as the requester (access certificate identity).
- Detect intermediary case when:
  - authenticated identity (Intermediary) differs from intermediated RP identity conveyed via request extension and/or registration certificate.
- Display both identities (intermediary and intermediated RP) to the User.
- If User opted-in to verify registered info:
  - verify that the intermediary relationship is registered (certificate-based if possible; otherwise Registrar lookup).
- Perform over-asking checks against intermediated RP registered scope (not intermediary scope).
- Apply embedded disclosure policy semantics using intermediated RP identity and trust material.

---

## 8. Common sub-processes

### 8.1 Registration Certificate representation (ETSI TS 119 475)
A Registration Certificate according to ETSI TS 119 475 may be represented as:
- JWT/JWS with `typ = "rc-wrp+jwt"`, or
- CWT/COSE with `typ = "rc-wrp+cwt"`.

The payload includes (among others), depending on the registered entity and context:
- `registry_uri` (link to Registrar online service),
- `privacy_policy` (when applicable),
- intended-use information and registered scope (e.g., `credentials`),
- `entitlements` (from ETSI-defined set, e.g., Service_Provider, PID_Provider, QEAA_Provider, PUB_EAA_Provider, Non_Q_EAA_Provider),
- `status` (Status List reference with `idx` and `uri`),
- intermediary indication fields, when the relying party acts through an intermediary:
  - `usesIntermediary` and
  - `act.sub.id` / `act.sub.name` (identifying the intermediary).

**Validity constraint**  
`exp` SHALL NOT be later than 12 months after `iat` (ETSI TS 119 475 GEN-5.2.4-08).

---

### 8.2 Registration Certificate validation (minimum)
When validating an WRPRC, the Wallet Unit SHALL perform at least:

1) **Type check**  
Confirm `typ` is one of the supported RC types.

2) **Signature and chain validation**  
- JWT: verify JWS signature; validate certificate chain in `x5c` (as applicable).
- CWT: verify COSE signature; validate certificate chain in COSE headers (as applicable).

3) **Time validity**  
Enforce `iat/exp` and the 12-month maximum validity constraint.

4) **Status validation (mandatory)**  
Use the **Status List mechanism** defined by ETSI TS 119 475:
- `status.idx`: numeric string position in the bitstring
- `status.uri`: URI of the status list credential
Fetch status list and verify current status for `idx`.

> NOTE: Do not assume OCSP is available for this certificate type; the mandated revocation/suspension checking mechanism is the Status List.

5) **Claims extraction and normalization**  
Extract identifiers, entitlements, intended use, registered scope, registry_uri, privacy policy link, and intermediary fields (if present).

---

### 8.3 Registrar online service lookup (minimum)
When the Wallet Unit performs a Registrar lookup, it SHALL:
1. Construct the query using the inputs available (depending on use case):
   - Issuance: Issuer identity, role and type requested
   - Presentation: RP identifier and intended use identifier (from RPRC_19a)
   - Intermediary: intermediated RP identifier, intended use identifier and intermediary identity (if relationship check required)
2. Validate authenticity and integrity of the returned information (mechanism TBD by applicable technical specs; at minimum, treat unverifiable data as “cannot confirm”).
3. Apply caching and freshness controls (e.g., avoid stale scope/policy data).

---

### 8.4 Binding rules (authorization-relevant)

#### 8.4.1 Direct RP (non-intermediated)
If a WRPRC is present in a presentation request, the Wallet Unit SHALL verify that it is usable for authorization for the authenticated requester by checking consistency between:
- the authenticated RP identity (from Access Certificate), and
- the RP identity conveyed via:
  - WRPRC subject identifiers and/or
  - presentation-request extension fields.

If binding fails, the Wallet Unit SHALL treat the WRPRC as invalid for authorization purposes and SHALL notify the User during approval.

#### 8.4.2 Intermediary
In intermediated presentation:
- The Wallet Unit SHALL authenticate the intermediary using the intermediary’s access certificate.
- Authorization inputs (WRPRC, registry data, intended use) SHALL apply to the intermediated RP, not to the intermediary.
- If a WRPRC is provided for the intermediated RP and the RP acts through an intermediary:
  - the WRPRC SHALL include intermediary indication and the `act` structure.
  - the Wallet Unit SHALL verify `act.sub.id` matches the authenticated Intermediary identity.
- If User opted to verify registered information, the Wallet Unit SHALL verify the relationship between intermediary and intermediated RP is registered (certificate-based if possible; otherwise via Registrar lookup).

---

### 8.5 Requested vs registered scope comparison (User-optional)
If (and only if) the User enabled verification of RP registered info and the Wallet Unit obtained registered scope via WRPRC or Registrar lookup, then the Wallet Unit SHALL:
- compare requested scope versus registered scope,
- notify the User of any requested items not registered.

---

### 8.6 Embedded disclosure policy evaluation
If an embedded disclosure policy applies to a requested attestation:
- the Wallet Unit SHALL evaluate the policy in conjunction with information received from the requesting party,
- present the outcome to the User,
- and allow User override.

Policy types supported include at least:
- Authorised relying parties only: compare the RP identifier from the access certificate to the policy list; if intermediary case, compare the intermediated RP identifier.
- Specific root of trust: compare RP certificate chain (or, in intermediary case, the intermediated RP’s registration certificate provider root as applicable) against the policy list.

If a policy includes a layman link, Wallet Unit SHALL display it and allow navigation.

---

## 9. Diagrams (updated)

### 9.1 Generic authorization flow (presentation-oriented)
```mermaid
flowchart TB
  A["Authenticated counterparty (precondition)"] --> B["Collect authorization evidence"]
  B --> C{"Registration Certificate present & usable?"}
  C -- yes --> D["Validate WRPRC (type, signature/chain, time, status list)"]
  C -- no --> E{"Registrar lookup required?"}
  E -- "Yes (issuance) / Yes (presentation only if user opted-in)" --> F["Query Registrar online service"]
  E -- "No (presentation; user did not opt-in)" --> G["Skip registered-scope verification"]
  D --> H["Derive authorization context (IDs, entitlements, intended use, scope)"]
  F --> H
  H --> I{"User opted-in to verify registered scope?"}
  I -- yes --> J["Compare requested vs registered scope (over-asking)"]
  I -- no --> K["No scope comparison"]
  J --> L["Evaluate embedded disclosure policy (if applicable)"]
  K --> L
  L --> M["Prepare UI: identities, intended use, privacy link, warnings, policy outcome"]
  M --> N["User approval"]
  N --> O{"Approved?"}
  O -- yes --> P["Proceed with issuance/presentation"]
  O -- no --> Q["Abort / return error"]

  ---
  
**### 9.2 Issuance authorization flow (hard gate)**
```mermaid
flowchart TB
  A["Authenticated Issuer (precondition)"] --> B["Collect Issuer registration evidence"]
  B --> C{"WRPRC present in Issuer metadata?"}
  C -- yes --> D["Validate WRPRC + extract entitlements + registered attestation types"]
  C -- no --> E{"Registrar lookup possible?"}
  E -- yes --> F["Query Registrar for role + registered types"]
  E -- no --> G["Optional fallback: self-declared entitlement in metadata"]
  D --> H{"Registration confirmed?"}
  F --> H
  G --> H
  H -- no --> I["NOT_AUTHORIZED: warn User + MUST block issuance"]
  H -- yes --> J["If attestations: verify requested type is registered"]
  J --> K["Store embedded disclosure policy if present"]
  K --> L["Proceed with issuance protocol"]