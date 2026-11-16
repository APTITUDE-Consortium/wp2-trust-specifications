The **Trust Anchor Validation Process** verifies the cryptographic integrity of a <artifacts:List of Trusted Entities (LoTE)|LoTE> and checks its signing certificate against the set published for its type in the <artifacts:Official Journal of APTITUDE (OJA)|OJA>. For <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)|QEAA Providers>, it instead authenticates the pilot <artifacts:List Of Trusted Lists (LOTL)|LOTL> and the <artifacts:Trusted List (TL)|Trusted List> it points to. The accepted <artifacts:List of Trusted Entities (LoTE)|LoTE> and the accepted pilot <artifacts:Trusted List (TL)|Trusted List> are the sources for <artifacts:Trust Anchor|Trust Anchors>. A <artifacts:Trust Anchor> is an X.509 certificate containing the name and public key used by a <components:Wallet Unit> or <roles:Wallet-Relying Party (WRP)|WRP> to validate an artifact or <credentials:Attestation>.

!!! choice "APTITUDE Implementation Choice"

    All <artifacts:Trust Anchor|Trust Anchors> SHALL be obtained from the applicable dedicated <artifacts:List of Trusted Entities (LoTE)|LoTE>, except those of <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)|QEAA Providers>, which SHALL be obtained from the pilot <artifacts:List Of Trusted Lists (LOTL)|LOTL> and <artifacts:Trusted List (TL)|Trusted Lists> as specified in this section. This applies to <roles:Provider of Person Identification Data (PID Provider)|PID Providers>, <roles:Wallet Provider (WP)|Wallet Providers>, <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)|Providers of WRPAC>, <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)|Providers of WRPRC>, <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|PuB-EAA Providers>, <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|EAA Providers>, <roles:Registrar|Registrars> and their <components:Register|Registers>.

Depending on the artifact or <credentials:Attestation> being verified, the validating entity SHALL fetch, download, and validate the dedicated <artifacts:List of Trusted Entities (LoTE)|LoTE> for the required entity type, or the pilot <artifacts:List Of Trusted Lists (LOTL)|LOTL> and <artifacts:Trusted List (TL)|Trusted List> for <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA>. The lists are used to retrieve <artifacts:Trust Anchor|Trust Anchors> for validating:

1. **Infrastructure Certificates**: <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPACs> and <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRCs>.
2. **<artifacts:Wallet Unit Attestation (WUA)|Wallet Unit Attestations (WUAs)>**: <artifacts:Key Attestation (KA)> and <artifacts:Wallet Instance Attestation (WIA)>.
3. **<credentials:Person Identification Data (PID)|PID> Signatures**: <credentials:Person Identification Data (PID)>.
4. **<credentials:Attestation> Signatures and Seals**: <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA> (through the pilot <artifacts:Trusted List (TL)|TL> and <artifacts:List Of Trusted Lists (LOTL)|LOTL>), <credentials:Electronic Attestation of Attributes (EAA)|EAA>, and <credentials:Public Electronic Attestation of Attributes (PuB-EAA)|Pub-EAA>.
5. **Artifacts and <credentials:Attestation> Status and Revocation Information**: <artifacts:Status List Token> for <credentials:Attestation|Attestations>, <artifacts:Key Attestation (KA)|KA>, <artifacts:Wallet Instance Attestation (WIA)|WIA>, and <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> status information; <artifacts:Certificate Revocation List (CRL)|CRL> or <protocols:Online Certificate Status Protocol (OCSP)|OCSP> for <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> and Sign/Seal Certificate status information.
6. **Registrar-signed Artifacts**: <components:Register> information.

!!! choice "APTITUDE Implementation Choice"

    The <artifacts:Trust Anchor|Trust Anchors> for <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|EAA Providers> SHALL be retrieved from and validated against their dedicated <artifacts:List of Trusted Entities (LoTE)|LoTE>, and the same <artifacts:List of Trusted Entities (LoTE)|LoTE> validation process SHALL be used for these <artifacts:Trust Anchor|Trust Anchors> as for all other APTITUDE entities. The <artifacts:Trust Anchor|Trust Anchors> for <roles:Provider of Qualified Electronic Attestation of Attributes (QEAA Provider)|QEAA Providers> SHALL be retrieved only from the pilot <artifacts:List Of Trusted Lists (LOTL)|LOTL> and <artifacts:Trusted List (TL)|Trusted List>, validated under the dispatch and runtime acceptance rules of this section, and SHALL NOT fall back to a <artifacts:List of Trusted Entities (LoTE)|LoTE>.

To validate a retrieved <artifacts:List of Trusted Entities (LoTE)|LoTE> under the APTITUDE profile, the validating entity SHALL:

- obtain the location and authorized signing certificate set for the requested <artifacts:List of Trusted Entities (LoTE)|LoTE> type from the <artifacts:Official Journal of APTITUDE (OJA)>;
- verify the <artifacts:List of Trusted Entities (LoTE)|LoTE> signature or seal using the format-specific procedure and compare its signing certificate, by exact DER certificate identity, with the certificate set published for that type in the <artifacts:Official Journal of APTITUDE (OJA)|OJA>;
- validate the <artifacts:List of Trusted Entities (LoTE)|LoTE> structure, requested type, publication location, freshness, and sequence number.

#### Trust-Source Dispatch

**Inputs and Outcome**

Inputs are the requested artifact or attestation and provider kind, provider certificate and service identity, required service type, territory `CC` (uppercase ISO 3166-1 Alpha-2), and current runtime validation time. Authentication, runtime acceptance and service eligibility are separate results. Runtime rejection SHALL return no <artifacts:Trust Anchor>.

