This section describes a set of trust use cases that apply horizontally across the APTITUDE ecosystem. In particular, drawing on the [APTITUDE Trust Architecture](../sections/trust-architecture.md), these use cases leverage the [Trust Artifacts](../sections/trust-artifacts.md) to perform the [Trust Evaluation Processes](../sections/trust-evaluation-process.md).

The trust use cases are divided into the following categories:

- **Runtime Trust Use Cases**: Verify trust decisions during issuance and presentation interactions.
- **Operational Trust Use Cases**: Verify the conformance of the trust infrastructure when entities and trust artifacts are onboarded, updated, revoked, or removed.

These categories are complementary: **Runtime Trust Use Cases** verify a trust decision against the artifacts available during an interaction, while **Operational Trust Use Cases** verify that a given management process produces the expected infrastructure state or artifact, and, where applicable, that the linked runtime use case observes the resulting trust state.

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
            <td><artifacts:Trust Anchor> Validation</td>
            <td>
                <ul>
                    <li>Issuance</li>
                    <li>Presentation</li>
                </ul>
            </td>
            <td>Current <artifacts:List of Trusted Entities (LoTE)|LoTE>, APTITUDE WP2 <artifacts:List of Trusted Entities (LoTE)|LoTE> signing certificate (published on GitHub)</td>
            <td>Validate the authenticity, integrity, currency, and applicable entity entry of the <artifacts:List of Trusted Entities (LoTE)|LoTE> using <artifacts:List of Trusted Entities (LoTE)|LoTE> Validation.</td>
            <td>The <artifacts:Trust Anchor> is validated.</td>
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
                    <li>Validated <artifacts:Trust Anchor> Certificate of the <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC></li>
                    <li><artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC></li>
                    <li><artifacts:Certificate Revocation List (CRL)|CRL> or <protocols:Online Certificate Status Protocol (OCSP)|OCSP> response</li>
                    <li>Entity-signed metadata</li>
                </ol>
            </td>
            <td>
                <ul>
                    <li>Validate the Entity-signed metadata (depending on the flow type) using the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>.</li>
                    <li>Validate the X.509 Chain starting with the <artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC>, including its revocation status, using X.509 Validation with the <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)|Provider of WRPAC> <artifacts:Trust Anchor> as input.</li>
                </ul>
            </td>
            <td>The Entity SHALL BE considered authenticated.</td>
            <td>The process SHALL BE interrupted as the Entity is not trusted.</td>
        </tr>
        <tr>
            <td><credentials:Attestation> Authenticity and Integrity</td>
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
                    <li>Validated <roles:Attestation Provider (AP)|Attestation Provider> <artifacts:Trust Anchor> or <roles:Wallet Provider (WP)|Wallet Provider> <artifacts:Trust Anchor></li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Validate the signed <credentials:Attestation> or <artifacts:Key Attestation (KA)|KA>/<artifacts:Wallet Instance Attestation (WIA)|WIA> signature using the Sign/Seal Certificate.</li>
                    <li>Validate the X.509 Chain starting with the Sign/Seal Certificate, including its revocation status, using X.509 Validation with the <roles:Attestation Provider (AP)|Attestation Provider> <artifacts:Trust Anchor> or <roles:Wallet Provider (WP)|Wallet Provider> <artifacts:Trust Anchor> as input.</li>
                </ul>
            </td>
            <td>The <credentials:Attestation> or <artifacts:Key Attestation (KA)|KA>/<artifacts:Wallet Instance Attestation (WIA)|WIA> SHALL BE considered authentic.</td>
            <td>The <credentials:Attestation> or <artifacts:Key Attestation (KA)|KA>/<artifacts:Wallet Instance Attestation (WIA)|WIA> SHALL BE considered untrustworthy.</td>
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
                    <li><artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> and <artifacts:Status List Token>, or <components:Register> query response</li>
                    <li>Validated <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)|Provider of WRPRC> <artifacts:Trust Anchor> or <roles:Registrar> certificate</li>
                    <li><artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC></li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Validate the <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> signature, X.509 Chain, temporal validity, and <artifacts:Status List Token> status, or the <components:Register> response signature and signing-certificate chain, using X.509 Validation with the applicable <artifacts:Trust Anchor> as input.</li>
                    <li>Validate the Entity authorization profile using Authorization Validation with the validated <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> or <components:Register> query as input.</li>
                </ul>
            </td>
            <td>The Entity SHALL be authorized for issuance or presentation.</td>
            <td>The Entity SHOULD NOT be authorized for issuance or presentation; the user MAY override the decision in specific cases.</td>
        </tr>
    </tbody>
