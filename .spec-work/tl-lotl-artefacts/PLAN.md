# Plan: Add pilot TL and LOTL artefacts and validation, and migrate QEAA trust from LoTE

Target Git root: /home/baol/Desktop/Specifications/Aptitude/wp2-trust-specifications
Work branch: spec/tl-lotl-artefacts
Original ref: refactor-of-lote-val
Slug: tl-lotl-artefacts
Original thread: 4d16925d-76c2-48c0-b399-ae719565f2fd
Base: 1e5f59bf16b80969ec224529db25f8da4add4323 · Map: mapped at 1e5f59bf16b80969ec224529db25f8da4add4323
Models: planner codex/gpt-6.1-sol reasoningEffort=high; mapper codex/gpt-6.1-sol reasoningEffort=high; tracer codex/gpt-6.1-sol reasoningEffort=low

## Sources

- [S1] ETSI TS 119 612 V2.4.1 (2025-08), *Electronic Signatures and Trust Infrastructures (ESI); Trusted Lists*. Read the complete 81-page PDF: https://www.etsi.org/deliver/etsi_ts/119600_119699/119612/02.04.01_60/ts_119612v020401p.pdf. SHA-256: `83285a1069e369d225cf16a0051a46b1f9d8961b6ad5d66bb7650351309a5196`. Annex C identifies the version-specific schema attachment `ts_119612v020401p0.zip`; cite this schema version rather than a moving schema repository.
- [S2] ETSI TS 119 615 V1.4.1 (2026-05), *Electronic Signatures and Trust Infrastructures (ESI); Trusted lists; Procedures for using and interpreting European Union Member States national trusted lists*. Read the complete 56-page PDF: https://www.etsi.org/deliver/etsi_ts/119600_119699/119615/01.04.01_60/ts_119615v010401p.pdf. SHA-256: `7e348c297b273fce37e6243ba9e53490cb554c1d8bd9cb63b85259ba427ce3fa`.
- [S3] EUDI Architecture and Reference Framework, complete chapter 6, *Trust model*, latest/main as retrieved on 2026-11-13: https://eudi.dev/latest/main/06-trust-model/. Pin the chapter to main commit `f5789a77dfc6d5a85834c431465afbe543d0141a`: https://github.com/eu-digital-identity-wallet/eudi-doc-architecture-and-reference-framework/blob/f5789a77dfc6d5a85834c431465afbe543d0141a/docs/main/06-trust-model.md. Chapter Markdown SHA-256: `668d65ccb9a4041e941ae75809d34825d6e9d5e0b00c66c5c50c04df000a5091`; retrieved HTML SHA-256: `591c502e75bace3fca79d9495cfff4d44b5a45d9274ea1665e946ba6f49ed0fc`. This is a commit-pinned main snapshot, not an inferred release number.
- [S4] User request and Detail answer: add TL and LOTL artefact types and their validations; update architecture, introduction and dependent views; cite the standards and state only the framework-specific profile, fields, parameters and checks. User decisions on 2026-11-13: “APTITUDE-operated TL and LOTL, with WP2 emulating the institutional publishers and an explicit OJA bootstrap”; “Move QEAA trust to TL/LOTL; retain the other LoTE types”; “Reject overdue TLs; preserve the ETSI authentication result but require freshness for runtime acceptance.”
- [S5] Existing specification at base commit `1e5f59bf16b80969ec224529db25f8da4add4323`, particularly the LoTE profile in `docs/topics/trusted-list-and-list-of-trusted-lists.md`, list evaluation in `docs/topics/trust-anchor-validation.md`, CA anchor profile in `docs/topics/trust-anchor-certificate-profiles.md`, and the dependent views identified by `.spec-work/MAP.md`. These supply the retained APTITUDE OJA discovery assumption, list-cache and rollback policy, certificate profiles, and seven remaining LoTE types.

## Changes

### Overview and entry point

