# Plan: Adapt the LoTE validation (ETSI TS 119 605 draft) and the LoTE data model (ETSI TS 119 602 V1.1.1) to the APTITUDE pilot

Target Git root: /home/baol/Desktop/Specifications/Aptitude/wp2-trust-specifications
Work branch: spec/lote-validation
Original ref: refactor-of-lote-val
Slug: lote-validation
Original thread: e0ca0d97-c43f-4e3a-b440-39670716c352
Base: 06261719fd3ad15f5069e823a8a94f2c77c956fa · Map: mapped at 06261719fd3ad15f5069e823a8a94f2c77c956fa
Models: planner claudeAgent/claude-sonnet-5-5 effort=medium; mapper claudeAgent/claude-sonnet-5-5 effort=medium; tracer claudeAgent/claude-haiku-5-5 effort=high

Original commit: 0626171 (`chore: review`). Detail (Q2, answered): cite ETSI TS 119 605 with the pilot additions for all constraint sets, the status vocabulary, applicability and critical extensions; spell out in full only the EAA LoTE (constraints, status handling, identifiers), which 119 605 does not cover.

Note on commit 6e57453: the coordinator committed the user's pending edits to `docs/topics/trust-anchor-validation.md` and `docs/topics/trusted-list-and-list-of-trusted-lists.md` as `6e57453` (`docs: manual edits to LoTE validation and list topics (pre-run)`). They are not run output. Assignments that touch either file start from that commit. Revision 5 of this plan (final gate 1 revision).

## Sources

- [S1] ETSI TS 119 605 **V0.0.3 (2026-06) DRAFT**, "Lists of Trusted Entities; Procedures for using and interpreting lists of trusted entities", <https://docbox.etsi.org/esi/Open/Latest_Drafts/ETSI%20DRAFT%20TS_119_605v0.0.3-public.pdf>. Version read from the cover and the change history (V0.0.1 02/2026, V0.0.2 06/2026, V0.0.3 06/2026, editorial comments). Cover: "Do not use as reference material. Do not cite this document other than as 'work in progress'"; comments were requested by 30 September 2026. At 2026-11-16 it is the only 119 605 edition listed in the ETSI "Latest_Drafts" folder and `etsi.org/deliver/.../119605/` returns 404, so no published edition exists to cite. The ETSI web firewall blocks the default `curl` agent; the PDF was retrieved with a browser User-Agent. Normative reference of S1: [S2] V1.1.1.
- [S2] ETSI TS 119 602 **V1.1.1 (2025-11)**, "Lists of trusted entities; Data model", <https://www.etsi.org/deliver/etsi_ts/119600_119699/119602/01.01.01_60/ts_119602v010101p.pdf> (local copy `references/ETSI/ts_119602v010101p.pdf`, same version). The repository already cites V1.1.1 in `docs/sections/references.md` and in `docs/includes/lote-oas3.yaml`; the version does not change, the work is a conformance pass.
- [S2a] ETSI JSON binding of S2 (Annex A.1): <https://forge.etsi.org/rep/esi/x19_60201_lists_of_trusted_entities>, tag `v1.1.1` (last commit e84f427f, 2025-11-13), file `1960201_json_schema/1960201_json_schema.json`. The topic currently cites the repository without a tag.
- [S3] ETSI TS 119 615 V1.4.1 (2026-05) and [S4] ETSI TS 119 612 V2.4.1 (2025-08): already cited in the repository; govern the TL/LOTL route and are not changed by this run.

## Gaps

Gaps in the sources:

- G1. S1 is a draft whose clause numbers and requirement identifiers may change before publication (see S1 cover and §3.3). It cannot be cited as a published standard.
- G2. S1 Annex C interprets only the PID providers list (C.1) and the wallet providers list (C.2). It gives no constraints for the WRPAC, WRPRC, PuB-EAA, Registrar and Register lists, nor for the APTITUDE EAA list; the pilot must define them.
- G3. S1 defects that the pilot must work around: the contents list numbers clauses 4.21.x and 4.32.x while the body uses 4.2.x and 4.3.x; PRO-4.3.4-01 points to "clause 4.1" for authentication (that is 4.2); the 4.2.3 output table lists `Retrieved-LoTE` while PRO-4.2.4-09 sets an undefined `Authenticated-LoTE`; PRO-4.2.4-05 writes `Current-LoTE-Certs` for `Current-LoTE-Certs-Set`; the sub-status table in 4.1.2 omits `TRY_LATER`, `NO_REQUIRED_POE_SET_OR_CERT_VD_PROVIDED` and `CERT_CHAIN_NOT_VALID_AT_DATE_TIME` and lists `LOTE_EXPIRED` and `LOTE_NOT_YET_VALID` twice (the second pair should read `LOLOTE_*`); PRO-4.5.4-04 uses an input `Historical-Information-Period` that 4.5.2 does not define; PRO-4.5.4-02 treats `SupportedStatuses` as a Boolean although 4.1.1 defines a set; the identifier `OUT-4.4.3-01` is reused in 4.5.3; INP-4.6.2-01 requires `POE-Set` and `Cert-VD` whenever `Date-Time` is given, so `StatusStartingTime` cannot be evaluated at the current time through 4.6 without past-validation evidence; C.2.3 describes `Cert` of the wallet providers list as the signing certificate "of a PID".
- G4. S1 Annex C fixes `LoTEMimeType = application/jose` for the EU lists; S2 defines no media type; the pilot OpenAPI description serves `application/jwt`, which the pilot keeps (D17).
- G5. S2 §6.3.15 allows `NextUpdate` to be null for a closed list (S1 §4.2.4 PRO-4.2.4-07 NOTE relies on it), but the JSON schema [S2a] types `NextUpdate` as a `date-time` string; a closed list cannot be expressed in the JSON binding.
- G6. S2 defects: §6.1.2 and §6.3.3 point to "Annex H" for registered URIs and §6.1.4 to "Annex G" for multilingual rules (they are Annex C and Annex B; Annex H is the PuB-EAA profile); §6.6.0 lists `ServiceDefinitionURI` while §6.6.8 is titled `TEServiceDefinitionURI`; the JSON schema uses `ServiceDefinitionURI`; Annex C.2.2 and Table G.1 spell the WRPRC status-determination URI `.../WRPRCrovidersList/StatusDetn/EU` (typo) while the scheme-rules URI reads `WRPRCProvidersList`; the pilot uses the corrected spelling (D19); Table H.3 describes the PuB-EAA `Revocation` service as providing status of "wallet relying party access certificates"; the JSON schema places `additionalProperties` inside `properties` of `ServiceDigitalIdentity`.

Gaps in the pilot specification against S2 (all in `docs/topics/trusted-list-and-list-of-trusted-lists.md` and `docs/includes/lote-oas3.yaml` unless stated):

- G7. The LoTE introduction still describes a Member-State-compiled list of five entity kinds, a structure "defined for Trusted Lists on ETSI TS 119 612" and JSON and XML support (mapper point M6); S2 does not define that structure and the retained profile is JSON only with seven types.
- G8. No media type is stated for LoTE publication in the topic (see G4).
- G9. S2 Annex H.3 rules on `ServiceDigitalIdentity` (several certificates share one public key and identical subject names; `organizationName` present and strictly equal to `TEName`) and S2 §6.6.3 are not stated for the pilot types; S1 `SdiMatching` (C.1.2, C.2.2) is not reflected.
- G10. S2 §6.8.0 (country code and organization of the signing certificate subject match `SchemeTerritory` and a `SchemeOperatorName` value) is not stated for the pilot LoTE signing certificates.
- G11. S2 §6.6.5 and Table H.3 (a new `StatusStartingTime` is not set before the re-issuance date) are not stated; `docs/topics/trust-management-process.md` sets `StatusStartingTime` "to the time at which the withdrawn status takes effect".
- G12. S2 §6.4.0 makes `TrustedEntitiesList` absent when no entity is listed and the JSON schema requires only `ListAndSchemeInformation`; the OpenAPI description requires `TrustedEntitiesList` with `minItems: 1`.
- G13. The topic and the OpenAPI description name the field `TEServiceDefinitionURI`; the JSON binding [S2a] names it `ServiceDefinitionURI`.
- G14. The validation procedure does not say how a critical extension is handled (S2 §6.3.17 requires rejection of an unrecognized critical extension); the OpenAPI example carries `Critical: true` on the Wallet Provider `ServiceUniqueIdentifier` extension.
- G15. EAA identifiers are inconsistent between the topic and the OpenAPI description (mapper point M4).
- G16. `info.version` of the OpenAPI description (1.1.1) equals the S2 version and does not track API changes.

Gaps in the pilot specification against S1 (`docs/topics/trust-anchor-validation.md` unless stated):

- G17. The LoTE Validation produces only `LoTE_VERIFICATION_PASSED` or `LoTE_VERIFICATION_FAILED`; it has none of the S1 `Status`/`Sub-Status` outputs, none of the S1 LoTE profile constraints and none of the S1 status-applicability logic (§4.5).
- G18. The pilot adds checks that S1 does not contain; they stay: fixed OJA discovery (`OJA-LoTE-Loc`, `OJA-LoTE-Certs-Set`), 24-hour or `NextUpdate` refresh, signer certificate validity at validation time, exact DER matching, schema, type and location checks, six-month `NextUpdate` limit, rollback state (`Highest-Accepted-Sequence` and content digest) persisted before success.
- G19. `docs/topics/trust-checks-issuance.md` steps 3b, 7b and 11b describe LoTE validation informally ("extra checks") and step 11b recommends "ETSI TS 319 102-1" (the reference is EN 319 102-1); steps 11a to 11c still route QEAA through a LoTE; step 7a leaves LoTE caching to the provider (mapper point M5).
- G20. `docs/topics/trust-checks-presentation.md` `TL-PRES-001`, `docs/sections/use-cases.md` and `docs/sections/references.md` do not mention S1 or its status and sub-status outputs.

## Decisions