</table>

Detailed versions of these use cases are available in [APTITUDE-RFC003].

## Operational Trust Use Cases

The operational trust use cases are derived from the [Trust Management Process](../sections/trust-management-lifecycle.md#trust-management-process), [Onboarding Process](../sections/trust-management-lifecycle.md#onboarding-process), and [Revocation Mechanisms](../sections/trust-management-lifecycle.md#revocation-mechanisms). They verify both the successful path and the failure path of each management operation.

An Operational Trust Use Case passes when the APTITUDE WP2 checks and any applicable affected-entity or consuming-participant checks pass. Where the affected-entity responsibility is "None", APTITUDE WP2 performs the complete operational test.

APTITUDE WP2, acting as ecosystem manager and operator of the <roles:Registrar>, Certificate Services, and Publication Service, executes and records the infrastructure-side checks. The affected entity SHALL provide only the event inputs, notifications, and deployment actions assigned to it in the table. Pilot participants that consume an updated artifact SHALL refresh or automatically integrate that artifact and SHALL execute the linked runtime check. A test case that orchestrates other management processes SHALL invoke their respective operational Trust use cases instead of repeating their checks.

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
            <td><artifacts:List of Trusted Entities (LoTE)|LoTE> Publication Service Readiness</td>
            <td>Infrastructure <artifacts:List of Trusted Entities (LoTE)|LoTE> Publication</td>
            <td>
                <ul>
                    <li>APTITUDE WP2 <artifacts:List of Trusted Entities (LoTE)|LoTE> signing certificate</li>
                    <li>Infrastructure <artifacts:Trust Anchor|Trust Anchors></li>
                    <li>Applicable <artifacts:List of Trusted Entities (LoTE)|LoTE> profiles</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Verify that every required <artifacts:List of Trusted Entities (LoTE)|LoTE> endpoint is available.</li>
                    <li>Publish the APTITUDE WP2 <artifacts:List of Trusted Entities (LoTE)|LoTE> signing certificate.</li>
                    <li>Verify that each published <artifacts:List of Trusted Entities (LoTE)|LoTE> has a valid signature, conforms to its format, and contains the required infrastructure <artifacts:Trust Anchor|Trust Anchors>.</li>
                <ul>
            </td>
            <td>None</td>
            <td>All the required <artifacts:List of Trusted Entities (LoTE)|LoTE> endpoints and valid <artifacts:List of Trusted Entities (LoTE)|LoTE> are available.</td>
            <td>The operational onboarding SHALL NOT start.</li>
        </tr>
        <tr>
            <td><components:Register> Service Readiness</td>
            <td><components:Register> service provisioning</td>
            <td>
                <ul>
                    <li><components:Register> API profile</li>
                    <li><components:Register> data schema</li>
                    <li><roles:Registrar> signing certificate</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Verify that the <components:Register> API endpoints are available.</li>
                    <li>Verify that writes are authenticated and restricted to the <roles:Registrar>.</li>
                    <li>Verify that records and signed query responses conform to the applicable schemas.</li>
                <ul>
            </td>
            <td>None</td>
            <td>The <components:Register> can be securely written and queried.</td>
            <td><roles:Wallet-Relying Party (WRP)|WRP> registration SHALL NOT start.</li>
        </tr>
        <tr>
            <td>Certificate Issuance Service Readiness</td>
            <td>Certificate Service provisioning</td>
            <td>
                <ul>
                    <li><artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> Certificate Profile</li>
                    <li><artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> Certificate Profile</li>
                    <li>Sign/Seal Certificate Profiles</li>
                    <li>CA <artifacts:Trust Anchor|Trust Anchors></li>
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
                    <li><artifacts:Certificate Revocation List (CRL)|CRL> Profile</li>
                    <li><protocols:Online Certificate Status Protocol (OCSP)|OCSP> Profile</li>
                    <li>Status List Profile</li>
                    <li>Test Certificate</li>
                    <li><artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC></li>
                </ul>
            </td>
            <td>Verify that each configured status endpoint is available and returns a valid, correctly signed status artifact in the required format.</td>
            <td>None</td>
            <td>The configured Certificate and <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> status mechanisms are operational.</td>
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
            <td><roles:Wallet-Relying Party (WRP)|WRP> Registration</td>
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
                    <li>Create an active <components:Register> record that conforms to the schema.</li>
                <ul>
            </td>
            <td>The <roles:Wallet-Relying Party (WRP)|WRP> SHALL submit its self-declared registration data through the Onboarding System.</td>
            <td>An active <components:Register> record is available.</td>
            <td>The request SHALL BE rejected and the process interrupted.</li>
        </tr>
        <tr>
            <td><roles:Wallet-Relying Party (WRP)|WRP> Certificate Issuance</td>
            <td>Certificate issuance</td>
            <td>
                <ul>
                    <li>Active <components:Register> record</li>
                    <li>Certificate request</li>
                    <li><roles:Wallet-Relying Party (WRP)|WRP> public key</li>
                    <li>Applicable Certificate Profile</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Verify the active registration status and data consistency.</li>
                    <li>Issue the requested Certificate(s).</li>
                <ul>
            </td>
            <td>The <roles:Wallet-Relying Party (WRP)|WRP> SHALL submit the cryptographic material and deploy each issued certificate at the intended instance or service supply point.</td>
            <td>A valid certificate is issued and the applicable runtime test succeeds.</td>
            <td>Issuance SHALL be refused.</li>
        </tr>
        <tr>
            <td>Entity Publication</td>
            <td><artifacts:List of Trusted Entities (LoTE)|LoTE> Publication</td>
            <td>
                <ul>
                    <li>Registered entity information</li>
                    <li>Entity service information</li>
                    <li>Sign/Seal <artifacts:Trust Anchor></li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Verify that the entity data is complete and create or update the applicable entity-type <artifacts:List of Trusted Entities (LoTE)|LoTE> entry.</li>
                    <li>For a <roles:Wallet Provider (WP)|Wallet Provider> the required service information is the <components:Wallet Solution></li>
                <ul>
            </td>
            <td>The entity SHALL submit the required data and <artifacts:Trust Anchor>.</td>
            <td>The entity data is accepted for publication.</td>
            <td>No <artifacts:List of Trusted Entities (LoTE)|LoTE> entry SHALL BE created or updated.</li>
        </tr>
        <tr>
            <td rowspan="2">Information update</td>
            <td><components:Register> update</td>
            <td>
                <ul>
                    <li>Updated identity, policy, or authorization data</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Update the <components:Register> record and verify that the resulting record conforms to the <components:Register> schema.</li>
                <ul>
            </td>
            <td>The <roles:Wallet-Relying Party (WRP)|WRP> SHALL submit the updated information through the Onboarding System.</td>
            <td>The current <components:Register> record contains the updated information.</td>
            <td>The record SHALL NOT be updated.</li>
        </tr>
        <tr>
            <td><artifacts:List of Trusted Entities (LoTE)|LoTE> update</td>
            <td>
                <ul>
                    <li>Updated entity identity, service endpoint, <artifacts:Trust Anchor>, or eligibility information</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Update the applicable <artifacts:List of Trusted Entities (LoTE)|LoTE> entry.</li>
                    <li>When the entity becomes ineligible, invoke the applicable removal test case instead.</li>
                <ul>
            </td>
            <td>The affected entity SHALL notify APTITUDE WP2 of the changed information.</td>
            <td>The new entity information is included in the updated <artifacts:List of Trusted Entities (LoTE)|LoTE> content prepared and published.</td>
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
            <td><artifacts:List of Trusted Entities (LoTE)|LoTE> version publication</td>
            <td><artifacts:List of Trusted Entities (LoTE)|LoTE> distribution</td>
            <td>
                <ul>
                    <li>Updated <artifacts:List of Trusted Entities (LoTE)|LoTE> content</li>
                    <li>Pivot <artifacts:List of Trusted Entities (LoTE)|LoTE> URI</li>
                    <li>APTITUDE WP2 <artifacts:List of Trusted Entities (LoTE)|LoTE> signing certificate</li>
                </ul>
            </td>
            <td>
                <ul>
                    <li>Publish a signed new current <artifacts:List of Trusted Entities (LoTE)|LoTE> and make the replaced version at the applicable pivot URI for retro-compatibility.</li>
                    <li>Update the <code>SchemeInformationURI</code> accordingly.</li>
                <ul>
            </td>
            <td>Every participant that consumes the affected <artifacts:List of Trusted Entities (LoTE)|LoTE> SHALL refresh its cached copy via the <artifacts:Trust Anchor> Validation Process and SHALL NOT use old pivot versions for a current decision.</td>
            <td>The endpoint serves the new current <artifacts:List of Trusted Entities (LoTE)|LoTE> and <artifacts:Trust Anchor> Validation uses its updated entry.</td>
            <td>The new version is unavailable or invalid, or a participant continues to use the superseded version.</li>
        </tr>
        <tr>
            <td rowspan="2">Certificate revocation</td>
            <td><artifacts:Wallet-Relying Party Access Certificate (WRPAC)|WRPAC> - Sign/Seal Certificate revocation</td>
            <td>
                <ul>
                    <li>Certificate serial number</li>
                    <li>Current <artifacts:Certificate Revocation List (CRL)|CRL> or <protocols:Online Certificate Status Protocol (OCSP)|OCSP> status database</li>
                </ul>
            </td>
            <td>Update the configured <artifacts:Certificate Revocation List (CRL)|CRL> or <protocols:Online Certificate Status Protocol (OCSP)|OCSP> status source and verify that it reports the certificate as revoked.</td>
            <td>The affected entity SHALL stop using the certificate. Runtime participants SHALL retrieve current status information and reject it.</td>
            <td>The certificate fails <i>Entity Identity Validation</i> or <i>Attestation Authenticity and Integrity</i>, as applicable.</td>
            <td>The certificate remains accepted.</li>
        </tr>
        <tr>
            <td><artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> revocation</td>
            <td>
                <ul>
                    <li><artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> status reference and index</li>
                    <li>current Status List</li>
                </ul>
            </td>
            <td>The Provider or <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> SHALL set the assigned status value to <code>0x01</code>, publish the updated signed <artifacts:Status List Token>, and verify that its endpoint remains available.</td>
            <td>The affected entity SHALL stop presenting the <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC>. Wallet Units SHALL retrieve the current <artifacts:Status List Token> and apply the status in <i>Entity Authorization Profile Verification</i>.</td>
            <td>The <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> is treated as revoked.</td>
            <td>The <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)|WRPRC> remains valid or is accepted by a Wallet Unit.</li>
        </tr>
        <tr>
            <td><roles:Wallet-Relying Party (WRP)|WRP> deregistration</td>
            <td>Entity removal</td>
            <td>
                <ul>
                    <li>Removal request or decision</li>
                    <li>Current entity record and related trust artifacts</li>
                </ul>
            </td>
            <td>Orchestrate the applicable <components:Register> cancellation or deletion, entity-related certificate revocation, and <artifacts:List of Trusted Entities (LoTE)|LoTE> update Trust use cases, and verify that each completes successfully.</td>
            <td>For voluntary removal, the <roles:Wallet-Relying Party (WRP)|WRP> SHALL submit the removal request to APTITUDE WP2; in every case it SHALL cease new framework operations. Participants SHALL reject new interactions with the removed entity.</td>
            <td>The entity is <code>REMOVED</code> and all applicable runtime tests reject new interactions.</td>
            <td>Any invoked operational test fails or a new interaction remains trusted.</li>
        </tr>
        <tr>
            <td><components:Wallet Solution> deregistration</td>
            <td>Entity removal</td>
            <td>
                <ul>
                    <li>Removal request or decision</li>
                    <li>Current <artifacts:List of Trusted Entities (LoTE)|LoTE> entry</li>
                    <li>Sign/Seal Certificate for the <components:Wallet Solution></li>
                </ul>
            </td>
            <td>Orchestrate the applicable <artifacts:List of Trusted Entities (LoTE)|LoTE> update and Sign/Seal certificate revocation Trust Use Cases, including <artifacts:Wallet Unit Attestation (WUA)|WUA> revocation.</td>
            <td>For voluntary removal, the entity SHALL notify APTITUDE WP2 and cease new framework operations. Participants SHALL reject new interactions whose trust depends on the removed <components:Wallet Solution>.</td>
            <td>The <components:Wallet Solution> can no longer be resolved as trusted from the current <artifacts:List of Trusted Entities (LoTE)|LoTE>.</td>
            <td>Any invoked operational test fails or a new interaction remains trusted through a <components:Wallet Solution>'s Instance.</li>
        </tr>
    </tbody>
</table>