#### `docs/trust-framework.md` (changed)

Changes the introduction and deviation/implementation-choice tables from LoTE-only trust to WP2-operated pilot TL/LOTL for QEAA and the seven other dedicated LoTEs; identifies the emulated TL/LOTL publishers and OJA bootstrap, with an explicit boundary between pilot trust and institutional EU qualified status. [S3 §§6.1, 6.3.2.1, 6.3.2.4] [S4]

### 1. Trust Architecture

#### `docs/sections/trust-architecture.md`

##### `docs/topics/trust-architecture.md` (changed)

Changes the Publication Service's roles and PKI/publication diagrams to show the OJA → LOTL → TL → QEAA service trust relationship alongside the seven retained LoTE paths; distinguishes scheme-operator list-signing certificates from entity CA anchors and Sign/Seal Certificates. Updates the onboarding overview to refer to the detailed QEAA publication path and avoids a second procedure definition. [S1 §§4, 5.3.13, 5.5.3, 5.7.1, Annex A] [S2 §§4.0–4.2] [S3 §6.3.2.4] [S4]

### 2. Trust Artifacts

#### `docs/sections/trust-artifacts.md` (changed)

Adds TL and LOTL to the artefact/provider table, assigning Member State and Commission roles to their WP2 pilot equivalents. Adjusts the existing list-topic include boundary to assemble sibling TL, LOTL and LoTE sections while retaining the existing `#list-of-trusted-entities` anchor and single inclusion of the LoTE definition. [S1 §§4, 5.3.3, Annex A.1] [S3 §§6.1, 6.3.2.4] [S4]

##### `docs/topics/x509-certificates.md`

###### `docs/topics/trust-anchor-certificate-profiles.md` (changed)

Changes the anchor-source references to cover eligible TL service identities as well as LoTE CA anchors. Clarifies the scope of the existing CA Trust Anchor Certificate profile and its Sign/Seal-chain/header rules; keeps directly trusted list-signing certificates and any non-CA service identity used by the ETSI matching procedure distinct from that CA certificate profile, referring to their owning list/evaluation sections. [S1 §§5.5.3, 5.7.1] [S2 §§4.1.4, 4.2.4, 4.3.4] [S5]

##### `docs/topics/trusted-list-and-list-of-trusted-lists.md` (changed)

Uses this existing topic as the sole home of the three list artefact profiles, with sibling TL, LOTL and LoTE subsections. Removes the TL/LOTL exclusion, QEAA LoTE type/URI/service variants, and the optional QEAA XML-LoTE profile; retains the remaining LoTE profiles and existing PID example, and makes the OpenAPI link explicitly a view of those retained JSON LoTEs. [S3 §6.3.2.4] [S4] [S5]

###### Trusted List (new subsection)

Introduces the TL artefact by reference to the XML model, signature and publication provisions, as a pilot emulation of the EU TL profile for QEAA services. Identifies the runtime-consumed fields and the applicable mandatory, conditional and optional presence rules by precise references; includes a short, explicitly incomplete non-normative XML excerpt rather than a reproduced schema or complete model. [S1 §§5.1–5.7, 6.1–6.2, Annexes B–E, G] [S3 §6.3.2.4] [S4]

Detail: cite
Additions: profile: XML/UTF-8 TL, `TSLVersionIdentifier = 6`, `TSLType = http://uri.etsi.org/TrstSvc/TrustedList/TSLType/EUgeneric` as pilot emulation; fields: `SchemeTerritory` identifying the emulated Member State (`CC`), WP2 scheme-operator metadata and pilot legal notice, `TSLSequenceNumber`, `SchemeInformationURI`, `PointersToOtherTSL` pointing to the pilot LOTL, `ListIssueDateTime`, `NextUpdate`, `HistoricalInformationPeriod`, `TSPName`, `TSPTradeName`, `ServiceTypeIdentifier` with `http://uri.etsi.org/TrstSvc/Svctype/EAA/Q` for QEAA, `ServiceDigitalIdentity`, `ServiceStatus`, `StatusStartingTime`, and conditional `ServiceHistory`; optional fields: `DistributionPoints` and applicable `ServiceInformationExtensions` retain their source-defined presence and interpretation; trust decisions: QEAA service qualification and provider binding through the referenced ETSI procedures, distinct from `CA/QC` certificate qualification; signature: source-defined XAdES-B-B and list-signer profile, without transplanting the removed XML-LoTE profile; publication: source-defined XML retrieval and media type, with actual deployment values supplied by pilot configuration/publication.