- D1. S2 remains V1.1.1; the JSON binding is pinned to tag `v1.1.1` of [S2a]. S2 general rules (§6.1.3 date-time, §6.1.4 languages, §6.1.5 country codes, Annex B multilingual strings) are taken over unchanged by reference, without restatement.
- D2. S1 is cited as "ETSI TS 119 605 V0.0.3 (2026-06), draft, work in progress", by clause number of that version, wherever a clause is cited. The pilot text cites S1 and adds the pilot choices; only the EAA LoTE, which S1 does not cover, is written in full (Q2, D18).
- D3. S1 scope. Taken over, adapted: §4.1 (status model), §4.1.1 (LoTE profile constraints, as a pilot table), §4.1.2 (sub-statuses), §4.2 (authenticating a LoTE), §4.5 (status applicable to a trusted entity service), §4.6.4-13 and -14 (critical extensions), Annex A (the two implicit-status URIs), Annex C.1.2 and C.2.2 (constraint values for PID and Wallet Provider lists, with `SchemeTerritory` `EU`). Left out: §4.2.4-03 and `PivotEnabled` processing (pivot mechanism: pilot sets `PivotEnabled = FALSE`; the OJA locations and certificate sets are fixed); §4.3 and `LoLoTE-Constraints` (no list of LoTEs exists in the pilot; the OJA publication plays the discovery role; a "LoLoTE" is not the pilot LOTL); §4.4 as a certificate-based search and §4.6 as one procedure (replaced by the pilot trust-anchor validation algorithm, D20); Annex B.1 and all `POE-Set`, `Cert-VD` and past validation (certificate path validation stays in `docs/topics/x509-certificate-validation.md`, defined once); Annex C.1.4 and C.2.4 results `PID-Result` and `WP-Result`; Annex C certificate set and location values (replaced by the OJA values).
- D4. S1 applies to the LoTE route only. The QEAA route (pilot LOTL then TL) stays governed by [S3] and [S4] and is not changed; Trust-Source Dispatch is unchanged except that it names the governing source of each route.
- D5. The pilot LoTE profile constraints are one table per type in the validation topic, with values defined once: `LoTEType`, `SchemeTerritory` (`EU`), `LoTESigningCertificates` (the type-specific `OJA-LoTE-Certs-Set`), `LoTELocation` (`OJA-LoTE-Loc`), `LoTEMimeType` (`application/jwt`, D17), `PivotEnabled` (`FALSE`), `SupportedSti` (type-specific service type identifiers, as in the LoTE topic), `SupportedStatuses` (PuB-EAA: `notified` and `withdrawn`; others: absent), `StatusCoherenceOnSti` (`TRUE` for every supported identifier), `SdiMatching` ("at least one `organizationName` equals a `TEName` value" for all seven types, Q8), `StatusStartingTimePresent` (`TRUE` for PuB-EAA, `FALSE` for the other six types). Per Q2 the table cites S1 §4.1.1 for the vocabulary and gives the values per type; the EAA row is written in full (D18). The identifier, status and service-type values stay in the LoTE topic tables and the constraint table refers to them.
- D6. Status applicability at runtime: `Date-Time` is the runtime validation time; the target status for a PuB-EAA operational service is the `notified` URI; the six other types use the S1 Annex A implicit-status URIs; `ServiceHistory` never supplies trust (no historical-information input), consistent with the current text. S1 §4.5 is composed directly by the pilot procedure (not through §4.6) because of G3 (INP-4.6.2-01).
- D7. Critical extensions: a LoTE carrying a critical extension the validator does not recognize is rejected; the only recognized extension is the Wallet Provider `ServiceUniqueIdentifier`; `SchemeExtensions` and `TEInformationExtensions` stay prohibited. Sub-status `CRITICAL_EXTENSION_FAILURE` (S1 §4.1.2).
- D8. The field name `ServiceDefinitionURI` of the JSON binding replaces `TEServiceDefinitionURI` in the topic table and in the OpenAPI schema.
- D9. `TrustedEntitiesList` is optional and absent when no entity is listed (S2 §6.4.0); a validator then finds no matching service. The OpenAPI `minItems: 1` on the array stays for a present list.
- D10. Closed lists are left out: `NextUpdate` is always a date-time (G5); the pilot never publishes a final instance with a null `NextUpdate`.
- D11. The optional `ServiceTypeIdentifier` and `ServiceInformationExtensions` of `ServiceHistoryInstance` (S2 §6.7) are left out for PuB-EAA history, as in the current schema; the service type is given by the containing `TrustedEntityService`.
- D12. The pilot departures from S2 Annexes D to G and I (one `SchemeInformationURI` equal to the OJA URI instead of an archive URI; no self-pointer in `PointersToOtherLoTE`; no `DistributionPoints`; no scheme extensions; `TEInformationURI` rather than `TEAddress` for the type URI of PuB-EAA) are kept and remain recorded once in the LoTE topic.
- D13. S2 §6.6.5 and Table H.3 are taken over for the PuB-EAA list: `StatusStartingTime` of a new status is not before the re-issuance date (`ListIssueDateTime`) of the list that introduces it. The lifecycle text refers to this rule instead of restating it.
- D14. Pilot additions of G18 stay as they are; they are expressed as profile additions to S1 §4.2 and are not renamed.
- D15. The OpenAPI `info.version` changes to 1.2.0 (backward-compatible additions and a field rename recorded in the description); the document version history of `docs/trust-framework.md` is outside this run.
- D16. Terms (flagged for the glossary): the pilot role "LoTE Provider" is the S2 "LoTE Scheme Operator (LoTESO)", an alias stated once in the LoTE topic; S1 "trust anchor information" (RFC 5280 §6.1.1, a key and name that may be an end-entity certificate) differs from the pilot **Trust Anchor** (an X.509 certificate used as path-validation input); S1 `Sdi` abbreviates `ServiceDigitalIdentity`; S1 "scope" of a trusted entity service corresponds to the pilot "service eligibility"; S1 "LoLoTE" (list of LoTEs) is not the pilot LOTL (list of Trusted Lists); S1 `PROCESS_PASSED`/`PROCESS_FAILED` replace the pilot `LoTE_VERIFICATION_PASSED`/`LoTE_VERIFICATION_FAILED` (Q1, accepted); S2 "approval scheme" has no pilot counterpart (notification is mocked). `terminology.md` and the fetched glossary are not edited by this run.
- D17. Media type: `application/jwt` is kept (OpenAPI description, `registry.md`); `LoTEMimeType = application/jwt` is the pilot constraint value, defined once, for the pilot lists. S1 Annex C `application/jose` applies to the EU lists only; no change to the OpenAPI response media type.
- D18. Detail (Q2): ETSI TS 119 605 is cited with additions for all constraint sets, the status vocabulary, status applicability and critical extensions. The only element written in full, in the plan and in the target, is the EAA LoTE: its profile constraints, status handling and identifiers (D21). It is full because S1 has no Annex C interpretation for it (G2).
- D19. WRPRC `StatusDeterminationApproach` uses the corrected value `http://uri.etsi.org/19602/WRPRCProvidersList/StatusDetn/EU`, not the literal `WRPRCrovidersList` typo of S2 Annex C.2.2 and Table G.1; the typo is noted once in the LoTE topic.
- D20. Trust-anchor validation algorithm (user-chosen flow, replaces Q3 option A as drafted; identity-based, chain-validated). Selection of the anchor agrees with the identity-based selection of the former Q3 recommendation: the entity is identified by the subject name of the sign/seal certificate, then the anchor is selected from the LoTE by issuer match. Steps: (a) the validating entity selects the correct LoTE, known in advance or determined from the `qcStatements` extension of the sign/seal certificate; (b) it parses the `x5c` chain of the attestation `[C, I_1, ..., I_n]`, where C signs the attestation (the sign/seal certificate) and `I_n` is the last intermediate certificate; (c) it matches `C.subject` name to the LoTE `TEName` field and, optionally, `C.subject.organizationIdentifier` to `TETradeName`; (d) under `ServiceDigitalIdentity` of the matched entity's service it obtains the trust anchor certificates `[A_1, ..., A_m]`; (e) it matches `I_n.issuer` and `I_n.aki` to `A_i.subject` and `A_i.ski`, selecting the matching `A_i`; when the chain has no intermediate certificate (n = 0), it matches `C.issuer` and `C.aki` instead, because C was issued directly by the trust anchor (D23); (f) [removed by D27: the X.509 certificate chain validation is not part of LoTE Validation; the caller runs it with that `A_i` as the trust anchor input]. Steps (a) to (e) stand; D20 ends at the selection of `A_i`.
- D21. EAA identifiers (Q5, confirmed): `LoTEType` `http://aptitude-consortium.github.io/LoTEType/EAAProvidersList`; `StatusDeterminationApproach` `http://aptitude-consortium.github.io/SvcType/EAAProviderList/StatusDetn`; `SchemeTypeCommunityRules` `http://aptitude-consortium.github.io/SvcType/EAAProvider/schemerules/EU`; service types `http://aptitude-consortium.github.io/SvcType/{Specific_attestation}/Issuance|Revocation`. They replace `QEAAProviderList` and the `lote-identifiers/#eaa-lote-type` anchor.
- D22. Callers pass the chain through (user answer). The Authentication and Authorization steps, `trust-anchor-certificate-profiles.md` and `authentication-process.md` supply the sign/seal `x5c` chain `[C, I_1, ..., I_n]` and, optionally, the LoTE identification as inputs to the LoTE trust-anchor validation (D20), instead of retrieving the Trust Anchor themselves from the LoTE. Entity identification in those callers is otherwise unchanged. Each caller refers to the validation topic for the algorithm and does not restate it. Revised by D27 and T9 (O3): LoTE Validation outputs only the `Trust-Anchor`; the callers run the X.509 path validation themselves with the chain they pass in and the returned Trust Anchor (D28 for the failure). The attestation Sign/Seal Validation step that already routes through the LoTE (`attestation-signature-validation-process.md`, step 2) supplies the same inputs; it is added to the affected parts because it is the same caller pattern (flagged for confirmation).
- D23. No intermediate certificate (n = 0), user answer: the validation matches `C.issuer` and `C.aki` to `A_i.subject` and `A_i.ski`, because the sign/seal certificate C was issued directly by the trust anchor when the chain has no intermediate. Stated once, in D20 step (e) of the validation topic; the callers only pass the chain.
- D24. **Superseded by D27.** Narrow the callers' path validation (user answer "narrow them"). LoTE Validation step 8 already runs the X.509 chain validation to the selected anchor (D20 (f)), so the callers take that result and do not repeat it. WRPRC validation step 5 keeps only the checks LoTE Validation does not perform (Attestation Provider relationships, applicable constraints, certificate policies, revocation status) and says that the chain-to-anchor result comes from step 4. Attestation Sign/Seal Validation step 3 keeps signature validation and the failure rule and takes the chain-to-anchor result from LoTE Validation. In the WRPRC Inputs the Trust Anchor is an output of LoTE Validation, not an input: it is removed and the Provider of WRPRC LoTE identification stays. Each caller refers to LoTE Validation and does not restate the algorithm.
- D25. Advisory on LoTE selection (user answer). In step (a) of the trust-anchor validation algorithm (D20) a non-normative advisory note says that a verifier MAY use the `qcStatements` extension of the sign/seal certificate C to determine which LoTE to fetch. It is an advisory, not a mapping: the specification defines no mapping from `qcStatements` to a LoTE type and requires none. It replaces the earlier answer "Caller's choice, no rule".
- D26. **Superseded by D27 in so far as it removes the path validation from the callers** (the part of T7 that says "avoid repetition", by link and not by restatement, still holds for the X.509 rules). Avoid repetition in the callers (T7, supersedes the wording of D24 where they differ). A caller that uses LoTE Validation cites it by link and does not restate or re-list what LoTE Validation (chain-to-anchor, revocation and policy processing of the X.509 process it runs) or the X.509 Certificate Chain Validation states. WRPRC validation step 5 becomes a single cross-reference sentence (path result from step 4 / LoTE Validation step 8; status in step 7) with no check of its own, because the WRPRC profile defines no check beyond those (user follow-up to T7); the listing of the Attestation Provider relationships, applicable constraints, certificate policies and revocation status is dropped. Attestation Sign/Seal Validation step 3 states nothing of the LoTE route that step 2 already states; it keeps the QEAA path validation and matching, the sentence "An attestation-supplied certificate alone SHALL NOT establish trust" and the failure rule.
- D27. X.509 certificate path validation is not part of LoTE Validation (user, T8, T9; supersedes D24, D26 in so far as they rely on it, the T6 addition of `CERT_CHAIN_NOT_VALID_AT_DATE_TIME` and D20 (f)). **Why:** the validating entity validates the LoTE and extracts the Trust Anchor, then runs the X.509 path validation for the process at hand; the path validation belongs to each process that needs it (authentication, authorization, sign/seal validation and so on). LoTE Validation therefore ends at the selection of the Trust Anchor and defines the path rules nowhere. **Target:**
    - LoTE Validation (`docs/topics/trust-anchor-validation.md`): the current step 8 ("Validate the certificate path") is removed and steps 9 to 12 become 8 to 11; every reference to a step number, the sequence diagram line "Validate certificate path to the selected Trust Anchor", the flowchart, the Remarks and the persisted-state step ("after steps 1 to 11 have all succeeded") follow. Steps (a) to (e) of D20 and the n = 0 rule (D23) stay in step 6 and step 7. The input `Date-Time` stays but is no longer described as the `current_time` of a path validation (it serves the freshness and status checks). The only output of the selection is `Trust-Anchor` (the selected `A_i`); no chain is output (T9, O3). `PROCESS_PASSED` means that the LoTE is valid and the Trust Anchor is selected; it does not mean that the certificate path is valid. A remark says so and says that the calling process runs the X.509 path validation.
    - Sub-status list: `CERT_CHAIN_NOT_VALID_AT_DATE_TIME` is removed (T6 superseded). In step 6, an empty or unparseable `Sign-Seal-Chain` gives the sub-status `NO_MATCHING_TE_SERVICE` (T9, O1); no new sub-status.
    - Callers: each process that uses LoTE Validation runs the [X.509 Certificate Chain Validation](../../docs/topics/x509-certificate-validation.md) itself, after LoTE Validation returns `PROCESS_PASSED`, with the path `I_n, ..., I_1, C` built from the chain it passed in (for n = 0, the path is `C`), the `Trust-Anchor` output as `trust_anchor` and the runtime validation time as `current_time`. The callers cite the X.509 process by link and do not restate its rules. The failure rule of the callers is D28.
    - Kept from D22/D24: the Trust Anchor is an output of LoTE Validation and not an input from the Wallet Instance or the candidate artifact (a certificate supplied only by the candidate SHALL NOT be accepted as the Trust Anchor); the chain is an input to LoTE Validation (D22).
- D28. Failure of a caller on an `INVALID` X.509 path (user, T9, O2). An `INVALID` result of the X.509 Certificate Chain Validation fails the calling process: `NON_AUTHENTICATED` for authentication; a failed step for authorization (WRPRC validation step 5 and Registrar verification step 4); validation failure for attestation sign/seal validation. `docs/topics/x509-certificate-validation.md` defines no sub-status of its own (it defines only `VALID` and `INVALID`) and is not changed; no `CERT_CHAIN` name is used anywhere in the specification, and the callers add no sub-status. The Changes text of the three callers states exactly these outcomes (checked against D28 in revision 5).

## Questions for gate 1

All eight questions, the two follow-up points and the trace-phase follow-ups T1 to T9 are answered by the user; no question remains open. The answers are reflected in Gaps, Decisions and Changes.

