# OPA Policy Checks for Tekton CI/CD

This repository provides a minimal and reusable way to enforce **policy-as-code**
in **Tekton CI/CD pipelines** using **Open Policy Agent (OPA)**.

The intent is explicit and deliberate:

**enforce governance and compliance at build time, not after deployment.**

---

## Why this exists

Many CI/CD pipelines rely on:
- conventions instead of enforcement
- ad-hoc scripts
- duplicated security logic

This leads to:
- inconsistent governance
- weak auditability
- late detection of violations

This repository provides:
- a **generic Tekton Task** for policy evaluation
- **explicit Rego policies**
- a **clear and auditable contract** between pipeline and policy

---

## Architecture overview

```mermaid
flowchart LR
    A[Tekton Pipeline] --> B[OPA Policy Check Task]
    C[Rego Policy] --> B
    D[Input JSON] --> B
    B --> E{Allow?}
    E -->|Yes| F[Pipeline continues]
    E -->|No| G[Pipeline fails]