The validator SHALL route <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA> requests exclusively through the pilot <artifacts:List Of Trusted Lists (LOTL)|LOTL> and <artifacts:Trusted List (TL)|TL>, with no <artifacts:List of Trusted Entities (LoTE)|LoTE> fallback. <roles:Provider of Person Identification Data (PID Provider)|PID Providers>, <roles:Wallet Provider (WP)|Wallet Providers>, <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)|Providers of WRPAC>, <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)|Providers of WRPRC>, <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|PuB-EAA Providers>, <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|EAA Providers>, and <roles:Registrar|Registrars> and <components:Register|Registers> SHALL use their respective seven retained JSON <artifacts:List of Trusted Entities (LoTE)|LoTE> paths below. Stored lists and <artifacts:Trust Anchor|Trust Anchors> SHALL preserve source/profile separation, following [ARF Trust Model, Section 6.6.3.6].

**Governing Sources**

The LoTE validation is governed by [ETSI TS 119 605 V0.0.3 (2026-06)], with the pilot choices of [Pilot LoTE Profile Constraints](#pilot-lote-profile-constraints) and [List of Trusted Entities Validation](#list-of-trusted-entities-validation). The pilot LOTL and TL validation is governed by [ETSI TS 119 615 V1.4.1 (2026-05)] and [ETSI TS 119 612 V2.4.1 (2025-08)], as applied in [List of Trusted Lists Validation](#list-of-trusted-lists-validation) and [Trusted List Validation](#trusted-list-validation).

#### List of Trusted Lists Validation

This process authenticates the current pilot <artifacts:List Of Trusted Lists (LOTL)|LOTL> for a <components:Wallet Unit> or <roles:Wallet-Relying Party (WRP)|WRP>. The complete procedure in [ETSI TS 119 615 V1.4.1 (2026-05), Clauses 4.0 and 4.1.1–4.1.4] SHALL govern, subject to the pilot bootstrap mapping below.

**Inputs and State**

The validator SHALL use the input and state contract of Clause 4.1.2, with the following substitutions for the preconfigured parameters of Clause 4.0:

| Pilot parameter | Source parameter | Pilot binding |
| --- | --- | --- |
| `OJA-Loc` | `OJEU-Loc` | Initially, the fixed locally configured URI of the pilot <artifacts:Official Journal of APTITUDE (OJA)\|OJA> publication. |
| `OJA-LOTL-Loc` | `OJEU-LOTL-Loc` | Current <artifacts:List Of Trusted Lists (LOTL)\|LOTL> XML location supplied by that publication. |
| `OJA-LOTL-Certs-Set` | `OJEU-LOTL-Certs-Set` | Full set of LOTL-signing certificates supplied by that publication. |

The <artifacts:Official Journal of APTITUDE (OJA)|OJA> publication is unsigned and is not independently authenticated. The validator SHALL accept its initial bootstrap data under the explicit APTITUDE discovery assumption at the fixed configured pilot <artifacts:Official Journal of APTITUDE (OJA)|OJA> URI.

**Authentication**

The validator SHALL execute the complete referenced procedure, including its archived-pivot processing and authenticated parameter updates, using the mapped pilot parameters. Source-defined status and sub-status identifiers SHALL retain their original names, including identifiers containing `OJEU`.

For <artifacts:List Of Trusted Lists (LOTL)|LOTL> and pivot signature authentication, the validator SHALL directly trust the list-signing certificate as specified in Clause 4.1.4, with authorization established by that procedure. The CA <artifacts:Trust Anchor> Certificate profile and entity Sign/Seal certificate-chain rules SHALL NOT be applied to these directly trusted list-signing certificates; see [Trust Anchor Certificate Profiles](../sections/trust-artifacts.md#trust-anchor-certificate).

**Outputs**

The validator SHALL preserve `Authenticated-LOTL`, `LOTL-Status` and `LOTL-Sub-Status` as specified in Clauses 4.1.3–4.1.4, including initialization to void, all failure indications and supplementary indications, and the `LOTL_VERIFICATION_PASSED` success result. `Authenticated-LOTL` is the authenticated current XML <artifacts:List Of Trusted Lists (LOTL)|LOTL> on success and is void on authentication failure as specified by the source procedure.

#### Trusted List Validation

This process authenticates the pilot <artifacts:Trusted List (TL)|Trusted List> for a <components:Wallet Unit> or <roles:Wallet-Relying Party (WRP)|WRP>. The complete procedure in [ETSI TS 119 615 V1.4.1, Clauses 4.2.1–4.2.4] SHALL govern, subject to the pilot bindings below.

**Input**

The validator SHALL use the input contract of Clause 4.2.2: `CC` is the uppercase ISO 3166-1 Alpha-2 country code of the emulated Member State whose <artifacts:Trusted List (TL)|TL> is requested.

**Pilot Bindings**

The LOTL validation call in Clause 4.2.4 SHALL invoke [List of Trusted Lists Validation](#list-of-trusted-lists-validation), using its pilot <artifacts:Official Journal of APTITUDE (OJA)|OJA> bootstrap mapping. From the resulting `Authenticated-LOTL`, the validator SHALL select the `PointersToOtherTSL` tuple whose scheme-territory qualifier equals `CC` and whose MIME-type qualifier identifies XML (`application/vnd.etsi.tsl+xml`), as defined in the [LOTL profile](../sections/trust-artifacts.md#list-of-trusted-lists). That tuple supplies both `EUTL-Loc`, the XML <artifacts:Trusted List (TL)|TL> retrieval location, and `EUTL-Certs-Set`, the authorized TL-signing certificate set.

The validator SHALL authenticate the <artifacts:Trusted List (TL)|TL> signature using `EUTL-Signer-Cert` as a directly trusted certificate authorized by that tuple, as specified in Clause 4.2.4. These list-signing certificates are distinct from <artifacts:Trusted List (TL)|TL> service digital identities and CA <artifacts:Trust Anchor> Certificates. The CA <artifacts:Trust Anchor> Certificate profile and entity Sign/Seal certificate-chain rules SHALL NOT be applied to the directly trusted TL-signing certificate; see [Trust Anchor Certificate Profiles](../sections/trust-artifacts.md#trust-anchor-certificate).

**Outputs**

The validator SHALL preserve `Authenticated-EUTL`, `EUTL-Status` and `EUTL-Sub-Status` under Clauses 4.2.3–4.2.4, including initialization to void, all failure and supplementary indications, and the `EUTL_VERIFICATION_PASSED` success result. `Authenticated-EUTL` is the authenticated XML <artifacts:Trusted List (TL)|TL> on success and remains void on authentication failure under that procedure. If the <artifacts:Trusted List (TL)|TL>'s `NextUpdate` has passed, the procedure adds `WARNING_EUTL_NEXTUPDATE_PASSED` while retaining its source-defined authentication result.

#### Pilot TL and LOTL Runtime Acceptance

The dispatch procedure SHALL initiate required retrieval under the cache rules below and [List of Trusted Lists Validation](#list-of-trusted-lists-validation) and [Trusted List Validation](#trusted-list-validation), governed by [ETSI TS 119 615 V1.4.1 (2026-05), Clauses 4.1–4.2]. Authentication hands off to the following common checks; these checks consume authentication outputs, retrieval time and persisted sequence/digest state and SHALL NOT invoke authentication again. Required refresh SHALL be attempted before rejecting a stale cached instance.

1. Require successful authentication. Preserve all ETSI authentication statuses and sub-statuses on every local runtime failure. Report runtime acceptance separately; runtime rejection SHALL return no <artifacts:Trust Anchor> or usable trust context.
2. Independently check each authenticated current <artifacts:Trusted List (TL)|TL> and <artifacts:List Of Trusted Lists (LOTL)|LOTL> against its applicable pilot profile in [Trust Artifacts](../sections/trust-artifacts.md#trusted-list), requiring `ListIssueDateTime` not later than the current runtime validation time and `NextUpdate` later than that time, under [ETSI TS 119 612 V2.4.1 (2025-08), Clauses 5.3.14–5.3.15]. An overdue <artifacts:Trusted List (TL)|TL> SHALL be rejected even with `EUTL_VERIFICATION_PASSED` and `WARNING_EUTL_NEXTUPDATE_PASSED`.
3. Apply the sequence and signed-content-digest conflict checks below independently to each current list. All profile, freshness and state checks SHALL succeed, and the highest accepted state SHALL be successfully persisted, before reporting runtime success or returning usable trust context. Failure to persist SHALL reject runtime use without a <artifacts:Trust Anchor>. Dispatch SHALL require acceptance of both current lists.

This process supplies authenticated, runtime-accepted <artifacts:Trusted List (TL)|TL> service information and service identity or path context. The calling [Sign/Seal Validation](../sections/trust-evaluation-process.md#signseal-validation-process) procedure owns <credentials:Qualified Electronic Attestation of Attributes (QEAA)|QEAA> matching, qualification and provider binding under [ETSI TS 119 615 V1.4.1 (2026-05), Clauses 4.3 and 4.6]; matching alone does not establish qualification. Service digital identity, status and effective time follow [ETSI TS 119 612 V2.4.1 (2025-08), Clauses 5.5.3–5.5.5]. Any applicable CA <artifacts:Trust Anchor> follows the existing <artifacts:Trust Anchor> definition; non-CA direct service identities remain governed by the cited matching procedures rather than the CA-anchor profile. Absent or ambiguous eligible identities SHALL yield no <artifacts:Trust Anchor>.

**Current-List Cache and Rollback State**

For each current pilot <artifacts:Trusted List (TL)|TL> and <artifacts:List Of Trusted Lists (LOTL)|LOTL> independently, the validator SHALL retrieve the current list when no accepted cached instance exists, 24 hours have elapsed since retrieval, or `NextUpdate` has been reached, whichever occurs first. A failed required refresh SHALL reject runtime use without a <artifacts:Trust Anchor>. Publication and update detection follow [ETSI TS 119 612 V2.4.1 (2025-08), Clause 6.1]; a published digest does not authenticate a list.

For each logical current list, the validator SHALL persist across refreshes and restarts the highest accepted `TSLSequenceNumber` and a SHA-256 digest of the signed content (the canonicalized XML document after the enveloped-signature transform). Following [ETSI TS 119 612 V2.4.1 (2025-08), Clause 5.3.2], it SHALL reject lower sequences and equal sequences with differing signed-content digests. It SHALL update this state only after all runtime checks succeed and before reporting runtime acceptance. State SHALL remain separate for each <artifacts:Trusted List (TL)|TL> territory, the <artifacts:List Of Trusted Lists (LOTL)|LOTL>, and each retained <artifacts:List of Trusted Entities (LoTE)|LoTE> type, preserving source/profile separation through authenticated location updates.

Archived pivots SHALL follow the cited <artifacts:List Of Trusted Lists (LOTL)|LOTL> authentication procedure and SHALL be exempt from current-list cache, freshness and rollback checks. They SHALL NOT substitute for current lists in runtime <artifacts:Trust Anchor> selection.

#### List of Trusted Entities Validation

This section defines the validation of a <artifacts:List of Trusted Entities (LoTE)|LoTE>. The <artifacts:List of Trusted Entities (LoTE)|LoTE> format is specified in [List of Trusted Entities](../sections/trust-artifacts.md#list-of-trusted-entities).

!!! choice "APTITUDE Discovery Assumption"

    The <artifacts:Official Journal of APTITUDE (OJA)|OJA> publication is made available at a fixed, locally configured URI only available to the APTITUDE Partners, but is not signed or independently authenticated within APTITUDE.

    A <components:Wallet Unit> or <roles:Wallet-Relying Party (WRP)|WRP> SHALL accept the type-specific <artifacts:List of Trusted Entities (LoTE)|LoTE> location and authorized signing certificate set obtained from that publication.

For the duration of APTITUDE, the <artifacts:Official Journal of APTITUDE (OJA)|OJA> publication URI, each type-specific <artifacts:List of Trusted Entities (LoTE)|LoTE> location, and the authorized signing certificate set for each type will remain unchanged. New versions of a <artifacts:List of Trusted Entities (LoTE)|LoTE> SHALL replace the current version at that type's fixed location and SHALL be signed with a certificate from its fixed set.

##### List of Trusted Entities Retrieval and Validation Sequence Diagram

```mermaid
sequenceDiagram
  participant Client as Wallet/WRP
  participant OJA as Official Journal of APTITUDE
  participant Distribution as LoTE Distribution Point

  Client->>OJA: Request discovery for required LoTE type
  OJA-->>Client: Return fixed location and signer certificate set
  Client->>Distribution: Request current LoTE at the type-specific location
  Distribution-->>Client: Return JSON/JWT LoTE
  Client->>Client: Verify format-specific signature, schema and type
  Client->>Client: Compare signer certificate with OJA certificate set
  Client->>Client: Check scheme URI, publication location, freshness and sequence
  Client->>Client: Parse x5c chain, match subject of signing certificate to TEName and select service
  Client->>Client: Select Trust Anchor by issuer and AKI from ServiceDigitalIdentity
  Client->>Client: Check SdiMatching, status applicability and critical extensions
  Client->>Client: Persist highest accepted sequence and digest
  Client->>Client: Accept LoTE and return the Trust Anchor
```

##### Pilot LoTE Profile Constraints

The <artifacts:List of Trusted Entities (LoTE)|LoTE> profile constraints of [ETSI TS 119 605 V0.0.3 (2026-06), Clause 4.1.1] (work in progress) apply to each retained type, with the pilot values below. [ETSI TS 119 605 V0.0.3 (2026-06), Annex C] gives values for the PID and Wallet Provider lists only; the pilot sets the values for the other five types here. Every constraint is set for every type, except `SupportedStatuses`, which is not set where the table says so. The identifier, status and service type values are defined once in the [List of Trusted Entities](../sections/trust-artifacts.md#list-of-trusted-entities) and are referred to here, not repeated. `LoTESigningCertificates` and `LoTELocation` are the type's `OJA-LoTE-Certs-Set` and `OJA-LoTE-Loc`, defined under the process below.

The EAA Provider list has no counterpart in [ETSI TS 119 605 V0.0.3 (2026-06), Annex C], so its constraints are stated in full in its own table.

###### PID Provider

| Constraint | Value |
| --- | --- |
| `LoTEType` | The `LoTEType` URI of this type. |
| `SchemeTerritory` | `EU`. |
| `LoTESigningCertificates` | The `OJA-LoTE-Certs-Set` of this type. |
| `LoTEMimeType` | `application/jwt`. |
| `LoTELocation` | The `OJA-LoTE-Loc` of this type. |
| `PivotEnabled` | `FALSE`. |
| `SupportedSti` | The `Issuance` and `Revocation` service type identifiers of this type. |
| `SupportedStatuses` | Not set. |
| `StatusCoherenceOnSti` | `TRUE` for each identifier in `SupportedSti`. |
| `SdiMatching` | At least one `organizationName` in the subject name of a certificate in `ServiceDigitalIdentity` equals at least one `TEName` value. The per-certificate rule for `ServiceDigitalIdentity` in the List of Trusted Entities applies in addition. |
| `StatusStartingTimePresent` | `FALSE`. |

###### Wallet Provider

| Constraint | Value |
| --- | --- |
| `LoTEType` | The `LoTEType` URI of this type. |
| `SchemeTerritory` | `EU`. |
| `LoTESigningCertificates` | The `OJA-LoTE-Certs-Set` of this type. |
| `LoTEMimeType` | `application/jwt`. |
| `LoTELocation` | The `OJA-LoTE-Loc` of this type. |
| `PivotEnabled` | `FALSE`. |
| `SupportedSti` | The `Issuance` and `Revocation` service type identifiers of this type. |
| `SupportedStatuses` | Not set. |
| `StatusCoherenceOnSti` | `TRUE` for each identifier in `SupportedSti`. |
| `SdiMatching` | At least one `organizationName` in the subject name of a certificate in `ServiceDigitalIdentity` equals at least one `TEName` value. The per-certificate rule for `ServiceDigitalIdentity` in the List of Trusted Entities applies in addition. |
| `StatusStartingTimePresent` | `FALSE`. |

###### Provider of WRPAC

| Constraint | Value |
| --- | --- |
| `LoTEType` | The `LoTEType` URI of this type. |
| `SchemeTerritory` | `EU`. |
| `LoTESigningCertificates` | The `OJA-LoTE-Certs-Set` of this type. |
| `LoTEMimeType` | `application/jwt`. |
| `LoTELocation` | The `OJA-LoTE-Loc` of this type. |
| `PivotEnabled` | `FALSE`. |
| `SupportedSti` | The `Issuance` and `Revocation` service type identifiers of this type. |
| `SupportedStatuses` | Not set. |
| `StatusCoherenceOnSti` | `TRUE` for each identifier in `SupportedSti`. |
| `SdiMatching` | At least one `organizationName` in the subject name of a certificate in `ServiceDigitalIdentity` equals at least one `TEName` value. The per-certificate rule for `ServiceDigitalIdentity` in the List of Trusted Entities applies in addition. |
| `StatusStartingTimePresent` | `FALSE`. |

###### Provider of WRPRC

| Constraint | Value |
| --- | --- |
| `LoTEType` | The `LoTEType` URI of this type. |
| `SchemeTerritory` | `EU`. |
| `LoTESigningCertificates` | The `OJA-LoTE-Certs-Set` of this type. |
| `LoTEMimeType` | `application/jwt`. |
| `LoTELocation` | The `OJA-LoTE-Loc` of this type. |
| `PivotEnabled` | `FALSE`. |
| `SupportedSti` | The `Issuance` and `Revocation` service type identifiers of this type. |
| `SupportedStatuses` | Not set. |
| `StatusCoherenceOnSti` | `TRUE` for each identifier in `SupportedSti`. |
| `SdiMatching` | At least one `organizationName` in the subject name of a certificate in `ServiceDigitalIdentity` equals at least one `TEName` value. The per-certificate rule for `ServiceDigitalIdentity` in the List of Trusted Entities applies in addition. |
| `StatusStartingTimePresent` | `FALSE`. |

###### PuB-EAA Provider

| Constraint | Value |
| --- | --- |
| `LoTEType` | The `LoTEType` URI of this type. |
| `SchemeTerritory` | `EU`. |
| `LoTESigningCertificates` | The `OJA-LoTE-Certs-Set` of this type. |
| `LoTEMimeType` | `application/jwt`. |
| `LoTELocation` | The `OJA-LoTE-Loc` of this type. |
| `PivotEnabled` | `FALSE`. |
| `SupportedSti` | The `Issuance` and `Revocation` service type identifiers of this type. |
| `SupportedStatuses` | The `notified` and `withdrawn` service status URIs of this type. |
| `StatusCoherenceOnSti` | `TRUE` for each identifier in `SupportedSti`. |
| `SdiMatching` | At least one `organizationName` in the subject name of a certificate in `ServiceDigitalIdentity` equals at least one `TEName` value. The per-certificate rule for `ServiceDigitalIdentity` in the List of Trusted Entities applies in addition. |
| `StatusStartingTimePresent` | `TRUE`. |

###### Registrar

| Constraint | Value |
| --- | --- |
| `LoTEType` | The `LoTEType` URI of this type. |
| `SchemeTerritory` | `EU`. |
| `LoTESigningCertificates` | The `OJA-LoTE-Certs-Set` of this type. |
| `LoTEMimeType` | `application/jwt`. |
| `LoTELocation` | The `OJA-LoTE-Loc` of this type. |
| `PivotEnabled` | `FALSE`. |
| `SupportedSti` | The `Register` service type identifier of this type. |
| `SupportedStatuses` | Not set. |
| `StatusCoherenceOnSti` | `TRUE` for each identifier in `SupportedSti`. |
| `SdiMatching` | At least one `organizationName` in the subject name of a certificate in `ServiceDigitalIdentity` equals at least one `TEName` value. The per-certificate rule for `ServiceDigitalIdentity` in the List of Trusted Entities applies in addition. |
| `StatusStartingTimePresent` | `FALSE`. |

###### EAA Provider

| Constraint | Value |
| --- | --- |
| `LoTEType` | The `LoTEType` URI of the EAA Provider list. The `LoTEType` component of the list SHALL match this URI. |
| `SchemeTerritory` | `EU`. |
| `LoTESigningCertificates` | The `OJA-LoTE-Certs-Set` of the EAA Provider list. The signing certificate of the list SHALL be one of this set. |
| `LoTEMimeType` | `application/jwt`. |
| `LoTELocation` | The `OJA-LoTE-Loc` of the EAA Provider list. The list is retrieved from this location. |
| `PivotEnabled` | `FALSE`. Pivots are not processed for this list. |
| `SupportedSti` | The set of service type identifiers that follow the EAA pattern defined in the [List of Trusted Entities](../sections/trust-artifacts.md#list-of-trusted-entities), with one `Issuance` and one `Revocation` identifier for each attestation type the list covers. Each `ServiceTypeIdentifier` to which this constraint applies SHALL match one of them. |
| `SupportedStatuses` | Not set. The EAA Provider list carries no `ServiceStatus`. |
| `StatusCoherenceOnSti` | `TRUE` for each identifier in `SupportedSti`. |
| `SdiMatching` | At least one `organizationName` in the subject name of a certificate in `ServiceDigitalIdentity` equals at least one `TEName` value. The per-certificate rule for `ServiceDigitalIdentity` in the List of Trusted Entities applies in addition. |
| `StatusStartingTimePresent` | `FALSE`. The list carries no `StatusStartingTime`. |

##### List of Trusted Entities Validation Process

Clause references in this process are to [ETSI TS 119 605 V0.0.3 (2026-06)] (work in progress) and are given with each step. Where the pilot adds a rule, the step says so.

**Input Variables**:

- `Requested-LoTE-Type`: The <artifacts:List of Trusted Entities (LoTE)|LoTE> type required for the artifact or <credentials:Attestation> being validated. The constraints of that type are those of the table for it in [Pilot LoTE Profile Constraints](#pilot-lote-profile-constraints). The type is known in advance to the caller or is determined by the caller from the `qcStatements` extension of `C`; this specification defines no mapping from that extension to a type.
- `Sign-Seal-Chain`: The `x5c` certificate chain `[C, I_1, ..., I_n]` of the artifact or <credentials:Attestation> being validated, where `C` is the sign/seal certificate that signed it and `I_n` is the last intermediate certificate. When the chain has no intermediate certificate, n = 0 and the chain is `[C]`. The entity is identified from `C` in step 6, so no separate entity identity is an input.
- `Requested-Service-Type`: The `ServiceTypeIdentifier` required for that artifact or protocol.
- `OJA-Loc`: The fixed, locally configured URI of the <artifacts:Official Journal of APTITUDE (OJA)|OJA> publication.
- `Highest-Accepted-Sequence`: The highest `LoTESequenceNumber` previously accepted for `Requested-LoTE-Type`, if any, together with a SHA-256 digest of the accepted signed list content at that sequence number; this state is retained across refreshes and restarts. The list content is the JWS Payload octets.
- `Date-Time`: The runtime validation time. It is used by the freshness checks. It is supplied as the `Date-Time` input of the status applicability check only when `StatusStartingTimePresent` of `Requested-LoTE-Type` is `TRUE` ([ETSI TS 119 605 V0.0.3 (2026-06), Clause 4.5.2], INP-4.5.2-01).

!!! note "Advisory on LoTE Selection"

    This note is non-normative. A verifier may use the `qcStatements` extension of the sign/seal certificate `C` to determine which LoTE to fetch.

**Working and Output Variables**:

- `LoTE`: The JSON/JWT <artifacts:List of Trusted Entities (LoTE)|LoTE> being processed.
- `OJA-LoTE-Loc`: The fixed location published by the <artifacts:Official Journal of APTITUDE (OJA)|OJA> for `Requested-LoTE-Type`.
- `OJA-LoTE-Certs-Set`: The set of certificates published by the <artifacts:Official Journal of APTITUDE (OJA)|OJA> for verifying `Requested-LoTE-Type`.
- `LoTE-Format`: The format of `LoTE`, `JSON`.
- `LoTE-Signer-Cert`: The certificate used to verify the signature or seal on `LoTE`.
- `Status`: `PROCESS_PASSED` or `PROCESS_FAILED`, as defined in [ETSI TS 119 605 V0.0.3 (2026-06), Clause 4.1].
- `Sub-Status`: The sub-status supplementing `Status`. Each failing step sets it to the value named in that step. The values are `TRY_LATER`, `LOTE_SIGNER_NOT_AUTHENTICATED`, `LOTE_EXPIRED`, `LOTE_NOT_YET_VALID`, `NO_MATCHING_TE_SERVICE`, `STATUS_NOT_APPLICABLE`, `STATUS_CONFLICT`, `SDI_CONSTRAINT_FAILURE` and `CRITICAL_EXTENSION_FAILURE` ([ETSI TS 119 605 V0.0.3 (2026-06), Clause 4.1.2]), and the pilot values `LOTE_OJA_ENTRY_NOT_FOUND`, `LOTE_SCHEMA_INVALID`, `LOTE_TYPE_MISMATCH`, `LOTE_SIGNER_CERT_NOT_VALID`, `LOTE_LOCATION_MISMATCH`, `LOTE_PROFILE_VIOLATION`, `LOTE_SEQUENCE_ROLLBACK`, `LOTE_PUBLICATION_CONFLICT` and `LOTE_STATE_NOT_PERSISTED`. Where the failing check is the cryptographic verification of the signature, the sub-status is the sub-indication returned by that verification ([ETSI TS 119 605 V0.0.3 (2026-06), Clause 4.2.4], PRO-4.2.4-06).
- `Current-LoTE-Certs-Set`: The set of LoTE-signing certificates used to authenticate the requested LoTE at current time. It is set to `OJA-LoTE-Certs-Set` ([ETSI TS 119 605 V0.0.3 (2026-06), Clause 4.2.4], PRO-4.2.4-02).
- `Current-LoTE-Loc`: The URI from which the requested LoTE is retrieved at current time. It is set to `OJA-LoTE-Loc` (PRO-4.2.4-02).
- `Authenticated-LoTE`: The authenticated LoTE. It is set only when `Status` is `PROCESS_PASSED`, so that no content of the list is used before every step has succeeded.
- `Trust-Anchor`: The selected <artifacts:Trust Anchor> (`A_i`, step 7). It is set only when `Status` is `PROCESS_PASSED`.

All outputs are initialized to void ([ETSI TS 119 605 V0.0.3 (2026-06), Clause 4.2.3], OUT-4.2.3-01). A runtime rejection returns no <artifacts:Trust Anchor>.

##### JSON LoTE Signature Verification

This procedure applies when the <artifacts:List of Trusted Entities (LoTE)|LoTE> is JSON formatted and uses the Compact JAdES Baseline B profile.

The validator SHALL perform the following operations. Values from the payload SHALL NOT be used to extract <artifacts:Trust Anchor|Trust Anchors> before all validation operations succeed:

1. Parse the JWS Compact Serialization into exactly three parts and reject invalid Base64url encoding, duplicate JSON member names, detached or unencoded payloads, and unsupported critical header parameters. The protected header SHALL contain `alg` with value `ES256`, an integer `iat`, and `x5t#S256`; `x5c`, `kid`, `x5u`, and other certificate-binding parameters SHALL NOT be used. The `iat` value is a claimed signing time, not a trusted timestamp. Failure: `LOTE_SCHEMA_INVALID`.
2. Decode `x5t#S256` from Base64url and select exactly one certificate from `OJA-LoTE-Certs-Set` whose DER encoding has that SHA-256 digest. Set it as `LoTE-Signer-Cert`. If no certificate or more than one has that digest, the sub-status is `LOTE_SIGNER_NOT_AUTHENTICATED`.
3. Verify the JWS signature over the JWS Signing Input using the P-256 public key in `LoTE-Signer-Cert` and the `ES256` algorithm.
4. Decode the JWT Claims Set and require the private `LoTE` claim containing the list object. Validate that object against the applicable profiled JSON payload schema. Failure: `LOTE_SCHEMA_INVALID`.
5. Confirm that the `LoTEType` in the signature-verified payload equals `Requested-LoTE-Type`. Failure: `LOTE_TYPE_MISMATCH`.

If any operation fails, validation SHALL stop with `Status` set to `PROCESS_FAILED` and `Sub-Status` set to the value given for that operation.

##### LoTE Validation Operations

The validator SHALL perform the following steps in order. A failing step SHALL stop the process with `Status` set to `PROCESS_FAILED` and `Sub-Status` set to the value named in that step.

1. **Retrieve the current list.** [ETSI TS 119 605 V0.0.3 (2026-06), Clause 4.2.4], PRO-4.2.4-01 and PRO-4.2.4-02.

    - Select exactly one `Requested-LoTE-Type` entry from the trusted <artifacts:Official Journal of APTITUDE (OJA)|OJA> publication at `OJA-Loc` and require a non-empty authorized signing certificate set.
    - Obtain `OJA-LoTE-Loc` and `OJA-LoTE-Certs-Set` for that type, and set `Current-LoTE-Certs-Set` and `Current-LoTE-Loc` to them. Download the current `LoTE` from `OJA-LoTE-Loc` when no accepted cached list exists, 24 hours have elapsed since the cached list was retrieved, or its `NextUpdate` has been reached, whichever occurs first. A cached list SHALL NOT be used after a required refresh fails.

    The validator SHALL NOT use the location or certificate set of another <artifacts:List of Trusted Entities (LoTE)|LoTE> type.

    If the type-specific entry is absent or its certificate set is empty, the sub-status is `LOTE_OJA_ENTRY_NOT_FOUND`. If more than one entry exists for the type, the sub-status is `LOTE_OJA_ENTRY_NOT_FOUND`. If no file can be retrieved from `OJA-LoTE-Loc`, or a required refresh fails, the sub-status is `TRY_LATER` (PRO-4.2.4-01).

2. **Verify signature, schema, and type.**

    Require JSON format; a list that is not JSON fails with `LOTE_SCHEMA_INVALID`. Run the JSON <artifacts:List of Trusted Entities (LoTE)|LoTE> Signature Verification above. Its failures set the sub-status given there.

3. **Match the signing certificate.**

    Require `LoTE-Signer-Cert` to match a certificate in `OJA-LoTE-Certs-Set` by exact DER certificate identity; otherwise the sub-status is `LOTE_SIGNER_NOT_AUTHENTICATED`. Require its X.509 validity period to include the validation time; otherwise the sub-status is `LOTE_SIGNER_CERT_NOT_VALID`.

4. **Check the scheme URI and publication location.** Failure: `LOTE_LOCATION_MISMATCH`.

    - Require `SchemeInformationURI` to contain exactly one URI, equal to `OJA-Loc`, and require `DistributionPoints` to be absent. The current list location is `OJA-LoTE-Loc`.
    - For all <artifacts:List of Trusted Entities (LoTE)|LoTE> types, require `PointersToOtherLoTE` to be absent.

5. **Check profile, freshness, and sequence.** [ETSI TS 119 605 V0.0.3 (2026-06), Clause 4.2.4], PRO-4.2.4-07 and PRO-4.2.4-08; the profile, freshness and sequence checks of this step are pilot checks in addition to those two requirements.

    - Require `LoTEVersionIdentifier` to be `1`, a positive integer `LoTESequenceNumber`, and the type-specific values and presence rules of the [Pilot LoTE Profile Constraints](#pilot-lote-profile-constraints) and of the <artifacts:List of Trusted Entities (LoTE)|LoTE> topic for `Requested-LoTE-Type`, including the service type identifiers and the service status rules. For a <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|PuB-EAA Provider> service, require `StatusStartingTime` not to be later than the validation time. The absence of `TrustedEntitiesList` is not a failure of this step; step 6 then finds no matching service. Failure: `LOTE_PROFILE_VIOLATION`.
    - Require a valid `ListIssueDateTime` and `NextUpdate`, with `NextUpdate` a date-time value that is not null, the issue time not later than the validation time, and the interval between them no longer than six months. Failure of this requirement: `LOTE_PROFILE_VIOLATION`.
    - If the `NextUpdate` is not later than the validation time, the sub-status is `LOTE_EXPIRED`. Otherwise, if the `ListIssueDateTime` is later than the validation time, the sub-status is `LOTE_NOT_YET_VALID`.
    - If `Highest-Accepted-Sequence` exists, reject a `LoTESequenceNumber` below it: `LOTE_SEQUENCE_ROLLBACK`.
    - If the sequence number is equal but the digest of the signed list content differs from the previously accepted digest, reject the list as a publication conflict: `LOTE_PUBLICATION_CONFLICT`.

6. **Identify the entity and the service.** This is an APTITUDE choice that extends [ETSI TS 119 605 V0.0.3 (2026-06), Clause 4.4.4] for piloting purposes.

    - Parse `Sign-Seal-Chain` and take `C` as its first certificate. If the chain cannot be parsed or is empty, the sub-status is `NO_MATCHING_TE_SERVICE`.
    - Match the subject name of `C` to a `TEName` value of a `TrustedEntityInformation` of the list. Optionally, also match the `organizationIdentifier` of the subject of `C` to a `TETradeName` value.
    - From the matched entity, select the `TrustedEntityService` whose `ServiceTypeIdentifier` equals `Requested-Service-Type` and which is present in the list. `ServiceHistory` SHALL NOT supply the service.
    - If no entity or no service matches, the sub-status is `NO_MATCHING_TE_SERVICE`.

7. **Select the Trust Anchor.** This is a pilot rule, applied to the certificate chain that the caller supplies.

    - Obtain the certificates `[A_1, ..., A_m]` from the `ServiceDigitalIdentity` of the selected service. `ServiceDigitalIdentity` is REQUIRED, so an empty set fails with `LOTE_PROFILE_VIOLATION`.
    - When n = 0, take the issuer name and authority key identifier of `C`; otherwise take those of `I_n`. Select the `A_i` whose subject name equals that issuer name and whose subject key identifier equals that authority key identifier. If no `A_i` matches, the sub-status is `NO_MATCHING_TE_SERVICE`. If more than one `A_i` matches, this is not a failure: the matching certificates share one public key and subject name under [ETSI TS 119 602 V1.1.1 (2025-11), Annex H.3], and any one of them is selected as `A_i`.

8. **Check SdiMatching.** Apply the `SdiMatching` constraint of `Requested-LoTE-Type`, together with the per-certificate rule of the <artifacts:List of Trusted Entities (LoTE)|LoTE> topic, to the `ServiceDigitalIdentity` of the selected service. If it is not met, the sub-status is `SDI_CONSTRAINT_FAILURE` ([ETSI TS 119 605 V0.0.3 (2026-06), Clause 4.6.4], PRO-4.6.4-08).

9. **Determine the status applicability.** This step composes [ETSI TS 119 605 V0.0.3 (2026-06), Clause 4.5] directly. `TE-Service-Entries` is the selected service. `ServiceHistory` never supplies trust, because no `Historical-Information-Period` is supplied.

    - For a <roles:Provider of Public Electronic Attestation of Attributes (PuB-EAA Provider)|PuB-EAA Provider>, `Target-TE-Service-Statuses` is the `notified` status URI of this type, `Date-Time` is the runtime validation time, and `StatusStartingTimePresent` is `TRUE`. The status found is the `ServiceStatus` when `Date-Time` is at or after `StatusStartingTime` (PRO-4.5.4-04 i). If no status is found, the sub-status is `STATUS_NOT_APPLICABLE`.
    - For the other six types, including the <roles:Provider of Electronic Attestation of Attributes (EAA Provider)|EAA Provider>, no target is supplied, `StatusStartingTimePresent` is `FALSE` and no `Date-Time` is supplied. The EAA list carries no `ServiceStatus` and no `StatusStartingTime`, and the EAA interpretation is written here in full because [ETSI TS 119 605 V0.0.3 (2026-06), Annex C] has none. The status found is the implicit status `http://uri.etsi.org/19605/StatusDetn/ImplicitStatus/Applicable` of Annex A (PRO-4.5.4-03 i a), so the check passes.
    - If more than one status is found, PRO-4.5.4-06 and PRO-4.5.4-07 apply. `StatusCoherenceOnSti` is `TRUE` for every type, so a conflict sets the sub-status to `STATUS_CONFLICT`.
    - If the status found does not match the target, the sub-status is `STATUS_NOT_APPLICABLE` (PRO-4.5.4-05 ii).

10. **Check critical extensions.** [ETSI TS 119 605 V0.0.3 (2026-06), Clause 4.6.4], PRO-4.6.4-13 and PRO-4.6.4-14. Process all critical extensions present in the signature-verified list. The only recognized critical extension is the Wallet Provider `ServiceUniqueIdentifier` in `ServiceInformationExtensions`. A critical extension that is not recognized, or whose associated check fails, sets the sub-status to `CRITICAL_EXTENSION_FAILURE`.

11. **Persist the state and accept.** Persist `Highest-Accepted-Sequence` and the digest of the accepted signed list content for `Requested-LoTE-Type`, after steps 1 to 10 have all succeeded and before success is returned. If this state cannot be persisted, the sub-status is `LOTE_STATE_NOT_PERSISTED`. Otherwise set `Authenticated-LoTE` to `LoTE`, set `Trust-Anchor` to the selected `A_i`, and set `Status` to `PROCESS_PASSED`.

!!! note "Remarks"

    - The <artifacts:Official Journal of APTITUDE (OJA)|OJA> page is the discovery source within the APTITUDE ecosystem. A passed validation result establishes signature integrity and conformity with the certificate set and location supplied by that page, subject to the assumption stated above. It also establishes that `Trust-Anchor` is taken from the service that applies at the validation time, of the entity identified by `C`.
    - `PROCESS_PASSED` means that the <artifacts:List of Trusted Entities (LoTE)|LoTE> is valid and the <artifacts:Trust Anchor> is selected; it does not mean that the certificate path is valid. The calling process runs the [X.509 Certificate Chain Validation](../sections/trust-evaluation-process.md#x509-certificate-chain-validation) with the returned <artifacts:Trust Anchor>.
    - The JSON `x5t#S256` value identifies the signing certificate in the type-specific <artifacts:Official Journal of APTITUDE (OJA)|OJA> set.
    - Cached-list reuse is governed by [LoTE Validation Operations](#lote-validation-operations), including required refresh, signer validity and persistent rollback state.
    - This process composes [ETSI TS 119 605 V0.0.3 (2026-06), Clause 4.2] and [Clause 4.5] directly. It does not run [Clause 4.6] as a whole: steps 8 and 10 apply its PRO-4.6.4-08, PRO-4.6.4-13 and PRO-4.6.4-14, and steps 6 and 7 replace its certificate-based search of [Clause 4.4]. Clause 4.6 would require `POE-Set` and `Cert-VD` whenever `Date-Time` is given (INP-4.6.2-01), and the pilot does not use past validation. Pivot processing (PRO-4.2.4-03) and the list-of-lists process of Clause 4.3 are omitted.
    - `LOTE_EXPIRED` and `LOTE_NOT_YET_VALID` are the sub-statuses used for a LoTE. The `LOLOTE_*` names of [ETSI TS 119 605 V0.0.3 (2026-06), Clause 4.1.2] apply to lists of lists, which are not used.

Below is a flowchart summarizing the validation of a <artifacts:List of Trusted Entities (LoTE)|LoTE>:

```mermaid
flowchart TD
    classDef failure fill:#f8d7da,stroke:#721c24,color:#721c24,font-weight:bold;
    classDef success fill:#d4edda,stroke:#155724,color:#155724,font-weight:bold;
    classDef process fill:#fff,stroke:#333,stroke-width:1px;
    classDef decision fill:#e7f3fe,stroke:#0056b3,stroke-width:1px;

    Start([Start LoTE validation]) --> Fetch[1. Read type-specific OJA entry<br/>and fetch LoTE at fixed location]:::process
    Fetch --> Sig{2. Verify signature,<br/>schema and type}:::decision
    Sig -- Invalid --> Fail([Validation failed]):::failure
    Sig -- Valid --> OJA{3. Signer certificate in<br/>OJA certificate set?}:::decision
    OJA -- No --> Fail
    OJA -- Yes --> Profile{4. Scheme URI and<br/>publication location valid?}:::decision
    Profile -- No --> Fail
    Profile -- Yes --> History{5. Profile, freshness and<br/>sequence checks pass?}:::decision
    History -- No --> Fail
    History -- Yes --> Anchor{6 and 7. Entity and service identified,<br/>Trust Anchor selected?}:::decision
    Anchor -- No --> Fail
    Anchor -- Yes --> Sdi{8. SdiMatching passes?}:::decision
    Sdi -- No --> Fail
    Sdi -- Yes --> Status{9. Status applicable?}:::decision
    Status -- No --> Fail
    Status -- Yes --> Crit{10. Critical extensions processed?}:::decision
    Crit -- No --> Fail
    Crit -- Yes --> Persist{11. Rollback state persisted?}:::decision
    Persist -- No --> Fail
    Persist -- Yes --> Success([Accept LoTE and return applicable Trust Anchor]):::success
```