- Q1. Status model. Answer: agreed. Adopt the S1 `Status` (`PROCESS_PASSED`/`PROCESS_FAILED`) and `Sub-Status` outputs with the S1 sub-status names (`TRY_LATER`, `LOTE_SIGNER_NOT_AUTHENTICATED`, `LOTE_EXPIRED`, `LOTE_NOT_YET_VALID`, `NO_MATCHING_TE_SERVICE`, `STATUS_NOT_APPLICABLE`, `STATUS_CONFLICT`, `SDI_CONSTRAINT_FAILURE`, `CRITICAL_EXTENSION_FAILURE`) plus the pilot sub-statuses `LOTE_OJA_ENTRY_NOT_FOUND`, `LOTE_SCHEMA_INVALID`, `LOTE_TYPE_MISMATCH`, `LOTE_SIGNER_CERT_NOT_VALID`, `LOTE_LOCATION_MISMATCH`, `LOTE_PROFILE_VIOLATION`, `LOTE_SEQUENCE_ROLLBACK`, `LOTE_PUBLICATION_CONFLICT`, `LOTE_STATE_NOT_PERSISTED`; and [superseded by D27 and T8: the S1 name `CERT_CHAIN_NOT_VALID_AT_DATE_TIME` is removed from the list again] the S1 name `CERT_CHAIN_NOT_VALID_AT_DATE_TIME`, added after the trace phase (approved in the A-05 answer, user: "CERT_CHAIN_NOT_VALID_AT_DATE_TIME (S1 §4.1.2 name). No new pilot sub-status."; the user then confirmed "add it"). (Affects `trust-anchor-validation.md`, `trust-checks-presentation.md`, `use-cases.md`.) Revision 5 (T9, O1): `NO_MATCHING_TE_SERVICE` is also the sub-status when the `x5c` chain is empty or cannot be parsed (LoTE Validation step 6); no new sub-status.
- Q2. Detail. Answer: agreed with clarification. Cite S1 with additions for all constraint sets, the status vocabulary, status applicability and critical extensions. The only element spelled out in full is the EAA LoTE (constraints, status handling and identifiers), which S1 does not cover; it is written in full in the plan and in the target (D18, D21).
- Q3. Trust-anchor selection. Answer: the user's flow, recorded as D20 (identity-based, chain-validated): LoTE selection (known or from `qcStatements`), parse `x5c` `[C, I_1, ..., I_n]`, match `C.subject` to `TEName` (optionally `organizationIdentifier` to `TETradeName`), obtain `[A_1, ..., A_m]` under `ServiceDigitalIdentity`, match `I_n.issuer` and `I_n.aki` to `A_i.subject` and `A_i.ski`, run X.509 chain validation with `A_i` as the trust anchor. It replaces the wording of option A where they differ.
- Q4. Media type. Answer: `application/jwt`; no move to `application/jose`; the `application/jose` change is removed (D17).
- Q5. EAA identifiers. Answer: the proposed `http://aptitude-consortium.github.io/...` set is confirmed (D21).
- Q6. WRPRC `StatusDeterminationApproach`. Answer: use the corrected value `.../WRPRCProvidersList/StatusDetn/EU`, not the typo'd literal (D19).
- Q7. Signing certificate subject. Answer: confirmed. `organizationName` equals a `SchemeOperatorName` value and `countryName` is `EU`.
- Q8. `ServiceDigitalIdentity` and `SdiMatching`. Answer: confirmed. The Annex H rules and the matching rule are generalised to all seven types.
- Follow-up A. Callers of trust-anchor validation. Answer: pass the chain through; the callers supply `[C, I_1, ..., I_n]` and the optional LoTE identification (D22).
- Follow-up B. No intermediate certificate (n = 0). Answer: match `C.issuer` and `C.aki` to `A_i.subject` and `A_i.ski` (D20 (e), D23).

## Follow-up answers (trace phase)

Answers of the user to the open points of the trace phase. Each is recorded in Decisions and Changes.

- T1. **Superseded by T8 and D27.** Path validation in the callers. Answer: "narrow them". Reflected in D24 and in Changes (`authorization-process.md` Inputs and step 5; `attestation-signature-validation-process.md` step 3).
- T2. Where the LoTE is fetched in the issuance flow. Answer: "state the URL is published on the OJA". Reflected in Changes (`trust-checks-issuance.md` steps 3a, 7a, 11a) and in the A-09 answer.
- T3. Duplicate "Service readiness" bullet in `docs/sections/use-cases.md`. Answer: "remove one". The older bullet is removed and the new one kept (see Changes, `use-cases.md`). Confirmed by the user: the removed bullet ("contains the required infrastructure Trust Anchors") is acceptable to lose; the kept bullet stays.
- T4. Service type identifiers `Issuance` for WRPAC, WRPRC and attestations. Answer: "use the ETSI pattern values": WRPAC `http://uri.etsi.org/19602/SvcType/WRPAC/Issuance` and WRPRC `http://uri.etsi.org/19602/SvcType/WRPRC/Issuance`. They are written out in the identifier table of the LoTE topic, where the pattern is now given only in general form (see Changes, `trusted-list-and-list-of-trusted-lists.md`).
- T5. Selection of the LoTE from `qcStatements`. Answer: "we can write an advisory, that the verifier can rely on the qcStatements element of the sign/seal certificate to fetch the correct LoTE". Reflected in D25 and in Changes (`trust-anchor-validation.md` step (a)); replaces "Caller's choice, no rule" (A-05 answer).
- T6. **Superseded by T8 and D27.** Sub-status `CERT_CHAIN_NOT_VALID_AT_DATE_TIME`. Answer: "add it". Added to the Q1 sub-status list; removed again by D27.

- T7. **Superseded by T8 and D27 for the path validation in the callers; its rule "cite, do not restate" stays.** Narrow and avoid repetition in the callers. Answer: "narrow down and avoid repetition, cite the trust-anchor validation process if needed as a reference". It tightens D24: WRPRC validation step 5 does not repeat the chain-to-anchor validation (step 4, List of Trusted Entities Validation step 8) and does not list again what the X.509 Certificate Chain Validation or the List of Trusted Entities Validation process already states; it cites them by link and keeps only the checks specific to the WRPRC, stated once. Follow-up (user, after the A-20 tracer found that the WRPRC profile defines no Attestation Provider relationship check and that step 7 already validates the status): "Cross-reference only. Keep step 5 as one sentence: the path to the Trust Anchor is the result of step 4 (LoTE Validation step 8) and is not repeated; WRPRC status is checked in step 7. No new checks and no renumbering." The same test applies to step 3 of Attestation Sign/Seal Validation: its LoTE-route sentence repeats step 2 (which already validates the path through LoTE Validation and fails on `PROCESS_FAILED`) and is removed. Reflected in D26 and in Changes (`authorization-process.md` step 5; `attestation-signature-validation-process.md` step 3). Assignments A-20 and A-21.

- T8. The X.509 certificate path validation is not part of LoTE Validation (revision 4, gate 1 again). Answer (user): "remove the step \"8. Validate the certificate path\" (run X.509 Certificate Chain Validation with path I_n, ..., I_1, C, the selected A_i as trust_anchor and the runtime validation time as current_time; INVALID gives CERT_CHAIN_NOT_VALID_AT_DATE_TIME) from LoTE Validation. Recall it in authorization, authentication or any other process that requires it instead." Rationale of the user: the X.509 path validation "belongs to each process that needs it (authentication, authorization, sign/seal validation and so on)": the entity validates the LoTE and extracts the Trust Anchor, then runs the X.509 path validation for the process at hand. Reflected in D27 and in Changes.

- T9. Answers to the open questions O1 to O3 of revision 4 (revision 5, gate 1 again). Reflected in D22, D27, D28 and in Changes (`trust-anchor-validation.md`, `authentication-process.md`, `authorization-process.md`, `attestation-signature-validation-process.md`).
    - O1 (sub-status for an empty or unparseable `x5c` chain in LoTE Validation step 6). Answer (user): the sub-status is `NO_MATCHING_TE_SERVICE`; no new sub-status. Recorded in D27, in the step and in the Q1 sub-status list.
    - O2 (failure of the callers on an `INVALID` X.509 path). Answer (user): an `INVALID` result of the X.509 path check fails the calling process: `NON_AUTHENTICATED` for authentication, a failed step for authorization, validation failure for sign/seal validation. The X.509 topic defines no sub-status of its own and no `CERT_CHAIN` name is used in the specification. Recorded as D28.
    - O3 (output of LoTE Validation). Answer (user): LoTE Validation outputs only `Trust-Anchor`; the `Matched-Chain` output of revision 4 is removed together with any text that relies on it. The callers use the chain they already hold, which is the chain they pass in (D22). Recorded in D22 and D27.

### Resolved open questions of revision 4

O1 to O3 are answered by T9; none remains open.

## Mapper points

Resolved by this plan: M4 (EAA identifier conflict: LoTE topic and OpenAPI, Q5); M5, issuance steps 3b, 7a, 7b, 11a to 11c (trust-checks-issuance); M6, LoTE introduction (five kinds, JSON and XML, `SchemeTerritory`).

Left untouched, out of scope: the build-time glossary is not versioned; Register write scope; Register response shape; M5 remainder (the core-process introduction of `trust-evaluation.md` names LoTE and TL as trust sources and stays accurate); M6 remainder (undefined "LOTLSO" in `onboarding-process.md`); M7 (`QEAA` entity-end certificate profile against the non-CA direct service identity, TL route; stays out of scope: the D20 algorithm applies to the LoTE route); service-binding lookup issue #114, proximity `RPRC_19a`, attribute-level EDP processing, the EDP JSON schema and `id-etsi-qcs-QcPSB`; lifecycle breadth of `REMOVED` and QEAA TL history; the apparent duplicates not named in the changes below (the unsigned-OJA assumption in the LoTE topic, the validation topic and onboarding stays as is).

## Affected parts

Widened by D22 (callers pass the chain). Revision 4 and 5 (D27, D28) changes the ## Changes entries of: `docs/topics/trust-anchor-validation.md` (LoTE Validation: step 8, outputs, sub-statuses, diagram, flowchart, Remarks), `docs/topics/authentication-process.md`, `docs/topics/authorization-process.md`, `docs/topics/attestation-signature-validation-process.md`; and confirms by check (no text change expected unless the check finds a statement that LoTE Validation validates the path): `docs/topics/trust-checks-issuance.md` (steps 3b, 7b, 11b), `docs/topics/trust-checks-presentation.md` (`TL-PRES-001`), `docs/sections/use-cases.md`, `docs/topics/trust-anchor-certificate-profiles.md`, `docs/topics/trust-evaluation.md`. Corrections are listed under "Revision 5 corrections" below. Files in ## Changes: `docs/topics/trusted-list-and-list-of-trusted-lists.md`, `docs/topics/trust-anchor-certificate-profiles.md` (new), `docs/topics/onboarding-process.md`, `docs/topics/trust-anchor-validation.md`, `docs/topics/authentication-process.md` (new), `docs/topics/authorization-process.md` (new), `docs/topics/attestation-signature-validation-process.md` (new, to confirm), `docs/topics/trust-checks-issuance.md`, `docs/topics/trust-checks-presentation.md`, `docs/topics/trust-management-process.md`, `docs/sections/use-cases.md`, `docs/sections/references.md`, `docs/includes/lote-oas3.yaml`.

## Changes

### Overview and entry point

No change.

### 2. Trust Artifacts

#### `docs/topics/trusted-list-and-list-of-trusted-lists.md` (changed)

##### List of Trusted Entities (changed)

- Introduction: replace the Member-State-compiled five-kind description and the "same structure as Trusted Lists / JSON and XML" statement with the S2 data model (ListAndSchemeInformation and TrustedEntitiesList, explicit scheme information), JSON only, `SchemeTerritory` `EU`, seven retained types including EAA, bound to S2 V1.1.1 and the JSON schema tag `v1.1.1`; state the alias LoTESO. [S2 §4.1, §5, §6.3.0, Annex A.1; G7] [D1, D16]
- Data Models: cite the repository at tag `v1.1.1`; state that S2 prevails on conflict with the schema. [S2 Annex A.1; D1]
- Table of scheme-level parameters: change the EAA values of `LoTEType`, `StatusDeterminationApproach` and `SchemeTypeCommunityRules` and the unresolved-identifier note (Q5, D21); WRPRC `StatusDeterminationApproach` corrected value (Q6, D19); add the media-type parameter `LoTEMimeType` = `application/jwt` (D17); add the `TrustedEntitiesList` presence rule (D9) and the `NextUpdate` rule that it is never null (D10). [S2 §6.3.3, §6.3.8, §6.3.9, §6.3.15, §6.4.0, Annex C.2, Annex H.1, Annex I; S1 Annex C]
- Table of entity-level parameters: `ServiceDigitalIdentity` rules and `organizationName` match for all seven types (Q8); signing-certificate subject rule (Q7); `ServiceDefinitionURI` replaces `TEServiceDefinitionURI` (D8); `StatusStartingTime` re-issuance rule for PuB-EAA (D13); critical-extension statement for the Wallet Provider `ServiceInformationExtensions` (D7); statement that `ServiceHistoryInstance` omits the optional `ServiceTypeIdentifier` and `ServiceInformationExtensions` (D11). [S2 §6.4.0, §6.6.3, §6.6.5, §6.6.8, §6.7, §6.8.0, Annex H.3; S1 Annex C.1.2]
- Departures from S2 Annexes D to G and I stay recorded in this place only (D12).
- Service type identifiers (T4, answered): the table row `ServiceTypeIdentifier` gives the literal example `.../SvcType/PID/Issuance` and `.../PID/Revocation`; the Implementation Choice block defines the pattern only in general form. The `ServiceTypeIdentifier` row of the ServiceInformation table of this topic (the identifier table) writes out, beside the PID examples, the two `Issuance` identifiers: WRPAC `http://uri.etsi.org/19602/SvcType/WRPAC/Issuance` and WRPRC `http://uri.etsi.org/19602/SvcType/WRPRC/Issuance`, as given by the pattern `http://uri.etsi.org/19602/SvcType/{Specific_attestation}/Issuance|Revocation`. Defined once there; other parts refer to the table.

