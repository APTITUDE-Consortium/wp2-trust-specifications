This section describes a set of trust use cases applying horizontally to the APTITUDE Large Scale Pilot. In particular, considering the [APTITUDE Trust Architecture](../sections/trust-architecture.md), they leverage the [Trust Artifacts](../sections/trust-artifacts.md) to perform the [Trust Evaluation Processes](../sections/trust-evaluation-process.md).

The trust use cases are divided into the following categories:

- **Runtime Trust Use Cases**: Verify trust decisions during issuance and presentation interactions.
- **Operational Trust Use Cases**: Verify the conformance of the trust infrastructure when entities and trust artifacts are onboarded, updated, revoked, or removed.

The above categories are complementary: the **Runtime Trust Use Cases** verify a trust decision against the artifacts available during an interaction, while the **Operational Trust Use Cases** verify that a single management process produces the expected infrastructure state or current artifact and, where applicable, that the linked runtime test case observes the resulting trust state.

## Runtime Trust Use Cases

<table>
    <thead>
        <tr>
            <th>Trust Use Case</th>
            <th>Involved Processes</th>
            <th>Artifacts in Input</th>
            <th>Checks</th>
            <th>On Success</th>
            <th>On Failure</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Trust Anchor Validation</td>
            <td>
                <ul>
                    <li>Issuance</li>
                    <li>Presentation</li>
                </ul>
            </td>
            <td>Current LoTE, WP2 LoTE signing certificate (published on GitHub)</td>
            <td>Validate the authenticity, integrity, currency, and applicable entity entry of the LoTE using LoTE Validation.</td>
            <td>The Trust Anchor is validated.</td>
            <td>The process SHALL BE interrupted.</td>
        </tr>
        <tr>
            <td>Entity Identity Validation</td>
            <td>
                <ul>
                    <li>Issuance</li>
                    <li>Presentation</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Validated Trust Anchor Certificate of the WRPAC Provider</li>
                    <li>WRPAC</li>
                    <li>CRL or OCSP response</li>
                    <li>Entity-signed metadata</li>
                </ol>
            </td>
            <td>
                <ul>
                    <li>Validate the Entity-signed metadata (depending on the flow type) using the WRPAC.</li>
                    <li>Validate the X.509 Chain starting with the WRPAC, including its revocation status, using X.509 Validation with the WRPAC Provider Trust Anchor as input.</li>
                </ul>
            </td>
            <td>The Entity SHALL BE considered authenticated.</td>
            <td>The process SHALL BE interrupted as the Entity is not trusted.</td>
        </tr>
        <tr>
            <td>Attestation Authenticity and Integrity</td>
            <td>
                <ul>
                    <li>Issuance</li>
                    <li>Presentation</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Sign/Seal Certificate</li>
                    <li>Certificate-status information</li>
                    <li>Validated Attestation Provider TA or Wallet Provider TA</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Validate the signed Attestation or KA/WIA signature using the Sign/Seal Certificate.</li>
                    <li>Validate the X.509 Chain starting with the Sign/Seal Certificate, including its revocation status, using X.509 Validation with the Attestation Provider TA or Wallet Provider TA as input.</li>
                </ul>
            </td>
            <td>The Attestation or KA/WIA SHALL BE considered authentic.</td>
            <td>The Attestation or KA/WIA SHALL BE considered untrustworthy.</td>
        </tr>
        <tr>
            <td>Entity Authorization Profile Verification</td>
            <td>
                <ul>
                    <li>Issuance</li>
                    <li>Presentation</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>WRPRC and Status List Token, or Register query response</li>
                    <li>Validated WRPRC Provider TA or Registrar certificate</li>
                    <li>WRPAC</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Validate the WRPRC signature, X.509 Chain, temporal validity, and Status List Token status, or the Register response signature and signing-certificate chain, using X.509 Validation with the applicable TA as input.</li>
                    <li>Validate the Entity authorization profile using Authorization Validation with the validated WRPRC or Register query as input.</li>
                </ul>
            </td>
            <td>The Entity SHALL be authorized for issuance or presentation.</td>
            <td>The Entity SHOULD NOT be authorized for issuance or presentation; the user MAY override the decision in specific cases.</td>
        </tr>
    </tbody>
