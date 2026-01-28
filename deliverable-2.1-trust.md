# Implementation Profiles for the Trust Framework

**Table of Contents**
- [Trust Framework Requirements](#trust-framework-requirements)
- [Trust Architecture](#trust-architecture)
  - [Register](#register)
  - [Access Certificate](#access-certificate)
  - [Registration Certificate](#registration-certificate)
  - [List of Trusted Entities and List of Trusted Lists](#list-of-trusted-entities-and-list-of-trusted-lists)
- [Trust Evaluation](#trust-evaluation)
  - [Authentication Process](#authentication-process)
  - [Authorization Process](#authorization-process)
    - [Entitlement and Policy](#entitlement-and-policy)
- [Trust Management and Lifecycle](#trust-management-and-lifecycle)

## Trust Framework Requirements
*From `requirements/*.md`*.

This section elicitates relevant normative and APTITUDE-specific trust requirements extracted from the ARF, implementing acts, ETSI standards and use-cases. 

## Trust Architecture
*From `topics/trust-architecture.md`*.

This section describes the trust-related processes (i.e., Wallet Relying Party registration, Provider notification and publication in Trusted List, and trust evaluation) by detailing the entities involved, high level flows and their relationships. In addition, the following subsections describe different artificats output of these processes. The trust evaluation process is further detailed in [Trust Evaluation](#trust-evaluation).

### Register
*From `topics/registry.md`*.

This section describes the content of the Register and its common set of APIs.

### Access Certificate
*From `topics/access-certificate.md`*.

This section describes the content and format of the Wallet Relying Party Access Certificate.

### Registration Certificate
*From `topics/registration-certificate.md`*.

This section describes the content and format of the Wallet Relying Party Registration Certificate.

### List of Trusted Entities and List of Trusted Lists
*From `topics/trusted-list-and-list-of-trusted-lists.md`*.

This section describes the content and format of the List of Trusted Entities and List of Trusted Lists.

## Trust Evaluation

### Trust Anchor Validation
*From `topics/trust-anchor-validation.md`*.

This section describes the process of validating the trust anchor by downloading and verifying a Trusted List or List of Trusted Entities.

### Authentication Process
*From `topics/trust-evaluation-process-authentication.md`*.

This section describes the process of authenticating an entity by validating its Wallet Relying Party Access Certificate.

### Authorization Process
*From `topics/trust-evaluation-process-authorization.md`*.

This section covers the authorization process by evaluating the Wallet Relying Party registered data obtained through the Register or the Wallet Relying Party Registration Certificate with respect to the performed action and set of policies. For example, by checking during the issuance process that an Attestation Provider is allowed to issue a certain attestation, or by avoiding overasking by a Relying Party during the presentation process. 

#### Entitlement and Policy
*From `topics/entitlement-policy.md`*.

## Trust Management and Lifecycle
*From `topics/trust-management-process.md`*.

This section describe the trust management and lifecycle, e.g., by detailing what happen if a Wallet Relying Party updates its data on the Register or a Provider is not trusted anymore and the related revocation mechanims.

