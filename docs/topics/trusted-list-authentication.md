This process authenticates the pilot <artifacts:Trusted List (TL)|Trusted List> for a Wallet Unit, WRP or their trust-validation component. The complete procedure in [ETSI TS 119 615 V1.4.1 (2026-05), Clauses 4.2.1–4.2.4] SHALL govern, subject to the pilot bindings below. The pilot artefact is defined in [Trusted List](../sections/trust-artifacts.md#trusted-list); its pointer, signature and XML representation follow [ETSI TS 119 612 V2.4.1 (2025-08), Clauses 5.3.13 and 5.7, Annex B].

**Input**

The validator SHALL use the input contract of Clause 4.2.2: `CC` is the uppercase ISO 3166-1 Alpha-2 country code of the emulated Member State whose TL is requested.

**Pilot Bindings**

The LOTL-authentication call in Clause 4.2.4 SHALL invoke [LOTL Authentication](../sections/trust-evaluation-process.md#lotl-authentication), using its pilot OJA bootstrap mapping. From the resulting `Authenticated-LOTL`, the validator SHALL select the `PointersToOtherTSL` tuple whose scheme-territory qualifier equals `CC` and whose MIME-type qualifier identifies XML (`application/vnd.etsi.tsl+xml`), as defined in the [LOTL profile](../sections/trust-artifacts.md#list-of-trusted-lists). That tuple supplies both `EUTL-Loc`, the XML TL retrieval location, and `EUTL-Certs-Set`, the authorized TL-signing certificate set.

The validator SHALL authenticate the TL signature using `EUTL-Signer-Cert` as a directly trusted certificate authorized by that tuple, as specified in Clause 4.2.4. These list-signing certificates are distinct from TL service digital identities and CA Trust Anchor Certificates. The CA Trust Anchor Certificate profile and entity Sign/Seal certificate-chain rules SHALL NOT be applied to the directly trusted TL-signing certificate; see [Trust Anchor Certificate Profiles](../sections/trust-artifacts.md#trust-anchor-certificate).

**Outputs and Runtime Handoff**

The validator SHALL preserve `Authenticated-EUTL`, `EUTL-Status` and `EUTL-Sub-Status` under Clauses 4.2.3–4.2.4, including initialization to void, all failure and supplementary indications, and the `EUTL_VERIFICATION_PASSED` success result. `Authenticated-EUTL` is the authenticated XML TL on success and remains void on authentication failure under that procedure. If the TL's `NextUpdate` has passed, the procedure adds `WARNING_EUTL_NEXTUPDATE_PASSED` while retaining its source-defined authentication result.

Before using the authenticated TL at runtime, the validator SHALL invoke the common runtime-acceptance checks in [Trust Anchor Validation](../sections/trust-evaluation-process.md#trust-anchor-validation-process), which require rejection of an overdue TL. Runtime acceptance is a separate result and SHALL NOT overwrite or relabel the ETSI authentication outputs.