</table>

Detailed versions of these use cases are available in [RFC003](https://aptitude-consortium.github.io/aptitude-eudi-wallet-specs/latest/horizontal-RFCs/RFC003/).

## Operational Trust Use Cases

The operational trust use cases are derived from the [Trust Management Process](../sections/trust-management-lifecycle.md#trust-management-process), [Onboarding Process](../sections/trust-management-lifecycle.md#onboarding-process), and [Revocation Mechanisms](../sections/trust-management-lifecycle.md#revocation-mechanisms). They verify both the successful path and the failure path of each management operation.

An Operational Trust Use Case passes when the APTITUDE WP2 checks and any applicable affected-entity or consuming-participant checks pass. Where the affected-entity responsibility is "None", APTITUDE WP2 performs the complete operational test.

APTITUDE WP2, acting as ecosystem manager and operator of the Registrar, Certificate Services, and Publication Service, executes and records the infrastructure-side checks. The affected entity SHALL provide only the event inputs, notifications, and deployment actions assigned to it in the table. Pilot participants that consume an updated artifact SHALL refresh or automatically integrate that artifact and SHALL execute the linked runtime check. A test case that orchestrates other management processes SHALL invoke their respective operational Trust use cases instead of repeating their checks.

<table>
    <thead>
        <tr>
            <th>Trust Use Case</th>
            <th>Involved Process(es)</th>
            <th>Artifact(s) in Input</th>
            <th>APTITUDE WP2 Actions</th>
            <th>Affected entity and pilot participant responsibility</th>
            <th>On Success</th>
            <th>On Failure</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>LoTE Publication Service Readiness</td>
            <td>Infrastructure LoTE Publication</td>
            <td>
                <ul>
                    <li>APTITUDE WP2 LoTE signing certificate</li>
                    <li>Infrastructure Trust Anchors</li>
                    <li>Applicable LoTE profiles</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Verify that every required LoTE endpoint is available.</li>
                    <li>Publish the APTITUDE WP2 LoTE signing certificate.</li>
                    <li>Verify that each published LoTE has a valid signature, conforms to its format, and contains the required infrastructure Trust Anchors.</li>
                <ul>
            </td>
            <td>None</td>
            <td>All the required LoTE endpoints and valid LoTE are available.</td>
            <td>The operational onboarding SHALL NOT start.</li>
        </tr>
        <tr>
            <td>Register Service Readiness</td>
            <td>Register service provisioning</td>
            <td>
                <ul>
                    <li>Register API profile</li>
                    <li>Register data schema</li>
                    <li>Registrar signing certificate</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Verify that the Register API endpoints are available.</li>
                    <li>Verify that writes are authenticated and restricted to the Registrar.</li>
                    <li>Verify that records and signed query responses conform to the applicable schemas.</li>
                <ul>
            </td>
            <td>None</td>
            <td>The Register can be securely written and queried.</td>
            <td>WRP registration SHALL NOT start.</li>
        </tr>
        <tr>
            <td>Certificate Issuance Service Readiness</td>
            <td>Certificate Service provisioning</td>
            <td>
                <ul>
                    <li>WRPAC Certificate Profile</li>
                    <li>WRPRC Certificate Profile</li>
                    <li>Sign/Seal Certificate Profiles</li>
                    <li>CA Trust Anchors</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Verify that the interfaces required to request each supported certificate type are available.</li>
                    <li>Issue test certificates.</li>
                    <li>Verify that each issued certificate conforms to its applicable profile.</li>
                <ul>
            </td>
            <td>None</td>
            <td>The Certificate Services are available and issue profile-conformant certificates.</td>
            <td>Certificate-dependent onboarding SHALL NOT start.</li>
        </tr>
        <tr>
            <td>Certificate Status Service Readiness</td>
            <td>Certificate status service provisioning</td>
            <td>
                <ul>
                    <li>CRL Profile</li>
                    <li>OCSP Profile</li>
                    <li>Status List Profile</li>
                    <li>Test Certificate</li>
                    <li>WRPRC</li>
                </ul>
            </td>
            <td>Verify that each configured status endpoint is available and returns a valid, correctly signed status artifact in the required format.</td>
            <td>None</td>
            <td>The configured Certificate and WRPRC status mechanisms are operational.</td>
            <td>The corresponding Certificate Service SHALL NOT be considered ready.</li>
        </tr>
    </tbody>
</table>

<table>
    <thead>
        <tr>
            <th>Trust Use Case</th>
            <th>Involved Process(es)</th>
            <th>Artifact(s) in Input</th>
            <th>APTITUDE WP2 responsibility and checks</th>
            <th>Affected entity and pilot participant responsibility</th>
            <th>On Success</th>
            <th>On Failure</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>WRP Registration</td>
            <td>Registration</td>
            <td>
                <ul>
                    <li>Registration data</li>
                    <li>APTITUDE participation evidence</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Verify that the entity is officially enrolled in APTITUDE.</li>
                    <li>Create an active Register record that conforms to the schema.</li>
                <ul>
            </td>
            <td>The WRP SHALL submit its self-declared registration data through the Onboarding System.</td>
            <td>An active Register record is available.</td>
            <td>The request SHALL BE rejected and the process interrupted.</li>
        </tr>
        <tr>
            <td>WRP Certificate Issuance</td>
            <td>Certificate issuance</td>
            <td>
                <ul>
                    <li>Active Register record</li>
                    <li>Certificate request</li>
                    <li>WRP public key</li>
                    <li>Applicable Certificate Profile</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Verify the active registration status and data consistency.</li>
                    <li>Issue the requested Certificate(s).</li>
                <ul>
            </td>
            <td>The WRP SHALL submit the cryptographic material and deploy each issued certificate at the intended instance or service supply point.</td>
            <td>A valid certificate is issued and the applicable runtime test succeeds.</td>
            <td>Issuance SHALL be refused.</li>
        </tr>
        <tr>
            <td>Entity Publication</td>
            <td>LoTE Publication</td>
            <td>
                <ul>
                    <li>Registered entity information</li>
                    <li>Entity service information</li>
                    <li>Sign/Seal Trust Anchor</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Verify that the entity data is complete and create or update the applicable entity-type LoTE entry.</li>
                    <li>For a Wallet Provider the required service information is the Wallet Solution</li>
                <ul>
            </td>
            <td>The entity SHALL submit the required data and Trust Anchor.</td>
            <td>The entity data is accepted for publication.</td>
            <td>No LoTE entry SHALL BE created or updated.</li>
        </tr>
        <tr>
            <td rowspan="2">Information update</td>
            <td>Register update</td>
            <td>
                <ul>
                    <li>Updated identity, policy, or authorization data</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Update the Register record and verify that the resulting record conforms to the Register schema.</li>
                <ul>
            </td>
            <td>The WRP SHALL submit the updated information through the Onboarding System.</td>
            <td>The current Register record contains the updated information.</td>
            <td>The record SHALL NOT be updated.</li>
        </tr>
        <tr>
            <td>LoTE update</td>
            <td>
                <ul>
                    <li>Updated entity identity, service endpoint, Trust Anchor, or eligibility information</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Update the applicable LoTE entry.</li>
                    <li>When the entity becomes ineligible, invoke the applicable removal test case instead.</li>
                <ul>
            </td>
            <td>The affected entity SHALL notify APTITUDE WP2 of the changed information.</td>
            <td>The new entity information is included in the updated LoTE content prepared and published.</td>
            <td>The previous information SHALL remain in the prepared current content.</li>
        </tr>
        <tr>
            <td>Cryptographic key material update</td>
            <td>Certificate re-issuance</td>
            <td>
                <ul>
                    <li>Updated identity, policy, authorization, or cryptographic material</li>
                    <li>Applicable certificate profile</li>
                </ul>
            </td>
            <td>Issue a replacement certificate for the new data and invoke the applicable <i>Certificate Revocation</i> test case for the former certificate.</td>
            <td>The affected entity SHALL notify the Certificate Service, provide the new public key, and deploy the replacement certificate.</td>
            <td>The replacement certificate is correctly issued an conforms to the applicable profile.</td>
            <td>No valid replacement is available.</li>
        </tr>
        <tr>
            <td>LoTE version publication</td>
            <td>LoTE distribution</td>
            <td>
                <ul>
                    <li>Updated LoTE content</li>
                    <li>Pivot LoTE URI</li>
                    <li>APTITUDE WP2 LoTE signing certificate</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Publish a signed new current LoTE and make the replaced version at the applicable pivot URI for retro-compatibility.</li>
                    <li>Update the <code>SchemeInformationURI</code> accordingly.</li>
                <ul>
            </td>
            <td>Every participant that consumes the affected LoTE SHALL refresh its cached copy via the Trust Anchor Validation Process and SHALL NOT use old pivot versions for a current decision.</td>
            <td>The endpoint serves the new current LoTE and Trust Anchor Validation uses its updated entry.</td>
            <td>The new version is unavailable or invalid, or a participant continues to use the superseded version.</li>
        </tr>
        <tr>
            <td rowspan="2">Certificate revocation</td>
            <td>WRPAC - Sign/Seal Certificate revocation</td>
            <td>
                <ul>
                    <li>Certificate serial number</li>
                    <li>Current CRL or OCSP status database</li>
                </ul>
            </td>
            <td>Update the configured CRL or OCSP status source and verify that it reports the certificate as revoked.</td>
            <td>The affected entity SHALL stop using the certificate. Runtime participants SHALL retrieve current status information and reject it.</td>
            <td>The certificate fails <i>Entity Identity Validation</i> or <i>Attestation Authenticity and Integrity</i>, as applicable.</td>
            <td>The certificate remains accepted.</li>
        </tr>
        <tr>
            <td>WRPRC revocation</td>
            <td>
                <ul>
                    <li>WRPRC status reference and index</li>
                    <li>current Status List</li>
                </ul>
            </td>
            <td>The Provider or WRPRC SHALL set the assigned status value to <code>0x01</code>, publish the updated signed Status List Token, and verify that its endpoint remains available.</td>
            <td>The affected entity SHALL stop presenting the WRPRC. Wallet Units SHALL retrieve the current Status List Token and apply the status in <i>Entity Authorization Profile Verification</i>.</td>
            <td>The WRPRC is treated as revoked.</td>
            <td>The WRPRC remains valid or is accepted by a Wallet Unit.</li>
        </tr>
        <tr>
            <td>WRP deregistration</td>
            <td>Entity removal</td>
            <td>
                <ul>
                    <li>Removal request or decision</li>
                    <li>Current entity record and related trust artifacts</li>
                </ul>
            </td>
            <td>Orchestrate the applicable Register cancellation or deletion, entity-related certificate revocation, and LoTE update Trust use cases, and verify that each completes successfully.</td>
            <td>For voluntary removal, the WRP SHALL submit the removal request to APTITUDE WP2; in every case it SHALL cease new framework operations. Participants SHALL reject new interactions with the removed entity.</td>
            <td>The entity is <code>REMOVED</code> and all applicable runtime tests reject new interactions.</td>
            <td>Any invoked operational test fails or a new interaction remains trusted.</li>
        </tr>
        <tr>
            <td>Wallet Solution deregistration</td>
            <td>Entity removal</td>
            <td>
                <ul>
                    <li>Removal request or decision</li>
                    <li>Current LoTE entry</li>
                    <li>Sign/Seal Certificate for the Wallet Solution</li>
                </ul>
            </td>
            <td>Orchestrate the applicable LoTE update and Sign/Seal certificate revocation Trust Use Cases, including WUA revocation.</td>
            <td>For voluntary removal, the entity SHALL notify APTITUDE WP2 and cease new framework operations. Participants SHALL reject new interactions whose trust depends on the removed Wallet Solution.</td>
            <td>The Wallet Solution can no longer be resolved as trusted from the current LoTE.</td>
            <td>Any invoked operational test fails or a new interaction remains trusted through a Wallet Solution's Instance.</li>
        </tr>
    </tbody>
</table>