###### List Of Trusted Lists (new subsection)

Introduces the LOTL artefact as a signed list of TL pointers and authorized TL-signing identities, with its own pilot OJA bootstrap and WP2 scheme operator. Uses the source's list-of-lists structure and authentication metadata, including the self-pointer and pivot information where applicable, and includes a short annotated XML excerpt. [S1 §§5.3.3, 5.3.7, 5.3.13–5.3.18, 5.7, 6, Annexes A–D] [S2 §§4.0, 4.1] [S4]

Detail: cite
Additions: profile: XML/UTF-8 LOTL, `TSLVersionIdentifier = 6`, `TSLType = http://uri.etsi.org/TrstSvc/TrustedList/TSLType/EUlistofthelists`, `SchemeTerritory = EU`, all explicitly identifying pilot emulation; fields: WP2 scheme-operator metadata and pilot legal notice, `TSLSequenceNumber`, `SchemeInformationURI` with OJA/pivot references as applicable, `ListIssueDateTime`, `NextUpdate`, and `PointersToOtherTSL` tuples containing `TSLLocation`, signing identities, `TSLType`, `SchemeTerritory` and MIME-type qualifiers; presence: self-pointer and pointer to each pilot TL, with no TSP/service list in this pointer-only artefact; bootstrap parameters: `OJA-Loc`, `OJA-LOTL-Loc`, `OJA-LOTL-Certs-Set`, explicitly substituted for the standard's `OJEU-*` parameters; trust decisions: the existing unsigned-OJA discovery assumption remains explicit, and TL signers are authorized through an authenticated LOTL rather than a direct OJA bypass.

### 3. Onboarding Process

#### `docs/sections/onboarding-process.md`

##### `docs/topics/onboarding-process.md` (changed)

Changes infrastructure prerequisites, Publication Service responsibilities, inputs/outputs, entity-specific paths, diagrams, and affected `ONBOARD-*` summaries for OJA-bootstrapped LOTL/TL publication and QEAA service inclusion in the TL. Changes QEAA cancellation to TL withdrawal with retained history, preserves the other LoTE paths including the existing EAA path, and refers to the artefact/evaluation/lifecycle homes for their respective rules. [S1 §§5.3.13, 5.5.4–5.6, 5.7, 6, Annex G] [S2 §§4.0–4.2] [S3 §§6.3.2.1, 6.3.2.4, 6.3.3] [S4]

### 4. Trust Evaluation

#### `docs/sections/trust-evaluation-process.md`

##### `docs/topics/trust-evaluation.md` (changed)

Adds LOTL Authentication and Trusted List Authentication to the assembled core procedures, adjacent to Trust Anchor Validation, and changes the overview's trust-source references to distinguish QEAA TL service validation from retained LoTE validation. Includes the two new procedure topics exactly once. [S2 §§4.1–4.3, 4.6, 4.12] [S3 §§6.3.2.4, 6.6.2.6, 6.6.3.6] [S4]

###### `docs/topics/trust-anchor-validation.md` (changed)

