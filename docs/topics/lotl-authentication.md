This process authenticates the current pilot <artifacts:List Of Trusted Lists (LOTL)|LOTL> for a Wallet Unit, WRP or their trust-validation component. The complete procedure in [ETSI TS 119 615 V1.4.1 (2026-05), Clauses 4.0 and 4.1.1–4.1.4] SHALL govern, subject to the pilot bootstrap mapping below. [ETSI TS 119 612 V2.4.1 (2025-08), Annex A] provides informative background on list authentication and continuity. The pilot artefact and OJA publication are defined in [List Of Trusted Lists](../sections/trust-artifacts.md#list-of-trusted-lists).

**Inputs and State**

The validator SHALL use the input and state contract of Clause 4.1.2, with the following substitutions for the preconfigured parameters of Clause 4.0:

| Pilot parameter | Source parameter | Pilot binding |
| --- | --- | --- |
| `OJA-Loc` | `OJEU-Loc` | Initially, the fixed locally configured URI of the pilot OJA publication. |
| `OJA-LOTL-Loc` | `OJEU-LOTL-Loc` | Current LOTL XML location supplied by that publication. |
| `OJA-LOTL-Certs-Set` | `OJEU-LOTL-Certs-Set` | Full set of LOTL-signing certificates supplied by that publication. |

The OJA publication is unsigned and is not independently authenticated. The validator SHALL accept its initial bootstrap data under the explicit APTITUDE discovery assumption at the fixed configured pilot OJA URI. This assumption establishes no institutional OJEU trust. The fixed initial URI SHALL NOT prevent the authenticated parameter updates specified in Clause 4.1.4: the mapped parameters SHALL retain those update semantics and pivot continuity.

**Authentication**

The validator SHALL execute the complete referenced procedure, including its archived-pivot processing and authenticated parameter updates, using the mapped pilot parameters. Source-defined status and sub-status identifiers SHALL retain their original names, including identifiers containing `OJEU`.

For LOTL and pivot signature authentication, the validator SHALL directly trust the list-signing certificate as specified in Clause 4.1.4, with authorization established by that procedure. The CA Trust Anchor Certificate profile and entity Sign/Seal certificate-chain rules SHALL NOT be applied to these directly trusted list-signing certificates; see [Trust Anchor Certificate Profiles](../sections/trust-artifacts.md#trust-anchor-certificate).

**Outputs and Runtime Handoff**

The validator SHALL preserve `Authenticated-LOTL`, `LOTL-Status` and `LOTL-Sub-Status` as specified in Clauses 4.1.3–4.1.4, including initialization to void, all failure indications and supplementary indications, and the `LOTL_VERIFICATION_PASSED` success result. `Authenticated-LOTL` is the authenticated current XML LOTL on success and is void on authentication failure as specified by the source procedure.

Following successful authentication, the validator SHALL invoke the common current-list runtime-acceptance checks in [Trust Anchor Validation](../sections/trust-evaluation-process.md#trust-anchor-validation-process) before using the LOTL at runtime. Runtime usability is a separate result and SHALL NOT overwrite the ETSI authentication outputs. Current-list cache and rollback rules SHALL NOT be applied to archived pivots processed for authentication continuity; their processing remains governed by Clause 4.1.4.
