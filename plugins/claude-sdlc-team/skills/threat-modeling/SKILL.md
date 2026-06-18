---
name: threat-modeling
description: Design-time security risk analysis. Use when reviewing a design or change for what could go wrong — assets, trust boundaries, attack surface, and STRIDE categories. Used by the security-reviewer and consulted by the architect.
---

# Threat Modeling (design-time)

## Process
1. Identify assets (data, credentials, money, PII) and who wants them.
2. Map trust boundaries and data flows (where untrusted input enters).
3. Enumerate threats with STRIDE: Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, Elevation of privilege.
4. Rate by likelihood × impact; propose mitigations.

## Output
Per finding: asset at risk, STRIDE category, scenario, severity, mitigation. Distinguish design-level risks (this skill) from code-level vulnerabilities (`vulnerability-scanning`).