Changes the common process to select the QEAA TL/LOTL route or a retained LoTE route, with no QEAA-LoTE fallback; refers to the new authentication procedures and the existing Trust Anchor definition instead of redefining it. Removes the QEAA-only XML-LoTE verifier and makes this topic the single owner of runtime list acceptance, cache/rollback state and trust-source dispatch; separates list authentication from runtime usability and service eligibility. [S1 §§5.3.2, 5.3.14–5.3.15, 5.5.3–5.5.5, 6.1] [S2 §§4.1–4.3, 4.6] [S3 §6.6.3.6] [S4] [S5]

Detail: cite
Additions: inputs/context: requested artefact/provider kind, provider certificate/service identity, TL territory `CC`, and current runtime validation time; checks: source/profile separation and QEAA selection through authenticated LOTL/TL, rejection of overdue current TLs for runtime use even when ETSI authentication returns a pass with warning, and no trust anchor returned after runtime rejection; state/parameters: apply the existing 24-hour-or-`NextUpdate` cache limit, failed-required-refresh rejection and persisted highest-sequence/signed-content-digest policy independently to each current pilot TL and LOTL, using `TSLSequenceNumber` for those artefacts and keeping LoTE state separate; scope: archived pivots follow the cited pivot procedure and are not treated as current runtime lists for cache/rollback checks; outputs: preserve the cited authentication status/sub-status and report runtime acceptance separately; definition ownership: referring flow and lifecycle sections invoke these checks instead of defining them again.

###### `docs/topics/lotl-authentication.md` (new)

Defines LOTL Authentication by citing the complete source procedure, including its input/state contract, pivot handling and output status/sub-status. States only the mapping from OJEU bootstrap parameters to the pilot OJA bootstrap and the handoff to common runtime acceptance. [S2 §§4.0, 4.1.1–4.1.4] [S1 Annex A] [S4]

Detail: cite
Additions: actors: Wallet Unit, WRP or their trust-validation component; bootstrap parameters: `OJA-Loc`, `OJA-LOTL-Loc`, `OJA-LOTL-Certs-Set` mapped respectively to `OJEU-Loc`, `OJEU-LOTL-Loc`, `OJEU-LOTL-Certs-Set`; trust context: fixed configured pilot OJA URI and explicit unsigned-OJA discovery assumption, with no independent institutional trust claim; state: preserve the referenced procedure's authenticated parameter updates and pivot continuity; checks/outputs: directly trust the source-authorized list-signer certificate for list-signature authentication, preserve `Authenticated-LOTL`, `LOTL-Status` and `LOTL-Sub-Status`, then invoke common current-list runtime acceptance without reproducing either procedure.

###### `docs/topics/trusted-list-authentication.md` (new)

Defines TL Authentication by citing the source procedure for `CC`, with the authenticated pilot LOTL supplying the XML TL location and authorized signer set. Preserves source outputs, including the overdue-TL warning, and passes the result to the framework's separate runtime acceptance policy. [S2 §§4.2.1–4.2.4] [S1 §§5.3.13, 5.7, Annex B] [S4]

Detail: cite
Additions: actors: Wallet Unit, WRP or their trust-validation component; input: `CC` selecting the emulated Member State TL through the authenticated pilot LOTL; parameters/bindings: use the pilot LOTL Authentication procedure in the source's LOTL-authentication call and select the XML tuple by its territory/MIME qualifiers; trust decisions: directly trusted TL-signing certificate obtained from that tuple, distinct from service identities and CA anchors; outputs/checks: preserve `Authenticated-EUTL`, `EUTL-Status`, `EUTL-Sub-Status` and `WARNING_EUTL_NEXTUPDATE_PASSED`, with runtime rejection of an overdue TL owned by the common acceptance procedure rather than relabelling the ETSI authentication result.

###### `docs/topics/attestation-signature-validation-process.md` (changed)

