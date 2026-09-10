This section introduces the trust artifacts used within the APTITUDE ecosystem. The trust artifacts defined herein are consumed by the [Trust Evaluation Processes](../sections/trust-evaluation-process.md) and are produced and managed by the [Trust Architecture](../sections/trust-architecture.md) components.

!!! note

    In this document, the term *trust artifact* refers to a structured data object exchanged or consulted during trust evaluation. Trust artifacts are distinct from <credentials:Attestation>, whose authenticity they help verify.

The table below lists the trust artifacts defined in this document, along with their responsible actors in the <components:EUDI Wallet> and APTITUDE ecosystems, and the corresponding reference:

| Artifact                                                          | Responsible Actor(s) in EUDI Wallet       | Responsible Actor(s) in APTITUDE                  | Reference |
| ----------------------------------------------------------------- | ----------------------------------------- | ------------------------------------------------- | --------- |
| <artifacts:Certificate Revocation List (CRL)>                     | Provider of WRPAC and Sign/Seal Certificates | Component of the <roles:Certificate Authority (CA)\|Certificate Authority> managed by APTITUDE WP2 | [APTITUDE Certificate Revocation List Profile](#certificate-revocation-list) |
| <artifacts:Embedded Disclosure Policy (EDP)>                      | <roles:Attestation Provider (AP)> | Self-managed issuance | [APTITUDE Embedded Disclosure Policy Profile](#embedded-disclosure-policy) |
| <artifacts:Key Attestation (KA)>                                  | <roles:Wallet Provider (WP)\|Wallet Provider> | Wallet Provider | [TS03] |
| Key Attestation <artifacts:Status List Token>                     | <roles:Wallet Provider (WP)\|Wallet Provider> | Wallet Provider | [TS03] |
| <artifacts:List of Trusted Entities (LoTE)>                       | <roles:List of Trusted Entities Provider (LoTE Provider)\|LoTE Provider> | Service managed by APTITUDE WP2 | [APTITUDE List of Trusted Entities Profile](#list-of-trusted-entities) |
| <protocols:Online Certificate Status Protocol (OCSP)> Artifacts   | Provider of WRPAC and Sign/Seal Certificates | Component of the Certification Authority managed by APTITUDE WP2 | [APTITUDE Online Certificate Status Protocol Artifacts Profile](#online-certificate-status-protocol-artifacts) |
| <components:Register> API                                         | <roles:Registrar> | Service managed by APTITUDE WP2 | [APTITUDE Register API Profile](#register) |
| Sign/Seal Certificate                                             | Provider of Sign/Seal Certificates | <roles:Certificate Authority (CA)\|Certificate Authority> managed by APTITUDE WP2 | [APTITUDE Entity Sign/Seal Certificate Profile](#entity-signseal-certificate) |
| Status List Token                                                 | <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> | Component of the <roles:Certificate Authority (CA)\|Certificate Authority> managed by APTITUDE WP2 | [APTITUDE Status List Token Profile](#status-list-token) |
| <artifacts:Trust Anchor> Certificate                              | Member State <roles:Certificate Authority (CA)\|Certificate Authority> | Self-signed <roles:Certificate Authority (CA)\|Certificate Authority> managed by APTITUDE WP2 | [APTITUDE Trust Anchor Certificate Profile](#trust-anchor-certificate) |
| <artifacts:Wallet Instance Attestation (WIA)>                     | <roles:Wallet Provider (WP)\|Wallet Provider> | Wallet Provider | [TS03] |
| Wallet Instance Attestation <artifacts:Status List Token>         | <roles:Wallet Provider (WP)\|Wallet Provider> | Wallet Provider | [TS03] |
| <artifacts:Wallet-Relying Party Access Certificate (WRPAC)>       | <roles:Provider of Wallet-Relying Party Access Certificate (Provider of WRPAC)\|Provider of WRPAC> | <roles:Certificate Authority (CA)\|Certificate Authority> managed by APTITUDE WP2 | [APTITUDE Wallet-Relying Party Access Certificate Profile](#wallet-relying-party-access-certificate) |
| <artifacts:Wallet-Relying Party Registration Certificate (WRPRC)> | <roles:Provider of Wallet-Relying Party Registration Certificate (Provider of WRPRC)\|Provider of WRPRC> | <roles:Certificate Authority (CA)\|Certificate Authority> managed by APTITUDE WP2 | [APTITUDE Wallet-Relying Party Registration Certificate Profile](#wallet-relying-party-registration-certificate) |

## X.509 Certificates

{% include-markdown "../topics/x509-certificates.md" %}

## Register

{% include-markdown "../topics/registry.md" %}

## Wallet-Relying Party Registration Certificate

{% include-markdown "../topics/registration-certificate.md" %}

## List of Trusted Entities

{% include-markdown "../topics/trusted-list-and-list-of-trusted-lists.md" %}

## Embedded Disclosure Policy

{% include-markdown "../topics/embedded-disclosure-policy.md" %}

## Certificate Revocation List

{% include-markdown "../topics/certificate-revocation-list.md" %}

## Online Certificate Status Protocol Artifacts

{% include-markdown "../topics/ocsp-artifacts.md" %}

## Status List Token

{% include-markdown "../topics/status-list-token.md" %}