Detail: not applicable (edits to existing tables; the new `LoTEMimeType` parameter is a field, Detail: cite S2/S1; Additions: parameters: `LoTEMimeType`; fields: `TrustedEntitiesList` presence; values: WRPRC URI). EAA values, constraints and status handling are written in full (Q2, D18, D21).

##### `docs/topics/x509-certificates.md`

###### `docs/topics/trust-anchor-certificate-profiles.md` (changed)

Introduction: `ServiceDigitalIdentity` anchor selection refers to the LoTE trust-anchor validation algorithm, which receives the sign/seal chain `[C, I_1, ..., I_n]`, instead of implying direct selection from a service entry; the relationship note states that the end-entity C is passed in `x5c` and that the Trust Anchor is not (n = 0: C is issued directly by the anchor). Certificate profile requirements unchanged. [D20, D22, D23]

### 3. Onboarding Process

#### `docs/topics/onboarding-process.md` (changed)

Prerequisites 2 and 4: state that the LoTE signing certificate satisfies the subject rule (Q7) (`organizationName` equals a `SchemeOperatorName` value, `countryName` `EU`) and that lists are published as `application/jwt` (D17), by reference to the LoTE topic. [S2 §6.8.0; S1 Annex C]

### 4. Trust Evaluation

#### `docs/topics/trust-evaluation.md`

##### `docs/topics/trust-anchor-validation.md` (changed)

###### Trust-Source Dispatch (changed)

Names the governing source of each route: S1 (draft) with the pilot choices for the seven retained LoTE types; S3 and S4 for the pilot LOTL and TL. Inputs unchanged. [S1 §1] [D3, D4]

###### List of Trusted Entities Validation (changed)

- **Inputs:** add the pilot LoTE profile constraints of the requested type (artefact, new), plus the sign/seal certificate chain `x5c` `[C, I_1, ..., I_n]` and, optionally, the LoTE identification (known in advance or from the `qcStatements` extension) for the D20 algorithm; `Date-Time` is the runtime validation time. [S1 §4.1.1, §4.5.2] [D5]

  Detail (Q2 (a)): cite S1 §4.1.1; Additions: fields: `LoTEMimeType`, `PivotEnabled`, `SupportedSti`, `SupportedStatuses`, `StatusCoherenceOnSti`, `SdiMatching`, `StatusStartingTimePresent`; values: per type as in D5. The EAA constraint row is written in full (D18, D21).
- **Outputs:** `Status`, `Sub-Status`, `Authenticated-LoTE`, `Current-LoTE-Certs-Set`, `Current-LoTE-Loc` and the selected Trust Anchor (`Trust-Anchor`, the only output of the selection; no chain is returned, the callers use the chain they pass in, D22 and D27) replace `LoTE-Status`, initialized to void (Q1); `PROCESS_PASSED` means that the LoTE is valid and the Trust Anchor is selected, not that the certificate path is valid. [S1 §4.1, §4.1.2, §4.2.3] [G3, G17]

  Detail (Q2 (b)): cite S1 §4.1 and §4.1.2; Additions: sub-statuses: the pilot-defined list of Q1. Status handling for the EAA LoTE is written in full (D18).
- **Process steps (changed):** retrieval and authentication follow S1 §4.2 (`TRY_LATER` on no file; signing-certificate identification and cryptographic verification through the JSON LoTE Signature Verification; `LOTE_SIGNER_NOT_AUTHENTICATED`; `LOTE_EXPIRED`; `LOTE_NOT_YET_VALID`) with the pilot additions of G18 kept in place; the pivot step is omitted. Entity, service and trust anchor selection follow the trust-anchor validation algorithm D20 (steps a to e: LoTE selection, `x5c` parsing, `TEName`/`TETradeName` match of `C.subject`, anchors from `ServiceDigitalIdentity`, `I_n.issuer`/`I_n.aki` against `A_i.subject`/`A_i.ski`, or `C.issuer`/`C.aki` when n = 0 (D23); step (f), the X.509 chain validation, is removed by D27 and belongs to the callers), followed by `SdiMatching`, the status-applicability determination of D6 and the critical-extension check of D7, in that order, before the persisted state is written and success is returned. The existing steps stay in full. [S1 §4.2.4, §4.5.4, §4.6.4-08, -13, -14] [D3, D6, D7, D14]

  Detail (status applicability, Q2 (c)): cite S1 §4.5; Additions: parameters: `Date-Time`, `Target-TE-Service-Statuses`, `StatusStartingTimePresent`, `StatusCoherenceOnSti`; values as in D5 and D6; EAA handling in full (D18).

  Detail (critical extensions, Q2 (d)): cite S1 §4.6.4-13 and -14; Additions: parameters: recognized extension set (`ServiceUniqueIdentifier` for Wallet Provider); sub-status: `CRITICAL_EXTENSION_FAILURE`.
- **Advisory note (D25):** in the trust-anchor validation algorithm, step (a) (LoTE selection) gets a non-normative advisory note: a verifier MAY use the `qcStatements` extension of the sign/seal certificate C to determine which LoTE to fetch; this is an advisory and not a mapping, so the specification defines no mapping from `qcStatements` to a LoTE type and requires none. The current text of the `Requested-LoTE-Type` input ("this specification defines no mapping from that extension to a type") is kept in agreement with the note.
- **Sequence diagram, flowchart and Remarks:** updated for the new steps, outputs and sub-statuses. [S1 §4.2, §4.5]

##### `docs/topics/authentication-process.md` (changed)

