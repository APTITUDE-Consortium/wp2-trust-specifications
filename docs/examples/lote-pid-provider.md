**Protected JOSE header**:

```json
{
  "alg": "ES256",
  "iat": 1787054400,
  "x5t#S256": "<base64url-sha256-thumbprint-of-oja-certificate>"
}
```

**JWT Claims Set**:

```json
{
  "LoTE": {
    "ListAndSchemeInformation": {
      "LoTEVersionIdentifier": 1,
      "LoTESequenceNumber": 1,
      "LoTEType": "http://uri.etsi.org/19602/LoTEType/EUPIDProvidersList",
      "SchemeOperatorName": [
        {
          "lang": "en",
          "value": "APTITUDE LoTE Provider"
        }
      ],
      "SchemeOperatorAddress": {
        "SchemeOperatorPostalAddress": [
          {
            "lang": "en",
            "StreetAddress": "1 APTITUDE Avenue",
            "Locality": "Brussels",
            "PostalCode": "1000",
            "Country": "BE"
          }
        ],
        "SchemeOperatorElectronicAddress": [
          {
            "lang": "en",
            "uriValue": "https://oja.aptitude.example/contact"
          }
        ]
      },
      "SchemeName": [
        {
          "lang": "en",
          "value": "APTITUDE PID Provider Scheme"
        }
      ],
      "SchemeInformationURI": [
        {
          "lang": "en",
          "uriValue": "https://oja.aptitude.example/publications/pid-providers/2026-08-18"
        },
        {
          "lang": "en",
          "uriValue": "https://lote.aptitude.example/pid-providers/history"
        }
      ],
      "StatusDeterminationApproach": "http://uri.etsi.org/19602/PIDProvidersList/StatusDetn/EU",
      "SchemeTypeCommunityRules": [
        {
          "lang": "en",
          "uriValue": "http://uri.etsi.org/19602/PIDProvidersList/schemerules/EU"
        }
      ],
      "SchemeTerritory": "EU",
      "PolicyOrLegalNotice": [
        {
          "LoTELegalNotice": "https://oja.aptitude.example/lote/pid-providers/legal-notice"
        }
      ],
      "PointersToOtherLoTE": [
        {
          "LoTELocation": "https://lote.aptitude.example/pid-providers/current.jwt",
          "ServiceDigitalIdentities": [
            {
              "X509Certificates": [
                {
                  "encoding": "urn:ietf:rfc:5280",
                  "specRef": "RFC 5280",
                  "val": "<base64-encoded-DER-signing-certificate>"
                }
              ]
            }
          ],
          "LoTEQualifiers": [
            {
              "LoTEType": "http://uri.etsi.org/19602/LoTEType/EUPIDProvidersList",
              "SchemeOperatorName": [
                {
                  "lang": "en",
                  "value": "APTITUDE LoTE Provider"
                }
              ],
              "SchemeTypeCommunityRules": [
                {
                  "lang": "en",
                  "uriValue": "http://uri.etsi.org/19602/PIDProvidersList/schemerules/EU"
                }
              ],
              "SchemeTerritory": "EU",
              "MimeType": "application/jwt"
            }
          ]
        }
      ],
      "ListIssueDateTime": "2026-08-18T12:00:00Z",
      "NextUpdate": "2027-02-18T12:00:00Z",
      "DistributionPoints": [
        "https://lote.aptitude.example/pid-providers/current.jwt"
      ]
    },
    "TrustedEntitiesList": [
      {
        "TrustedEntityInformation": {
          "TEName": [
            {
              "lang": "en",
              "value": "Example PID Provider"
            }
          ],
          "TETradeName": [
            {
              "lang": "en",
              "value": "BE:PID-EXAMPLE-001"
            }
          ],
          "TEAddress": {
            "TEPostalAddress": [
              {
                "lang": "en",
                "StreetAddress": "10 Example Street",
                "Locality": "Brussels",
                "PostalCode": "1000",
                "Country": "BE"
              }
            ],
            "TEElectronicAddress": [
              {
                "lang": "en",
                "uriValue": "mailto:pid-provider@example.eu"
              }
            ]
          },
          "TEInformationURI": [
            {
              "lang": "en",
              "uriValue": "https://example.eu/pid-provider"
            }
          ]
        },
        "TrustedEntityServices": [
          {
            "ServiceInformation": {
              "ServiceName": [
                {
                  "lang": "en",
                  "value": "PID issuance service"
                }
              ],
              "ServiceDigitalIdentity": {
                "X509Certificates": [
                  {
                    "encoding": "urn:ietf:rfc:5280",
                    "specRef": "RFC 5280",
                    "val": "<base64-encoded-DER-pid-provider-certificate>"
                  }
                ]
              },
              "ServiceTypeIdentifier": "http://uri.etsi.org/SvcType/PID/Issuance"
            }
          },
          {
            "ServiceInformation": {
              "ServiceName": [
                {
                  "lang": "en",
                  "value": "PID revocation service"
                }
              ],
              "ServiceDigitalIdentity": {
                "X509Certificates": [
                  {
                    "encoding": "urn:ietf:rfc:5280",
                    "specRef": "RFC 5280",
                    "val": "<base64-encoded-DER-pid-provider-certificate>"
                  }
                ]
              },
              "ServiceTypeIdentifier": "http://uri.etsi.org/SvcType/PID/Revocation"
            }
          }
        ]
      }
    ]
  }
}
```