Changes Sign/Seal Validation's trust-source selection so QEAA uses authenticated, runtime-accepted TL service information and the cited QEAA qualification procedure; the other attestation types continue through their existing LoTE routes. Distinguishes QEAA service qualification from qualified-certificate determination and invokes the existing signature/path validation where applicable without duplicating certificate validation. [S2 §§4.3, 4.6, 4.12] [S1 §§5.5.1.1(k), 5.5.3–5.5.5] [S3 §§6.6.2.6, 6.6.3.6] [S4]

Detail: cite
Additions: inputs/context: QEAA, its supporting signing certificate and current runtime `Date-time`; parameter: `TLS-Sti = http://uri.etsi.org/TrstSvc/Svctype/EAA/Q`; checks: the source's `urn:etsi:esi:eaa:eu:qualified` content indication, certificate/service and provider matching, and an eligible currently granted QEAA service; output decision: source procedure success together with `QEAA-Results = Qualified` under the pilot trust context, with failed, not-qualified, indeterminate or runtime-unusable evidence producing validation failure; trust binding: retain matching service identity and certificate/path context, handle the source's direct-identity or certificate-path matching without treating every TL service certificate as a CA, and do not accept a certificate merely because it was supplied in the attestation.

###### `docs/topics/x509-certificate-validation.md` (changed)

Changes only the `trust_anchor` input description and profile references to accept an applicable CA anchor selected from validated TL service information as well as LoTE. Refers to the ETSI service-matching procedure for direct service identities and to list authentication for list signers, without sending those non-CA certificates through the CA-anchor profile or changing the shared RFC 5280/CRL/OCSP algorithms. [S1 §§5.5.3, 5.7.1] [S2 §§4.1.4, 4.2.4, 4.3.4] [S5]

##### `docs/topics/trust-checks.md`

###### `docs/topics/trust-checks-issuance.md` (changed)

Changes the participant/artefact labels, diagram and steps 11a–11c so QEAA acceptance invokes the TL/LOTL and Sign/Seal procedures while other provider types use their retained LoTEs. Replaces step 7a's unrestricted caching statement and repeated list-validation descriptions with references to the owning runtime procedure. [S3 §§6.6.2.4, 6.6.2.6] [S2 §§4.1–4.3, 4.6, 4.12] [S4] [S5]

###### `docs/topics/trust-checks-presentation.md` (changed)

Changes the cross-cutting trust-source diagram and `TL-PRES-001` dependency view to route QEAA verification by the receiving WRP to the common TL/LOTL and Sign/Seal procedures; retains LoTE-based WRPAC, WRPRC and Register authentication on the request side. Replaces repeated validation rules with references and aligns affected test-focus/traceability descriptions with the distinction between authentication and runtime acceptance. [S3 §6.6.3.6] [S2 §§4.1–4.3, 4.6, 4.12] [S4] [S5]

### 5. Trust Management and Lifecycle

#### `docs/sections/trust-management-lifecycle.md`

##### `docs/topics/trust-management-process.md` (changed)

Changes scheme-operator responsibilities, QEAA property-to-artefact mappings, diagrams, operational-state evidence and update/removal effects from QEAA LoTE membership to the pilot TL's QEAA service status. Adds TL/LOTL publication lifecycle references, retains TL withdrawal/status history and re-keying behaviour by citation, and replaces repeated list-acceptance rules with references to their owning procedure. [S1 §§5.3.12, 5.5.3–5.6, 6, Annex G.1–G.5] [S2 §§4.1–4.3, 4.6] [S3 §§6.3.2.4, 6.3.3, 6.6.3.6] [S4]

### 6. Trust Use Cases

#### `docs/sections/use-cases.md` (changed)

Changes the runtime Trust Anchor Validation and Attestation Authenticity/Integrity cases, publication-readiness case, and affected entity/list update, withdrawal and version-publication cases for pilot LOTL/TL and QEAA service validation. Refers to the owning procedures for OJA bootstrap, status propagation, freshness and rollback, including the authenticated-but-overdue TL case and separation of QEAA from retained LoTE routes. [S2 §§4.0–4.3, 4.6, 4.12] [S1 §§5.5.4–5.6, 6, Annex G] [S3 §§6.3.3, 6.6.3.6] [S4]

