# Authorization Process

This topic defines the common authorization process for issuance and presentation. It is applied after authentication and before an issuance or presentation operation is authorized. The trust-check topics define how the inputs are obtained for each operation; this topic defines how those inputs are evaluated and how the final decision is made.

The certificate, Register, and policy data models remain defined in the [WRPRC profile](registration-certificate.md), [Register profile](registry.md), and [EDP profile](embedded-disclosure-policy.md). Transport and artifact placement remain defined in the applicable issuance and presentation trust checks.

## Scope and Preconditions

Authorization SHALL be evaluated only after the applicable [Authentication Process](authentication-process.md) has completed successfully (`AUTHZ-GEN-01`). The Wallet SHALL use the same authorization process for issuance and presentation, while applying the operation-specific inputs and checks defined below (`AUTHZ-GEN-02`). A failed authentication or an unavailable authorization input SHALL prevent the operation from being authorized (`AUTHZ-GEN-03`).

The Authorization Subject is the organization that requests the issuance or presentation operation. For a direct interaction it is the authenticated final Relying Party. For an intermediated interaction it is the final Relying Party identified by the request, not the intermediary (`AUTHZ-GEN-04`).

## Inputs

The Authorization Context is the operation-specific data inferred by the Wallet from the authenticated flow inputs. For the presentation flow, it includes request-derived information such as the claimed final Relying Party, intended use, and requested credentials or claims; it is not, by itself, proof of registration.

An Authorization Artifact is the authoritative transport of entity-specific authorization data. A validated WRPRC is an Authorization Artifact, and a validated Register response MAY serve as an Authorization Artifact when the WRPRC is absent or invalid. Authorization data carried by an Authorization Artifact includes the registered subject, intended use, entitlements, scope, and intermediary relationship. The Wallet combines that authoritative authorization data with the Authorization Context for the subsequent checks.

The applicable trust-check process SHALL produce a normalized authorization input set. The input set SHALL contain the following where applicable:

| Input | Source and use |
| --- | --- |
| Presentation request | The request supplies the requested credentials, claims, intended use, and the final Relying Party identity for presentation (`AUTHZ-IN-01`). |
| Credential Issuer Metadata | Issuance obtains the issuer identity, supported credential types, and issuer authorization data from validated metadata (`AUTHZ-IN-02`). |
| WRPAC and its trust path | The Wallet Relying Party Authentication Certificate and its validated chain identify and authenticate the relying party (`AUTHZ-IN-03`, `AUTHZ-IN-04`). |
| WRPRC | The Wallet Relying Party Registration Certificate is an Authorization Artifact carrying authoritative registered relying-party data and intended-use information (`AUTHZ-IN-05`). |
| Register response | A validated response from the Register can serve as an Authorization Artifact when the WRPRC is absent or invalid (`AUTHZ-IN-06`). |
| Intended use | The operation's intended use in the Authorization Context is compared with the intended use carried by the Authorization Artifact (`AUTHZ-IN-07`). |
| Attestation type | Issuance identifies the requested or supported attestation type from the issuer and relying-party authorization data (`AUTHZ-IN-08`). |
| EDP | For presentation, an applicable Embedded Disclosure Policy is evaluated against the operation and the final Relying Party (`AUTHZ-IN-09`). |
| User setting | For presentation, the Wallet MAY disable the optional requested-scope comparison; the setting is enabled by default (`AUTHZ-IN-10`). |

The primary Authorization Artifact is the validated WRPRC (`AUTHZ-GEN-05`). A Register lookup is optional and is not a prerequisite for authorization (`AUTHZ-GEN-06`). When both a WRPRC and a Register response are available, the Wallet SHALL normalize the authorization data carried by those artifacts and use one consistent Authorization Context for all subsequent checks (`AUTHZ-GEN-07`).

The authenticated WRPAC-derived identity is authoritative for the authenticated identity. A successfully validated Authorization Artifact is authoritative for the registered authorization data it carries, and a validated EDP is authoritative for its applicable disclosure constraints. Self-declared request data and a request-carried Registrar URL are discovery inputs only; neither is proof of registration. An authoritative value SHALL take precedence over a non-authoritative conflict. A conflict between authoritative identity or binding sources SHALL fail authorization non-overridably. If both WRPRC and Register Authorization Artifacts are used, content validation SHALL use the Register-derived authorization data only when its identity and intermediary-binding data remain consistent with the WRPRC.

## Authorization Artifact Validation

This process validates the Authorization Artifact and establishes the authoritative authorization data used to complete the Authorization Context. It is the first stage of the common pipeline and MUST complete before Authorization Content Validation starts.

