# APTITUDE Trust Specifications

## About

Repository related to the subtask T2.3.1 (Implementation profiles for the trust framework) within WP2 of the European LSP APTITUDE.

## Structure

The repository is structured according to the following organization:

```text
.
├── .github/
│   ├── workflows/
├── docs/
│   ├── sections/
│   ├── topics/
│   └── references.md
│   └── trust-framework.md
├── references/
├── requirements/
├── .gitignore
├── .markdownlint.yml
├── CONTRIBUTING.md
├── LICENSE
├── mkdocs.yml
├── README.md
├── requirements.txt
└── terminology.md
```

The main files and folders are as follows:

| Name | Description |
| --- | --- |
| `.github/` | Contains GitHub actions and workflow configurations. |
| `docs/` | Contains the source documentation files. |
| `docs/sections/` | Contains individual section files that compose the main document. |
| `docs/topics/` | Contains individual topic files that compose sections of the main document. |
| `docs/references.md` | References section included in the main document. |
| `docs/trust-framework.md` | Main entry document assembling the trust framework topics. |
| `references/` | Contains reference materials, external specifications, and supporting documents. |
| `requirements/` | Contains consolidated requirements grouped by source (ARF, ETSI, etc.). |
| `.markdownlint.yml` | Configuration rules for Markdown linting. |
| `CONTRIBUTING.md` | Guidelines for contributing to the repository. |
| `LICENSE` | Terms and repository license details. |
| `mkdocs.yml` | Configuration file for generating the static MkDocs documentation site. |
| `README.md` | Main overview and repository guide. |
| `requirements.txt` | Python dependencies required to build or work with the project. |
| `terminology.md` | Glossary and definitions of terms used throughout the documentation. |

## Versioning and Preview

This project manages documentation versions using Git branches and release tags:

- The branch `main` contains the last stable version of the documentation;
- The [release page](https://github.com/APTITUDE-Consortium/wp2-trust-specifications/releases) of this project contains all the released versions of the specifications.

### Published Specifications

| Version  | Documentation Preview |
| :------- | :-------------------- |
| `v1.0`   | [View HTML](https://aptitude-consortium.github.io/wp2-trust-specifications/v1.0/) |
| `v0.2`   | [View HTML](https://aptitude-consortium.github.io/wp2-trust-specifications/v0.2/) |
| `v0.1`   | [View HTML](https://aptitude-consortium.github.io/wp2-trust-specifications/v0.1/) |

## Funding

![Co-funded by the European Union](https://github.com/APTITUDE-Consortium/aptitude-eudi-wallet-specs/raw/main/docs/img/eu-cofunded.png)

The project is co-funded by the European Union. However, the views and opinions expressed are those of the author(s) only and do not necessarily reflect those of the European Union or the granting authority. Neither the European Union nor the granting authority can be held responsible.

## Licensing

Licensed under the Apache 2.0 License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the LICENSE for the specific language governing permissions and limitations under the License.