### 7. References

#### `docs/sections/references.md` (changed)

Retains the existing TS 119 612 V2.4.1 entry, updates TS 119 615 from V1.3.1 to V1.4.1 (2026-05), and adds a scoped ARF Trust model reference pinned to [S3] for the changed trust-model material. Keeps that chapter snapshot distinct from the existing general ARF release citation used elsewhere. [S1] [S2] [S3]

### 8. Linked interface descriptions

#### `docs/api/lote-api.md`

##### `docs/includes/lote-oas3.yaml` (changed)

Changes the existing OpenAPI description from eight to seven JSON LoTE types: removes `/lote/qeaa-providers`, QEAA enum values and type-specific schema conditions/descriptions, and the optional XML-QEAA-LoTE statements; updates the dependent counts and profile references in the retained decoded views. Keeps XML TL/LOTL retrieval under the cited ETSI publication interface instead of adding TL/LOTL objects to this JSON/JWT API. [S1 §§6.1–6.2] [S3 §6.3.2.4] [S4] [S5]

## Review findings and open questions

- The apparent pre-existing TL/LOTL coverage is a filename, informative ecosystem table, glossary entries and an isolated core-process reference; the assembled artefact topic and operative validation still explicitly require LoTEs. This plan changes that coverage rather than adding a second LoTE model. The existing LoTE Swagger page and PID LoTE example are already present and need no new copies.
- Definition ownership for this change: list models/profile additions in the existing list artefact topic; source-based authentication in the two new core procedure topics; common runtime acceptance and state in Trust Anchor Validation; QEAA attestation qualification invocation in Sign/Seal Validation; infrastructure roles in Architecture; recurring onboarding in Onboarding Process; entity/list lifecycle effects in Trust Management. Architecture, flow, lifecycle and use-case views refer to these homes rather than restating them. The OpenAPI remains a schema/interface view of the retained LoTE profile.
- QEAA URI conflicts disappear with removal of the QEAA LoTE. An existing non-qualified EAA conflict remains: the prose assigns `http://aptitude-consortium.github.io/LoTEType/QEAAProviderList` to EAA, while the OpenAPI uses `https://aptitude-consortium.github.io/wp2-trust-specifications/latest/lote-identifiers/#eaa-lote-type`, whose target page is absent. Open question for a separate correction: which EAA URI is canonical? This run retains the EAA type and does not choose or replace its identifier; it removes only QEAA-specific values and references.
- The fetched glossary is not pinned in the base tree. Existing TL/LOTL glossary names can be reused; scheme-operator names can be written as ordinary text without introducing undefined glossary tags. Open question outside this run: which upstream glossary revision/owner should govern a reproducible publication? This plan does not edit fetched assets, the fetch script or the external glossary repository.
- Register write-scope and response-envelope conflicts remain separate open questions; the source set and the three decisions above do not settle them. No Register API or authorization-model redesign is included. Existing service-binding issue #114, proximity registration-data mapping, deferred EDP processing/schema and PuB-EAA OID questions remain outside this change.
- The broader lifecycle conflict between immediate revocation of all associated keys/attestations and conditional Sign/Seal certificate revocation remains an open policy question outside this run. TL withdrawal and history retention are included here; they do not decide that separate certificate/attestation-revocation policy or add historical attestation-validation capability.
- The remaining profile selections made explicit for gate 1 are the EU-shaped pilot XML profiles, emulated `CC`/`EU` territory bindings, source-prescribed QEAA service matching, and reuse of the existing runtime cache/rollback policy for current TL/LOTL instances. Deployment URLs, operator identities and signing certificates are configuration/publication values, not invented constants. The OJA substitution is a declared pilot trust assumption, not a claim of unmodified institutional EU conformance.