**Input**

- A WRPRC obtained from the applicable authenticated issuance or presentation flow, when one is available.
- The applicable Provider of WRPRC LoTE, Trust Anchor, certificate-status information, and current validation time.
- For the optional Register procedure, a discovered Register endpoint, the Authorization Subject identifier, and the applicable intended-use identifier.

**Outcome**

- A successfully validated WRPRC or Register response establishes the authoritative authorization data without introducing a new positive result code.
- A missing or invalid WRPRC produces `CERTIFICATE_INVALID` and permits the optional Register procedure.
- If no valid Authorization Artifact is obtained, the stage produces `FAILED` and the final result is `NOT_AUTHORIZED`.

### WRPRC Validation

The Wallet SHALL validate a supplied WRPRC before using it as an Authorization Artifact (`AUTHZ-GEN-08`). The Wallet SHALL perform the following checks in order, following the WRPRC profile and the applicable [Trust Anchor Validation Process](trust-evaluation.md#trust-anchor-validation-process), [X.509 Certificate Chain Validation](trust-evaluation.md#x509-certificate-chain-validation), and [status mechanism](status-list-token.md) (`AUTHZ-GEN-09`):

1. **Format verification:** verify the WRPRC encoding and profile syntax, including `typ = rc-wrp+jwt` for a JWT or `typ = rc-wrp+cwt` for a CWT in the applicable flow, and verify all required profile fields are present and well formed.
2. **Algorithm verification:** verify that the declared signature algorithm is permitted by the WRPRC profile and that the object is not unsigned.
3. **Signature validation:** verify the WRPRC signature using the signing certificate carried in the profile-defined certificate-chain member.
4. **Trust Anchor validation:** validate the applicable Provider of WRPRC LoTE and obtain the Trust Anchor from that validated LoTE; a certificate supplied only by the candidate WRPRC SHALL NOT be accepted as the Trust Anchor.
5. **Certificate path validation:** validate the complete signing-certificate path against the obtained Trust Anchor, including certificate signatures, issuer relationships, validity periods, applicable constraints, certificate policies, and revocation status according to the referenced X.509 process.
6. **WRPRC temporal validation:** verify the required `iat` value and, when present, the `exp` value against the current validation time.
7. **WRPRC status validation:** retrieve the Status List Token from `status.status_list.uri`, validate its protected format, signature, signing-certificate path, Trust Anchor, freshness, and data model, and inspect the bit at `status.status_list.idx`; `0x00` represents a valid WRPRC and `0x01` represents an invalid WRPRC.
8. **Profile and interaction consistency:** verify that the WRPRC subject, intended use, entitlements, registered scope, attestation-provider data, and intermediary data are semantically valid and consistent with the authenticated operation and the applicable request or issuance context.

If the WRPRC is absent or any mandatory validation check fails, the WRPRC Authorization Artifact outcome is `CERTIFICATE_INVALID`. The Wallet SHALL then either use the optional Register procedure below or terminate Authorization Artifact Validation without a valid Authorization Artifact.

### Optional Register Validation

The Register procedure is a permitted fallback after a missing or invalid WRPRC, and it is also the only Register operation currently defined by this process (`AUTHZ-GEN-10`). The Wallet SHALL:

1. **Discover the endpoint:** obtain the Register endpoint from the applicable request or metadata input; a request-carried URL is a discovery hint and is not proof of registration (`AUTHZ-REG-01`).
2. **Retrieve the record:** use HTTPS and the Register profile's `GET /wrp` operation with the Authorization Subject identifier and intended-use identifier where applicable, requesting the complete registered record rather than a Boolean intended-use result (`AUTHZ-REG-02`, `AUTHZ-ISS-08`, `AUTHZ-PRES-06`).
3. **Verify the response format:** require the successful response and media type defined by the Register profile and parse the signed registration statement as the profile-defined JWS representation.
4. **Verify authenticity and trust:** validate the Registrar signature, the Registrar Sign/Seal Certificate, its certificate path, the applicable Registrar LoTE and Trust Anchor, and any profile-defined temporal or status information (`AUTHZ-REG-03`, `AUTHZ-ISS-09`).
5. **Verify pertinence and completeness:** verify that the response contains the Authorization Subject, intended use, and all authorization data required by the operation, and that those values match the authenticated interaction and query.
6. **Normalize the result:** normalize the validated record into the same authorization-context model used for a WRPRC (`AUTHZ-REG-04`).

A successfully validated Register response is an Authorization Artifact and is authoritative for the authorization data it carries. If the Wallet invokes the Register and retrieval or validation fails, the Authorization Artifact outcome SHALL be `FAILED` and Authorization Artifact validation SHALL fail. If the Wallet does not invoke the optional procedure, or no valid response is obtained, there is no valid Authorization Artifact; the Authorization Artifact validation stage SHALL terminate with the existing validation outcome `FAILED` and the final result SHALL be `NOT_AUTHORIZED`. The earlier WRPRC Authorization Artifact outcome remains `CERTIFICATE_INVALID`. The Wallet SHOULD notify the User when Register data are used, as specified by `RPRC_21`.

The Register MAY support a future service-binding lookup, but the current profile does not define the service-binding fields or comparison rules. A lookup MAY be performed only after an applicable profile defines its inputs and comparison procedure. An implementation SHALL NOT claim that capability until then; the open service-binding question remains tracked as issue `#114`.

### Authorization Artifact Validation Outcome

This validation stage succeeds only when a WRPRC or an authoritative Register response has been fully validated. A validation failure is non-overridable and uses the existing validation outcome `FAILED` when no valid Authorization Artifact is obtained. The Wallet SHALL NOT continue with binding, entitlement, scope, attestation-type, or EDP checks after an Authorization Artifact validation failure.

## Authorization Content Validation

The Wallet SHALL perform content validation only after a valid Authorization Artifact has been established. The Wallet SHALL use only the authenticated identity and interaction context, the validated Authorization Artifact, the normalized operation inputs, and a validated applicable EDP. A failure in any non-overridable content check terminates the pipeline and prevents later checks.

**Input**

- The authoritative Authorization Context established by the preceding validation stage.
- The authenticated WRPAC identity and the normalized issuance or presentation inputs.
- For presentation, the normalized final Relying Party, intended use, requested credentials, and requested claims.
- For issuance, the requested credential or attestation type and validated Credential Issuer Metadata.
- For presentation, each locally stored EDP associated with a matching Attestation, when one exists.

**Process**

The following checks SHALL be performed in order. After a binding, intermediary-association, entitlement, or issuance attestation-type failure, the Wallet SHALL stop this process and SHALL NOT perform later checks.

### Binding and Intermediary Association

The Wallet SHALL ensure that the authenticated entity is the same entity described by the applicable authorization data (`AUTHZ-GEN-11`). The authenticated WRP identity SHALL be the `organizationIdentifier` attribute in the subject Distinguished Name of the WRPAC, as defined by [ETSI EN 319 412-1, Clause 5.1.4] and the WRPAC profile in [ETSI TS 119 411-8].

The Wallet SHALL perform the following binding comparisons using the applicable identifier comparison rules:

1. **Credential Issuance:** match the Credential Issuer identifier with the `sub` value of the WRPRC or, when no WRPRC is available, with the identifier used in the successful Register query, and with `issuer_info.data.identifier` in the validated Credential Issuer Metadata. A mismatch produces `BINDING_FAILED`.
2. **Credential Presentation, direct scenario:** first assume the direct scenario and compare the authenticated WRPAC `organizationIdentifier` with the final Relying Party identifier. The final Relying Party identifier SHALL also match the WRPRC `sub` value or, when no WRPRC is available, the identifier used in the successful Register query, and the request identifier: `verifier_info.data.identifier` in the Remote Flow Request Object or `docRequest.itemsRequest[].requestInfo.EUWrpRegistrarInfo.identifier` in the Proximity Flow. If all identifiers match, direct binding succeeds.
3. **Credential Presentation, intermediated scenario:** if the direct comparison fails, the Wallet SHALL attempt the intermediated scenario and compare the authenticated WRPAC `organizationIdentifier` with the `intermediary.sub` value carried by the WRPRC or validated Register response. If the intermediary relationship is absent or invalid, the Wallet SHALL produce `INTERMEDIARY_NOT_AUTHORIZED` (`AUTHZ-INT-03`). If the relationship is valid, the Wallet SHALL verify that the final Relying Party identifier remains consistent across the request and the authoritative authorization data and SHALL use the final Relying Party for all subsequent authorization decisions (`AUTHZ-INT-02`). An inconsistent final Relying Party identity produces `BINDING_FAILED`.

The binding process SHALL use an already-established validated Register context when the WRPRC is unavailable. Binding and intermediary-association failures are non-overridable.

### Entitlement

The Authorization Context SHALL contain the entitlement required by the operation (`AUTHZ-GEN-13`). The Wallet SHALL parse the `entitlements` member of the WRPRC or the profile-defined `entitlement` member of the validated Register response, normalize the result, and verify that the entitlements of the Authorization Subject match the expected role. Issuance SHALL require the entitlement for the requested credential type (`AUTHZ-ISS-01`), and presentation SHALL require the service-provider entitlement (`AUTHZ-PRES-08`).

The expected entitlement URI SHALL be the URI defined for the active role in [ETSI TS 119 475, Annex A.2]. For the roles covered by this process, the expected values are:

- PID Provider during PID Issuance: `https://uri.etsi.org/19475/Entitlement/PID_Provider`.
- QEAA Provider during QEAA Issuance: `https://uri.etsi.org/19475/Entitlement/QEAA_Provider`.
- PuB-EAA Provider during PuB-EAA Issuance: `https://uri.etsi.org/19475/Entitlement/PUB_EAA_Provider`.
- EAA Provider during EAA Issuance: `https://uri.etsi.org/19475/Entitlement/Non_Q_EAA_Provider`.
- Relying Party during Credential Presentation: `https://uri.etsi.org/19475/Entitlement/Service_Provider`.

The entitlement URI definitions in the WRPRC and Register profiles remain authoritative. The Wallet SHALL compare the expected URI with the authoritative entitlement values using the profile-defined comparison rules. If the expected entitlement is not present, the Wallet SHALL produce `WRONG_ENTITLEMENT` and terminate authorization non-overridiably.

### Issuance Attestation Type

During Credential Issuance, the Wallet SHALL verify that the requested PID or Attestation Type is registered for the Credential Issuer. The Wallet SHALL compare the authoritative `provides_attestations` array from the WRPRC or validated Register response with the keys of `credential_configurations_supported` in the validated Credential Issuer Metadata (`AUTHZ-ISS-02`, `AUTHZ-ISS-03`). For an SD-JWT VC, the comparison SHALL use `vct`; for an mdoc, it SHALL use `docType`. The match SHALL be exact and case-sensitive. If the requested type is not registered or not supported, the Wallet SHALL produce `ATTESTATION_TYPE_NOT_REGISTERED` and terminate authorization non-overridiably.

### Presentation Scope

During Credential Presentation, the Wallet SHALL verify that the requested Digital Credentials and attributes fall within the registered scope carried in the `credentials` array of the WRPRC or validated Register response (`AUTHZ-PRES-02`). The requested-scope comparison is an optional presentation check (`AUTHZ-PRES-01`). 

!!! choice
        
    The Wallet SHALL offer the setting enabled by default and the setting SHALL affect only this comparison (`AUTHZ-PRES-04`).

When scope comparison is enabled, the Wallet SHALL apply the flow-specific extraction and matching rules:

- For the Remote Flow, extract the requested Digital Credentials and attributes from `dcql_query` in the Request Object and compare them with the registered `credentials` entries, including `format`, `meta` and, for SD-JWT VC, `vct_values`, and compare requested attributes with the registered `claim` paths.
- For the Proximity Flow, extract `docType` and `nameSpaces` from the `docRequests` of the mdoc Request and compare them with `credentials[].meta.doctype_value` and `credentials[].claim`, respectively.

Every credential, format, type, and claim-path match SHALL be exact and case-sensitive. The Wallet SHALL identify every requested Digital Credential or attribute for which no registered scope entry matches. If all checks applicable to the interaction succeed, the scope outcome is `VERIFICATION_PASSED`; if any requested Digital Credential or attribute is not registered, the Wallet SHALL produce `OVERASKING_DETECTED` and identify the unregistered items (`AUTHZ-PRES-09`). When the User disables the setting, the Wallet SHALL skip only the scope comparison without treating the request as failed.

### Embedded Disclosure Policy

For presentation, EDP evaluation is performed only after context, binding, intermediary association, entitlement, and any enabled scope checks have completed.

EDP evaluation applies to QEAA, PuB-EAA, and EAA attestations. PID does not assume or require an EDP (`AUTHZ-EDP-01`). For each matching presentation Attestation, the Wallet SHALL perform the following checks against the locally stored EDP, if any:

1. If no EDP is stored for the Attestation, this check is superseded and the EDP outcome is `EDP_SATISFIED` (`AUTHZ-EDP-03`).
2. Read the EDP `policy_type` defined in [ETSI TS 119 472-3, Section 4.2.5]. For `no_policy`, no restriction applies and the EDP outcome is `EDP_SATISFIED`.
3. For `authorized_rp_only`, compare the direct or final Relying Party's WRPAC subject DN with the `authorized_parties[].subject_dn` entries and compare the Relying Party's authoritative entitlements or sub-entitlements with the `authorized_parties[].entitlement_uri` entries. A match on either supported criterion is sufficient. The Wallet SHALL NOT use the intermediary identity as a substitute (`AUTHZ-EDP-04`).
4. For `specific_root_of_trust`, verify that the direct or final Relying Party's WRPAC chain or the Provider of WRPRC root selected for that final Relying Party contains one of the policy's `trusted_roots`. The Wallet SHALL compare `issuer_dn` using LDAP DN comparison and `serial_number` using integer comparison, and SHALL NOT use the intermediary trust root as a substitute (`AUTHZ-EDP-05`).
5. Evaluate the policy's authorized relying-party, credential, and claim constraints against the final Relying Party and the operation (`AUTHZ-EDP-06`).
6. If every applicable policy check succeeds, set the EDP outcome to `EDP_SATISFIED`; otherwise set it to `EDP_NOT_SATISFIED`. The Wallet SHALL present the applicable policy meaning, requested disclosures, and explanatory link when present in the confirmation UI (`AUTHZ-EDP-07`).
7. If the User rejects an applicable EDP disclosure, set the EDP outcome to `EDP_NOT_SATISFIED` (`AUTHZ-EDP-08`). `EDP_NOT_SATISFIED` is an overridable presentation outcome only after all non-overridable checks have passed (`AUTHZ-EDP-09`).

## Authorization Decision and Override

The Wallet SHALL produce the binary result `AUTHORIZED` or `NOT_AUTHORIZED` (`AUTHZ-UI-01`). User-relevant limitations SHALL be represented as advisories (`AUTHZ-UI-02`). 

The Wallet SHALL display all results and advisories with the requested attributes and request User approval (`AUTHZ-UI-03`, `AUTHZ-UI-07`). 

User approval SHALL remain a separate step from the authorization decision (`AUTHZ-UI-04`), and the process SHALL support transparent decision-making (`AUTHZ-UI-05`).

The final result is determined as follows:

| Conditions | Final result |
| --- | --- |
| No valid Authorization Artifact or authoritative authorization data, Register failure, binding failure, invalid intermediary association, wrong entitlement, unsupported issuance attestation type, or any other non-overridable failure | `NOT_AUTHORIZED` (`AUTHZ-UI-06`) |
| Issuance with a valid Authorization Artifact and resulting Authorization Context, binding, entitlement, and supported attestation type | `AUTHORIZED` |
| Presentation with a valid Authorization Artifact and resulting Authorization Context, binding, intermediary association where applicable, entitlement, scope passed or skipped, and `EDP_SATISFIED` | `AUTHORIZED` |
| Presentation with only `OVERASKING_DETECTED` and/or `EDP_NOT_SATISFIED` remaining | `NOT_AUTHORIZED` until the user accepts the applicable override |

In an intermediated presentation, missing final Relying Party information, missing authoritative data, binding failure, and negative scope or EDP outcomes are negative cases for the final Relying Party (`AUTHZ-INT-06`).

The Wallet SHALL display the final Relying Party identity and intended use. It SHALL NOT display the intermediary identity (`AUTHZ-UI-08`). 

A non-overridable failure SHALL be clearly identified and SHALL not be presented as user-overridable.

If the result is `AUTHORIZED`, the Wallet SHALL proceed to normal User approval (`AUTHZ-UI-10`). If the result is `NOT_AUTHORIZED` and only overridable presentation outcomes remain, the Wallet SHALL present the negative outcome and SHALL allow continuation if the User accepts every applicable override (`AUTHZ-UI-11`).

All issuance failures are non-overridable. Only presentation scope overasking and EDP failure MAY be overridden.

The Wallet SHALL record and enforce the final decision. A successful authorization produces `AUTHORIZED`; a rejected or failed authorization produces `NOT_AUTHORIZED`.

## Phase Applicability

### Issuance

Before running the common pipeline, the Wallet SHALL retrieve and validate Credential Issuer Metadata, including its signature, trust chain, and metadata content (`AUTHZ-ISS-04`, `AUTHZ-ISS-05`, `AUTHZ-ISS-06`). It SHALL extract the issuer authorization data needed by the common pipeline (`AUTHZ-ISS-07`). The detailed sequence is defined in [Trust Checks for Issuance](trust-checks-issuance.md).

After successful authorization, the Wallet SHALL show the issuer, credential type, service description, and applicable advisories before user confirmation (`AUTHZ-UI-09`). If an EDP is accepted, the issuance process SHALL retain it with the authorization and credential result (`AUTHZ-ISS-10`).

### Presentation

Remote and proximity presentation use the same common pipeline (`AUTHZ-PRES-03`). Remote presentation obtains and validates the request-derived Authorization Context and Authorization Artifact through its defined transport and trust checks (`AUTHZ-PRES-10`). Proximity presentation applies the corresponding device and transport checks; it SHALL retain the profile's limitation on the available proximity association evidence (`AUTHZ-PRES-11`).

Presentation request extraction SHALL produce the normalized requested attributes and intended use before content validation (`AUTHZ-PRES-05`). An intermediated presentation SHALL use the final Relying Party and its validated association for the common pipeline (`AUTHZ-INT-04`). The final RP identity is displayed; the intermediary identity is not displayed (`AUTHZ-INT-05`). The detailed sequence is defined in [Trust Checks for Presentation](trust-checks-presentation.md).

## Result Codes

The process uses the following existing artifact, validation, and final outcomes, grouped by the stage that produces them.

### Authorization Artifact Validation Outcomes

| Outcome | Meaning |
| --- | --- |
| `CERTIFICATE_INVALID` | The supplied WRPRC Authorization Artifact is absent or invalid; the optional Register Authorization Artifact fallback may be attempted. |
| `FAILED` | Authorization Artifact validation failed because no valid Authorization Artifact was obtained; an invoked Register retrieval or validation failure produces this outcome. |

### Content Validation Outcomes

| Outcome | Meaning |
| --- | --- |
| `BINDING_FAILED` | The authenticated, requested, and registered identities do not bind. |
| `INTERMEDIARY_NOT_AUTHORIZED` | The intermediary-to-final-party association is absent or invalid. |
| `WRONG_ENTITLEMENT` | The Authorization Context does not contain the required entitlement. |
| `ATTESTATION_TYPE_NOT_REGISTERED` | Issuance attestation type is not registered or supported. |
| `VERIFICATION_PASSED` | Presentation requested-scope comparison passed. |
| `OVERASKING_DETECTED` | Presentation requested scope exceeds credential scope. |

### EDP Outcomes

| Outcome | Meaning |
| --- | --- |
| `EDP_SATISFIED` / `EDP_NOT_SATISFIED` | Embedded Disclosure Policy evaluation passed or failed. |

### Final Decisions

| Outcome | Meaning |
| --- | --- |
| `AUTHORIZED` / `NOT_AUTHORIZED` | Final operation decision. |

## Authorization Requirements

The following table restores the implementation and conformance mapping from the former requirements table with the updated authorization meanings. The normative clauses above remain authoritative; this table does not create additional requirements.

| ID | Updated requirement | Phase | Canonical clause |
| --- | --- | --- | --- |
| `AUTHZ-GEN-01` | Authorization is evaluated only after successful authentication. | Both | Scope and Preconditions |
| `AUTHZ-GEN-02` | The same authorization process is used for issuance and presentation with operation-specific inputs and checks. | Both | Scope and Preconditions |
| `AUTHZ-GEN-03` | Failed authentication or unavailable authorization input prevents authorization. | Both | Scope and Preconditions |
| `AUTHZ-GEN-04` | The Authorization Subject is selected according to direct or intermediated interaction rules. | Both | Scope and Preconditions |
| `AUTHZ-GEN-05` | The validated WRPRC is the primary Authorization Artifact. | Both | Inputs |
| `AUTHZ-GEN-06` | Register lookup is optional and is not a prerequisite for authorization. | Both | Inputs |
| `AUTHZ-GEN-07` | Authorization data carried by WRPRC and Register artifacts are normalized into one consistent Authorization Context when both are available. | Both | Inputs |
| `AUTHZ-GEN-08` | A supplied WRPRC is validated before it is used as an Authorization Artifact. | Both | WRPRC Validation |
| `AUTHZ-GEN-09` | WRPRC validation includes authenticity, status, validity, and scenario-coherence checks. | Both | WRPRC Validation |
| `AUTHZ-GEN-10` | The defined Register procedure is an optional fallback after missing or invalid WRPRC. | Both | Optional Register Validation |
| `AUTHZ-GEN-11` | Authenticated identity, Authorization Context, and authorization data carried by the Authorization Artifact are compared with the operation request. | Both | Binding and Intermediary Association |
| `AUTHZ-GEN-12` | Direct and intermediated interactions use their respective identity and association rules. | Both | Binding and Intermediary Association |
| `AUTHZ-GEN-13` | The Authorization Context contains the entitlement required by the operation. | Both | Entitlement |
| `AUTHZ-IN-01` | The presentation request supplies requested credentials, claims, intended use, and final Relying Party identity. | Presentation | Inputs |
| `AUTHZ-IN-02` | Validated Credential Issuer Metadata supplies issuance identity, supported types, and authorization data. | Issuance | Inputs |
| `AUTHZ-IN-03` | The validated WRPAC context identifies and authenticates the relying party. | Both | Inputs |
| `AUTHZ-IN-04` | The validated WRPAC trust path supports relying-party authentication. | Both | Inputs |
| `AUTHZ-IN-05` | WRPRC supplies registered relying-party context and intended-use information. | Both | Inputs |
| `AUTHZ-IN-06` | A validated Register response can serve as an Authorization Artifact when WRPRC is absent or invalid. | Both | Inputs |
| `AUTHZ-IN-07` | Intended use is compared with the request-derived Authorization Context and the Authorization Artifact. | Both | Inputs |
| `AUTHZ-IN-08` | Issuance identifies the requested or supported attestation type from issuer and authorization data. | Issuance | Inputs |
| `AUTHZ-IN-09` | Presentation evaluates an applicable EDP against the operation and final Relying Party. | Presentation | Inputs |
| `AUTHZ-IN-10` | The default-enabled User setting controls only optional requested-scope comparison. | Presentation | Inputs |
| `AUTHZ-UI-01` | The Wallet produces the binary result `AUTHORIZED` or `NOT_AUTHORIZED`. | Both | Authorization Decision and Override |
| `AUTHZ-UI-02` | User-relevant limitations are represented as advisories. | Both | Authorization Decision and Override |
| `AUTHZ-UI-03` | Results and advisories are displayed with the requested attributes and User approval is requested. | Presentation | Authorization Decision and Override |
| `AUTHZ-UI-04` | User approval remains separate from the authorization decision. | Both | Authorization Decision and Override |
| `AUTHZ-UI-05` | Authorization supports transparent decision-making. | Both | Authorization Decision and Override |
| `AUTHZ-UI-06` | Authorization Artifact, Authorization Context, binding, intermediary, entitlement, attestation-type, Register, and other non-overridable failures produce `NOT_AUTHORIZED`. | Both | Authorization Decision and Override |
| `AUTHZ-UI-07` | Presentation displays all results and advisories and requests User approval. | Presentation | Authorization Decision and Override |
| `AUTHZ-UI-08` | Presentation displays the final Relying Party identity and does not display the intermediary identity. | Presentation | Authorization Decision and Override |
| `AUTHZ-UI-09` | Issuance displays the issuer, credential type, service description, and applicable advisories before confirmation. | Issuance | Issuance |
| `AUTHZ-UI-10` | An `AUTHORIZED` result proceeds to normal User approval. | Both | Authorization Decision and Override |
| `AUTHZ-UI-11` | Continuation after an overridable presentation failure may be offered after the User accepts every applicable override. | Presentation | Authorization Decision and Override |
| `AUTHZ-UI-12` | Continuation is prohibited when a `NOT_AUTHORIZED` result contains a non-overridable failure. | Both | Authorization Decision and Override |
| `AUTHZ-ISS-01` | Issuance requires the entitlement for the requested credential type. | Issuance | Entitlement |
| `AUTHZ-ISS-02` | Issuance compares the requested attestation type with registered `provides_attestations` information. | Issuance | Issuance Attestation Type |
| `AUTHZ-ISS-03` | Issuance compares the requested attestation type with Credential Issuer Metadata support. | Issuance | Issuance Attestation Type |
| `AUTHZ-ISS-04` | The Wallet retrieves and validates Credential Issuer Metadata. | Issuance | Issuance |
| `AUTHZ-ISS-05` | The Wallet validates the metadata signature and WRPAC trust chain. | Issuance | Issuance |
| `AUTHZ-ISS-06` | The Wallet validates metadata content and supported-credential declarations. | Issuance | Issuance |
| `AUTHZ-ISS-07` | The Wallet extracts issuer authorization data needed by the common process. | Issuance | Issuance |
| `AUTHZ-ISS-08` | The optional Register fallback uses the defined Authorization Artifact retrieval operation after invalid or absent WRPRC. | Issuance | Optional Register Validation |
| `AUTHZ-ISS-09` | The Register response used by issuance is authenticated, validated, and complete. | Issuance | Optional Register Validation |
| `AUTHZ-ISS-10` | An accepted EDP is retained with the authorization and credential result. | Issuance | Issuance |
| `AUTHZ-PRES-01` | Presentation scope comparison is optional. | Presentation | Presentation Scope |
| `AUTHZ-PRES-02` | Enabled scope comparison uses exact, case-sensitive matching of normalized requested attributes. | Presentation | Presentation Scope |
| `AUTHZ-PRES-03` | Remote and proximity presentation use the same common authorization pipeline. | Presentation | Presentation |
| `AUTHZ-PRES-04` | The default-enabled User setting affects only scope comparison and cannot disable other checks. | Presentation | Presentation Scope |
| `AUTHZ-PRES-05` | Presentation request extraction produces normalized requested attributes and intended use before content validation. | Presentation | Presentation |
| `AUTHZ-PRES-06` | The optional Register fallback retrieves and validates an Authorization Artifact when WRPRC is absent or invalid. | Presentation | Optional Register Validation |
| `AUTHZ-PRES-07` | Presentation applies direct or intermediated binding and association checks. | Presentation | Binding and Intermediary Association |
| `AUTHZ-PRES-08` | Presentation requires the service-provider entitlement. | Presentation | Entitlement |
| `AUTHZ-PRES-09` | Presentation reports the requested-scope comparison result and unmatched items. | Presentation | Presentation Scope |
| `AUTHZ-PRES-10` | Remote presentation obtains and validates the request-derived Authorization Context and Authorization Artifact through its defined flow. | Presentation | Presentation |
| `AUTHZ-PRES-11` | Proximity presentation applies its defined device, transport, and association-evidence limitations. | Presentation | Presentation |
| `AUTHZ-INT-01` | The Wallet determines whether presentation is direct or intermediated. | Presentation | Binding and Intermediary Association |
| `AUTHZ-INT-02` | Intermediated authorization validates the intermediary-to-final-party association and uses the final Relying Party for decisions. | Presentation | Binding and Intermediary Association |
| `AUTHZ-INT-03` | An absent or invalid intermediary association produces `INTERMEDIARY_NOT_AUTHORIZED`. | Presentation | Binding and Intermediary Association |
| `AUTHZ-INT-04` | Intermediary handling applies to both remote and proximity presentation. | Presentation | Presentation |
| `AUTHZ-INT-05` | Intermediated presentation displays the final Relying Party and not the intermediary. | Presentation | Presentation |
| `AUTHZ-INT-06` | Missing final-party data, authoritative data, binding, scope, or EDP outcomes are negative final-party cases. | Presentation | Authorization Decision and Override |
| `AUTHZ-INT-07` | Intermediated override is limited to negative scope and EDP outcomes. | Presentation | Authorization Decision and Override |
| `AUTHZ-REG-01` | The Register endpoint is discovered from applicable request or metadata input without treating its URL as registration proof. | Both | Optional Register Validation |
| `AUTHZ-REG-02` | The Wallet retrieves the complete Register record over HTTPS using `GET /wrp`, Authorization Subject, and intended use. | Both | Optional Register Validation |
| `AUTHZ-REG-03` | The Wallet validates Register authenticity, trust, freshness, status, subject, intended use, and completeness. | Both | Optional Register Validation |
| `AUTHZ-REG-04` | Validated Register data are normalized into the WRPRC-derived Authorization Context model. | Both | Optional Register Validation |
| `AUTHZ-EDP-01` | EDP applies to QEAA, PuB-EAA, and EAA attestations and is not assumed for PID. | Presentation | Embedded Disclosure Policy |
| `AUTHZ-EDP-02` | Issuance retains an accepted EDP and does not evaluate it. | Issuance | Embedded Disclosure Policy |
| `AUTHZ-EDP-03` | No applicable EDP or a passing policy produces `EDP_SATISFIED`. | Presentation | Embedded Disclosure Policy |
| `AUTHZ-EDP-04` | Authorized RP Only evaluates the direct or final Relying Party, not the intermediary. | Presentation | Embedded Disclosure Policy |
| `AUTHZ-EDP-05` | Specific Root of Trust evaluates the direct or final-party trust root, not the intermediary root. | Presentation | Embedded Disclosure Policy |
| `AUTHZ-EDP-06` | EDP constraints are evaluated against the final Relying Party and operation. | Presentation | Embedded Disclosure Policy |
| `AUTHZ-EDP-07` | Applicable EDP meaning, disclosures, and explanatory links are presented in the confirmation UI. | Presentation | Embedded Disclosure Policy |
| `AUTHZ-EDP-08` | Rejecting an applicable EDP disclosure produces `EDP_NOT_SATISFIED`. | Presentation | Embedded Disclosure Policy |
| `AUTHZ-EDP-09` | `EDP_NOT_SATISFIED` is overridable only after all non-overridable checks pass. | Presentation | Embedded Disclosure Policy |