Step 1 (retrieve the Trust Anchor) and step 3 (path validation) of WRPAC validation: the caller passes the WRPAC `x5c` chain `[C, I_1, ..., I_n]` of the Remote, Proximity (`x5chain`) and Issuance flows, and the optional Provider of WRPAC LoTE identification, as inputs to LoTE Validation, which returns the selected Trust Anchor (its only output besides the status outputs); the process does not select the entry itself. Entity identification and the flow-specific chain carriers stay unchanged. By D27 and D28, step 1 ends with the LoTE Validation result and the `Trust-Anchor` output (title "Select the Trust Anchor"; the sentence "does not validate the certificate path a second time" and the words "and validates the certificate path with it" are removed); a new step after step 1 (no renumbering of the flow-specific list beyond what consistency needs; the assignment fixes the number) runs the [X.509 Certificate Chain Validation](../sections/trust-evaluation-process.md#x509-certificate-chain-validation) with the path `I_n, ..., I_1, C` of the WRPAC chain (for n = 0, `C`), the Trust Anchor from step 1 as `trust_anchor` and the runtime validation time as `current_time`; an `INVALID` path gives the Authentication outcome `NON_AUTHENTICATED`, which is also the outcome of a `PROCESS_FAILED` result. The Input list item "the X.509 certificate path terminating in the WRPAC end-entity certificate" stays. [S1 §4.2, §4.5] [D20, D22, D23, D27, D28]

##### `docs/topics/authorization-process.md` (changed)

WRPRC validation step 4 (Trust Anchor validation) and Registrar verification step 4: the caller passes the signing-certificate chain `[C, I_1, ..., I_n]` and the optional LoTE identification (Provider of WRPRC LoTE; Registrar LoTE) as inputs to LoTE Validation, which returns the `Trust-Anchor`. The Inputs list no longer names the Trust Anchor (it is an output of LoTE Validation); it keeps the Provider of WRPRC LoTE identification, the certificate-status information and the validation time. By D27 and D28, step 4 states no path validation (a `PROCESS_FAILED` result fails the step; a certificate supplied only by the candidate WRPRC SHALL NOT be accepted as the Trust Anchor stays). Step 5 ("Signing-certificate path") runs the [X.509 Certificate Chain Validation](../sections/trust-evaluation-process.md#x509-certificate-chain-validation) with the path `I_n, ..., I_1, C` of the signing-certificate chain, the Trust Anchor returned by step 4 as `trust_anchor` and the runtime validation time as `current_time`; an `INVALID` path fails the step. Registrar verification step 4 drops "validates the certificate path" and gains the same X.509 run after the LoTE Validation result and before the signature validation with `C`; an `INVALID` path fails the step. The status of the WRPRC stays in step 7. No restatement of path rules; the cross-reference-only step 5 of A-20 (T7) is replaced. [D20, D22, D23, D27, D28]

##### `docs/topics/attestation-signature-validation-process.md` (changed)

Step 2, LoTE route for PID, WIA, EAA and PuB-EAA: the caller passes the attestation `x5c` chain and the optional LoTE identification instead of extracting the Trust Anchor from `ServiceDigitalIdentity` itself; the process returns the `Trust-Anchor`; "and validates the certificate path with it" is dropped (D27). The QEAA route stays unchanged (D4). Added by D22 for consistency; confirm. Step 3 validates the Sign/Seal Certificate chain `C, I_1, ..., I_n` against the Trust Anchor obtained in step 2 for both routes (the `Trust-Anchor` output for the LoTE route, the CA Trust Anchor of the TL route for QEAA), where path-based validation applies, using the [X.509 Certificate Chain Validation](../sections/trust-evaluation-process.md#certificate-path-validation) (the path ordered from the certificate issued by the Trust Anchor to `C`); the QEAA direct service-identity matching, the sentence "An attestation-supplied certificate alone SHALL NOT establish trust" and the failure rule stay; an `INVALID` path is a validation failure (D28). The path rules are not restated. [D20, D22, D27, D28]

##### `docs/topics/trust-checks.md`

###### `docs/topics/trust-checks-issuance.md` (changed)

Steps 3b, 7b and 11b invoke LoTE Validation by reference instead of "signature plus extra checks" and drop the "ETSI TS 319 102-1" good-practice sentence; step 7a refers to the 24-hour or `NextUpdate` refresh rule instead of provider-chosen caching; steps 11a to 11c route a QEAA through Trust Anchor Validation (pilot LOTL and TL) and Sign/Seal Validation and keep LoTE routes for PID, PuB-EAA and EAA only. OJA location (T2): steps 3a, 7a and 11a say that the LoTE is fetched from the fixed location that the Official Journal of APTITUDE (OJA) publishes for that LoTE type, instead of "from a publicly-known URL" (3a and 7a carry that phrase; 11a does not and receives the OJA statement for the PID, PuB-EAA and EAA lists). New sentence: "The <LoTE> is fetched from the fixed location that the <OJA> publishes for that LoTE type (`OJA-LoTE-Loc`; values in the [List of Trusted Entities](...) topic)." The topic is referred to for the `OJA-LoTE-Loc` values, which are not restated. [S1 §4.2] [M4, M5; D4]

###### `docs/topics/trust-checks-presentation.md` (changed)

`TL-PRES-001`: preserve S1 `Status` and `Sub-Status` of LoTE Validation next to the S3 statuses; test focus adds critical-extension failure, status applicability and sequence rollback for the LoTE route; the mapping row to ETSI clauses adds S1 §4.2, §4.5 and §4.6.4-13/-14 as draft. [S1 §4.1, §4.1.2]

### 5. Trust Management and Lifecycle

#### `docs/topics/trust-management-process.md` (changed)

PuB-EAA withdrawal: `StatusStartingTime` follows the re-issuance rule of the LoTE topic instead of "the time at which the withdrawn status takes effect". [S2 §6.6.5, Table H.3] [D13]

### 6. Trust Use Cases

#### `docs/sections/use-cases.md` (changed)

Runtime Trust Anchor Validation use case: LoTE Validation outputs (`Status`, `Sub-Status`), status applicability and critical extensions in the checks and failure consequence. Service readiness: each published LoTE passes LoTE Validation for its type. Duplicate removed (T3): the bullet "Verify that each published LoTE has a valid signature, conforms to its format, and contains the required infrastructure Trust Anchors", which A-12 left beside the new bullet "Verify that each published LoTE passes LoTE Validation for its type", is removed and the new bullet is kept, because LoTE Validation checks the signature, the profile, the type and the entity and service. The older bullet also required that the list contains the required infrastructure Trust Anchors, which LoTE Validation does not check; the user confirmed that the loss is acceptable. [S1 §4.1] [Q1]

### 7. References

#### `docs/sections/references.md` (changed)

Adds ETSI TS 119 605 V0.0.3 (2026-06), draft, marked work in progress, in the ETSI group; adds the S2a repository tag to the S2 entry. [S1] [S2a]

### 8. Linked interface descriptions

#### `docs/api/lote-api.md`

No change (loads the OpenAPI description only).

##### `docs/includes/lote-oas3.yaml` (changed)

`info.version` 1.2.0 and description (D15); `externalDocs` adds S1 as work in progress; response media type stays `application/jwt` (no change, D17); `LoTEType` enum and examples for EAA per Q5 (D21), WRPRC description with the corrected value (D19); `TEServiceDefinitionURI` renamed `ServiceDefinitionURI` (D8); `TrustedEntitiesList` no longer required in `LoTE` (D9); `Critical` semantics and recognized extension described on `ServiceInformationExtension` (D7); description states that `ServiceHistoryInstance` omits optional components (D11). Every retained component compared with [S2a] tag `v1.1.1`; the known differences are G12 and G13. [S2 §6.4.0, §6.6.8, §6.7, Annex A.1; S1 Annex C]

Detail: not applicable (edits to existing schemas).

## Revision 5 corrections (D27, D28, T8, T9)

Basis. Commit 6e57453 (`docs: manual edits to LoTE validation and list topics (pre-run)`) holds the user's pending edits to `docs/topics/trust-anchor-validation.md` and `docs/topics/trusted-list-and-list-of-trusted-lists.md`. It is not run output and no assignment of this run produced it. Every assignment that touches either file starts from that commit and reads the current text of the file before it edits; it does not restore the pre-6e57453 text.

Decisions superseded by D27, D28 and T9: D24 (narrow the callers), D26 (path part), D20 step (f), D22 (the sentence that LoTE Validation validates the path; the pass-through stays), T1, T6, T7 (path part), the `Matched-Chain` output proposed in revision 4 (O3) and the reuse of `CERT_CHAIN_NOT_VALID_AT_DATE_TIME` for an unusable chain (A-05 answer OPEN-4; O1). Kept: the Trust Anchor is an output of LoTE Validation (A-16 (1) holds), the chain is an input (D22), D23, D25, T2 to T5.

No open question remains (O1 to O3 are answered by T9).

Accepted assignments that need a correction assignment: A-05, A-06, A-07, A-08, A-16, A-17, A-20, A-21. Correction assignments are to be written after gate 1, one per file (rule of the assignment format: one file, one assignment). Not corrected (checked): A-01 to A-04, A-09 to A-15, A-18, A-19.

| File | Accepted assignments to correct | Correction assignment |
|---|---|---|
| `docs/topics/trust-anchor-validation.md` | A-05 | Correction of A-05 |
| `docs/topics/authentication-process.md` | A-06 | Correction of A-06 |
| `docs/topics/authorization-process.md` | A-07, A-16, A-20 | One correction of A-07, A-16 and A-20 |
| `docs/topics/attestation-signature-validation-process.md` | A-08, A-17, A-21 | One correction of A-08, A-17 and A-21 |

Target text per file (the assignment writes it; path rules are referred to by link, never restated; the link target of the X.509 Certificate Chain Validation is the one the file already uses for it, `../sections/trust-evaluation-process.md#x509-certificate-chain-validation` or `#certificate-path-validation`, whichever resolves in the repository, checked by the assignment):

- **LoTE Validation** (`docs/topics/trust-anchor-validation.md`, correction of A-05; start from 6e57453):
    - Remove step 8 ("Validate the certificate path"); steps 9 to 12 become 8 to 11. Update every step reference (the sequence diagram line "Validate certificate path to the selected Trust Anchor", the flowchart, the Remarks, "after steps 1 to 11 have all succeeded" becomes "after steps 1 to 10 have all succeeded"). Steps (a) to (e) of D20 and the n = 0 rule stay in steps 6 and 7.
    - Outputs: `Trust-Anchor` only (the selected `A_i`); no `Matched-Chain`; no other new output. `Authenticated-LoTE`, `Current-LoTE-Certs-Set` and `Current-LoTE-Loc` stay as written.
    - Step 6: "If the chain cannot be parsed or is empty, the sub-status is `NO_MATCHING_TE_SERVICE`." (replaces `CERT_CHAIN_NOT_VALID_AT_DATE_TIME`).
    - Sub-status list (line of the `Sub-Status` output): remove `CERT_CHAIN_NOT_VALID_AT_DATE_TIME`; `NO_MATCHING_TE_SERVICE` stays and is also the sub-status of an empty or unparseable chain. No new sub-status and no `CERT_CHAIN` name anywhere.
    - Input `Date-Time`: not described as the `current_time` of a path validation; it serves the freshness and status checks.
    - Remark: "`PROCESS_PASSED` means that the LoTE is valid and the Trust Anchor is selected; it does not mean that the certificate path is valid. The calling process runs the X.509 Certificate Chain Validation (link) with the Trust Anchor." The remark does not restate the path rules.
- **Authentication** (`docs/topics/authentication-process.md`, correction of A-06): step 1 keeps the pass-through of the WRPAC `x5c` chain `[C, I_1, ..., I_n]`, the `Requested-LoTE-Type`, the `Issuance` service type identifier and the runtime validation time to LoTE Validation, returns the `Trust-Anchor` output and fails with `NON_AUTHENTICATED` on `PROCESS_FAILED`; its title becomes "Select the Trust Anchor" and it no longer says "and validates the certificate path with it" or "does not validate the certificate path a second time". A new step after step 1 (the assignment fixes the number; the flow-specific list of chain carriers keeps its numbering or is renumbered only as far as needed for consistency): "**Validate the certificate path.** Run the [X.509 Certificate Chain Validation](link) with the path `I_n, ..., I_1, C` of the WRPAC chain (for n = 0, the path is `C`), the <Trust Anchor> from step 1 as `trust_anchor` and the runtime validation time as `current_time`. If the path is `INVALID`, the Authentication outcome is `NON_AUTHENTICATED`." One step for the Remote, Proximity (`x5chain`) and Issuance flows. Line 9 (the Trust Anchor obtained from a valid LoTE) stays.
- **Authorization** (`docs/topics/authorization-process.md`, one correction of A-07, A-16 and A-20; the Inputs change of A-16 (1), the Trust Anchor an output and not an input, holds and stays):
    - WRPRC validation step 4: as written without any "validates the path" wording; it already says that the process validates the LoTE and selects the Trust Anchor (current text of line 60 holds); a failed `Status` fails the step.
    - WRPRC validation step 5, title "Signing-certificate path": "Run the [X.509 Certificate Chain Validation](link) with the path `I_n, ..., I_1, C` of the signing-certificate chain used in step 4 (for n = 0, the path is `C`), the <Trust Anchor> returned by step 4 as `trust_anchor` and the runtime validation time as `current_time`. If the path is `INVALID`, this step fails." Replaces the current cross-reference sentence (A-20, which cites "step 8" of LoTE Validation). Step 7 (status) and the rest unchanged; no renumbering.
    - Registrar verification step 4: drop "validates the certificate path"; after the LoTE Validation result and before the signature validation with `C`, add the same X.509 run with the path `I_n, ..., I_1, C` of the Registrar chain, the returned <Trust Anchor> and the runtime validation time; an `INVALID` path fails the step. Then "validate the Registrar signature with `C`" and the profile-defined temporal and status information stay.
    - The assignment reads the file and applies the same wording to any other step that calls LoTE Validation or states a path validation through it (the Inputs list and the WRPAC case, if the file has them).
- **Attestation Sign/Seal Validation** (`docs/topics/attestation-signature-validation-process.md`, one correction of A-08, A-17 and A-21):
    - Step 2: keep the chain pass-through and the `Trust-Anchor` output for PID, WIA, EAA and PuB-EAA; drop "and validates the certificate path with it"; a failed `Status` is a validation failure. The QEAA route is unchanged (D4).
    - Step 3: "Validate the Sign/Seal Certificate chain `C, I_1, ..., I_n` against the <Trust Anchor> obtained in step 2 (for PID, WIA, EAA and PuB-EAA the `Trust-Anchor` output of LoTE Validation; for QEAA the CA Trust Anchor of the TL route), where path-based validation applies, using the [X.509 Certificate Chain Validation](link) with the path ordered from the certificate issued by the Trust Anchor to `C`, the Trust Anchor as `trust_anchor` and the runtime validation time as `current_time`." The QEAA direct service-identity matching, the sentence "An attestation-supplied certificate alone SHALL NOT establish trust" and the failure rule stay ("Failure of signature validation, applicable path validation or trust-source validation SHALL result in validation failure"); an `INVALID` path is a validation failure.
- **Other callers** (no change; the correction assignments re-check them with a grep for "LoTE Validation" and for any sentence that says LoTE Validation validates the path): `trust-checks-issuance.md` steps 3b, 7b, 11b only invoke LoTE Validation by link; `trust-checks-presentation.md` `TL-PRES-001` (A-10) and `TC-PRES-004`, `TC-PRES-005` list the path or chain validation as a separate check; `use-cases.md` (A-12) lists the X.509 chain validation as a separate check; `trust-evaluation.md` already says that the X.509 process validates a path against the Trust Anchor obtained from a validated LoTE; `trust-anchor-certificate-profiles.md` states that the Trust Anchor is not passed.

New assignments: none numbered; "to be assigned after gate 1".

## Assignments

### A-01 · Artefact · accepted

Plan entry: `docs/topics/trusted-list-and-list-of-trusted-lists.md` › List of Trusted Entities: Introduction, Data Models, table of scheme-level parameters
Writes: `docs/topics/trusted-list-and-list-of-trusted-lists.md`
Sources: [S2 §4.1, §5, §6.3.0, §6.3.3, §6.3.8, §6.3.9, §6.3.15, §6.4.0, Annex A.1, Annex C.2, Annex H.1, Annex I], [S1 Annex C]
Uses: none
Delivers: new introduction (S2 data model, JSON only, `SchemeTerritory` `EU`, seven types including EAA, bound to S2 V1.1.1 and the JSON schema tag `v1.1.1`, alias LoTESO); Data Models paragraph (repository at tag `v1.1.1`, S2 prevails on conflict); scheme-level table changes: EAA values of `LoTEType`, `StatusDeterminationApproach`, `SchemeTypeCommunityRules` written in full per D21 and the unresolved-identifier note removed; WRPRC `StatusDeterminationApproach` corrected value with the typo noted once (D19); new parameter `LoTEMimeType` = `application/jwt` (D17); `TrustedEntitiesList` presence rule (D9); `NextUpdate` never null (D10). Departures from S2 Annexes D to G and I stay recorded in this place only (D12). Detail: cite S2/S1 with additions (parameter `LoTEMimeType`; field `TrustedEntitiesList` presence; value WRPRC URI); EAA values in full.
Answers: Q5 "the proposed `http://aptitude-consortium.github.io/...` set is confirmed" (user); Q6 "use the corrected value, not the typo'd literal" (user); Q4 "`application/jwt`" (user); D21 identifiers: `LoTEType` `http://aptitude-consortium.github.io/LoTEType/EAAProvidersList`; `StatusDeterminationApproach` `http://aptitude-consortium.github.io/SvcType/EAAProviderList/StatusDetn`; `SchemeTypeCommunityRules` `http://aptitude-consortium.github.io/SvcType/EAAProvider/schemerules/EU`; service types `http://aptitude-consortium.github.io/SvcType/{Specific_attestation}/Issuance|Revocation`; WRPRC value `http://uri.etsi.org/19602/WRPRCProvidersList/StatusDetn/EU`.

### A-02 · Artefact · accepted

Plan entry: `docs/topics/trusted-list-and-list-of-trusted-lists.md` › List of Trusted Entities: table of entity-level parameters
Writes: `docs/topics/trusted-list-and-list-of-trusted-lists.md`
Sources: [S2 §6.4.0, §6.6.3, §6.6.5, §6.6.8, §6.7, §6.8.0, §6.3.17, Annex H.3], [S1 Annex C.1.2, C.2.2]
Uses: scheme-level table and `LoTEMimeType` (A-01, same file)
Delivers: `ServiceDigitalIdentity` rules and `organizationName` equal to a `TEName` value for all seven types (Q8); signing-certificate subject rule (Q7: `organizationName` equals a `SchemeOperatorName` value, `countryName` `EU`); `ServiceDefinitionURI` replaces `TEServiceDefinitionURI` (D8); `StatusStartingTime` re-issuance rule for PuB-EAA, stated once (D13: not before the `ListIssueDateTime` of the list that introduces the status); critical-extension statement for the Wallet Provider `ServiceInformationExtensions` (D7; only `ServiceUniqueIdentifier` recognized; `SchemeExtensions` and `TEInformationExtensions` stay prohibited); statement that `ServiceHistoryInstance` omits the optional `ServiceTypeIdentifier` and `ServiceInformationExtensions` (D11). Detail: cite S2/S1 with additions.
Answers: Q7 "confirmed. `organizationName` equals a `SchemeOperatorName` value and `countryName` is `EU`" (user); Q8 "confirmed. The Annex H rules and the matching rule are generalised to all seven types" (user); tracer question on `ServiceInformationExtensions` (Wallet Provider): "the Wallet Solution reference number is carried in the `ServiceUniqueIdentifier` extension: `docs/includes/lote-oas3.yaml` states 'At least one extension supplies the wallet solution reference number through ServiceUniqueIdentifier', and D7 names it as the only recognized extension; write the critical-extension statement as delivered and restate the reference-number sentence in those terms" (planner, from the plan and the repository)

### A-03 · Artefact · accepted

Plan entry: `docs/includes/lote-oas3.yaml`
Writes: `docs/includes/lote-oas3.yaml`
Sources: [S2 §6.4.0, §6.6.8, §6.7, Annex A.1 (JSON schema tag `v1.1.1`)], [S1 Annex C]
Uses: LoTE table values (A-01, A-02, `docs/topics/trusted-list-and-list-of-trusted-lists.md`)
Delivers: `info.version` 1.2.0 and description recording the backward-compatible additions and the field rename (D15); `externalDocs` adds S1 as work in progress; response media type stays `application/jwt`; EAA `LoTEType` enum and examples per D21; WRPRC description with the corrected value (D19); `TEServiceDefinitionURI` renamed `ServiceDefinitionURI` (D8); `TrustedEntitiesList` no longer required in `LoTE`, `minItems: 1` stays on a present array (D9); `Critical` semantics and recognized extension on `ServiceInformationExtension` (D7); description that `ServiceHistoryInstance` omits optional components (D11). Retained components compared with the JSON schema at tag `v1.1.1`.
Answers: Q4 "`application/jwt`; no move to `application/jose`" (user); Q5 "confirmed" (user); Q6 "use the corrected value" (user); tracer question on D15 content: "record all four in `info.description`: the EAA LoTE type, `TrustedEntitiesList` no longer required, the critical-extension semantics with `ServiceUniqueIdentifier` as recognized extension, and the WRPRC corrected value with the `ServiceHistoryInstance` omissions, plus the field rename" (planner, from D15 and the A-03 Delivers)

### A-04 · Artefact · accepted

Plan entry: `docs/topics/trust-anchor-validation.md` › List of Trusted Entities Validation › Inputs (profile constraints)
Writes: `docs/topics/trust-anchor-validation.md`
Sources: [S1 §4.1.1, Annex C.1.2, C.2.2]
Uses: LoTE identifiers, service types, statuses (A-01, A-02, `docs/topics/trusted-list-and-list-of-trusted-lists.md`)
Delivers: the pilot LoTE profile constraints, one table per type for the seven types, values defined once and referring to the LoTE topic for identifier, status and service-type values: `LoTEType`, `SchemeTerritory` (`EU`), `LoTESigningCertificates` (type-specific `OJA-LoTE-Certs-Set`), `LoTELocation` (`OJA-LoTE-Loc`), `LoTEMimeType` (`application/jwt`), `PivotEnabled` (`FALSE`), `SupportedSti`, `SupportedStatuses` (PuB-EAA `notified` and `withdrawn`, others absent), `StatusCoherenceOnSti` (`TRUE`), `SdiMatching` (at least one `organizationName` equals a `TEName` value), `StatusStartingTimePresent` (`TRUE` for PuB-EAA, `FALSE` otherwise). Cites S1 §4.1.1 for the vocabulary; the EAA row written in full and stating that it has no S1 counterpart (D18). Detail: cite with additions as in Plan entry.
Answers: Q2 "cite S1 with additions; only the EAA LoTE is spelled out in full" (user); Q8 "confirmed" (user); tracer question on EAA `SupportedSti`: "leave the pattern open: D21, confirmed by the user in Q5, fixes the EAA service types as the pattern `http://aptitude-consortium.github.io/SvcType/{Specific_attestation}/Issuance` and `.../Revocation`, where `{Specific_attestation}` stands for the specific attestation type; `SupportedSti` is the set of identifiers that follow this pattern, one `Issuance` and `Revocation` pair for each attestation type the list covers, and `StatusCoherenceOnSti` is `TRUE` for each identifier of that set" (planner, from D21)

### A-05 · Algorithm · accepted

Superseded in part by D27, D28 and T9: step 8, the sub-status `CERT_CHAIN_NOT_VALID_AT_DATE_TIME` and the `Matched-Chain` idea are removed; an empty or unparseable chain gives `NO_MATCHING_TE_SERVICE` (the OPEN-4 answer below is replaced); the only selection output is `Trust-Anchor`. A correction assignment will be added after gate 1; it starts from commit 6e57453.

Plan entry: `docs/topics/trust-anchor-validation.md` › List of Trusted Entities Validation (Inputs, Outputs, Process steps, sequence diagram, flowchart, Remarks)
Writes: `docs/topics/trust-anchor-validation.md`
Sources: [S1 §4.1, §4.1.2, §4.2, §4.2.3, §4.2.4, §4.5, §4.5.4, §4.6.4-08, §4.6.4-13, §4.6.4-14, S2 Annex H.3 (several certificates of one service share one key)]
Uses: constraint tables (A-04, same file); LoTE tables (A-01, A-02); X.509 Certificate Chain Validation (`docs/topics/x509-certificate-validation.md`)
Delivers: Inputs: constraints of the requested type (A-04), the sign/seal chain `x5c` `[C, I_1, ..., I_n]`, optional LoTE identification (known or from `qcStatements`), `Date-Time` = runtime validation time. Outputs: `Status` (`PROCESS_PASSED`/`PROCESS_FAILED`), `Sub-Status`, `Authenticated-LoTE`, `Current-LoTE-Certs-Set`, `Current-LoTE-Loc`, selected Trust Anchor, replacing `LoTE-Status` (Q1), with the sub-status list of Q1 (S1 names plus pilot names). Process steps: retrieval and authentication per S1 §4.2 with the pilot additions of G18 kept in place; pivot omitted; then the D20 trust-anchor algorithm steps (a) to (f), with n = 0 variant stated once in step (e) (D23); then `SdiMatching`, status applicability (D6: `Date-Time`, `Target-TE-Service-Statuses`, `StatusStartingTimePresent`, `StatusCoherenceOnSti`; PuB-EAA target `notified`; six others S1 Annex A implicit URIs; `ServiceHistory` never supplies trust; EAA handling in full), critical-extension check (D7, `CRITICAL_EXTENSION_FAILURE`), in that order, before persisted state is written and success returned. Sequence diagram, flowchart, Remarks updated. S1 defects of G3 worked around, not copied. Detail: cite S1 with additions (a) to (d) of the plan entry.
Answers: Q1 "agreed" with the sub-status list (`TRY_LATER`, `LOTE_SIGNER_NOT_AUTHENTICATED`, `LOTE_EXPIRED`, `LOTE_NOT_YET_VALID`, `NO_MATCHING_TE_SERVICE`, `STATUS_NOT_APPLICABLE`, `STATUS_CONFLICT`, `SDI_CONSTRAINT_FAILURE`, `CRITICAL_EXTENSION_FAILURE` plus pilot `LOTE_OJA_ENTRY_NOT_FOUND`, `LOTE_SCHEMA_INVALID`, `LOTE_TYPE_MISMATCH`, `LOTE_SIGNER_CERT_NOT_VALID`, `LOTE_LOCATION_MISMATCH`, `LOTE_PROFILE_VIOLATION`, `LOTE_SEQUENCE_ROLLBACK`, `LOTE_PUBLICATION_CONFLICT`, `LOTE_STATE_NOT_PERSISTED`) (user); Q3 "the user's flow, recorded as D20" (user); Follow-up B "match `C.issuer` and `C.aki` to `A_i.subject` and `A_i.ski`" (user); user answers to tracer questions: (OPEN-1) superseded by the user's later answer (D25): "we can write an advisory, that the verifier can rely on the qcStatements element of the sign/seal certificate to fetch the correct LoTE"; keep D20(a) with a non-normative advisory note that a verifier MAY use `qcStatements`, an advisory and not a mapping; (OPEN-3) "CERT_CHAIN_NOT_VALID_AT_DATE_TIME (S1 §4.1.2 name). No new pilot sub-status."; (OPEN-4) "Same as path INVALID: reuse CERT_CHAIN_NOT_VALID_AT_DATE_TIME for an unusable chain."; (OPEN-2) "Reuse existing names. OJA entry duplicate: LOTE_OJA_ENTRY_NOT_FOUND; duplicate signer certificate: LOTE_SIGNER_NOT_AUTHENTICATED; entity or service duplicate: NO_MATCHING_TE_SERVICE. Several matching A_i are not a failure (same key and subject under Annex H.3); any one is used." (all user)

### A-06 · Algorithm · accepted

Superseded in part by D27: the caller runs the path validation; a correction assignment will be added after gate 1.

Plan entry: `docs/topics/authentication-process.md`
Writes: `docs/topics/authentication-process.md`
Sources: [S1 §4.2, §4.5]
Uses: List of Trusted Entities Validation (A-05, `docs/topics/trust-anchor-validation.md`); X.509 Certificate Chain Validation (`docs/topics/x509-certificate-validation.md`)
Delivers: steps 1 and 3 of WRPAC validation: the caller passes the WRPAC `x5c` chain `[C, I_1, ..., I_n]` of the Remote, Proximity (`x5chain`) and Issuance flows and the optional Provider of WRPAC LoTE identification to LoTE Validation, which returns the selected Trust Anchor; the step does not select the entry itself and does not restate the algorithm. Entity identification and flow-specific chain carriers unchanged.
Answers: Follow-up A "pass the chain through" (user); Follow-up B (user); tracer questions: "LoTE Validation replaces steps 2 and 3: D20 step (f) runs the X.509 chain validation with the selected `A_i`, so the caller validates the chain once, through LoTE Validation, and takes its result" and "the Provider of WRPAC `Issuance` service type identifier is the `Requested-Service-Type`" (planner, from D20(f) and A-05; the `Issuance` choice is derived, not stated by the user)

### A-07 · Algorithm · accepted

Superseded in part by D27: step 4 text and Registrar verification step 4 are corrected; to be assigned after gate 1.

Plan entry: `docs/topics/authorization-process.md`
Writes: `docs/topics/authorization-process.md`
Sources: [S1 §4.2, §4.5]
Uses: List of Trusted Entities Validation (A-05, `docs/topics/trust-anchor-validation.md`)
Delivers: WRPRC validation step 4 and Registrar verification step 4: the caller passes the signing-certificate chain `[C, I_1, ..., I_n]` and the optional LoTE identification (Provider of WRPRC LoTE; Registrar LoTE) to LoTE Validation; step 5 and the rest unchanged; no restatement of the algorithm.
Answers: Follow-up A "pass the chain through" (user); planner note from the plan entry: "Steps 5 (path validation) and the rest stay unchanged", so only step 4 of WRPRC validation and step 4 of Registrar verification change; the `Requested-Service-Type` is the `Issuance` service type identifier for the Provider of WRPRC list (derived from A-06, not stated by the user) and the `Register` service type identifier for the Registrar list (correction of the earlier note, from the LoTE topic); WRPRC step 5 stays unchanged as the plan says, and the Inputs list of the file is not in the plan entry and stays unchanged

### A-08 · Algorithm · accepted

Superseded in part by D27: step 2 text is corrected; to be assigned after gate 1.

Plan entry: `docs/topics/attestation-signature-validation-process.md`
Writes: `docs/topics/attestation-signature-validation-process.md`
Sources: [S1 §4.2]
Uses: List of Trusted Entities Validation (A-05, `docs/topics/trust-anchor-validation.md`)
Delivers: step 2, LoTE route for PID, WIA, EAA and PuB-EAA: the caller passes the attestation `x5c` chain and optional LoTE identification instead of extracting the Trust Anchor from `ServiceDigitalIdentity` itself; the QEAA route unchanged (D4). Widening by D22, not yet confirmed by the user.
Answers: planner note from the plan entry: only step 2 changes; step 3 (path validation) and the rest of the file stay unchanged as the plan says. The `Requested-LoTE-Type` is the LoTE type of the attestation type and the `Requested-Service-Type` is the `Issuance` service type identifier of that list (derived from A-06, not stated by the user). Scope (D22) flagged for user confirmation in the phase report.

### A-09 · Algorithm · accepted

Plan entry: `docs/topics/trust-checks-issuance.md`
Writes: `docs/topics/trust-checks-issuance.md`
Sources: [S1 §4.2]
Uses: List of Trusted Entities Validation (A-05); Trust Anchor Validation and Sign/Seal Validation (existing, `docs/topics/trust-anchor-validation.md`, `docs/topics/attestation-signature-validation-process.md`)
Delivers: steps 3b, 7b, 11b invoke LoTE Validation by reference instead of "signature plus extra checks"; the "ETSI TS 319 102-1" sentence dropped; step 7a refers to the 24-hour or `NextUpdate` refresh rule instead of provider-chosen caching; steps 11a to 11c route a QEAA through Trust Anchor Validation (pilot LOTL and TL) and Sign/Seal Validation, keeping LoTE routes for PID, PuB-EAA and EAA only.
Answers: T2 "state the URL is published on the OJA" (user): steps 3a, 7a and 11a say that the LoTE is fetched from the fixed location that the OJA publishes for that LoTE type, with the `OJA-LoTE-Loc` values in the LoTE topic, not restated (follow-up revision; to be assigned)

### A-10 · Framing · accepted

Plan entry: `docs/topics/trust-checks-presentation.md`; `docs/topics/trust-management-process.md`
Writes: `docs/topics/trust-checks-presentation.md`, `docs/topics/trust-management-process.md`
Sources: [S1 §4.1, §4.1.2, §4.2, §4.5, §4.6.4-13, §4.6.4-14], [S2 §6.6.5, Table H.3]
Uses: LoTE Validation outputs (A-05); `StatusStartingTime` rule (A-02, `docs/topics/trusted-list-and-list-of-trusted-lists.md`)
Delivers: `TL-PRES-001`: preserve S1 `Status` and `Sub-Status` next to the S3 statuses; test focus adds critical-extension failure, status applicability and sequence rollback for the LoTE route; ETSI clause mapping row adds S1 §4.2, §4.5, §4.6.4-13/-14 as draft. PuB-EAA withdrawal in the trust-management process: `StatusStartingTime` refers to the re-issuance rule of the LoTE topic, without restating it.
Answers: none

### A-11 · Framing · accepted

Plan entry: `docs/topics/trust-anchor-certificate-profiles.md`; `docs/topics/onboarding-process.md`; `docs/topics/trust-anchor-validation.md` › Trust-Source Dispatch
Writes: `docs/topics/trust-anchor-certificate-profiles.md`, `docs/topics/onboarding-process.md`, `docs/topics/trust-anchor-validation.md`
Sources: [S1 §1, Annex C], [S2 §6.8.0]
Uses: LoTE tables (A-01, A-02); LoTE Validation (A-05)
Delivers: certificate-profiles introduction: anchor selection refers to LoTE Validation, which receives `[C, I_1, ..., I_n]`; relationship note that C is passed in `x5c` and the Trust Anchor is not (n = 0: C issued directly by the anchor). Onboarding prerequisites 2 and 4: the signing-certificate subject rule (Q7) and `application/jwt` publication, by reference to the LoTE topic. Trust-Source Dispatch names the governing source of each route (S1 draft with pilot choices for the seven LoTE types; S3 and S4 for the pilot LOTL and TL), inputs unchanged.
Answers: Follow-up A (user); Q7 (user)

### A-12 · Framing · accepted

Plan entry: `docs/sections/use-cases.md`; `docs/sections/references.md`
Writes: `docs/sections/use-cases.md`, `docs/sections/references.md`
Sources: [S1], [S2a]
Uses: LoTE Validation outputs (A-05)
Delivers: Runtime Trust Anchor Validation use case: `Status`, `Sub-Status`, status applicability and critical extensions in the checks and failure consequence; Service readiness: each published LoTE passes LoTE Validation for its type. References: ETSI TS 119 605 V0.0.3 (2026-06), draft, marked work in progress, in the ETSI group; S2a repository tag `v1.1.1` added to the S2 entry.
Answers: Q1 "agreed" (user)

### A-13 · Flow frame · accepted

Plan entry: `docs/topics/trust-checks-issuance.md` (steps 11a to 11c; found by the final check)
Writes: `docs/topics/trust-checks-issuance.md`
Sources: none
Uses: steps 11a to 11c as written by A-09 (same file)
Delivers: the sequence diagram of the issuance flow matches the text of steps 11a to 11c: the participants and labels of 11a to 11c state that the LoTE route applies to PID, PuB-EAA and EAA and that a QEAA uses the pilot LOTL and TL and Sign/Seal Validation. Only the diagram changes.
Answers: none

### A-14 · Artefact · accepted

Plan entry: `docs/topics/trusted-list-and-list-of-trusted-lists.md` › List of Trusted Entities › Service type identifiers (T4)
Writes: `docs/topics/trusted-list-and-list-of-trusted-lists.md`
Sources: [S2 §6.6.1]
Uses: the `ServiceTypeIdentifier` row of the entity-level table and the Implementation Choice block on service type identifiers (A-02, same file)
Delivers: the two `Issuance` identifiers written out literally as examples in the `ServiceTypeIdentifier` row of the ServiceInformation table (the identifier table of the topic), after the PID examples and in the same form: for the <Provider of WRPAC> list `http://uri.etsi.org/19602/SvcType/WRPAC/Issuance`, for the <Provider of WRPRC> list `http://uri.etsi.org/19602/SvcType/WRPRC/Issuance`. Defined once there, as instances of the existing pattern `http://uri.etsi.org/19602/SvcType/{Specific_attestation}/Issuance`; the pattern, the other values and the `Revocation` identifiers are not changed or restated. Detail: cite S2 with additions (values: the two URIs).
Answers: T4 "use the ETSI pattern values": WRPAC `http://uri.etsi.org/19602/SvcType/WRPAC/Issuance` and WRPRC `http://uri.etsi.org/19602/SvcType/WRPRC/Issuance` (user); tracer question on the place of the literals: "add them as examples in the `ServiceTypeIdentifier` row of the ServiceInformation table, after the PID examples, in the same form; no new table or heading; the Implementation Choice block is unchanged. The user's 'identifier table' is that row, the only place of the topic that gives literal identifiers" (planner, from the plan and the T4 answer)

### A-15 · Algorithm · accepted

Plan entry: `docs/topics/trust-anchor-validation.md` › List of Trusted Entities Validation › Advisory note (D25)
Writes: `docs/topics/trust-anchor-validation.md`
Sources: none
Uses: the `Requested-LoTE-Type` input and the D20 algorithm, step (a) LoTE selection (A-05, same file)
Delivers: in step (a) of the trust-anchor validation algorithm (selection of the LoTE), a non-normative advisory note: a verifier MAY use the `qcStatements` extension of the Sign/Seal Certificate `C` to determine which LoTE to fetch. It is an advisory and not a mapping: this specification defines no mapping from `qcStatements` to a LoTE type and requires none. The sentence of the `Requested-LoTE-Type` input ("this specification defines no mapping from that extension to a type") stays, in agreement with the note; the note is not normative, uses no SHALL or SHOULD, and does not restate the algorithm. No other change.
Answers: T5 "we can write an advisory, that the verifier can rely on the qcStatements element of the sign/seal certificate to fetch the correct LoTE" (user); D25: an advisory with MAY, no mapping required (user, restated by the coordinator)

### A-16 · Algorithm · accepted

Superseded in part by D27 (D24): the Inputs change (Trust Anchor an output) holds; the step 5 text is replaced by the X.509 run; to be assigned after gate 1.

Plan entry: `docs/topics/authorization-process.md` (Inputs; WRPRC validation step 5, D24)
Writes: `docs/topics/authorization-process.md`
Sources: [S1 §4.2, §4.5]
Uses: LoTE Validation and its `Trust-Anchor` output (A-05, `docs/topics/trust-anchor-validation.md`); WRPRC validation step 4 (A-07, same file)
Delivers: (1) Inputs: the Trust Anchor is removed from the list that names the Provider of WRPRC LoTE, the Trust Anchor and the certificate-status information; it is an output of LoTE Validation, not an input; the Provider of WRPRC LoTE identification, the certificate-status information and the validation time stay. (2) WRPRC validation step 5 drops the chain-to-anchor validation (certificate signatures and validity periods up to the anchor) and keeps the checks LoTE Validation does not perform: Attestation Provider relationships, applicable constraints, certificate policies and revocation status according to the referenced X.509 process. It says that the validation of the signing-certificate path to the selected Trust Anchor is the result of step 4 (LoTE Validation, step 8) and is not repeated; no restatement of the algorithm. Step 4, Registrar verification and the rest unchanged.
Answers: T1 "narrow them" (user); D24 text of step 5: "**Certificate path checks:** the validation of the signing-certificate path to the selected <Trust Anchor> is the result of step 4 (List of Trusted Entities Validation, step 8) and is not repeated here; verify, on that path, the <Attestation Provider> relationships, the applicable constraints, the certificate policies and the revocation status according to the referenced X.509 process." (planner, from the plan); the referenced X.509 process also runs policy and revocation processing, so these checks may repeat part of step 8; kept as the user asked (planner flag)

### A-17 · Algorithm · accepted

Superseded by D27 (D24): step 3 gets the X.509 run again for the LoTE route; to be assigned after gate 1.

Plan entry: `docs/topics/attestation-signature-validation-process.md` (step 3, D24)
Writes: `docs/topics/attestation-signature-validation-process.md`
Sources: [S1 §4.2]
Uses: LoTE Validation and its `Trust-Anchor` output (A-05); step 2 of this file (A-08, same file)
Delivers: step 3 narrowed: it keeps signature validation of the attestation and the failure rule ("Failure of signature validation, applicable path validation or trust-source validation SHALL result in validation failure") and drops the chain-to-anchor validation for the LoTE route. New sentence: for a PID, WIA, EAA or PuB-EAA, the validation of the Sign/Seal Certificate chain against the Trust Anchor is the result of LoTE Validation (step 8), obtained in step 2, and is not repeated here; a failed result is a validation failure. The QEAA direct service-identity matching, the QEAA path validation and the sentence "An attestation-supplied certificate alone SHALL NOT establish trust" stay. Step 2 and the rest unchanged.
Answers: T1 "narrow them" (user); D24 (planner, from the plan): the QEAA route stays unchanged (D4), so path validation through X.509 Certificate Chain Validation stays for it

### A-18 · Algorithm · accepted

Plan entry: `docs/topics/trust-checks-issuance.md` (steps 3a, 7a, 11a, T2)
Writes: `docs/topics/trust-checks-issuance.md`
Sources: none
Uses: `OJA-LoTE-Loc` values and the Official Journal of APTITUDE publication (A-01, `docs/topics/trusted-list-and-list-of-trusted-lists.md`; A-05, `docs/topics/trust-anchor-validation.md`); steps 3a, 7a and 11a as written by A-09 (same file)
Delivers: steps 3a, 7a and 11a (for a PID, PuB-EAA or EAA; not for a QEAA) say that the LoTE is fetched from the fixed location that the OJA publishes for that LoTE type, in place of "from a publicly-known URL" (steps 3a and 7a carry that phrase; 11a does not and receives the statement). The text refers to the List of Trusted Entities topic for the locations (`OJA-LoTE-Loc`) and does not restate any value. Step 7a keeps its caching sentence. Sequence diagram labels, if they state the source of the fetch, follow the text. No other change.
Answers: T2 "state the URL is published on the OJA" (user); sentence from the plan: "The <LoTE> is fetched from the fixed location that the <OJA> publishes for that LoTE type (`OJA-LoTE-Loc`; values in the [List of Trusted Entities](...) topic)." (planner, from the plan)

### A-19 · Framing · accepted

Plan entry: `docs/sections/use-cases.md` (duplicate bullet, T3)
Writes: `docs/sections/use-cases.md`
Sources: none
Uses: the bullet "Verify that each published LoTE passes LoTE Validation for its type" (A-12, same file)
Delivers: the bullet "Verify that each published LoTE has a valid signature, conforms to its format, and contains the required infrastructure Trust Anchors" is removed from the LoTE Publication Service Readiness actions; the bullet "Verify that each published LoTE passes LoTE Validation for its type" is kept unchanged. Nothing else changes.
Answers: T3 "remove one" (user); the removed bullet ("contains the required infrastructure Trust Anchors") is acceptable to lose; keep the kept bullet (user)

### A-20 · Algorithm · accepted

Superseded by D27 (D26, T7): step 5 is the X.509 run, not a cross-reference; to be assigned after gate 1.

Plan entry: `docs/topics/authorization-process.md` (WRPRC validation step 5, T7, D26)
Writes: `docs/topics/authorization-process.md`
Sources: none
Uses: List of Trusted Entities Validation (A-05, `docs/topics/trust-anchor-validation.md`), whose step 8 validates the chain to the selected Trust Anchor; WRPRC validation step 4 (A-07, same file) and step 7 (WRPRC status validation, same file)
Delivers: WRPRC validation step 5 reduced to one cross-reference sentence: the validation of the signing-certificate path to the selected Trust Anchor is the result of step 4 (List of Trusted Entities Validation, step 8, cited by link) and is not repeated here, and the status of the WRPRC is checked in step 7. It lists no check of its own: no Attestation Provider relationship, applicable constraints, certificate policies or revocation status, and does not restate the X.509 process. The step heading is changed to fit (no longer "Certificate path checks"). No new check, no renumbering; steps 1 to 4 and 6 to 8, the intro paragraph and the rest of the file unchanged.
Answers: T7 "narrow down and avoid repetition, cite the trust-anchor validation process if needed as a reference" (user); T7 follow-up on tracer block (the WRPRC profile `registration-certificate.md` defines no Attestation Provider relationship check, and its only status requirement is validated in full by step 7): "Cross-reference only. Keep step 5 as one sentence: the path to the Trust Anchor is the result of step 4 (LoTE Validation step 8) and is not repeated; WRPRC status is checked in step 7. No new checks and no renumbering." (user); D26 (planner)

### A-21 · Algorithm · accepted

Superseded by D27 (D26, T7): step 3 runs the X.509 process for the LoTE route; to be assigned after gate 1.

Plan entry: `docs/topics/attestation-signature-validation-process.md` (step 3, T7, D26)
Writes: `docs/topics/attestation-signature-validation-process.md`
Sources: none
Uses: LoTE Validation and its `Trust-Anchor` output (A-05); step 2 of this file (A-08, same file), which already passes the chain to LoTE Validation, states that it validates the certificate path with the Trust Anchor, and fails on `PROCESS_FAILED`
Delivers: step 3 narrowed again: the sentence added by A-17 for the PID, WIA, EAA and PuB-EAA route ("the validation of the Sign/Seal Certificate chain against the Trust Anchor is the result of List of Trusted Entities Validation (step 8), obtained in step 2, and is not repeated here; a failed result is a validation failure") is removed, because step 2 already states it. Step 3 keeps the QEAA path validation through X.509 Certificate Chain Validation, the QEAA direct service-identity matching, the sentence "An attestation-supplied certificate alone SHALL NOT establish trust" and the failure rule. Step 3 must still read correctly for a reader who takes the LoTE route (it may name that route's path validation as covered by step 2 only if it adds no repetition). Step 2 and the rest unchanged.
Answers: T7 "narrow down and avoid repetition, cite the trust-anchor validation process if needed as a reference" (user); D26 (planner, from T7)

### A-22 · Algorithm · accepted

Correction of A-05 (and of the A-15 and A-11 text in the same file only where it relies on step 8). Starts from commit 6e57453 as carried by HEAD; the tracer reads the current text and does not restore earlier text.

Plan entry: `docs/topics/trust-anchor-validation.md` › List of Trusted Entities Validation (Inputs, Outputs, Process steps, sequence diagram, flowchart, Remarks); Revision 5 corrections, "LoTE Validation"
Writes: `docs/topics/trust-anchor-validation.md`
Sources: [S1 §4.1.2, §4.2, §4.5]
Uses: nothing new; the constraint tables (A-04), the D20 steps (a) to (e) in steps 6 and 7 (A-05), and the advisory note (A-15) stay as written. The X.509 Certificate Chain Validation (`docs/topics/x509-certificate-validation.md`) is not used by this process any more and is not cited as a step.
Delivers:

- Remove step 8 ("Validate the certificate path"). Steps 9 to 12 become 8 to 11. Every step reference follows: the persisted-state step ("after steps 1 to 11 have all succeeded" becomes "after steps 1 to 10 have all succeeded"); the Remark that names "steps 9 and 11" and "steps 6 to 8" becomes "steps 8 and 10" and "steps 6 and 7"; the sequence diagram line "Validate certificate path to the selected Trust Anchor" is removed; the flowchart node "6 to 8. Entity and service identified, Trust Anchor selected and path valid?" becomes "6 and 7. Entity and service identified and Trust Anchor selected?" and the later nodes are renumbered (SdiMatching 8, status 9, critical extensions 10, persistence 11). Steps (a) to (e) of D20 and the n = 0 rule stay in steps 6 and 7.
- Outputs: `Trust-Anchor` (the selected `A_i`, step 7) is the only output of the selection; no chain is output and no other output is added. `Authenticated-LoTE`, `Current-LoTE-Certs-Set` and `Current-LoTE-Loc` stay as written. The reference in the `Trust-Anchor` entry points to step 7 and, for the result, to the persist step by its new number if it names one.
- Step 6, first bullet: "If the chain cannot be parsed or is empty, the sub-status is `NO_MATCHING_TE_SERVICE`." (replaces `CERT_CHAIN_NOT_VALID_AT_DATE_TIME`).
- `Sub-Status` output: remove `CERT_CHAIN_NOT_VALID_AT_DATE_TIME` from the list; add no sub-status; no `CERT_CHAIN` name remains anywhere in the file.
- Input `Date-Time`: it is no longer described as the `current_time` of a certificate path validation; it serves the freshness checks and, when `StatusStartingTimePresent` is `TRUE`, the status applicability check. The rest of the sentence (supply condition and clause reference) is kept.
- Remarks: a remark stating that `PROCESS_PASSED` means that the LoTE is valid and the Trust Anchor is selected; it does not mean that the certificate path is valid; the calling process runs the [X.509 Certificate Chain Validation](../sections/trust-evaluation-process.md#x509-certificate-chain-validation) with the returned Trust Anchor. The remark links to the X.509 process and does not restate any path rule. The existing Remark that says the result "establishes that `Trust-Anchor` is taken from the service that applies at the validation time, of the entity identified by `C`" stays. The link target is checked: use the anchor that resolves (`#x509-certificate-chain-validation` in `docs/topics/trust-evaluation.md` or `#certificate-path-validation` in `docs/topics/x509-certificate-validation.md`), and the same form as the other callers of the file.
- After the edit, a grep of the file for `step 8`, `steps 9`, `steps 6 to 8`, `path valid`, `Validate certificate path`, `CERT_CHAIN` and `current_time` returns no stale reference. The input `Date-Time` does not mention `current_time`.
- Nothing else changes: Trust-Source Dispatch, the QEAA text, the constraint tables, JSON LoTE Signature Verification, steps 1 to 7 other than the step 6 bullet, and the advisory note stay as in HEAD.
Answers: D27, D28, T8 (user: "remove the step \"8. Validate the certificate path\" ... from LoTE Validation. Recall it in authorization, authentication or any other process that requires it instead."); O1 (user): the sub-status of an empty or unparseable chain is `NO_MATCHING_TE_SERVICE`, no new sub-status; O3 (user): LoTE Validation outputs only `Trust-Anchor`, no `Matched-Chain`.

### A-23 · Algorithm · accepted

Correction of A-06. Starts from the HEAD text of the file.

Plan entry: `docs/topics/authentication-process.md`; Revision 5 corrections, "Authentication"
Writes: `docs/topics/authentication-process.md`
Sources: none
Uses: List of Trusted Entities Validation and its `Trust-Anchor` output (A-22, `docs/topics/trust-anchor-validation.md`); X.509 Certificate Chain Validation (`docs/topics/x509-certificate-validation.md`)
Delivers:

- Step 1 title becomes "Select the <artifacts:Trust Anchor|Trust Anchor>". It keeps the pass-through of the WRPAC `x5c` chain `[C, I_1, ..., I_n]`, the `Requested-LoTE-Type`, the `Issuance` service type identifier as `Requested-Service-Type` and the runtime validation time to the List of Trusted Entities Validation, the statement that the process does not select the entry or the Trust Anchor itself, the failure rule ("If its `Status` is `PROCESS_FAILED`, the Authentication outcome is `NON_AUTHENTICATED`") and the `Trust-Anchor` output. It no longer says that the process "validates the certificate path with it" and no longer says "does not validate the certificate path a second time".
- A new step 2: "**Validate the certificate path.** Run the [X.509 Certificate Chain Validation](link) with the path `I_n, ..., I_1, C` of the WRPAC chain (for n = 0, the path is `C`), the <artifacts:Trust Anchor|Trust Anchor> from step 1 as `trust_anchor` and the runtime validation time as `current_time`. If the path is `INVALID`, the Authentication outcome is `NON_AUTHENTICATED`." It is one step for the Remote, Proximity (`x5chain`) and Issuance flows. The path rules are not restated. The former step 2 ("Verify the signature") becomes step 3 and the flow-specific list of chain carriers stays unchanged under it; the sentence in the former step 1 "carried by the flow (see step 2)" is updated to the new number.
- The Input list item "the X.509 certificate path terminating in the WRPAC end-entity certificate" and the paragraph on accepting only Trust Anchors from the validated LoTE stay. Nothing else changes.
- The link target of the X.509 process is the form that resolves in the repository, as used in the file for the other process links; the tracer checks it.
Answers: D27, D28, T9 O2 (user): an `INVALID` X.509 path fails the calling process; `NON_AUTHENTICATED` for authentication; the X.509 topic defines no sub-status of its own and no `CERT_CHAIN` name is used. D22: the chain is the input passed in.

### A-24 · Algorithm · accepted

Correction of A-07, A-16 and A-20 (one file). Starts from the HEAD text of the file. The Inputs change of A-16 (1) holds and stays.

Plan entry: `docs/topics/authorization-process.md` (WRPRC Validation steps 4 and 5; Optional Register Validation step 4); Revision 5 corrections, "Authorization"
Writes: `docs/topics/authorization-process.md`
Sources: none
Uses: List of Trusted Entities Validation and its `Trust-Anchor` output (A-22); X.509 Certificate Chain Validation (`docs/topics/x509-certificate-validation.md`)
Delivers:

- WRPRC validation step 4: keeps the pass-through and the `Trust-Anchor` output, the failure on `PROCESS_FAILED` and the sentence that a certificate supplied only by the candidate WRPRC SHALL NOT be accepted as the Trust Anchor. It states no path validation (the current text of step 4 already has none; check and keep).
- WRPRC validation step 5, heading "Signing-certificate path": "Run the [X.509 Certificate Chain Validation](link) with the path `I_n, ..., I_1, C` of the signing-certificate chain used in step 4 (for n = 0, the path is `C`), the <artifacts:Trust Anchor|Trust Anchor> returned by step 4 as `trust_anchor` and the runtime validation time as `current_time`. If the path is `INVALID`, this step fails." It replaces the cross-reference sentence of A-20, which names "step 8" of LoTE Validation and says that the status is checked in step 7; no such wording remains in step 5. Step 7 (status), the other steps and the numbering stay unchanged.
- Optional Register Validation step 4: drops "validates the certificate path" from the description of the process; after the LoTE Validation result and before the Registrar signature validation with `C`, adds the same run of the X.509 Certificate Chain Validation with the path `I_n, ..., I_1, C` of the Registrar chain, the returned Trust Anchor as `trust_anchor` and the runtime validation time as `current_time`; an `INVALID` path fails the step. "Validate the Registrar signature with `C`" and the profile-defined temporal and status information stay. The ordering text stays a single step (no renumbering).
- The file is read for any other sentence that says LoTE Validation validates the path or cites its "step 8" (for example in the paragraph before the WRPRC checks and the Inputs table) and that sentence is brought into line in the same words; no other change.
- The intro line before step 1 of WRPRC validation already links the X.509 process; the new text links it again only in steps 5 and in Register step 4 and does not restate its rules. The link form is the one that resolves in the repository, the same as the existing link of the file.
Answers: D27, D28, T9 O2 (user): an `INVALID` path is a failed step for authorization; no sub-status is added. T7 follow-up (user) is superseded for the path wording; "no renumbering" holds.

### A-25 · Algorithm · accepted

Correction of A-08, A-17 and A-21 (one file). Starts from the HEAD text of the file.

Plan entry: `docs/topics/attestation-signature-validation-process.md` (Base Signature Validation steps 2 and 3); Revision 5 corrections, "Attestation Sign/Seal Validation"
Writes: `docs/topics/attestation-signature-validation-process.md`
Sources: none
Uses: List of Trusted Entities Validation and its `Trust-Anchor` output (A-22); X.509 Certificate Chain Validation (`docs/topics/x509-certificate-validation.md`); QEAA TL route, unchanged (D4)
Delivers:

- Step 2: keeps the chain pass-through, the `Requested-LoTE-Type`, the `Issuance` `Requested-Service-Type`, `Date-Time`, the failure rule ("If its `Status` is `PROCESS_FAILED`, the validation fails") and the `Trust-Anchor` output for PID, WIA, EAA and PuB-EAA; the words "and validates the certificate path with it" are dropped. The QEAA route stays as written.
- Step 3: covers both routes. It validates the Sign/Seal Certificate chain `C, I_1, ..., I_n` against the Trust Anchor obtained in step 2 (for PID, WIA, EAA and PuB-EAA, the `Trust-Anchor` output of LoTE Validation; for QEAA, the CA Trust Anchor of the TL route), where path-based validation applies, using the [X.509 Certificate Chain Validation](link) with the path ordered from the certificate issued by the Trust Anchor to `C`, the Trust Anchor as `trust_anchor` and the runtime validation time as `current_time`. The QEAA direct service-identity matching, the sentence "An attestation-supplied certificate alone SHALL NOT establish trust" and the failure rule stay; an `INVALID` path is a validation failure. The path rules are not restated and nothing of the LoTE route that step 2 already states is repeated.
- The link keeps the form the file already uses for the X.509 process (`#certificate-path-validation` in the opening paragraph and in step 3); the tracer checks that it resolves. Nothing else changes (Input, Outcome, QEAA Service Qualification, note).
Answers: D27, D28, T9 O2 (user): an `INVALID` path is a validation failure for sign/seal validation; no sub-status is added.
